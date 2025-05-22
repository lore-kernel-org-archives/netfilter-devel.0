Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43CB539A
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747928175; cv=none; b=U+Xchh0racAuZOTHX5KvfAYrjLP++cgLn4PNcuelt210ZAgsk/n7jgejzbuqIKVsTW/mho2hDduKNVDOYDYTUGX9TfAFdoC7ctAupJuAFpfZZekHcjqYRE1NxAkFQmxZCH9KvTwjjnt3sH2emf5VUMcuW5Bp5BhwI5KTMjSNHKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747928175; c=relaxed/simple;
	bh=QXruPdFVnhk6tyI7a38FjsMq3HLde1yrnH3oor7FRc8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ij0cBnY/DUQAcaLHQ+UrfjfBHw6DikH/X5umtsxvVjMNVRKxf/ApvQYLJ01SBC0RHMjLySMypSPmAwL/EQA8fcpnKrpurjBM5S4Z2gOb0mTTsTUW+sIsLTe0Cv3405q+mt3BZSIg06BDFH54AJrTEmc/8nZpOA0jrOcRvmySjJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=p0S3C7aT; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XvJQLB3p; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="p0S3C7aT";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XvJQLB3p"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B765660280; Thu, 22 May 2025 17:36:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747928170;
	bh=TDFBaS426gmMtGE9ho5EFhD7FAD7pyuJYmJfp1lmqyw=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=p0S3C7aT+bnuY2NpYTCtV4UCQLdaFDaKuJJ64y2s4kx+46C9UG4Y51yMphdRTazlG
	 PhSTsP+P4QbJMml8FYWDwLGALWVdvImCobpB5YJPfe6jaYZI82Y+3Dkmei+pvuMj17
	 Yk9KPT9tWpFbejdChzql1mfHL0tIdWHYZa2xAu7zSTOj3SEqAh+8yYckHcubBtYWg5
	 lqbpkUWOVpmTNtd+XhZAVYFnnXKoNDkltt/e9kcVxDh4Bqs7zpR0WBNFiT0NDMpBvu
	 RHJvUZqJ0rIzp6E26cm17/c2lJeKES4cnoYUrOdDRYB26Y5DaVyggofR4LnnSdpXmY
	 ejau3q3humQKg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 781B360280;
	Thu, 22 May 2025 17:36:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747928169;
	bh=TDFBaS426gmMtGE9ho5EFhD7FAD7pyuJYmJfp1lmqyw=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=XvJQLB3pzgZ2wA+g8bcM4jUUIRjQTf9V3Vm90SgaWTy8WmxqrQMIAKpH8wK2AWa5z
	 TnvHtFCUu5AYKptvBH9X4hjZoajMLct1asaYCGY2yD7aWG4IGL/XOe1+mwZVmgI41U
	 emS8QT/16fFqaNQ2cXQZC0EmqYasvD11fW4t7+GtV8iVX4v8tIYHtrW2vWsGIIKjty
	 kF3XFM6vC1Mj6zzDFVUtKz0UtSCED1yOIAK3VKU3TPK7iJq0oMDS6Avd79hZxoOCe0
	 4AUAuPbyohnquhfUfja79/qPVRuPSPRTB+hUWWkIEDwLtgRl2YBh1qmPZKCX6BsaPJ
	 BPd6pkVd0LCgA==
Date: Thu, 22 May 2025 17:36:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v7 12/13] netfilter: nf_tables: Add notifications
 for hook changes
Message-ID: <aC9EZ1JTmQH5q-F9@calendula>
References: <20250521204434.13210-1-phil@nwl.cc>
 <20250521204434.13210-13-phil@nwl.cc>
 <aC9COQreWoVMhSEq@calendula>
 <aC9EF5eAiJjJY0YJ@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aC9EF5eAiJjJY0YJ@orbyte.nwl.cc>

On Thu, May 22, 2025 at 05:34:47PM +0200, Phil Sutter wrote:
> On Thu, May 22, 2025 at 05:26:49PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, May 21, 2025 at 10:44:33PM +0200, Phil Sutter wrote:
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index a7240736f98e..268bc00fe2ec 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -9686,6 +9686,64 @@ struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
> > >  }
> > >  EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
> > >  
> > > +static void
> > > +nf_tables_device_notify(const struct nft_table *table, int attr,
> > > +			const char *name, const struct nft_hook *hook,
> > > +			const struct net_device *dev, int event)
> > > +{
> > > +	struct net *net = dev_net(dev);
> > > +	struct nlmsghdr *nlh;
> > > +	struct sk_buff *skb;
> > > +	u16 flags = 0;
> > > +
> > > +	if (!nfnetlink_has_listeners(net, NFNLGRP_NFT_DEV))
> > > +		return;
> > > +
> > > +	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> > > +	if (!skb)
> > > +		goto err;
> > > +
> > > +	event = event == NETDEV_REGISTER ? NFT_MSG_NEWDEV : NFT_MSG_DELDEV;
> > > +	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
> > > +	nlh = nfnl_msg_put(skb, 0, 0, event, flags, table->family,
> > > +			   NFNETLINK_V0, nft_base_seq(net));
> > > +	if (!nlh)
> > > +		goto err;
> > > +
> > > +	if (nla_put_string(skb, NFTA_DEVICE_TABLE, table->name) ||
> > > +	    nla_put_string(skb, attr, name) ||
> > > +	    nla_put(skb, NFTA_DEVICE_SPEC, hook->ifnamelen, hook->ifname) ||
> > > +	    nla_put_string(skb, NFTA_DEVICE_NAME, dev->name))
> > > +		goto err;
> > > +
> > > +	nlmsg_end(skb, nlh);
> > > +	nfnetlink_send(skb, net, 0, NFNLGRP_NFTABLES,
> >                                     ^..............^
> >                                     NFNLGRP_NFT_DEV))
> 
> Oops! I tested this with both groups enabled in nftables. :(
> 
> > > +		       nlmsg_report(nlh), GFP_KERNEL);
> > > +	return;
> > > +err:
> > > +	if (skb)
> > > +		kfree_skb(skb);
> > > +	nfnetlink_set_err(net, 0, NFNLGRP_NFTABLES, -ENOBUFS);
>                                   ^^^^^^^^^^^^^^^^
> 
> Here's one more. Should I respin or will you fold these after applying?

I can mangle and apply.
