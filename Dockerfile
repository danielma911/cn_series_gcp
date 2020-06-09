ARG MARKETPLACE_TOOLS_TAG=0.9.4
FROM launcher.gcr.io/google/debian9 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ADD schema.yaml /tmp/schema.yaml

# Provide registry prefix and tag for default values for images.
ARG REGISTRY=gcr.io/paloaltonetworks-public/cn-series-marketplace
ARG TAG_plugin=cni-1.0.0-b3
ARG NAMESPACE=cn-series
ARG TAG_init=6e6a84cbe818f9b679367bf18f030d4394ce432d5045c4b81cf82de8fdcdd729
ARG TAG_mgmt=41e3488ec3de01dfe640c5d4d50b4c3233afbcd85f12fb782497312f3e024ea5

RUN cat /tmp/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG_plugin=$TAG_plugin" "NAMESPACE=$NAMESPACE" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /tmp/schema.yaml

ADD schema.yaml /tmp/apptest/schema.yaml

RUN cat /tmp/apptest/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG_plugin=$TAG_plugin" "NAMESPACE=$NAMESPACE" envsubst \
    > /tmp/apptest/schema.yaml.new \
    && mv /tmp/apptest/schema.yaml.new /tmp/apptest/schema.yaml

FROM gcr.io/cloud-marketplace-tools/k8s/deployer_envsubst:$MARKETPLACE_TOOLS_TAG

COPY manifest /data/manifest
#COPY apptest/deployer /data-test/
COPY --from=build /tmp/schema.yaml /data/
COPY --from=build /tmp/apptest/schema.yaml /data-test/
RUN mkdir /data/values

