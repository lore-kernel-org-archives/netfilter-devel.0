From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ctnetlink: don't permit ct creation with
 random tuple
Date: Tue, 12 Feb 2013 13:24:30 +0100
Message-ID: <20130212122430.GA30291@localhost>
References: <1360660958-29494-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:26882 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933088Ab3BLMYf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:24:35 -0500
Content-Disposition: inline
In-Reply-To: <1360660958-29494-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 12, 2013 at 10:22:38AM +0100, Florian Westphal wrote:
> Userspace can cause kernel panic by not specifying orig/reply
> tuple: kernel will create a tuple with random stack values.
> 
> Problem is that tuple.dst.dir will be random, too, which
> causes nf_ct_tuplehash_to_ctrack() to return garbage.

good catch.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_netlink.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 7bbfb3d..e592281 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1596,6 +1596,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
>  		if (nlh->nlmsg_flags & NLM_F_CREATE) {
>  			enum ip_conntrack_events events;
>  
> +			if (!cda[CTA_TUPLE_ORIG] ||
> +			    !cda[CTA_TUPLE_REPLY])
> +				return -EINVAL;

I think that needs to be && instead of ||.

No need to resend the patch, I'll fix it and apply.

Thanks Florian.

>  			ct = ctnetlink_create_conntrack(net, zone, cda, &otuple,
>  							&rtuple, u3);
>  			if (IS_ERR(ct))
> -- 
> 1.7.8.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
