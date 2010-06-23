From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: xt_connbytes: Force CT tracking to be
 enabled
Date: Wed, 23 Jun 2010 08:05:47 +0200
Message-ID: <4C21A43B.40700@trash.net>
References: <1277225075-30428-1-git-send-email-tim.gardner@canonical.com> <1277225075-30428-3-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, ole@ans.pl
To: tim.gardner@canonical.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65094 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0FWGFs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:05:48 -0400
In-Reply-To: <1277225075-30428-3-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tim.gardner@canonical.com wrote:
> From: Tim Gardner <tim.gardner@canonical.com>
>
> Check at runtime that CT tracking is enabled, and force it
> to be enabled if not.
>
> This is in preparation for deprecating CONFIG_NF_CT_ACCT.
>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  net/netfilter/xt_connbytes.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
> index 7351783..d703355 100644
> --- a/net/netfilter/xt_connbytes.c
> +++ b/net/netfilter/xt_connbytes.c
> @@ -21,7 +21,7 @@ static bool
>  connbytes_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  {
>  	const struct xt_connbytes_info *sinfo = par->matchinfo;
> -	const struct nf_conn *ct;
> +	struct nf_conn *ct;
>  	enum ip_conntrack_info ctinfo;
>  	u_int64_t what = 0;	/* initialize to make gcc happy */
>  	u_int64_t bytes = 0;
> @@ -32,6 +32,17 @@ connbytes_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	if (!ct)
>  		return false;
>  
> +	/*
> +	 * This filter cannot function correctly unless connection tracking
> +	 * accounting is enabled, so complain about it until someone notices.
> +	 * It _should_ only print one warning message.
> +	 */
> +	if (unlikely(nf_ct_acct_enabled(ct) == false)) {
> +		if (net_ratelimit())
> +			pr_warning("ipt_connbytes: Force enabling CT accounting\n");
> +		nf_ct_set_acct(ct, true);
> +	}

This should be checked once the rule is added in ->checkentry(),
not once for every packet.
