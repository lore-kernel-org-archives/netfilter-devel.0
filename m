From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] netfilter: conntrack: clamp timeouts to INT_MAX
Date: Sat, 11 Nov 2017 19:27:51 +0100
Message-ID: <20171111182751.GI5512@breakpoint.cc>
References: <1510394920-25302-1-git-send-email-jelliott@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
To: Jay Elliott <jelliott@arista.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42424 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751694AbdKKS2f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Nov 2017 13:28:35 -0500
Content-Disposition: inline
In-Reply-To: <1510394920-25302-1-git-send-email-jelliott@arista.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jay Elliott <jelliott@arista.com> wrote:
> As of commit 58e207e4983d ("netfilter: evict stale entries when user reads
> /proc/net/nf_conntrack"), timeouts are evaluated by casting the difference
> between a timeout value and the nfct_time_stamp to a signed integer and
> comparing that to zero.
> 
> This means that any timeout greater than or equal to (1<<31) will be
> considered negative, and the conntracking code will think it has
> immediately expired.  Prior to 58e207e4983d, they would have been treated
> as very large positive timeouts.
> 
> The upshot of this is that userspace software which is used to being able
> to create conntracking timeouts >= (1<<31) can accidentally create a
> negative timeout which will expire immediately.  To protect against this,
> incoming timeouts are clamped to INT_MAX after they are added to the
> nfct_time_stamp.
> 
> Fixes: 58e207e4983d ("netfilter: evict stale entries when user reads /proc/net/nf_conntrack")
> Signed-off-by: Jay Elliott <jelliott@arista.com>
> ---
>  net/netfilter/nf_conntrack_core.c    |  6 +++++-
>  net/netfilter/nf_conntrack_netlink.c | 15 ++++++++++++---
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 0113039..8f55da3 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -734,6 +734,7 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
>  	struct net *net;
>  	unsigned int sequence;
>  	int ret = NF_DROP;
> +	u_int64_t timeout64;
>  
>  	ct = nf_ct_get(skb, &ctinfo);
>  	net = nf_ct_net(ct);
> @@ -796,7 +797,10 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
>  	/* Timer relative to confirmation time, not original
>  	   setting time, otherwise we'd get timer wrap in
>  	   weird delay cases. */
> -	ct->timeout += nfct_time_stamp;
> +	timeout64 = (u_int64_t)ct->timeout + nfct_time_stamp;
> +	if (timeout64 > INT_MAX)
> +		timeout64 = INT_MAX;
> +	ct->timeout = timeout64;

I don't understand why this needs to be changed.  It also looks wrong.
let ct->timeout be 1000.
let nfct_time_stamp be 0x80000000

Then ct->timout is capped to 0x7fffffff.
Next check considers the timeout to be expired, as 0x7fff... - 0x800 < 0.

> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index de4053d..3db8e03 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1560,9 +1560,12 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
>  static int ctnetlink_change_timeout(struct nf_conn *ct,
>  				    const struct nlattr * const cda[])
>  {
> -	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
> +	u_int64_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
> +	u_int64_t timeout_absolute = timeout * HZ + (u_int64_t)nfct_time_stamp;
>  
> -	ct->timeout = nfct_time_stamp + timeout * HZ;
> +	if (timeout_absolute > INT_MAX)
> +		timeout_absolute = INT_MAX;
> +	ct->timeout = timeout_absolute;

Same applies here.
I would have expected something like

	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
	if (timeout > INT_MAX)
		timeout = INT_MAX;

> +	u_int64_t timeout_nla;
>  
>  	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
>  	if (IS_ERR(ct))
> @@ -1770,7 +1775,11 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
>  	if (!cda[CTA_TIMEOUT])
>  		goto err1;
>  
> -	ct->timeout = nfct_time_stamp + ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;

and here something similar, read CTA_TIMEOUT, cap to INT_MAX.
Actually looking ast this this was always a bit broken because * HZ can
overflow.

So I guess best bet is to actually do a 64bit multiplication, as you
did, then truncate.

Please use u64 for this (the u_intXX_t types are prehistoric leftovers).

Thanks!
