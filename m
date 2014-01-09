From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 3/3] tests: update tests with
 nft_*_parse_file()
Date: Thu, 9 Jan 2014 18:00:39 +0100
Message-ID: <20140109170039.GC15460@localhost>
References: <20140109111906.32565.65222.stgit@nfdev.cica.es>
 <20140109111917.32565.22160.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50891 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbaAIRAo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:00:44 -0500
Content-Disposition: inline
In-Reply-To: <20140109111917.32565.22160.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 09, 2014 at 12:19:17PM +0100, Arturo Borrero Gonzalez wrote:
> Lets do testing with nft_ruleset_parse_file() functions.
> 
> For this to work, all testfiles are enclosed in the corresponding
> format top element:
>  * XML: <nftables>*</nftables>
>  * JSON: {"nftables":[*]}

Applied this with changes. Thanks Arturo.

> diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
> index 558c849..2f9ffd9 100644
> --- a/tests/nft-parsing-test.c
> +++ b/tests/nft-parsing-test.c
> @@ -12,14 +12,6 @@
>  #include <libnftables/rule.h>
>  #include <libnftables/set.h>
>  
> -#ifdef XML_PARSING
> -#include <mxml.h>
> -#endif
> -
> -#ifdef JSON_PARSING
> -#include <jansson.h>
> -#endif
> -
>  enum {
>  	TEST_XML_TABLE = 0,
>  	TEST_XML_CHAIN,

TEST_XML_TABLE, _CHAIN, ... are not used anymore after this change. I
removed them.

> @@ -33,7 +25,6 @@ enum {
>  	TEST_JSON_RULESET,
>  };
>  
> -#if defined(XML_PARSING) || defined(JSON_PARSING)
>  static void print_detail_error(char *a, char *b)
>  {
>  	int i;
> @@ -73,7 +64,8 @@ static void print_detail_error(char *a, char *b)
>  	}
>  }
>  
> -static int compare_test(uint32_t type, void *input, const char *filename)
> +static int compare_test(uint32_t type, void *input, const char *filename,
> +			FILE *fp)
>  {
>  	struct nft_table *t = NULL;
>  	struct nft_chain *c = NULL;
> @@ -82,7 +74,6 @@ static int compare_test(uint32_t type, void *input, const char *filename)
>  	struct nft_ruleset *rs = NULL;
>  	char orig[4096];
>  	char out[4096];
> -	FILE *fp;
>  
>  	switch (type) {
>  	case TEST_XML_TABLE:
> @@ -148,14 +139,8 @@ static int compare_test(uint32_t type, void *input, const char *filename)
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
> @@ -165,192 +150,75 @@ static int compare_test(uint32_t type, void *input, const char *filename)
>  	print_detail_error(orig, out);
>  	return -1;
>  }
> -#endif
>  
>  static int test_json(const char *filename, struct nft_parse_err *err)
>  {
> -#ifdef JSON_PARSING
>  	int ret = -1;
> -	struct nft_table *t;
> -	struct nft_chain *c;
> -	struct nft_rule *r;
> -	struct nft_set *s;
>  	struct nft_ruleset *rs;
> -	json_t *root;
> -	json_error_t error;
> -	char *json;
> +	FILE *fp;
>  
> -	root = json_load_file(filename, 0, &error);
> -	if (!root)
> +	fp = fopen(filename, "r");
> +	if (fp == NULL) {
> +		printf("unable to open file %s: %s\n", filename,
> +		       strerror(errno));
>  		return -1;
> +	}
>  
> -	json = json_dumps(root, JSON_INDENT(0));
> -
> -	if (json_object_get(root, "table") != NULL) {
> -		t = nft_table_alloc();
> -		if (t != NULL) {
> -			if (nft_table_parse(t, NFT_PARSE_JSON, json, err) == 0)
> -				ret = compare_test(TEST_JSON_TABLE, t, filename);
> -			else
> -				goto failparsing;
> -
> -			nft_table_free(t);
> -		}
> -	} else if (json_object_get(root, "chain") != NULL) {
> -		c = nft_chain_alloc();
> -		if (c != NULL) {
> -			if (nft_chain_parse(c, NFT_PARSE_JSON, json, err) == 0)
> -				ret = compare_test(TEST_JSON_CHAIN, c, filename);
> -			else
> -				goto failparsing;
> -
> -			nft_chain_free(c);
> -		}
> -	} else if (json_object_get(root, "rule") != NULL) {
> -		r = nft_rule_alloc();
> -		if (r != NULL) {
> -			if (nft_rule_parse(r, NFT_PARSE_JSON, json, err) == 0)
> -				ret = compare_test(TEST_JSON_RULE, r, filename);
> -			else
> -				goto failparsing;
> +	rs = nft_ruleset_alloc();
> +	if (rs != NULL) {

The typical policy is to check for errors instead, I have changed this:

        if (rs == NULL {
                perror("nft_ruleset_alloc");
                return -1;
        }

> +		if (nft_ruleset_parse_file(rs, NFT_PARSE_JSON,
> +					   fp, err) == 0)
> +			ret = compare_test(TEST_JSON_RULESET, rs,
> +					   filename, fp);

And we save one indent and we don't need to break lines anymore.

> +		else
> +			goto failparsing;
>  
> -			nft_rule_free(r);
> +		nft_ruleset_free(rs);
>  		}
