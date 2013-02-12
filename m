From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] Added examples of functionality to print XML
 output of nftables rule/chain/table
Date: Tue, 12 Feb 2013 23:31:06 +0100
Message-ID: <20130212223106.GA4882@localhost>
References: <20130211225529.2489.3521.stgit@nfdev.cica.es>
 <20130211225638.2489.36343.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pneira@us.es
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:27712 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752101Ab3BLWbN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:31:13 -0500
Content-Disposition: inline
In-Reply-To: <20130211225638.2489.36343.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi Arturo,

I have applied this patch but I have left out a part of it, see below:

On Mon, Feb 11, 2013 at 11:56:38PM +0100, Arturo Borrero wrote:
> 
> ---
>  examples/nft-chain-get.c |   17 ++++++++++++-----
>  examples/nft-rule-get.c  |   12 ++++++++++--
>  examples/nft-table-get.c |   25 +++++++++++++++++++++++--
>  src/expr/match.c         |    2 --
>  4 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/examples/nft-chain-get.c b/examples/nft-chain-get.c
> index 2756c90..4bb0552 100644
> --- a/examples/nft-chain-get.c
> +++ b/examples/nft-chain-get.c
> @@ -23,6 +23,7 @@ static int table_cb(const struct nlmsghdr *nlh, void *data)
>  {
>  	struct nft_chain *t;
>  	char buf[4096];
> +	uint32_t *type=data;
>  
>  	t = nft_chain_alloc();
>  	if (t == NULL) {
> @@ -35,7 +36,7 @@ static int table_cb(const struct nlmsghdr *nlh, void *data)
>  		goto err_free;
>  	}
>  
> -	nft_chain_snprintf(buf, sizeof(buf), t, NFT_CHAIN_O_DEFAULT, 0);
> +	nft_chain_snprintf(buf, sizeof(buf), t, *type, 0);
>  	printf("%s", buf);
>  
>  err_free:
> @@ -52,13 +53,14 @@ int main(int argc, char *argv[])
>  	uint32_t portid, seq;
>  	struct nft_chain *t = NULL;
>  	int ret;
> +	uint32_t type=NFT_CHAIN_O_DEFAULT;
>  
>  	seq = time(NULL);
>  
> -	if (argc == 1) {
> +	if (argc >= 1 && argc <= 2) {
>  		nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, AF_INET,
>  						NLM_F_DUMP, seq);
> -	} else if (argc == 4) {
> +	} else if (argc >= 4 && argc <= 5) {
>  		int family;
>  
>  		if (strcmp(argv[1], "ip") == 0)
> @@ -84,11 +86,16 @@ int main(int argc, char *argv[])
>  		nft_chain_nlmsg_build_payload(nlh, t);
>  		nft_chain_free(t);
>  	} else {
> -		fprintf(stderr, "Usage: %s [<family> <table> <chain>]\n",
> +		fprintf(stderr, "Usage: %s [<family> <table> <chain>] [xml]\n",
>  			argv[0]);
>  		exit(EXIT_FAILURE);
>  	}
>  
> +
> +	if ( strcmp(argv[argc - 1], "xml") == 0 )
> +		type = NFT_CHAIN_O_XML;
> +
> +
>  	nl = mnl_socket_open(NETLINK_NETFILTER);
>  	if (nl == NULL) {
>  		perror("mnl_socket_open");
> @@ -108,7 +115,7 @@ int main(int argc, char *argv[])
>  
>  	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
>  	while (ret > 0) {
> -		ret = mnl_cb_run(buf, ret, seq, portid, table_cb, NULL);
> +		ret = mnl_cb_run(buf, ret, seq, portid, table_cb, &type);
>  		if (ret <= 0)
>  			break;
>  		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
> index 75043d7..93359c3 100644
> --- a/examples/nft-rule-get.c
> +++ b/examples/nft-rule-get.c
> @@ -23,6 +23,7 @@ static int table_cb(const struct nlmsghdr *nlh, void *data)
>  {
>  	struct nft_rule *t;
>  	char buf[4096];
> +	uint32_t *type=data;
>  
>  	t = nft_rule_alloc();
>  	if (t == NULL) {
> @@ -35,7 +36,7 @@ static int table_cb(const struct nlmsghdr *nlh, void *data)
>  		goto err_free;
>  	}
>  
> -	nft_rule_snprintf(buf, sizeof(buf), t, NFT_RULE_O_DEFAULT, 0);
> +	nft_rule_snprintf(buf, sizeof(buf), t, *type, 0);
>  	printf("%s", buf);
>  
>  err_free:
> @@ -52,6 +53,13 @@ int main(int argc, char *argv[])
>  	uint32_t portid, seq;
>  	struct nft_rule *t = NULL;
>  	int ret;
> +	uint32_t type=NFT_RULE_O_DEFAULT;
> +
> +	if (argc == 2) {
> +		if (strcmp(argv[1], "xml") == 0 ) {
> +			type=NFT_RULE_O_XML;
> +		}
> +	}
>  
>  	/* XXX requires table, chain and handle attributes for selective get */
>  
> @@ -84,7 +92,7 @@ int main(int argc, char *argv[])
>  
>  	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
>  	while (ret > 0) {
> -		ret = mnl_cb_run(buf, ret, seq, portid, table_cb, NULL);
> +		ret = mnl_cb_run(buf, ret, seq, portid, table_cb, &type);
>  		if (ret <= 0)
>  			break;
>  		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
> index 219c188..97123b0 100644
> --- a/examples/nft-table-get.c
> +++ b/examples/nft-table-get.c
> @@ -23,6 +23,7 @@ static int table_cb(const struct nlmsghdr *nlh, void *data)
>  {
>  	struct nft_table *t;
>  	char buf[4096];
> +	uint32_t *type=data;
>  
>  	t = nft_table_alloc();
>  	if (t == NULL) {
> @@ -35,7 +36,7 @@ static int table_cb(const struct nlmsghdr *nlh, void *data)
>  		goto err_free;
>  	}
>  
> -	nft_table_snprintf(buf, sizeof(buf), t, NFT_TABLE_O_DEFAULT, 0);
> +	nft_table_snprintf(buf, sizeof(buf), t, *type, 0);
>  	printf("%s", buf);
>  
>  err_free:
> @@ -52,6 +53,26 @@ int main(int argc, char *argv[])
>  	uint32_t portid, seq;
>  	struct nft_table *t = NULL;
>  	int ret;
> +	uint32_t type = NFT_TABLE_O_DEFAULT;
> +
> +	/*
> +	Usage: ./nft_table_get [table] [{xml|default}]
> +	# ./nft_table_get xml -> this shows all tables in xml format
> +	# ./nft_table_get xml xml -> this shows "xml" table in xml format
> +	# ./nft_table_get xml default -> shows "xml" table in default format
> +	# ./nft_table_get default -> a table named "default" in default format
> +	# ./nft_table_get default default -> "default" table in default format
> +	# ./nft_table_get default xml -> shows "default" table in xml format
> +	*/
> +
> +	if (strcmp(argv[argc - 1], "xml") == 0) {
> +		type = NFT_TABLE_O_XML;
> +		argv[argc -1] = NULL;
> +		argc--;
> +	} else if (strcmp(argv[argc - 1], "default") == 0) {
> +		argc--;
> +	}
> +
>  
>  	if (argc == 2) {
>  		t = nft_table_alloc();
> @@ -92,7 +113,7 @@ int main(int argc, char *argv[])
>  
>  	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
>  	while (ret > 0) {
> -		ret = mnl_cb_run(buf, ret, seq, portid, table_cb, NULL);
> +		ret = mnl_cb_run(buf, ret, seq, portid, table_cb, &type);
>  		if (ret <= 0)
>  			break;
>  		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> diff --git a/src/expr/match.c b/src/expr/match.c
> index 0c7427d..9ae849b 100644
> --- a/src/expr/match.c
> +++ b/src/expr/match.c
> @@ -15,8 +15,6 @@
>  #include <stdint.h>
>  #include <string.h>	/* for memcpy */
>  #include <arpa/inet.h>
> -#include <stdlib.h>	/* bin to hex*/
> -#include <math.h>	/* bin to hex*/
>  
>  #include <libmnl/libmnl.h>
>  
> 

This chunk logically belongs to a different patch. Please, send me a
follow up patch including description for this and I will apply.

Thanks!
