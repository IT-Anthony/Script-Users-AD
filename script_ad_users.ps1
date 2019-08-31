###############################################
#            Mairien Anthony, 2019            #
#     Script de création Users AD via Calc    #
# Librement repris de celui de Thomas Limpens #
###############################################

# On importe le module Active Directory
Import-Module ActiveDirectory

# On utilise le module Import-csv sur notre calc pour en faire une variable
$CalcAD = Import-csv -Delimiter ";" -Path C:\Scripts\Calc_powershell_script.csv

# Boucle foreach 
foreach ($User in $CalcAD)
{
       $Username    = $User.Username
       $Password    = $User.password
       $Prenom      = $User.Prenom
       $Nom         = $User.Nom
       $Chemin      = $User.Chemin         


       # On vérifie si l'utilisateur n'existe pas déjà dans le domaine
       if (Get-ADUser -F {SamAccountName -eq $Username}) {

           # On affiche un message sous forme de Warning
           Write-Warning "Oops, on dirait que $Username est déjà présent dans l'AD..."
       }
       else {

              # Sinon on créer l'utilisateur. Bien prendre soin de modifier le nom de domaine 
              # ici avant d'exécuter le script !
              New-ADUser -SamAccountName $Username -UserPrincipalName "$Username@notamax.local" -Name "$Prenom $Nom" -GivenName $Prenom -Surname $Nom -Enabled $True -DisplayName "$Nom, $Prenom" -Path $Chemin -AccountPassword (convertto-securestring $Password -AsPlainText -Force)

       }
}
