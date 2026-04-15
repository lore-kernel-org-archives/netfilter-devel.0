Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A64244694
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 11:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776252019; cv=none; b=EyTNfaLaA0TrmJes4dXmDiSzS6/dsioStQpLea0Rq1p0hmCD/5FuanDW1Q0WaxE1G5L6JK3h/IpOmGPnCIZ61fcHTq9B30uxMxeBjCtIv6Su+jpy4G0tacj1+XhfYKqktANQGgj2ZVvjSNRBZj0YdxUCjdSarXo1DSY9ynqJ1YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776252019; c=relaxed/simple;
	bh=66U9xelc7BvW75jK12YiPdcvEcVywVteNOldO8jSmpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/2C2891peGKJLtryLjXPeKsRxCl4AZKIrcweD0crjjG9BsdcWVz40ZdTFRxptueZw1kPA1Q0bYPMGXELKA6Kcp+B/ESTf6hw8MOyxDn7/OFTBGws6phxGHtTQnwmeL9l2jctwCbbSQgw2mhLgigiKR8MsE0dW3TsBjIIs7tIAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oxXD90Tt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oxXD90Tt"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5357C6017D;
	Wed, 15 Apr 2026 13:20:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776252016;
	bh=EC2PmFpE70GJVSm6/W6erBhz5GPQ+lseUqVQEi6EQ1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oxXD90TtdEaB14XH9ZT2VPORaBsWOHN2mU29hEo442sxiPWYRLslNxnAs03JS0dDs
	 0ExcyxoeiTwNphh6/UGrzK2+NLuz4z3mMsAzsBxqYNeGV7+RsqEC1J2TGNLOE6xGpm
	 KJRVjju0fpi7kn3HMCZWU+Fa6qYoB0s7f12xXX+BUWl9TNnQ5P2pM4VSAzBfDWrPNL
	 MIcvgTnh4PR/mFUL7Gcb4JEP1S8qe57w+HlLIf5mJr6nysu6zZwC2Tu4Rvy6G8OK8U
	 xn68g4QDNvBkje6MJtQjETHv5MHRU1d5UNTpWbZYmVVf65hSb3xGaXPYHRcFFfO2W5
	 DTV0kNNWSu78A==
Date: Wed, 15 Apr 2026 13:20:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: xtables: restrict several matches to ipv4
 and ipv6
Message-ID: <ad90bW_55v9hU-x5@chamomile>
References: <20260415104707.55946-1-pablo@netfilter.org>
 <ad9z8Bv9-BvL-cPd@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad9z8Bv9-BvL-cPd@strlen.de>

On Wed, Apr 15, 2026 at 01:18:08PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
> > index 6df485f4403d..130ebe5d1c43 100644
> > --- a/net/netfilter/xt_realm.c
> > +++ b/net/netfilter/xt_realm.c
> > @@ -27,24 +27,35 @@ realm_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >  	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
> >  }
> >  
> > -static struct xt_match realm_mt_reg __read_mostly = {
> > -	.name		= "realm",
> > -	.match		= realm_mt,
> > -	.matchsize	= sizeof(struct xt_realm_info),
> > -	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
> > -			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
> > -	.family		= NFPROTO_UNSPEC,
> > -	.me		= THIS_MODULE
> > +static struct xt_match realm_mt_reg[] __read_mostly = {
> > +	{
> > +		.name		= "realm",
> > +		.match		= realm_mt,
> > +		.matchsize	= sizeof(struct xt_realm_info),
> > +		.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
> > +				  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
> > +		.family		= NFPROTO_IPV4,
> > +		.me		= THIS_MODULE
> > +	},
> > +	{
> > +		.name		= "realm",
> > +		.match		= realm_mt,
> > +		.matchsize	= sizeof(struct xt_realm_info),
> > +		.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
> > +				  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
> > +		.family		= NFPROTO_IPV6,
> > +		.me		= THIS_MODULE
> > +	}
> >  };
> 
> Is this for possible users of ip6tables ... -t realm?
> AFAICS dst->tclassid is never populated for ipv6, so while its possible
> to use it from ip6tables I don't think it can match.
> 
> I don't object to this change of course.  I just wonder why this was
> ever changed from ipt_realm to xt in the first place.

Patch description is quite terse...

I can just restrict realm to IPv4 only, sending v2.

> It was done as part of 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables").
