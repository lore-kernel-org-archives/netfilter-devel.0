Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBE3140E5F
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747928099; cv=none; b=JQzM9HCGjD+Ry+qUjMd2/N3EJuiivr9LEL8NYahsmA0jcPcH1kMQOVf6lh6XKtvTmp/IAoNDlm2CSv0aIz4M5rAdm2XMoOVrG+j4g6hOJLFYyHpllbeRsGN31gk/GTXFKlvnvZdcydXDUK8BlYiGGU3xE5M8d/8OOPX5s1Ss36Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747928099; c=relaxed/simple;
	bh=KkVDp1AIHD0m4PWxwD9N+rAUI9JjQ4o8VgU89xzBE8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQs4Pfg5Iv0YJlFIqS2gq7KRLd0r4eHRB6oQt897vozwuk0d003FzqkdBCrDLr0xhEcpCZ0A4yQ+excKC+K3Zb801wE4uZMmEUN9ojjWOl+szC8fJagD7HdrA+7coGyLcbpuJHrGv+wvHHIMhQJ9RECQuEj0Iaev0Mr3UXMbmUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jChYiF0u; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jChYiF0u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xaLx4rrW40ilNVgM2JVzf++EwHNqn75HdO0TKJz0nvA=; b=jChYiF0ufec98EAkZ7Q34BoX6S
	Q+OLo2XXM73hMncqgyzjD1iC3RXslauqRoDFpJ4g/hd5wd54/Fd5WrexWURrwWoON4q2Or8cw9v44
	NRuFv+Hi2PaeJuxK+urd1gPiJND/Eg38Plfr0Lo+zizxJ5PQHQIth73qg/82HVOsiK9IjnpbfIvt0
	L8mAWQhF2Qx9zCOkIXvs47lJQkk1wOLIoQbj/zuR6ws85dzTqy/lSooJ/63gdQNP9sw3ZiU+jOPQ4
	+mCl7T5jwUFGGYfWWGGKneAQ+BgLkgjAeDEJLB2PUldIPcCYxcoThv2H0dDI2I8GxoSUcplvt8KrM
	l93T56Xg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uI7wV-000000006yV-1GwE;
	Thu, 22 May 2025 17:34:47 +0200
Date: Thu, 22 May 2025 17:34:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v7 12/13] netfilter: nf_tables: Add notifications
 for hook changes
Message-ID: <aC9EF5eAiJjJY0YJ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
References: <20250521204434.13210-1-phil@nwl.cc>
 <20250521204434.13210-13-phil@nwl.cc>
 <aC9COQreWoVMhSEq@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC9COQreWoVMhSEq@calendula>

On Thu, May 22, 2025 at 05:26:49PM +0200, Pablo Neira Ayuso wrote:
> On Wed, May 21, 2025 at 10:44:33PM +0200, Phil Sutter wrote:
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index a7240736f98e..268bc00fe2ec 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -9686,6 +9686,64 @@ struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
> >  }
> >  EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
> >  
> > +static void
> > +nf_tables_device_notify(const struct nft_table *table, int attr,
> > +			const char *name, const struct nft_hook *hook,
> > +			const struct net_device *dev, int event)
> > +{
> > +	struct net *net = dev_net(dev);
> > +	struct nlmsghdr *nlh;
> > +	struct sk_buff *skb;
> > +	u16 flags = 0;
> > +
> > +	if (!nfnetlink_has_listeners(net, NFNLGRP_NFT_DEV))
> > +		return;
> > +
> > +	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> > +	if (!skb)
> > +		goto err;
> > +
> > +	event = event == NETDEV_REGISTER ? NFT_MSG_NEWDEV : NFT_MSG_DELDEV;
> > +	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
> > +	nlh = nfnl_msg_put(skb, 0, 0, event, flags, table->family,
> > +			   NFNETLINK_V0, nft_base_seq(net));
> > +	if (!nlh)
> > +		goto err;
> > +
> > +	if (nla_put_string(skb, NFTA_DEVICE_TABLE, table->name) ||
> > +	    nla_put_string(skb, attr, name) ||
> > +	    nla_put(skb, NFTA_DEVICE_SPEC, hook->ifnamelen, hook->ifname) ||
> > +	    nla_put_string(skb, NFTA_DEVICE_NAME, dev->name))
> > +		goto err;
> > +
> > +	nlmsg_end(skb, nlh);
> > +	nfnetlink_send(skb, net, 0, NFNLGRP_NFTABLES,
>                                     ^..............^
>                                     NFNLGRP_NFT_DEV))

Oops! I tested this with both groups enabled in nftables. :(

> > +		       nlmsg_report(nlh), GFP_KERNEL);
> > +	return;
> > +err:
> > +	if (skb)
> > +		kfree_skb(skb);
> > +	nfnetlink_set_err(net, 0, NFNLGRP_NFTABLES, -ENOBUFS);
                                  ^^^^^^^^^^^^^^^^

Here's one more. Should I respin or will you fold these after applying?

Thanks, Phil
