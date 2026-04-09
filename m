Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C99A2AD10
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 10:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775729051; cv=none; b=l8YF24FiYbb1r92tdwkVUjTdThl1uqQM1IAuYoKmQoBr1O/B/a1Hb+GAuPofWDwXKcdp+RCpYZWiq0BsVKX0lYXnaOHvpSifqfU7mOGYBKQv0c2sAPAXQGBHS8IgBZkS/vLmOiWe5aB/efUo+aqonSCb4dEek0J2TshrDDXhVlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775729051; c=relaxed/simple;
	bh=jx4W/6539d0IyYyi6BMGFTWaxYJLxBFGZYwmWoZqTek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTNIkEb3Oy//bt0csVmDAJhvTaH2JbSovAUeDOiRXy5B/W3rMyDZFUxaNsA+4SxyvQgAQdX3qrjla/V0VJOlvHpA9bYhJ9UyJBSG7/pYD1iJkDPWhJNTxSsz/W7kHDA1AFRJLXAnKSpUbo+ZeSP5flzKrjGmAvyJA4ElnMo4kU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0736C604AA; Thu, 09 Apr 2026 12:04:04 +0200 (CEST)
Date: Thu, 9 Apr 2026 12:04:04 +0200
From: Florian Westphal <fw@strlen.de>
To: David Baum <davidbaum461@gmail.com>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH] netfilter: ipset: harden payload calculation in call_ad()
Message-ID: <add5lL88z9oJqTJY@strlen.de>
References: <20260313180132.75655-1-davidbaum461@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313180132.75655-1-davidbaum461@gmail.com>

David Baum <davidbaum461@gmail.com> wrote:
> call_ad() computes the netlink error payload size with
> min(SIZE_MAX, sizeof(*errmsg) + nlmsg_len(nlh)), but min(SIZE_MAX, x)
> is always x, so the guard is a no-op.
> 
> Replace it with an explicit negative-length check and
> check_add_overflow() so the addition is validated before being passed
> to nlmsg_new().

Jozsef, are you ok with this patch?
Full quote below.

> Signed-off-by: David Baum <davidbaum461@gmail.com>
> ---
>  net/netfilter/ipset/ip_set_core.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index a2fe711cb5e3..11d3854d9b11 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -10,6 +10,7 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/ip.h>
> +#include <linux/overflow.h>
>  #include <linux/skbuff.h>
>  #include <linux/spinlock.h>
>  #include <linux/rculist.h>
> @@ -1763,13 +1764,18 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
>  		struct nlmsghdr *rep, *nlh = nlmsg_hdr(skb);
>  		struct sk_buff *skb2;
>  		struct nlmsgerr *errmsg;
> -		size_t payload = min(SIZE_MAX,
> -				     sizeof(*errmsg) + nlmsg_len(nlh));
> +		int nlmsg_payload_len = nlmsg_len(nlh);
> +		size_t payload;
>  		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
>  		struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
>  		struct nlattr *cmdattr;
>  		u32 *errline;
>  
> +		if (nlmsg_payload_len < 0 ||
> +		    check_add_overflow(sizeof(*errmsg),
> +				       (size_t)nlmsg_payload_len, &payload))
> +			return -ENOMEM;
> +
>  		skb2 = nlmsg_new(payload, GFP_KERNEL);
>  		if (!skb2)
>  			return -ENOMEM;

