# Terraform IAC
basic infrastructure as code

`terraform init		to initialize everything setup above env first though in any new terminal window`					
`terraform plan		a plan to show what will happen actually					** needs access security key set in terminal before running`
`terraform apply	apply the changes to infrastructure to provider`					
`terraform destroy	so that AWS does not charge you if nothing needed`					
`terraform console	console to try out few things`	
`TF_VAR_db_password to read env variable db_password i.e. export TF_VAR_db_password="(YOUR_DB_PASSWORD)"`			
`TF_LOG=TRACE SOME_TF_COMMAND`
`${format(FMT, ARGS, ...)}`
`format("%.3f", 3.14159265359)`

${file("SOME_SCRIPT")}  in case script tries to read another terraform output vars NOT POSSIBLE like this
so we define template_file data

* Modules
need to define relative path for any file as ${path.module} as TF root command is different 

modules can point to GIT urls too (staging and prod both say `different tags` )

`source = "git::git@github.com:foo/modules.git//webserver-cluster?ref=v0.0.1"`



REF: Terraform - Up and Running

