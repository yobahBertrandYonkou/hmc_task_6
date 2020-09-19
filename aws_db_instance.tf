provider "aws" {
    version = "~> 2.0"
    region = "ap-south-1"
    profile = "bmbterraform"
}

//create RDS
resource "aws_db_instance" "bmbdb"{
    allocated_storage = 20
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    name = "bmbdb"
    username = "root"
    password = "yobah11111"
    parameter_group_name = "default.mysql5.7"
    availability_zone = "ap-south-1a"
    vpc_security_group_ids = ["sg-0243b5401065c5330"]
    skip_final_snapshot = true
    identifier = "bmbsql"
    publicly_accessible = true
    tags = {
        Name = "bmbdb"
    }
}


//minikube
resource "null_resource" "minikubestart"{
    provisioner "local-exec" {
        command = "minikube start"
    }
}

resource "null_resource" "wordpress_launch"{
    depends_on = [null_resource.minikubestart]
    provisioner "local-exec" {
        command = "kubectl create -f wordpress.yml"
    }
}

resource "null_resource" "wordpress_lb_launch"{
    depends_on = [null_resource.wordpress_launch]
    provisioner "local-exec" {
        command = "kubectl create -f wordpress-lb.yml"
    }
}





//display required information

output "dbendpoint"{
    value = "${aws_db_instance.bmbdb.endpoint}"
}

output "dbname"{
    value = "${aws_db_instance.bmbdb.name}"
}