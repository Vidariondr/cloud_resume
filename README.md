# Cloud Resume Challenge

`nix develop --impure` - get into the development environment

`biome check --write` - check and lint the supported files (HTML, CSS, JS)

`pytest` - local tests + e2e tests.

## AWS setup
Configure details with `aws configure sso`. Then log in with `aws sso login`.

For terraform to work, you need to create a `tf-state-profile` in `~/.aws/config`. That's where the terraform state is stored. You also need the `secrets.auto.tfvars` file in the `./terraform` folder. Terrafrom won't work with the credentials you logged in with. You need to `export` variables with access codes.

`terraform init` - start the project.

`terraform fmt` - format tf files.

`terraform validate` - validate syntax.

`terraform plan` - see what will change.

`terraform apply` - apply the changes.