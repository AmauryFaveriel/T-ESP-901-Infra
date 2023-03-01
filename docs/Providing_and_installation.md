# Prerequisite

- [Python](https://www.python.org/)  [Pip](https://pypi.org/project/pip/)
- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
- AWS account

Providing and installation are automated for an AWS infra, it needs [credentials](https://docs.aws.amazon.com/fr_fr/sdk-for-java/v1/developer-guide/setup-credentials.html).

# Providing

Before deploying you must [provide an ssh key](https://confluence.atlassian.com/bitbucketserver/creating-ssh-keys-776639788.html).

Key will be ask by Terraform script:

```
/infra/terraform
$ terraform init

/infra/terraform
$ terraform apply
```

To choose how many server you want for front and back, you can change client_instance_count and back_end_instance_count vars.

# Installation

```
ansible-playbook production.yml -i inventory --user=ubuntu --key-file=[path_to_ssh_key] --ask-vault-pass --tags "installation"
```