From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/3] xtables-compat: check if nft ruleset is
 compatible
Date: Mon, 22 Aug 2016 11:56:23 +0200
Message-ID: <20160822095623.GB10679@salvia>
References: <20160821181027.14622-1-pablombg@gmail.com>
 <20160821181027.14622-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbcHVJ4c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 05:56:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4234316B2AF
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:56:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31B704C334
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:56:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 151094C334
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:56:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160821181027.14622-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 21, 2016 at 08:10:26PM +0200, Pablo M. Bermudo Garay wrote:
> This patch adds a verification of the compatibility between the nft
> ruleset and iptables. If the nft ruleset is not compatible with
> iptables, the execution stops and an error message is displayed to the
> user.

Please, indicate here that this is also checking for built-in tables
and chains.

> This checking is triggered by xtables-compat -L and xtables-compat-save
> commands.
> 
> Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
> ---
>  iptables/nft.c          | 166 ++++++++++++++++++++++++++++++++++++++++++++++++
>  iptables/nft.h          |   2 +
>  iptables/xtables-save.c |   5 ++
>  iptables/xtables.c      |   5 ++
>  4 files changed, 178 insertions(+)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 247a60a..7389689 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -2698,3 +2698,169 @@ uint32_t nft_invflags2cmp(uint32_t invflags, uint32_t flag)
>  
>  	return NFT_CMP_EQ;
>  }
> +
> +static int nft_is_rule_compatible(struct nftnl_rule *rule)
> +{
> +	struct nftnl_expr_iter *iter;
> +	struct nftnl_expr *expr;
> +
> +	iter = nftnl_expr_iter_create(rule);
> +	if (iter == NULL)
> +		return -1;
> +
> +	expr = nftnl_expr_iter_next(iter);
> +	while (expr != NULL) {
> +		const char *name = nftnl_expr_get_str(expr, NFTNL_EXPR_NAME);
> +
> +		if (strcmp(name, "counter")   &&
> +		    strcmp(name, "match")     &&
> +		    strcmp(name, "target")    &&

Arturo is right, this is duplicated.

> +		    strcmp(name, "payload")   &&
> +		    strcmp(name, "meta")      &&
> +		    strcmp(name, "bitwise")   &&
> +		    strcmp(name, "cmp")       &&
> +		    strcmp(name, "immediate") &&
> +		    strcmp(name, "match")     &&
> +		    strcmp(name, "target")) {

I would place this in a array:

#define NFT_COMPAT_EXPR_MAX     8

static const char *supported_exprs[NFT_COMPAT_EXPR] = {
        "match",
        "target"
        "payload",
        "meta"
        "cmp",
        "bitwise",
        "counter",
        "immediate"
};

And make a function for this:

static bool nft_compat_expr(const struct nftnl_expr *expr)
{
        int i;

        for (i = 0; i < NFT_COMPAT_EXPR_MAX; i++) {
                if (!strcmp(supported_exprs[i], name))
                        return true;
        }

        return false;
}

> +			nftnl_expr_iter_destroy(iter);
> +			return 1;
> +		}
> +
> +		expr = nftnl_expr_iter_next(iter);
> +	}
> +
> +	nftnl_expr_iter_destroy(iter);
> +	return 0;
> +}
> +
> +static int check_builtin_chain(const char *table, const char *chain)
> +{
> +	const char *cur_table;
> +	struct builtin_chain *chains;
> +	int i, j;
> +
> +	for (i = 0; i < TABLES_MAX; i++) {
> +		cur_table = xtables_ipv4[i].name;
> +		chains = xtables_ipv4[i].chains;
> +		if (strcmp(table, cur_table) == 0) {
> +			for (j = 0; j < NF_INET_NUMHOOKS && chains[j].name; j++) {
> +				if (strcmp(chain, chains[j].name) == 0)
> +					return 0;
> +			}
> +		}
> +	}
> +
> +	return 1;
> +}
> +
> +static int nft_are_chains_compatible(struct nft_handle *h)
> +{
> +	struct nftnl_chain_list *list;
> +	struct nftnl_chain_list_iter *iter;
> +	struct nftnl_chain *chain;
> +
> +	list = nftnl_chain_list_get(h);
> +	if (list == NULL)
> +		return -1;
> +
> +	iter = nftnl_chain_list_iter_create(list);
> +	if (iter == NULL)
> +		return -1;
> +
> +	chain = nftnl_chain_list_iter_next(iter);
> +	while (chain != NULL) {
> +		if (nft_chain_builtin(chain)) {
> +			const char *table = nftnl_chain_get(chain,
> +							    NFTNL_CHAIN_TABLE);
> +			const char *name = nftnl_chain_get(chain,
> +							   NFTNL_CHAIN_NAME);
> +
> +			if (check_builtin_chain(table, name) == 1) {
> +				nftnl_chain_list_iter_destroy(iter);
> +				nftnl_chain_list_free(list);
> +				return 1;
> +			}
> +		}
> +
> +		chain = nftnl_chain_list_iter_next(iter);
> +	}
> +
> +	nftnl_chain_list_iter_destroy(iter);
> +	nftnl_chain_list_free(list);
> +	return 0;
> +}
> +
> +static int nft_are_tables_compatible(struct nft_handle *h)
> +{
> +	struct nftnl_table_list *list;
> +	struct nftnl_table_list_iter *iter;
> +	struct nftnl_table *table;
> +
> +	list = nftnl_table_list_get(h);
> +	if (list == NULL)
> +		return -1;
> +
> +	iter = nftnl_table_list_iter_create(list);
> +	if (iter == NULL)
> +		return -1;
> +
> +	table = nftnl_table_list_iter_next(iter);
> +	while (table != NULL) {
> +		const char *name = nftnl_table_get(table, NFTNL_TABLE_NAME);
> +
> +		if (strcmp(name, "filter") &&
> +		    strcmp(name, "nat")    &&
> +		    strcmp(name, "mangle") &&
> +		    strcmp(name, "raw")    &&
> +		    strcmp(name, "security")) {

Why not use the builtin structure definition for this?

> +			nftnl_table_list_iter_destroy(iter);
> +			nftnl_table_list_free(list);
> +			return 1;
> +		}
> +
> +		table = nftnl_table_list_iter_next(iter);
> +	}
> +
> +	nftnl_table_list_iter_destroy(iter);
> +	nftnl_table_list_free(list);
> +	return 0;
> +}
> +
> +int nft_is_ruleset_compatible(struct nft_handle *h)
> +{
> +
> +	struct nftnl_rule_list *list;
> +	struct nftnl_rule_list_iter *iter;
> +	struct nftnl_rule *rule;
> +	int ret;
> +
> +	ret = nft_are_tables_compatible(h);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = nft_are_chains_compatible(h);
> +	if (ret != 0)
> +		return ret;
> +
> +	list = nft_rule_list_get(h);
> +	if (list == NULL)
> +		return -1;
> +
> +	iter = nftnl_rule_list_iter_create(list);
> +	if (iter == NULL)
> +		return -1;
> +
> +	rule = nftnl_rule_list_iter_next(iter);
> +	while (rule != NULL) {
> +		ret = nft_is_rule_compatible(rule);
> +		if (ret != 0) {
> +			nftnl_rule_list_iter_destroy(iter);
> +			return ret;
> +		}
> +
> +		rule = nftnl_rule_list_iter_next(iter);
> +	}
> +
> +	nftnl_rule_list_iter_destroy(iter);
> +	return 0;
> +}
> diff --git a/iptables/nft.h b/iptables/nft.h
> index bcabf42..f5449db 100644
> --- a/iptables/nft.h
> +++ b/iptables/nft.h
> @@ -181,4 +181,6 @@ int nft_arp_rule_insert(struct nft_handle *h, const char *chain,
>  
>  void nft_rule_to_arpt_entry(struct nftnl_rule *r, struct arpt_entry *fw);
>  
> +int nft_is_ruleset_compatible(struct nft_handle *h);
> +
>  #endif
> diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
> index 50b5b5a..50ae8a5 100644
> --- a/iptables/xtables-save.c
> +++ b/iptables/xtables-save.c
> @@ -138,6 +138,11 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
>  		exit(1);
>  	}
>  
> +	if (nft_is_ruleset_compatible(&h) == 1) {
> +		printf("WARNING: You're using features from nft that we cannot map to iptables, please keep using nft.\n\n");
> +		exit(EXIT_SUCCESS);

Success? :) I would say ERROR here and get back to the shell with
EXIT_FAILURE. Same thing in other spots.
