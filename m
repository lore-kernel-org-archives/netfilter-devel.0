Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEAA2E717B;
	Fri, 10 Apr 2026 01:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775783126; cv=none; b=KAzAg1mMHCO/3Qh2UmJTemwM3WNR5CtGgnr7Ng1gS947lrXvWKEmR+06IF1zEDHB8Z99CZ27S2w7JHuZOA1/CRvfVX+sGB7Fd6N2blpIZCk9pfThLA4SEYFZIKfqRwcskiYmvOD3is1em+dH9VsqhPLpkFlATMdDhd47m7gX0TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775783126; c=relaxed/simple;
	bh=qdgssJRMwz1d2TGXRBVH2TXjsMcaKk+grK57WDmuzlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2t4MA/F5ntKC063b1p8Qw+qMT74wltb5LRS1zyDZvVZpEq2e3oehTqS2GkO1/OBCJspvhLMNZzPTgKk48HbskfFZ090gUx7uduNcqandiP41y/3yw+4sDaNqJ7PB2wuCAMQPGvN6IVmdVhCDbKvyHZghZOYvc+Z5pE6QWOEmhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KnNqZkcF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KnNqZkcF"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A4C3360272;
	Fri, 10 Apr 2026 03:05:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775783120;
	bh=D8yT3WK1RCLIZ7KuYQ/Z4fBg4zEVaxOQdKATrK3a1Z0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KnNqZkcFJc3H9nGytG+6AN3L893XjWFjU0aVFPZrgtY5fNXmdtfufa1MfCY4RqOOT
	 /yZyEhwzJqCOVPZTcRzvs6QCPbtyv6cZqLQdw3G79ccgvwKyzY73wLYZq9vU1zHRgn
	 HnBodWADDbejEmkkNKpqzrOpOHgNUZBNLSqbu09iF3MEs6Ii1CxyrqH8KDs6FuII0l
	 CsztsFy50ErvPQUOBvPfjX2wFYsP6dhWj9ekcaDvU2mnuPv/QjvaQBdP7ad/kNGkn4
	 QU1UPg2sPUAHJtcjqJtrJhKD1bH111et9pSRCqB93ySDnKF/EpyehsLp5UorV9p7T/
	 a8Pxz7AI8ipDA==
Date: Fri, 10 Apr 2026 03:05:18 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Baum <davidbaum461@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: harden payload calculation in call_ad()
Message-ID: <adhMzvFhTcmTMZTV@chamomile>
References: <20260313180132.75655-1-davidbaum461@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260313180132.75655-1-davidbaum461@gmail.com>

On Fri, Mar 13, 2026 at 01:01:32PM -0500, David Baum wrote:
> call_ad() computes the netlink error payload size with
> min(SIZE_MAX, sizeof(*errmsg) + nlmsg_len(nlh)), but min(SIZE_MAX, x)
> is always x, so the guard is a no-op.
> 
> Replace it with an explicit negative-length check and
> check_add_overflow() so the addition is validated before being passed
> to nlmsg_new().
> 
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

Hm, nlh was already sanitized by nfnetlink?

> +		    check_add_overflow(sizeof(*errmsg),
> +				       (size_t)nlmsg_payload_len, &payload))

Maybe cap this to int:

                int payload = sizeof(struct nlmsgerr);
                ...
        
                if (check_add_overflow(payload, nlmsg_payload_len, &payload))

> +			return -ENOMEM;
> +
>  		skb2 = nlmsg_new(payload, GFP_KERNEL);
>  		if (!skb2)
>  			return -ENOMEM;
