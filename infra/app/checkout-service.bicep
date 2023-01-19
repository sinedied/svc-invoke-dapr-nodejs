@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unqiue hash used in all resources.')
param name string

@minLength(1)
@description('Primary location for all resources')
param location string

@minLength(1)
@description('name used to derive service, container and dapr appid')
param containerName string = 'checkout'

@description('image name used to pull')
param imageName string = ''

var resourceToken = toLower(uniqueString(subscription().id, name, location))

param tags object = {
  'azd-env-name': name
}

module containerApp '../core/containerapp.bicep' = {
  name: 'ca-checkout-svc-${resourceToken}'
  params:{
    name: name
    location: location
    containerName: containerName
    imageName: imageName != '' ? imageName : 'nginx:latest'
    tags: union(tags, { 'azd-service-name': 'checkout' })
  }
}

output CONTAINERAPP_URI string = containerApp.outputs.CONTAINERAPP_URI
