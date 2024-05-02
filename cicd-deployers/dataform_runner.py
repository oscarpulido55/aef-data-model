import logging
import time
import argparse
import collections
import sys
from google.cloud import dataform_v1beta1

df_client = dataform_v1beta1.DataformClient()

def execute_workflow(repo_uri: str, compilation_result: str, tags: list):
    """Triggers a Dataform workflow execution based on a provided compilation result.

    Args:
        repo_uri (str): The URI of the Dataform repository.
        compilation_result (str): The name of the compilation result to use.

    Returns:
        str: The name of the created workflow invocation.
    """
    invocation_config = dataform_v1beta1.types.InvocationConfig(
        included_tags=tags
    )
    request = dataform_v1beta1.CreateWorkflowInvocationRequest(
        parent=repo_uri,
        workflow_invocation=dataform_v1beta1.types.WorkflowInvocation(
            compilation_result=compilation_result,
            invocation_config=invocation_config
        )
    )
    response = df_client.create_workflow_invocation(request=request)
    name = response.name
    logging.info(f'created workflow invocation {name}')
    return name

def compile_workflow(repo_uri: str, branch: str):
    """Compiles a Dataform workflow using a specified Git branch.

    Args:
        repo_uri (str): The URI of the Dataform repository.
        gcp_project (str): The GCP project ID.
        tag (str): The dataform tag to compile.
        branch (str): The Git branch to compile.

    Returns:
        str: The name of the created compilation result.
    """
    request = dataform_v1beta1.CreateCompilationResultRequest(
        parent=repo_uri,
        compilation_result=dataform_v1beta1.types.CompilationResult(
            git_commitish=branch
        )
    )
    response = df_client.create_compilation_result(request=request)
    name = response.name
    logging.info(f'compiled workflow {name}')
    return name

def get_workflow_state(workflow_invocation_id: str):
    """Monitors the status of a Dataform workflow invocation.

    Args:
        workflow_invocation_id (str): The ID of the workflow invocation.
    """
    while True:
        request = dataform_v1beta1.GetWorkflowInvocationRequest(
            name=workflow_invocation_id
        )
        response = df_client.get_workflow_invocation(request)
        state = response.state.name
        logging.info(f'workflow state: {state}')
        if state == 'RUNNING':
            time.sleep(10)
        elif state in ('FAILED', 'CANCELING', 'CANCELLED'):
            raise Exception(f'Error while running workflow {workflow_invocation_id}')
        elif state == 'SUCCEEDED':
            return

def run_workflow(gcp_project: str, location: str, repo_name: str, tags: list, execute: str, branch: str):
    """Orchestrates the complete Dataform workflow process: compilation and execution.

    Args:
        gcp_project (str): The GCP project ID.
        location (str): The GCP region.
        repo_name (str): The name of the Dataform repository.
        tag (str): The target tags to compile and execute.
        branch (str): The Git branch to use.
    """
    repo_uri = f'projects/{gcp_project}/locations/{location}/repositories/{repo_name}'
    compilation_result = compile_workflow(repo_uri, branch)
    if execute:
        workflow_invocation_name = execute_workflow(repo_uri, compilation_result, tags)
        get_workflow_state(workflow_invocation_name)

def main(args: collections.abc.Sequence[str]) -> int:
    """The main function parses command-line arguments and calls the run_workflow function to execute the complete Dataform workflow.
    To run the script, provide the required command-line arguments:
        python intro.py --project_id your_project_id --location your_location --repository your_repo_name --dataset your_bq_dataset --branch your_branch
    """
    parser = argparse.ArgumentParser(description="Dataform Workflows runner")




    parser.add_argument("--project_id",
                        type=str,
                        required=True,
                        help="The GCP project ID where the Dataform code will be deployed.")
    parser.add_argument("--location",
                        type=str,
                        required=True,
                        help="The location of the Dataform repository.")
    parser.add_argument("--repository",
                        type=str,
                        required=True,
                        help="The name of the Dataform repository to compile and run")
    parser.add_argument("--tags",
                        nargs="*",  # 0 or more values expected => creates a list
                        type=str,
                        required=True,
                        help="The target tags to compile and execute")
    parser.add_argument("--execute",
                        type=str,
                        required=True,
                        help="Control if dataform repository will be executed or compiled only.")
    parser.add_argument("--branch",
                        type=str,
                        required=True,
                        help="The branch of the Dataform repository to use.")
    params = parser.parse_args(args)
    project_id = str(params.project_id)
    location = str(params.location)
    repository = str(params.repository)
    execute = str(params.execute)
    tags = list(params.tags)
    branch = str(params.branch)

    run_workflow(gcp_project=project_id,
                 location=location,
                 repo_name=repository,
                 tags=tags,
                 execute=execute,
                 branch=branch)

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
