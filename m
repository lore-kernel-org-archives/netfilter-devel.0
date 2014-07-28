From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nfnetlink_acct: use flag to reset counters
Date: Mon, 28 Jul 2014 23:53:25 +0200
Message-ID: <20140728215325.GA4093@salvia>
References: <20140725160123.GA20548@salvia>
 <1406570272-3704-2-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kyungmin.park@samsung.com, hs81.go@samsung.com,
	netfilter-devel@vger.kernel.org, alexey.perevalov@hotmail.com,
	mathieu.poirier@linaro.org
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46965 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbaG1VxL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:53:11 -0400
Content-Disposition: inline
In-Reply-To: <1406570272-3704-2-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 28, 2014 at 09:57:51PM +0400, Alexey Perevalov wrote:
> Two additional NFACCT_F* was introduced for ability to reset
> counters with and without quota separately.
> 
> It could be useful when client has to reset counters and wants to keep
> quotas untouched or vice versa without flushing and renewing.
> 
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  include/uapi/linux/netfilter/nfnetlink_acct.h |    2 ++
>  net/netfilter/nfnetlink_acct.c                |   30 ++++++++++++++++++++-----
>  2 files changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
> index 51404ec..1181c8e 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_acct.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
> @@ -18,6 +18,8 @@ enum nfnl_acct_flags {
>  	NFACCT_F_QUOTA_PKTS	= (1 << 0),
>  	NFACCT_F_QUOTA_BYTES	= (1 << 1),
>  	NFACCT_F_OVERQUOTA	= (1 << 2), /* can't be set from userspace */
> +	NFACCT_F_RESET_COUNTERS = (1 << 3),
> +	NFACCT_F_RESET_QUOTAS   = (1 << 4),
>  };
>  
>  enum nfnl_acct_type {
> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
> index 2baa125..1f47503 100644
> --- a/net/netfilter/nfnetlink_acct.c
> +++ b/net/netfilter/nfnetlink_acct.c
> @@ -121,9 +121,23 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>  	return 0;
>  }
>  
> +static inline bool
> +is_counters_reset(u32 nfacct_flags, unsigned long counter_flags)
> +{
> +	return nfacct_flags & NFACCT_F_RESET_COUNTERS &&
> +		!(counter_flags & NFACCT_F_QUOTA);
> +}
> +
> +static inline bool
> +is_quotas_reset(u32 nfacct_flags, unsigned long counter_flags)
> +{
> +	return nfacct_flags & NFACCT_F_RESET_QUOTAS &&
> +		counter_flags & NFACCT_F_QUOTA;
> +}

I think you can use the existing flags, ie.

1) If no flag is set, it means that userspace wants to dump/reset
everything.

2) If NFACCT_F_QUOTA_PKTS is set, it means that userspace wants to
dump/reset only packet-based quotas.

3) If NFACCT_F_QUOTA_BYTES is set, it means that userspace wants to
dump/reset only byte-based quotas.

4) If NFACCT_F_QUOTA_PKTS|NFACCT_F_QUOTA_BYTES are set, any accounting
object with quota is dump/reset.

5) If NFACCT_F_OVERQUOTA is set, only objects overquota are reset.

... Basically, you could even make any possible combination. I think
that should be flexible enough for all cases.

Therefore:

>  static int
>  nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
> -		   int event, struct nf_acct *acct)
> +		   int event, struct nf_acct *acct, u32 nfacct_flags)
>  {
>  	struct nlmsghdr *nlh;
>  	struct nfgenmsg *nfmsg;
> @@ -143,7 +157,9 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>  	if (nla_put_string(skb, NFACCT_NAME, acct->name))
>  		goto nla_put_failure;
>  
> -	if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
> +	if (type == NFNL_MSG_ACCT_GET_CTRZERO &&
> +		(!nfacct_flags || is_counters_reset(nfacct_flags, acct->flags) ||
> +		is_quotas_reset(nfacct_flags, acct->flags))) {

Replacing this:

                acct->flags & nfacct_flags == nfacct_flags

I think it should be enough.
