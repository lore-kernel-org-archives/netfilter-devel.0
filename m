Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5827325484D
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Jul 2025 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752501761; cv=none; b=rvpruq2DxAxMNOWM7+c0/AJGxdQfbTqC/mCRDqhRgFGN57sFGs0X2pY1Lr/pmUZ1MOMxzLR0a/XW6clomDp/c8LCjt1KppNdjuzSHMq2nnVM9KPp6SiA9cSUvHlQPuhHdadFgdOGuJ24Qe34kcJxuUdLTJPkRfCCqfVXWDcs6Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752501761; c=relaxed/simple;
	bh=7d6zRuTKh4VHgPJPvHvvIL/IzNlh4xh3HKIn5JUUufg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3RS/cqctaLkDWi9e1QqyVkkiQR7vA5uyPDaLaZ+MszIxW4RqSoEMu/0j9NrQWAtR27AbCb7LgEtRABxtdM70RUjt8sF4G16npXhh6HwCCBt03KtKowHCYAPXn39nJgZ8t0VeRRjtMqXsn0lZbqlMU9TGVsfB3quBNTc9+7lFYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PbM6vgOe; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PbM6vgOe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PbM6vgOe";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PbM6vgOe"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D00856027C; Mon, 14 Jul 2025 16:02:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752501747;
	bh=My+k81cfjHQuWDkkeD1MXnZjly8VQVwTx1EYXLxTsCE=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=PbM6vgOeQLncjj2fqn19DHJMmOTEAz8qpxkv9YZJPldO3YxXhoQhB7w0yD4yKM9XE
	 UBmu1hZgzqup8Fay1+MY2PuyNETkK+LhO+lj86g/6xYlUfqwaQgnQWDv65WmO2AgKC
	 Dv7DpZvwzhoUG+6oqzUJzEKh2B8bYAkjCfgjFlIsMHqO7aaIMwYCr5tLK2WS2C5Lba
	 1nk5P+cEOl6JNWKX9f8KsUSNFrwSHoFGBUvJ3dYa2ZK7bkXMabpOUKkZPZa3tzrhJN
	 Z9UKJEmUUZdg3NwZxpAEylm02JeRNIGSJ1LKzwQkDrwg+/iUjtDgtiCK535WPSTHDp
	 xCTB7nJXEjmTA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EB0C26026E;
	Mon, 14 Jul 2025 16:02:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752501747;
	bh=My+k81cfjHQuWDkkeD1MXnZjly8VQVwTx1EYXLxTsCE=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=PbM6vgOeQLncjj2fqn19DHJMmOTEAz8qpxkv9YZJPldO3YxXhoQhB7w0yD4yKM9XE
	 UBmu1hZgzqup8Fay1+MY2PuyNETkK+LhO+lj86g/6xYlUfqwaQgnQWDv65WmO2AgKC
	 Dv7DpZvwzhoUG+6oqzUJzEKh2B8bYAkjCfgjFlIsMHqO7aaIMwYCr5tLK2WS2C5Lba
	 1nk5P+cEOl6JNWKX9f8KsUSNFrwSHoFGBUvJ3dYa2ZK7bkXMabpOUKkZPZa3tzrhJN
	 Z9UKJEmUUZdg3NwZxpAEylm02JeRNIGSJ1LKzwQkDrwg+/iUjtDgtiCK535WPSTHDp
	 xCTB7nJXEjmTA==
Date: Mon, 14 Jul 2025 16:02:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aHUN8Po-JkWIezmN@calendula>
References: <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
 <aGwfPqpymU17BFHw@calendula>
 <aG0tdPnwKitQWYA6@orbyte.nwl.cc>
 <aG7wd6ALR7kXb1fl@calendula>
 <aHEBOFfIk3B2bxxr@orbyte.nwl.cc>
 <aHElR53iOsae5qK3@calendula>
 <aHE-VmyBPBejy0GP@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aHE-VmyBPBejy0GP@orbyte.nwl.cc>

On Fri, Jul 11, 2025 at 06:39:50PM +0200, Phil Sutter wrote:
> On Fri, Jul 11, 2025 at 04:52:55PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jul 11, 2025 at 02:19:04PM +0200, Phil Sutter wrote:
> > > Pablo,
> > > 
> > > On Thu, Jul 10, 2025 at 12:43:03AM +0200, Pablo Neira Ayuso wrote:
> > > [...]
> > > > If you accept this suggestion, it is a matter of:
> > > > 
> > > > #1 revert the patch in nf.git for the incomplete event notification
> > > >    (you have three more patches pending for nf-next to complete this
> > > >     for control plane notifications).
> > > > #2 add event notifications to net/netfilter/core.c and nfnetlink_hook.
> > > 
> > > Since Florian wondered whether I am wasting my time with a quick attempt
> > > at #2, could you please confirm/deny whether this is a requirement for
> > > the default to name-based interface hooks or does the 'list hooks'
> > > extension satisfy the need for user space traceability?
> > 
> > For me, listing is just fine for debugging.
> > 
> > If there is a need to track hook updates via events, then
> > nfnetlink_hook can be extended later.
> 
> OK, cool!
> 
> > So I am not asking for this, I thought you needed both listing and
> > events, that is why I suggest to add events to nfnetlink_hook.
> 
> Just to be sure I wrote shell test case asserting correct device
> reg/dereg using 'nft list hooks' tool, works just fine. So let's skip
> notifications for now.

OK.

Would you rebase userspace on top of git HEAD so next kernel release
comes with userspace code to start testing this new feature?

Your test will need to wait for next kernel to include your
nfnetlink_hook extension, you can post it and keep it around if you
like.

Thanks.
