
# Backup

> This is the backup solution with [docker-volume-backup](https://github.com/jareware/docker-volume-backup).

## Restore

1. Install [AWS-CLI](https://formulae.brew.sh/formula/awscli)
2. Login to AWS:
   1. create a `.aws` directory in you userhome
   2. create two files in this directory `config` and `credentials`
   3. add this to your config file:

        ```toml
        [default]
        region = ch-dk-2 # your bucket region
        ```

   4. add this to your credentials file:

        ```toml
        [default]
        aws_access_key_id = EXOasdf
        aws_secret_access_key = asdf
        ```

3. Download your backup you want with `aws s3 cp s3://<bucket-name>/<backup-file-name.tar.gz> --endpoint-url "<your-url>" ./`
4. Unpack archive with: `tar -xf <backup-file-name.tar.gz>`
5. Find the mount path of your mounted volume:
   1. List all volumes with `docker volume ls`
   2. Inspect your target volume with `docker inspect database-cluster_database`
   3. Copy the path from the attribute: `Mountpoint` (`"Mountpoint": "/var/lib/docker/volumes/database-cluster_database/_data",`)
6. delete currect value (or safe your currect value from the volume with moving the file to another place): `rm -rf/var/lib/docker/volumes/database-cluster_database/_data ./current-volume`
7. copy your resotred volume to this mountpoint with: `cp -r backup/database_cluster /var/lib/docker/volumes/database-cluster_database/_data`
