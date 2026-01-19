# AWS CLI Setup and First Command with CLI and S3

## Problem

Organizations need efficient command-line access to AWS services for automation,
scripting, and daily operations. Many developers and system administrators 
struggle with initial AWS ClI setup, credentials configuration, and learning 
essential command. Without proper CLI access, teams resort to manual console
operations that are time-consuming, error-prone, and difficult to automate or
integrate into CI/CD pipelines.

## Solution

Install and configute the AWS CLI v2 with proper credentials and security best
practices, then learn fundamental S3 operations through hands-on practice. This
approach establishes a solid foundation for AWS automation by providing secure
programmatic access to AWS services through a standardized command-line 
interface that supports scripting, automation and integration with 
development workflows.

## Architecture Diagram

```mermaid
graph TB
    subgraph "Local Environment"
        CLI[AWS CLI v2]
        CREDS[AWS Credentials]
        CONFIG[CLI Configuration]
    end
    
    subgraph "AWS Cloud"
        S3[S3 Service]
        BUCKET[S3 Bucket]
        OBJECTS[S3 Objects]
    end
    
    subgraph "Authentication"
        IAM[IAM User/Role]
        KEYS[Access Keys]
    end
    
    CLI-->IAM
    CLI-->S3
    CREDS-->KEYS
    CONFIG-->CLI
    S3-->BUCKET
    BUCKET-->OBJECTS
    
    style S3 fill:#FF9900
    style CLI fill:#3F8624
    style IAM fill:#FF4B4B
```

## Prerequisites

1. AWS account with appropriate permissions for IAM and S3 services
2. Administrative access to install software on your local machine
3. Basic understanding of command-line interfaces and terminal usage
4. Text editor for configuration file management
5. Estimated cost: Free (AWS CLI is free, S3 operations may incur minimal charges for testing)

## Steps

1. **Install AWS CLI v2**
    The AWS CLI v2 provides enhanced features, improved performance, and better
    security compared to v1. It's the recommended version for new installations
    and includes support for features like AWS SSO, enhanced credential 
    management, and improved output formatting that follows AWS securit best
    practices.

    ```bash
    # For Linux x86_64
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    # For macOS (Intel)
    # curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    # sudo installer -pkg AWSCLIV2.pkg -target /

    # For macOS (Apple Silicon)
    # curl "https://awscli.amazonaws.com/AWSCLIV2-arm64.pkg" -o "AWSCLIV2.pkg"
    # sudo installer -pkg AWSCLIV2.pkg -target /

    # For Windows (PowerShell as Administrator)
    # msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /quiet

    # Verify installation
    aws --version

    echo "✅ AWS CLI v2 installed successfully"
    ```
2. **Configure AWS CLI Credentials**
    Proper credential management is essential for secure AWS CLI usage. The
    `aws configure` command sets up you access key, default region, and output
    format in a secure credential store that follows AWS security best practices
    and creates encrypted files with approriate file permissions.

    ```bash
    # Configure AWS CLI with your credentials
    # You'll be prompted for:
    # - AWS Access Key ID (from your IAM user)
    # - AWS Secret Access Key (from your IAM user)
    # - Default region name (e.g., us-east-1, us-west-2)
    # - Default output format (json recommended for automation)
    aws configure

    # Verify configuration without exposing credentials
    aws configure list

    # Test authentication with STS service
    aws sts get-caller-identity

    echo "✅ AWS CLI configured and authenticated"
    ```

3. **Execute First AWS CLI Command with S3**
    Now that the AWS CLI is installed and configured, you can perform your first
    command to interact with the S3 service. This example lists all S3 buckets
    in your account, demonstrating successful CLI access to AWS services.

    ```bash
    # List all S3 buckets in your AWS account
    aws s3 ls

    echo "✅ Successfully listed S3 buckets"
    ```

3. **Execute Command to get Bucket Location**
    You can also retrieve the location of a specific S3 bucket to verify access
    and understand its regional configuration.

    ```bash
    # Replace 'your-bucket-name' with the actual name of your S3 bucket
    aws s3api get-bucket-location --bucket your-bucket-name

    echo "✅ Successfully retrieved S3 bucket location"
    ```

4. **Upload and Manage Objects in S3**
    Object operations form the core of S3 functionality and demonstrate 
    fundamental cloud storage patterns. Learning to upload, list, and download
    objects provides the foundation for using s3 as a storage backend for 
    applications, backups, and data processing workflows with built-in security
    features.

    ```bash
    # Create a sample files to upload
    echo "Hello AWS CLI! This is my first S3 object." > sample-file.txt
    echo "AWS CLI makes cloud operations simple and scriptable." \
        >> sample-file.txt
    echo "Created on $(date)" >> sample-file.txt

    # Upload the sample file to your S3 bucket
    aws s3 cp sample-file.txt s3://<your-bucket-name>/sample-file.txt/ \
        --metadata purpose=tutorial,created-by=aws-cli

    # List object in bucket with details
    aws s3 ls s3://<your-bucket-name>/ --human-readable

    # Download the file with different name
    aws s3 cp s3://<your-bucket-name>/sample-file.txt downloaded-file.txt

    # Verify downloaded file content
    cat downloaded-file.txt

    echo "✅ File uploaded to and downloaded from S3"
    ```

5. **Explore Advanced CLI-Features**
    The AWS CLI includes powerfull features for output formatting, filtering, 
    and querying that enhace productivity and enable sophisticated scripting
    scenarios. Learning these features early establishes good CLI usage 
    patterns and demonstrates the power of programmativ AWS access.

    ```bash
    # Get detailed bucket information with JSON output
    aws s3api head-bucket --bucket <your-bucket-name>
    
    # List objects with comprehensive metadata
    aws s3api list-objects-v2 --bucket <your-bucket-name>  

    # Use JMESPath query to extract specific dta
    aws s3api list-objects-v2 --bucket <your-bucket-name> \
        --query "Contents[].{Name:Key,Size:Size,Modified:LastModified}" \
        --output table

    # Check bucket encryption configuration
    aws s3api get-bucket-encryption --bucket <your-bucket-name>

    # AGET AWS CLI help for any command
    aws s3 help | head -20

    echo "✅ Explored advanced AWS CLI features"
    ```

