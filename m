Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5C13FE667
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 08:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649695; cv=none; b=knJ4uL+MnG+QIEtyGnknqZY/s24z7hhOj6Yi22klq9ah92/WpFPgCY/ZtSoNJ1M+Cr0IuZP0HsS+DQVDEGcoVcdqRfNYOidRfFYC+zkdr8dI/D5GpV4JzEZpby6uy3MzhukZGeqnDwGSeRU3MYzeORI865wmBVtgh8wpsIeo6v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649695; c=relaxed/simple;
	bh=ChndUXNxjiGHGNfit4TqE+6yl1q1XBBh6eV+3RThzqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QGaggnosOnSa/xVYVQ7pgI037WBOuhkYPxDDG+/EoHRNStweoFvhziD+QIYtkv96AHHCsj/pINYhGCmqVyeK/YnHf5wgFXiYmQFEoPPXprTAflDHSyce6YdhWISuniGnPyvTos6Wnb6ZGTWgxoEUqGbDMv/X2O68Ck87eKFhsPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UsHrb2PG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UsHrb2PG"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 336CC6017F;
	Fri,  5 Jun 2026 10:54:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780649684;
	bh=ekoWz7I6ZJOPiMjeRFCLQzI3w+G6NfJ7xcA1qoLN8Is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UsHrb2PGlV34IPip58KgPFz5gV2jkVgWKDn01P2fzmFiQ4C0ixM0WPZRUop5S1wbt
	 KlJaxPCjdcHbREQhMJGoDeNMm/C87D1hbG7umNKZOvowxy11hJQl3b6zfi6fg1pyUA
	 hlDt0yEDg7ml2zfttncQK2Q5lKs9azy+eX3b4TL2i2RsqDySS4BAXY/w37brxn1T2a
	 ok7CabJZ7vJhRUt7boi+NBNwzvqflwpXFOsEcQKkCmlcKveazmgYNte1opD7jr/EAd
	 LZsHru7iKqFZ6bmnnJrl5N0DvfqEte4IOQfZwQscpFWWP9HNPw8l2OUF9H5O2qS8Mw
	 0b/PSMEt8VXCQ==
Date: Fri, 5 Jun 2026 10:54:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Possible device resouce leak in nf_offload infra
Message-ID: <aiKO0TxEgqgAZtve@chamomile>
References: <aiHPPts-fb3oG9Sx@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aiHPPts-fb3oG9Sx@strlen.de>

On Thu, Jun 04, 2026 at 09:17:42PM +0200, Florian Westphal wrote:
> Hi Pablo
> 
> net/netfilter/nf_dup_netdev.c :
> 
>  70 int nft_fwd_dup_netdev_offload(struct nft_offload_ctx *ctx,
>  71                                struct nft_flow_rule *flow,
>  72                                enum flow_action_id id, int oif)
>  73 {
>  74         struct flow_action_entry *entry;
>  75         struct net_device *dev;
>  76
>  77         /* nft_flow_rule_destroy() releases the reference on this device. */
> 
> This comment is no longer true.
> 
>  78         dev = dev_get_by_index(ctx->net, oif);
>  79         if (!dev)
>  80                 return -EOPNOTSUPP;
>  81
>  82         entry = nft_flow_action_entry_next(ctx, flow);
>  83         if (!entry)
>  84                 return -E2BIG;
> 
> ... because nft_flow_rule_destroy() cannot drop the device
> ref when we return here, as dev is not assigned to entry
> yet (and we got no entry).

Yes, it is a refcount leak in error path.

> AFAICS its safe to just swap this and have
> lines 77/78 moved after line 82.
> 
> nft_fwd_dup_netdev_offload() could also use some debug
> check to make sure this doesn't get called for actions
> other than FLOW_ACTION_REDIRECT/FLOW_ACTION_MIRRED as
> those are the only ones where nft_flow_rule_destroy() takes
> action.
> 
> (or accessors and comments that say that accesses to the
>  hidden union are illegal).
> 
> Is the analysis correct?  I can make a patch.

Yes, sure, go ahead. Thanks Florian
