Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C8EEAC7;
	Fri, 10 Apr 2026 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775783950; cv=none; b=g5mop6jt8rMKhwpcF1ndZ7PBUe7xSYo4/OY+D3IZ0qRS4xFlVx4UJ4/LQF+NkunEW7ZIisww5TFEmJRy9ZJQfz9NiBJavxZQ+bdhPuADdOFFIufC33gklwP6y4QdR5852BZnNCcfMx7eLurvFDKwoPbqVYxOeK4TAeocOVjriUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775783950; c=relaxed/simple;
	bh=NQIRCKH+CF9ksKxlcfEDpouEfLcVH3VnVzfJylyaHxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPcM9/GaOQfp4t5lSv9rFe2MGxvl7c6Goy5GD62KVAerCj5hlxY0of8nbpXkPcj93AyRSbNz6MXMawUqLiu7Krf54UR3DlcJZiSXfqPmv//n+2QEtDy909xJBp/WP9njNM7zLp6LwUv6FimRqrGrRf3SYWlCObifIPqhO/L/VzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D6mRqMsC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D6mRqMsC"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A9AD060254;
	Fri, 10 Apr 2026 03:19:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775783947;
	bh=lBxJLuvHYfhTOkYj2DWEcTgFWyXVb+fj1QepW/OVbX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D6mRqMsCYYbbPVaIR1DLFnhWtLvo78L6gLh+7anOfp8R9l3zQsusSeL3E8KgMDpHO
	 AWm4c5kW1jbe5m8L2kjG2ccnTHaNKV9L3RSkzxvWoiQxBBj7XP4EInbP2ObQcXrF7K
	 ussIVdEBaFZBE1tCNBA4Pdr9CP31N5MnsZ5BrDVnssHNL7aOwbJtKjTHDvpgIEnGlQ
	 y9q2Mpy2HrJmg++e3A9MeR4DmwXOieh9fS03LH3x9PKU5rJP9PSbut5cqhb2XTSl0d
	 R6NYlJnDB/DuvLKWGB0a8qK8/oxiNDRr8I3Aq+H+514jkopdaGUW6jj8J+kUEbDfVf
	 PMe2pMqtCIFxw==
Date: Fri, 10 Apr 2026 03:19:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Baum <davidbaum461@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: harden payload calculation in call_ad()
Message-ID: <adhQCKL9nO68m4nC@chamomile>
References: <20260313180132.75655-1-davidbaum461@gmail.com>
 <adhMzvFhTcmTMZTV@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <adhMzvFhTcmTMZTV@chamomile>

On Fri, Apr 10, 2026 at 03:05:18AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Mar 13, 2026 at 01:01:32PM -0500, David Baum wrote:
> > call_ad() computes the netlink error payload size with
> > min(SIZE_MAX, sizeof(*errmsg) + nlmsg_len(nlh)), but min(SIZE_MAX, x)
> > is always x, so the guard is a no-op.
> > 
> > Replace it with an explicit negative-length check and
> > check_add_overflow() so the addition is validated before being passed
> > to nlmsg_new().
> > 
> > Signed-off-by: David Baum <davidbaum461@gmail.com>
> > ---
> >  net/netfilter/ipset/ip_set_core.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > index a2fe711cb5e3..11d3854d9b11 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/module.h>
> >  #include <linux/moduleparam.h>
> >  #include <linux/ip.h>
> > +#include <linux/overflow.h>
> >  #include <linux/skbuff.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/rculist.h>
> > @@ -1763,13 +1764,18 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
> >  		struct nlmsghdr *rep, *nlh = nlmsg_hdr(skb);
> >  		struct sk_buff *skb2;
> >  		struct nlmsgerr *errmsg;
> > -		size_t payload = min(SIZE_MAX,
> > -				     sizeof(*errmsg) + nlmsg_len(nlh));
> > +		int nlmsg_payload_len = nlmsg_len(nlh);
> > +		size_t payload;
> >  		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
> >  		struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
> >  		struct nlattr *cmdattr;
> >  		u32 *errline;
> >  
> > +		if (nlmsg_payload_len < 0 ||
> 
> Hm, nlh was already sanitized by nfnetlink?
> 
> > +		    check_add_overflow(sizeof(*errmsg),
> > +				       (size_t)nlmsg_payload_len, &payload))
> 
> Maybe cap this to int:
> 
>                 int payload = sizeof(struct nlmsgerr);
>                 ...
>         
>                 if (check_add_overflow(payload, nlmsg_payload_len, &payload))

Wait, then payload and nlmsg_payload_len should be __u32, not int.

> 
> > +			return -ENOMEM;
> > +
> >  		skb2 = nlmsg_new(payload, GFP_KERNEL);
> >  		if (!skb2)
> >  			return -ENOMEM;
> 
