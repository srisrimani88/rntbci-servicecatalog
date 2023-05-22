########### variable ##############
variable "ec2name" {
    type = string
    default = "myec2name"
}

variable "sshport" {
    type = number
    default = 22
}

variable "enabled" {
    default = true
}

variable "elb_names" {
    type = list(string)
    default = ["dev-loadbalancer","stage-loadbalancer", "prod-loadbalancer"]
}

variable "keyvaluemap" {
    type = map 
    default = {
        key1 = "value1"
        key2 = "value2"
    }
}

# #### below is for tupels and object ###
# variable "myobject" {
#     type = object({ name = string, port = list(string) })
#     default = {
#         name = mani
#         port = [22, 25, 80]
#     }     
# }

variable "instancename" {
    type = string
    description = "enter the name of the instance"
}

variable "ingressrules" {
    type = list(number)
    default = [80,443]
}

variable "egressrules" {
    default = [80,443,25,8080]
}

variable "istest" {}  #mention var.tfvars istest = true to run in non prod, false in prod

########code####
provider "aws" {
    region = "ap-northeast-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-0ca6acead25a91962"
    instance_type = "t2.micro"
    subnet_id = "subnet-00579b7983edaeff4"
    security_groups = [aws_security_group.sgname.id]
    #count = var.istest == true ? 1 : 0   --> this will help to run resoruce in prod or non prod 
    #count = 3  --> it will create 3 instnace

    # depends_on = [aws_instance.db]   --> after db server get created then the web server will get create
    tags = {
        Name = var.instancename
    }
    }

###    aws import
    ## here we have aws import concept, here if we have created a vpc in console we can bring this to our tf control by import option 
    # terraform import aws.vpc.myvpc2 vpc-wer9uweru9weru  --> this command will bring the vpc to terraform control

# resource "aws_instance" "db" {
#     ami = "ami-0ca6acead25a91962"
#     instance_type = "t2.micro"
#     subnet_id = "subnet-00579b7983edaeff4"
#     security_groups = [aws_security_group.sgname.id]

#     tags = {
#         Name = var.instancename
#     }
#     }

resource "aws_security_group" "sgname" {
    name = "sgname"
    vpc_id = "vpc-0f92efc362c324c55"

    dynamic "ingress" {
        iterator = port
        for_each = var.ingressrules
        content {
        from_port = port.value
        to_port = port.value
        protocol = "TCP"
        cidr_blocks = ["10.0.0.0/8"]
        }
    }

    dynamic "egress" {
        iterator = port
        for_each = var.egressrules
        content {
        from_port = port.value
        to_port = port.value    
        protocol = "TCP"
        cidr_blocks = ["10.0.0.0/8"] #[var.sgiprange]
        }
    }
}

# ##### bloe code is for iam user and policy ####
# resource "aws_iam_user" "myuser" {
#     name = "maniuser"
# }

# resource "aws_iam_policy" "custompolciy" {
#     name = "ec2fullaccesspolicy"

#     policy = <<EOF
#     {
#         copy and paste the policy
#     }
#     EOF
# }

# resource "aws_iam_attachment" "policybind" {
#     name = "attachment"
#     users = [aws_iam_user.myuser.name]
#     policy_arn = aws_iam_policy.custompolciy.arn
# }

##### below is the code for module here we can create ec2 instance from module file, module file wil have main.tf 
# module "ec2module" {
#     source = "./ec2"
#     ec2name = " Name from module"
# }

# output "module_output" {
#     value = module.ec2module.instance_id
# }

#####below code is for creating ec2 with different environment thorugh workspace
# variable "instance_type" {
#     type = "map"
#     default = {
#         default = "t2.nano"
#         dev = "t2.micro"
#         prd = "t2.large"
#     }
# }

# resource "aws_instance" "ec2" {
#     ami = "ami-0ca6acead25a91962"
#     instance_type = lookup(var.instance_type,terrafrom.workspace)
#     subnet_id = "subnet-00579b7983edaeff4"
#     security_groups = [aws_security_group.sgname.id]

#     tags = {
#         Name = var.instancename
#     }
#     }

# ## below is the code for rds
# resource "aws_db_instance" "myrds" {
#     name = "mydb"
#     identifier = "my-first-rds"
#     instance_class = "db.t2.micro"
#     engine = "mariadb"
#     engine_version = "10.2.21"
#     username = "bob"
#     password = "password123"
#     port = 3306
#     allocated_storage = 20
#     skip_final_snapshot = true
# }


#below code is for creating eip
# resource "aws_eip" "elastiip" {
#     instance = aws_instance.ec2.id
# }

# #######if we want to get the output we can use the below line ##
# output "EIP" {
#     value = aws_eip.elasticip.public_ip
# }
# output "myoutput" {
#     value = aws_vpc.myvcp.id
# }



























# resource "google_compute_instance" "default" {
#   name         = var.name
#   machine_type = var.machine_type
#   zone         = var.zone
#   allow_stopping_for_update = true

#   tags = ["foo", "bar"]

#   boot_disk {
#     initialize_params {
#       image = var.image
#       #labels = {
#       #my_label = "value"
#       #}
#     }
#   }

#   #// Local SSD disk
#   #scratch_disk {
#   #  interface = "SCSI"
#   #}

#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral public IP
#     }
#   }

#   metadata = {
#     foo = "bar"
#   }

#   metadata_startup_script = "echo hi > /test.txt"

#   service_account {
#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     #email  = "terraformsa@my-project-22-369304.iam.gserviceaccount.com"
#     scopes = ["userinfo-email", "compute-ro", "storage-ro"]
#   }
# }
# resource "google_storage_bucket" "bucket" {
#  count = 1
#  name = "test-tm-mani-tf-bkt"
#  location = "europe-west2"
#  storage_class = "STANDARD"
# }