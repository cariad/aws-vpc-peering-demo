# AWS VPC peering demo

This project holds a collection of CloudFormation templates to demonstrate cross-account Amazon Web Services VPC peering.

## Overview

We're going to deploy the following scenario:

- Account _A_ holds a database. This account will be the peering **requester**.
- Account _B_ holds an EC2 instance that needs connectivity to the application database. This account will be the peering **acceptor**.

## Deployment

1. In the **requester** account, deploy [requester-role.cf.yml](cloudformation-templates/requester-role.cf.yml).
    - You will need to pass in the ID of the _acceptor_ account.
1. In the **acceptor** account, deploy [acceptor.cf.yml](cloudformation-templates/acceptor.cf.yml).
    - You will need to pass in the ID of the _requester_ account.
1. In the **requester** account, deploy [requester.cf.yml](cloudformation-templates/requester.cf.yml).
    - You will need to pass in the ID, region and VPC of the _acceptor_ account. These can be copied from the outputs of the `acceptor.cf.yml` stack.
    - You _must_ configure the stack to assume the `requester-deployer.aws-vpc-peering-demo.cariad.github` IAM role.
1. In the **acceptor** account:
    1. Deploy [acceptor-routing.cf.yml](cloudformation-templates/acceptor-routing.cf.yml).
        - You will need to pass in the VPC peering connection ID, which can be found in the _VPC_ console under _Peering Connections_
    1. Launch an EC2 instance in the `github.com/cariad/aws-vpc-peering-demo` subnet of the `github.com/cariad/aws-vpc-peering-demo` VPC.
    1. SSH into the EC2 instance.
    1. Install `psql`:

        ```bash
        sudo yum install postgresql -y
        ```

    1. Use `psql` to connect to the database in the _requestor_ account.
        - You can get the database's hostname from the outputs of the `requester.cf.yml` stack.
        - The username is `main` and the password is `topsecret`.

        ```bash
        psql --dbname=postgres --host=rd101gx8u3uzcb2.ceuxngm9dcdd.eu-west-1.rds.amazonaws.com --user=main
        ```

1. **Congratulations!** You just connected to a private database across accounts via VPC peering. 🎉
    - If it _didn't_ work then you're very welcome to raise an issue and share the details, but I'm afraid I can't promise any help. This is essentially a proof-of-concept shared in good faith.

## Undeployment

1. In the **acceptor** account:
    1. Terminate your EC2 instance.
    1. Delete the security group you created to connect to the EC2 instance.
    1. Delete the `acceptor-routing.cf.yml` stack.
1. In the **requester** account, delete the `requester.cf.yml` stack.
1. In the **acceptor** account, delete the `acceptor.cf.yml` stack.
1. In the **requester** account, delete the `requester-role.cf.yml` stack.

## Thank you! 🎉

My name is **Cariad**, and I'm an [independent freelance DevOps engineer](https://cariad.me).

I'd love to spend more time working on projects like this, but--as a freelancer--my income is sporadic and I need to chase gigs that pay the rent.

If this project has value to you, please consider [☕️ sponsoring](https://github.com/sponsors/cariad) me. Sponsorships grant me time to work on _your_ wants rather than _someone else's_.

Thank you! ❤️
