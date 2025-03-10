This step demonstrates one of the key aspects of why state makes sense. It's always known which resources should exist and how they should exist. The same goes for resources that should no longer exist. Compared to Ansible, OpenTofu can destroy resources that are no longer part of the configuration.

## Tasks

Complete these tasks for this step:

### Task 1: Extend Configuration

> We can place any `*.tf` file in the configuration directory. Terraform will automatically detect and apply the configuration. However, you can't use subdirectories.

Now, we are adding a second file to the configuration:

```shell
cat <<EOF > local_file.tf
resource "local_file" "goodbye" {
    filename = "\${path.module}/goodbye.txt"
    content  = "Goodbye, Terraform!"
}
EOF
```{{exec}}

The **local name** of the resource must be different (`goodbye`) to avoid conflicts.

Plan and Apply the changes, you may review what's being created:

```shell
tofu plan && tofu apply -auto-approve
```{{exec}}

Verify the new file was created:

```shell
cat ./goodbye.txt
```{{exec}}

### Task 2: Change content

Let's make changes to the content and the name of the file. We'll also change the resource's name to `morning`:

```shell
cat <<EOF > local_file.tf
resource "local_file" "morning" {
    filename = "\${path.module}/morning.txt"
    content  = "Good Morning, Terraform!"
}
EOF
```{{exec}}

Plan the changes. You should see that the file `goodbye.txt` will be removed and `morning.txt` will be created:

```shell
tofu plan
```{{exec}}

You should see that the file `goodbye.txt` will be removed and `morning.txt` will be created. So you don't have to worry about the removal of the old file, Terraform will take care of it. This Garbage Collection is possible because of the state file. Apply the changes:

```shell
tofu apply -auto-approve
```{{exec}}
