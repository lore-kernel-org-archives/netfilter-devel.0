From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 6/6] tests: update tests with
 nft_*_parse_file()
Date: Wed, 8 Jan 2014 00:32:19 +0100
Message-ID: <20140107233219.GE16894@localhost>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
 <20140107114742.12841.61774.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35642 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaAGXcX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:32:23 -0500
Content-Disposition: inline
In-Reply-To: <20140107114742.12841.61774.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 07, 2014 at 12:47:42PM +0100, Arturo Borrero Gonzalez wrote:
> Lets do testing with nft_*_parse_file() functions.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  tests/nft-parsing-test.c |  102 +++++++++++++++++++++++++++-------------------
>  1 file changed, 59 insertions(+), 43 deletions(-)
> 
> diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
> index 558c849..4702fd3 100644
> --- a/tests/nft-parsing-test.c
> +++ b/tests/nft-parsing-test.c
> @@ -73,7 +73,8 @@ static void print_detail_error(char *a, char *b)
>  	}
>  }
>  
> -static int compare_test(uint32_t type, void *input, const char *filename)
> +static int compare_test(uint32_t type, void *input, const char *filename,
> +			FILE *fp)
>  {
>  	struct nft_table *t = NULL;
>  	struct nft_chain *c = NULL;
> @@ -82,7 +83,6 @@ static int compare_test(uint32_t type, void *input, const char *filename)
>  	struct nft_ruleset *rs = NULL;
>  	char orig[4096];
>  	char out[4096];
> -	FILE *fp;
>  
>  	switch (type) {
>  	case TEST_XML_TABLE:
> @@ -148,14 +148,8 @@ static int compare_test(uint32_t type, void *input, const char *filename)
>  		return -1;
>  	}
>  
> -	fp = fopen(filename, "r");
> -	if (fp == NULL) {
> -		perror("open");
> -		exit(EXIT_FAILURE);
> -	}
> -
> +	rewind(fp);
>  	fgets(orig, sizeof(orig), fp);
> -	fclose(fp);
>  
>  	if (strncmp(orig, out, strlen(out)) == 0)
>  		return 0;
> @@ -178,19 +172,26 @@ static int test_json(const char *filename, struct nft_parse_err *err)
>  	struct nft_ruleset *rs;
>  	json_t *root;
>  	json_error_t error;
> -	char *json;
> +	FILE *fp;
> +
> +	fp = fopen(filename, "r");
> +	if (fp == NULL) {
> +		printf("unable to open file %s: %s\n", filename,
> +		       strerror(errno));
> +		return -1;
> +	}
>  
>  	root = json_load_file(filename, 0, &error);
>  	if (!root)
>  		return -1;
>  
> -	json = json_dumps(root, JSON_INDENT(0));
> -
>  	if (json_object_get(root, "table") != NULL) {

This was fine in an early stage, but now that you have the ruleset
API, we should provide a nft_ruleset_parse_file(...) function that do
all this for you. As a side effect, the test will be simplified.

>  		t = nft_table_alloc();
>  		if (t != NULL) {
> -			if (nft_table_parse(t, NFT_PARSE_JSON, json, err) == 0)
> -				ret = compare_test(TEST_JSON_TABLE, t, filename);
> +			if (nft_table_parse_file(t, NFT_PARSE_JSON,
> +						 fp, err) == 0)
> +				ret = compare_test(TEST_JSON_TABLE, t,
> +						   filename, fp);
>  			else
>  				goto failparsing;
>  
