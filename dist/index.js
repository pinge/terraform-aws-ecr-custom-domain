'use strict'

const AWS_ECR_PATH = process.env.AWS_ECR_PATH

exports.handler = (event, context, callback) => {
    const location = `https://${AWS_ECR_PATH}${event.rawPath}`
    return callback(null, { headers: { location }, statusCode: 307 })
}
