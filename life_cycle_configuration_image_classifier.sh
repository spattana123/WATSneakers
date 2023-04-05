set -e

# Download Script

ENVIRONMENT=python3
NOTEBOOK_FILE="/home/ec2-user/SageMaker/WATSneakers/Sagemaker-Image-Classifer-Transfer-Learning.ipynb"
NOTEBOOK_DIR="/home/ec2-user/SageMaker/WATSneakers/"
AUTO_STOP_FILE="/home/ec2-user/SageMaker/auto-stop.py"

cd /home/ec2-user/SageMaker/
git clone https://github.com/spattana123/WATSneakers
ls $NOTEBOOK_DIR
cd ../../../
# Check if file is intalled
if  [ ! -d "NOTEBOOK_DIR" ] 
then
    echo "File exists"
    ls -la /home/ec2-user/SageMaker/
else
    echo "File does not exist"
    ls /home/ec2-user/SageMaker/
    cd /home/ec2-user/SageMaker/
    git clone https://github.com/spattana123/WATSneakers
    cd ~
    echo "Clone Complete"
fi
ls $NOTEBOOK_DIR
# Install Anaconda
source /home/ec2-user/anaconda3/bin/activate "$ENVIRONMENT"

jupyter nbconvert --to html "$NOTEBOOK_FILE" --ExecutePreprocessor.kernel_name=python3 --execute --ExecutePreprocessor.enabled=True --stdout

source /home/ec2-user/anaconda3/bin/deactivate

# PARAMETERS
IDLE_TIME=21600  # 6 hours

echo "Fetching the autostop script"
wget https://raw.githubusercontent.com/aws-samples/amazon-sagemaker-notebook-instance-lifecycle-config-samples/master/scripts/auto-stop-idle/autostop.py

echo "Starting the SageMaker autostop script in cron"
(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/bin/python $PWD/autostop.py --time $IDLE_TIME --ignore-connections") | crontab -
