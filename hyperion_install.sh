#######################################################################
#######################################################################
##                                                                   ##
## THIS SCRIPT SHOULD ONLY BE RUN ON A TANIX TX3 BOX RUNNING ARMBIAN ##
##                                                                   ##
#######################################################################
#######################################################################
set -o errexit  # Exit script when a command exits with non-zero status
set -o errtrace # Exit on error inside any functions or sub-shells
set -o nounset  # Exit script on use of an undefined variable
set -o pipefail # Return exit status of the last command in the pipe that failed

# ==============================================================================
# GLOBALS
# ==============================================================================

# ==============================================================================
# SCRIPT LOGIC
# ==============================================================================

# ------------------------------------------------------------------------------
# public key from Hyperion
# ------------------------------------------------------------------------------
public_key_from_hyperion() {
    echo ""
    echo ""
    echo ""
    wget -qO- https://apt.hyperion-project.org/hyperion.pub.key | sudo gpg --dearmor -o /usr/share/keyrings/hyperion.pub.gpg
}

# ------------------------------------------------------------------------------
# Hyperion-Project as source of Hyperion
# ------------------------------------------------------------------------------
hyperion_project_as_source_of_hyperion() {
    echo ""
    echo ""
    echo ""
    echo "deb [signed-by=/usr/share/keyrings/hyperion.pub.gpg] https://apt.hyperion-project.org/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hyperion.list
}
# ------------------------------------------------------------------------------
# update the package list and install Hyperion
# ------------------------------------------------------------------------------
update_the_package_install_hyperion() {
    echo ""
    echo "A instalar o Hyperion"
    echo ""
    sudo apt-get update && sudo apt-get -y install hyperion
}

# ------------------------------------------------------------------------------
# Armbian update
# ------------------------------------------------------------------------------
update_armbian() {
    echo ""
    echo "A atualizar armbian"
    echo ""
    armbian-update
}

# ==============================================================================
# RUN LOGIC
# ------------------------------------------------------------------------------
main() {
  # Are we root?
  if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    echo "Please try again after running:"
    echo "  sudo su"
    exit 1
  fi

  # Install ALL THE THINGS!
#  update_armbian
  public_key_from_hyperion
  hyperion_project_as_source_of_hyperion
  update_the_package_install_hyperion

  exit 0
}
main
