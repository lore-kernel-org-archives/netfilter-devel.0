From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: Expose connection tracking accounting
 toggles
Date: Thu, 24 Jun 2010 17:36:13 +0200
Message-ID: <4C237B6D.5010904@trash.net>
References: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com> <1277393257-15281-2-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36019 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab0FXPgR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:36:17 -0400
In-Reply-To: <1277393257-15281-2-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Gardner wrote:
> nf_ct_acct_enabled() - Get CT accounting state.
> nf_ct_set_acct() - Enable/disable CT accountuing.
>   

Thanks for taking care of this. Just one final comment:

> diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
> index 03e218f..31f5cd3 100644
> --- a/include/net/netfilter/nf_conntrack_acct.h
> +++ b/include/net/netfilter/nf_conntrack_acct.h
> @@ -45,6 +45,18 @@ struct nf_conn_counter *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
>  extern unsigned int
>  seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir);
>  
> +/* Check if connection tracking accounting is enabled */
> +static inline bool nf_ct_acct_enabled(const struct xt_mtchk_param *par)
>   

 From an API point of view its cleaner to have the caller just pass
in the net pointer. Accounting has no direct relationship to xtables.

It would also make sense to fold this patch into 2/3 since this is
where these functions are actually getting used.

> +{
> +	return par->net->ct.sysctl_acct == 0 ? false : true;
> +}
> +
> +/* Enable/disable connection tracking accounting */
> +static inline void nf_ct_set_acct(const struct xt_mtchk_param *par, bool enable)
>   

Same here.

> +{
> +	par->net->ct.sysctl_acct = enable == true ? 1 : 0;
> +}
> +
>  extern int nf_conntrack_acct_init(struct net *net);
>  extern void nf_conntrack_acct_fini(struct net *net);
>  
>   

