##############################################
#            Mairien Anthony, 2019           #
#          Création Users AD via Calc        #
##############################################

# On utilise le module Import-csv sur notre calc pour en faire une variable
$CalcAD = Import-csv C:\scripts\newusers.csv

# Boucle foreach 
foreach ($User in $CalcAD)
{
       $Username    = $User.username
       $Password    = $User.password
       $Firstname   = $User.firstname
       $Lastname    = $User.lastname
       $OU          = $User.ou

       # On vérifie si l'utilisateur n'existe pas déjà dans le domaine
       if (Get-ADUser -F {SamAccountName -eq $Username}) {

           # On affiche un message sous forme de Warning
           Write-Warning "Oops, on dirait que $Username est déjà présent dans l'AD..."
       }
       else {

              # Sinon on créer l'utilisateur
            New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@notamax.local" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$Lastname, $Firstname" `
            -Department $Department `
            -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)

       }
}