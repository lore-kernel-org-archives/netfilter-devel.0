From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [xtables-arptables PATCH 3/4] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Mon, 22 Jul 2013 18:35:49 +0300
Message-ID: <51ED5155.7020306@linux.intel.com>
References: <20130716222925.13253.93123.stgit@nftables> <20130716223053.13253.90159.stgit@nftables>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25878 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab3GVPgO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:36:14 -0400
In-Reply-To: <20130716223053.13253.90159.stgit@nftables>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

You haven't tested your patch, have you?

You need to change nft_init() so it takes the family to give to the 
handle as a parameter. Only then nft_xtables_config_load will work.
That said, you will have to move nft_init() into xtables.c and remove it 
from xtables-standalone.c
and fix xtables-save.c, xtables-restore.c etc... (move the nft_init() 
part after the command parsing in those, so you can put h.family as 
family param, for instance)
I quickly tried and it works well that way.

About xtables-config.c, you have to add the config filename as a paremet 
to nft_init() as well. it will be required anyway for arptables too!

Cheers,

Tomasz

> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>   iptables/nft.c |   28 ++++++++--------------------
>   1 file changed, 8 insertions(+), 20 deletions(-)
>
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 9a8986a..198c41e 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -388,6 +388,14 @@ int nft_init(struct nft_handle *h)
>   	h->portid = mnl_socket_get_portid(h->nl);
>   	h->tables = tables;
>   
> +	/* If built-in chains don't exist for this table, create them */
> +	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0) {
> +		int i;
> +
> +		for (i=0; i<TABLES_MAX; i++)
> +			if (h->tables[i].name != NULL)
> +				nft_chain_builtin_init(h, h->tables[i].name, NULL, NF_ACCEPT);
> +	}
>   	return 0;
>   }
>   
> @@ -742,10 +750,6 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
>   	uint16_t flags = NLM_F_ACK|NLM_F_CREATE;
>   	int ret = 1;
>   
> -	/* If built-in chains don't exist for this table, create them */
> -	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
> -		nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
> -
>   	nft_fn = nft_rule_append;
>   
>   	r = nft_rule_new(h, chain, table, cs);
> @@ -1316,10 +1320,6 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
>   	struct nft_chain *c;
>   	int ret;
>   
> -	/* If built-in chains don't exist for this table, create them */
> -	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
> -		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
> -
>   	c = nft_chain_alloc();
>   	if (c == NULL)
>   		return 0;
> @@ -1472,10 +1472,6 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
>   	uint64_t handle;
>   	int ret;
>   
> -	/* If built-in chains don't exist for this table, create them */
> -	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
> -		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
> -
>   	/* Find the old chain to be renamed */
>   	c = nft_chain_find(h, table, chain);
>   	if (c == NULL) {
> @@ -2170,10 +2166,6 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
>   	struct nft_rule *r;
>   	uint64_t handle;
>   
> -	/* If built-in chains don't exist for this table, create them */
> -	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
> -		nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
> -
>   	nft_fn = nft_rule_insert;
>   
>   	list = nft_rule_list_create(h);
> @@ -2521,10 +2513,6 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
>   	struct nft_chain *c;
>   	bool found = false;
>   
> -	/* If built-in chains don't exist for this table, create them */
> -	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
> -		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
> -
>   	list = nft_chain_dump(h);
>   
>   	iter = nft_chain_list_iter_create(list);
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

