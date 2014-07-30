From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: nfnetlink_acct: avoid using
 NFACCT_F_OVERQUOTA with bit helper funcitons
Date: Wed, 30 Jul 2014 18:31:33 +0200
Message-ID: <20140730163133.GB6018@salvia>
References: <1406733475-5222-1-git-send-email-a.perevalov@samsung.com>
 <1406733475-5222-2-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60336 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbaG3Qbf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:31:35 -0400
Content-Disposition: inline
In-Reply-To: <1406733475-5222-2-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 30, 2014 at 07:17:54PM +0400, Alexey Perevalov wrote:
> Bit helper functions were used for manipulation with NFACCT_F_OVERQUOTA,
> but they are accepting pit position, but not a bit mask. As a result
> not a third bit for NFACCT_F_OVERQUOTA was set, but forth. Such
> behaviour was dangarous and could lead to unexpected overquota report
> result.
> 
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  net/netfilter/nfnetlink_acct.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
> index 2baa125..127d24e 100644
> --- a/net/netfilter/nfnetlink_acct.c
> +++ b/net/netfilter/nfnetlink_acct.c
> @@ -77,7 +77,7 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>  			smp_mb__before_atomic();
>  			/* reset overquota flag if quota is enabled. */
>  			if ((matching->flags & NFACCT_F_QUOTA))
> -				clear_bit(NFACCT_F_OVERQUOTA, &matching->flags);
> +				matching->flags &= ~NFACCT_F_OVERQUOTA;
>  			return 0;
>  		}
>  		return -EBUSY;
> @@ -148,7 +148,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>  		bytes = atomic64_xchg(&acct->bytes, 0);
>  		smp_mb__before_atomic();
>  		if (acct->flags & NFACCT_F_QUOTA)
> -			clear_bit(NFACCT_F_OVERQUOTA, &acct->flags);
> +			acct->flags &= ~NFACCT_F_OVERQUOTA;
>  	} else {
>  		pkts = atomic64_read(&acct->pkts);
>  		bytes = atomic64_read(&acct->bytes);
> @@ -411,8 +411,8 @@ int nfnl_acct_overquota(const struct sk_buff *skb, struct nf_acct *nfacct)
>  
>  	ret = now > *quota;
>  
> -	if (now >= *quota &&
> -	    !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags)) {

We cannot do this. The aim of that code it to avoid to deliver several
overquota notification when several cpus are racing to update the
counters and check if they have go over the quota.

I think you have to define NFACCT_F_*_BIT and use it from the bitwise
functions to fix this. You can define these in:

include/uapi/linux/netfilter/nfnetlink_acct.h

And use them to define the enum nfnl_acct_flags.

Thanks.
