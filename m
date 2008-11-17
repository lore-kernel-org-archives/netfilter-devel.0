From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/8] [PATCH] Helper modules load-on-demand support for
 ctnetlink
Date: Mon, 17 Nov 2008 16:24:16 +0100
Message-ID: <49218CA0.20502@trash.net>
References: <20081117083924.11368.38741.stgit@Decadence> <20081117084055.11368.51948.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46229 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYKQPYV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:24:21 -0500
In-Reply-To: <20081117084055.11368.51948.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds module loading for helpers via ctnetlink.
> 
> * Creation path: We support explicit and implicit helper assignation. For
>   the explicit case, we try to load the module. If the module is correctly
>   loaded and the helper is present, we return EAGAIN to re-start the
>   creation. Otherwise, we return EOPNOTSUPP.
> * Update path: release the spin lock, load the module and check. If it is
>   present, then return EAGAIN to re-start the update.
> 
> This patch provides a refactorized function to lookup-and-set the
> connection tracking helper. The function removes the exported symbol
> __nf_ct_helper_find as it has not clients anymore.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> 
> +int __nf_ct_assign_helper(struct nf_conn *ct, gfp_t flags)
> +{
> +	int ret = 0;
> +	struct nf_conntrack_helper *helper;
> +	struct nf_conn_help *help = nfct_help(ct);
> +
> +	helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
> +	if (helper == NULL) {
> +		if (help)
> +			rcu_assign_pointer(help->helper, NULL);
> +		ret = -ENOENT;
> +		goto out;

Its a bit confusing to change the entry, but still return an error.
ctnetlink_create_conntrack() explicitly checks for ENOMEM and
ignores other errors, other callers ignore them completely. This
is risky because people changing that function will probably
expect the caller to handle any kind of error.

Since failure to find a helper is not really an error, I think
it would be better to simply return 0 in that case and have
ctnetlink_create_conntrack() check for < 0. Even better would
be to reflect in the function name that it only tries to find a
matching helper. I don't have a good suggestion though, maybe
try_assign_helper or lookup_helper.

> +	}
> +
> +	if (help == NULL) {
> +		help = nf_ct_helper_ext_add(ct, flags);
> +		if (help == NULL) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +	} else {
> +		memset(&help->help, 0, sizeof(help->help));
> +	}
> +
> +	rcu_assign_pointer(help->helper, helper);
> +out:
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(__nf_ct_assign_helper);
> +
>  static inline int unhelp(struct nf_conntrack_tuple_hash *i,
>  			 const struct nf_conntrack_helper *me)
>  {
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 49a04fa..7af7a86 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -917,8 +917,22 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
>  	}
>  
>  	helper = __nf_conntrack_helper_find_byname(helpname);
> -	if (helper == NULL)
> +	if (helper == NULL) {
> +#ifdef CONFIG_KMOD

As Alexey pointed out, CONFIG_KMOD should not be used here, but
CONFIG_MODULES.

