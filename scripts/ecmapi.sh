#!/bin/bash

#PRIMERA FORMA ---------------

# chown -R www-data.www-data /www/apps/ecmadm/
# cd /www/apps/ecmadm/
# #rm -rf /tmp/ecmadm-script.log                          #No se usaba
export COMPOSER_ALLOW_SUPERUSER=1; composer show;      
# #composer install                                       #No se usaba
# #npm install                                            #No se usaba
# #npm run production                                     #No se usaba

# #mkdir test89023                                        #No se usaba
# #chown -R www-data.www-data /www/apps/ecmadm/           #No se usaba

# sudo service apache2 restart

#SEGUNDA FORMA --------------

MARCA="ecommerce-api"
TEMP_APP="temp-$MARCA"
OLD_APP="old-$MARCA"
#Construye aplicación

cp -R /data-files/clone/$MARCA/ /www/build/
cp /data-files/envs/$MARCA/.env /www/build/$MARCA/
#chown -R www-data.www-data /www/build/$MARCA/
chown -R root.root /www/build/$MARCA/
cd /www/build/$MARCA/

#export COMPOSER_ALLOW_SUPERUSER=1; composer show;

composer install > /tmp/$MARCA-install.log 2>&1
npm install >> /tmp/$MARCA-install.log 2>&1
npm run production >> /tmp/$MARCA-install.log 2>&1
chown -R www-data.www-data /www/build/$MARCA/

#Mover la aplicación a la ruta original

mkdir -p /www/apps/

#Validar si la aplicación existe

if [ -d /www/apps/$MARCA/ ]; then

    mv /www/build/$MARCA/ /www/apps/$TEMP_APP/
    mv /www/apps/$MARCA/ /www/apps/$OLD_APP/
    mv /www/apps/$TEMP_APP/ /www/apps/$MARCA/

    sudo service apache2 restart >> /tmp/$MARCA-install.log 2>&1

    rm -rf /www/apps/$OLD_APP/

    else
        mv /www/build/$MARCA/ /www/apps/$MARCA/

        sudo service apache2 restart >> /tmp/$MARCA-install.log 2>&1

fi
