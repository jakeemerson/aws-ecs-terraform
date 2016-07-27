# aws-ecs-terraform
Terraform modules for setting up a microservices architecture with amazon web services and the EC2 container service. 


## Set up your AWS configuration
In order to connect to your AWS infrastructure you will need an Access Key ID and Secret Access Key. If you don't have these already, go [here](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html) to learn how to get new ones. 

Next, find the `terraform.tfvars.replace` file, and rename it `terraform.tfvars`. In that file you will need to replace the `<>` bracketed bits with your credentials and key information for your EC2 key pair.


## Your very own containers
There are a few things to watch out for when setting up containers for deployment to the AWS EC2 container service. These include port mappings, image locations, health checks, and assigning instances to a load balancer.

### Port mappings
Make sure you know how ports are mapped in the container, and which ports are exposed. This is important to the load balancer setup.

### Docker Image locations
It's much easier to pull your images from your public [Docker Hub](https://hub.docker.com/) location than to set up a private registry on Amazon's ECR. However, for comercial production applications you will want to set up a private repo. Check [here](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html) for details.


### Health checks
Make sure that health check endpoints end with a trailing slash, e.g., `HTTP:80/` (if necessary). The web application may render properly in the browser, but that's only because the browser follows 301 redirects. If you don't include a trailing slash (when one is needed) in your health checks, then they will silently fail. Failing health checks will prevent the ECS container service from running your tasks.


### Assign EC2 instances to load balancer
When you first form your infrastructure, you should find that terraform creates all of the infrastructure components. However, when you copy the load balancer's URL into your browser, you may be disappointed to find that nothing is there. On non-obvious area to check is the load balancer instance tab. 

![Load balancer with instances assigned](https://cloud.githubusercontent.com/assets/3948840/17186033/8901a4fc-5401-11e6-97e7-0830799a57c5.png)

If you find that there are no EC2 instances assigned to the load balancer, then click on "Edit Instances" and add the ones you expected to be there. If you have given your instances names, then it should be easy to find the right one(s).


## Commands
    terraform get
    terraform plan
    terraform apply
    