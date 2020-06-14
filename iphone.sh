#!/bin/bash
# Objetivo: realizar montagem de iphone no linux
# Dependencias: ifuse e zenity
# apt install ifuse zenity

MOUNT_PATH=~/iphone
APP="/usr/bin/nautilus"
#APP="/usr/bin/nemo"

# Checando se existe device
function detect_device()
{
	DEVICE=$(lsusb | grep -i iphone)
	if [ -z "$DEVICE" ]; then
		zenity --info --text="Dispositivo não encontrado.\nVerifique as conexões." --width=200 || echo "Iphone não encontrado!"
		return 1
	else	
		zenity --info --text="Dispositivo encontrado.\n${DEVICE}." --width=300 || echo "Iphone encontrado: $DEVICE"
		return 0
	fi
}
#Checando se ja está montado
function detect_mounted()
{
	# Retorna se esta montado = 0
	MOUNTED=$(mount | grep -i iphone)
	if [ -n "${MOUNTED}" ]; then
		echo "montado - ${MOUNTED}"
		return 0
	else
		echo "nao montado - ${MOUNTED}"
		return 1

	fi
}

function mount_device()
{
	mkdir -p ${MOUNT_PATH} 2>/dev/null
	ifuse "${MOUNT_PATH}" && ${APP} ${MOUNT_PATH} &  
	return $?
}
function umount_device()
{
	sudo umount ${MOUNT_PATH} 2>/dev/null
}

function mount_action_zenity()
{
	#DEV=$(detect_device)
	detect_device
	VAR=$$
	if [ ! $VAR ]; then
		exit 1
	fi


	OPT=$(zenity --list --text="Selecione a opção de montagem"  --radiolist --column="Seleção" --column="Opção" TRUE Montagem FALSE "Desmontagem")
	case $OPT in
		Montagem)
			detect_mounted && VAR=$?
			if [ $VAR -eq 0 ]; then
				zenity --question --text="O dispositivo já está montado. \nDeseja acessá-lo?" --width=200
				RET=$?
				case $RET in
					0) 
						${APP} ${MOUNT_PATH} & 
					;;
					1)
						exit 1
					;;
				esac				
			else
				#(detect_device)
				if [ detect_device ]; then
					mount_device
				fi
			fi
		;;

		Desmontagem)
			detect_mounted && VAR=$?
			if [ $VAR -eq 0 ]; then
				umount_device
			else
				
				zenity --info --text="Não há dispositivo montado.\nPode remover o dispositivo." --width=200 || echo "Não há dispositivo montado, pode remover o dispositivo"
			fi
		;;
	esac
}

##################
# INICIO
##################

mount_action_zenity
