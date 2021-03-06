﻿Import-Module ActiveDirectory
#import from CSV data    
$Users = Import-Csv -Path "c:\Users\nicholas.chang\Documents\Scripts\newusers.csv" 

#Loop through each row containing user details in the CSV file
foreach ($User in $Users) {            
    $Displayname = $User.FirstName + " " + $User.Lastname            
    $UserFirstname = $User.Firstname            
    $UserLastname = $User.Lastname            
    $OU = $User.OU           
    $SAM = $User.SAM      
    $email = $User.$email  
    $telephone  = $User.telephone
    $Description = $User.Description
    $department = $User.department 
    $jobtitle = $User.jobtitle
   # $groups = $User.groupname -split ";"
    $groupname = ($User.groupname).split(",")

    $Password = $User.Password  
    
    # Creating User with AD Attributes

    New-ADUser `
        -Name $Displayname -DisplayName $Displayname -SamAccountName $SAM -OfficePhone $telephone  `
        -UserPrincipalName "$SAM@cloudtechgenius.com" -GivenName $UserFirstname -Surname $UserLastname -Department $department `
        -Description $Description -EmailAddress $User.email -Title $jobtitle  `
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true `
        -Path "$OU"  -ChangePasswordAtLogon $true  –PasswordNeverExpires $false 
   
        Write-Host $User.SAM "created successfully" 
        # Add user to Groups
        foreach  ($groupnames in $groupname)
        {
        Add-ADGroupMember -Identity $User.groupname $SAM

        }                 
        # assigned each user office365 licence
    }
