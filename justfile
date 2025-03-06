add_product:
  hugo new product/product-$(date "+%Y-%m-%d").md

build:
    hugo --minify=true --gc --cleanDestinationDir --logLevel info

publish: build
    git add --all && git commit -m "autocommit $(date)" && git pull && git push

serve:
    hugo server --minify=true --gc --cleanDestinationDir  --logLevel info --buildDrafts
