<?php 

if (isset($_POST['submit'])) {
  $name = $_POST['name'];
  $mobile = $_POST['mobile'];
  $email = $_POST['email'];
  $referal = $_POST['referal'];
  $password = $_POST['password'];
  $address = $_POST['address'];

  //$folder="/xampp/htdocs/";

  $con = mysqli_connect('localhost','root','','mlm');

  if ($name == '' && $mobile == '' && $email == ''  && $password == ''&& $referal=='' && $address == ''){
    echo "Please recheck the form before submit";
  }
  else {
      $query = "INSERT INTO `user`(`name`, `mobile`, `email` , `password`,`referal`, `address`) VALUES ('$name' , '$mobile' , '$email' , '$password' ,$referal , '$address')";

  } if (mysqli_query($con,$query)) {
      header("Location:index.php");
    }else {
      echo "Email alreary Exist , Registration Failed";
    }
}


 ?>