@Library('general-pipeline') _

def clone(udid) {
  checkout changelog: true, poll: true, scm: [$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: "$udid/ios-core-sdk"]], submoduleCfg: [], userRemoteConfigs: [[url: 'git@github.com:emartech/ios-core-sdk.git']]]
}

def podi(udid) {
  lock("pod") {
      sh "cd $udid/ios-core-sdk && pod install"
  }
}

def podiLinti(udid) {
    lock(udid) {
        sh "cd $udid/ios-core-sdk && pod lib lint --allow-warnings"
    }
}

def buildAndTest(platform, udid) {
  lock(udid) {
    def uuid = UUID.randomUUID().toString()
    try {
        sh "mkdir /tmp/$uuid"
        retry(3) {
            sh "cd $udid/ios-core-sdk && scan --scheme CoreTests -d 'platform=$platform,id=$udid' --derived_data_path $uuid -o test_output/unit/ -allowProvisioningUpdates"
        }
    } catch(e) {
        currentBuild.result = 'FAILURE'
        throw e
    } finally {
        junit "$udid/ios-core-sdk/test_output/unit/*.junit"
        archiveArtifacts "$udid/ios-core-sdk/test_output/unit/*"
    }
  }
}

node('master') {
  withSlack channel:'jenkins', {
      stage('Start'){
          deleteDir()
        sh 'eval $(ssh-agent) && ssh-add ~/.ssh/ios-core'
      }
      stage('Git Clone') {
        parallel iOS_9_3_Simulator: {
            clone env.IOS93SIMULATOR
        }, failFast: false
      }
      stage('Pod install') {
        parallel iOS_9_3_Simulator: {
            podi env.IOS93SIMULATOR
        }, failFast: false
      }
    stage('Pod lint'){
            parallel iOS_9_3_Simulator: {
                podiLinti env.IOS93SIMULATOR
            }, failFast: false
      }
      stage('Build and Test'){
            parallel iOS_9_3_Simulator: {
                buildAndTest 'iOS Simulator', env.IOS93SIMULATOR
            }, failFast: false
      }
      stage('Deploy to private pod repo'){
          sh "cd $env.IPAD_PRO/ios-core-sdk && ./deploy-to-private-pod-repo.sh ${env.BUILD_NUMBER}.0.0"
      }
      stage('Finish'){
        echo "That is just pure awesome!"
      }
  }
}
