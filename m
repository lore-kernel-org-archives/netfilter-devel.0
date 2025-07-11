Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB8E13D531
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2025 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752241399; cv=none; b=eEEXoAxma/RmRo73bqm0UhixpSEKODvS0u0B1iEGEJLiakMGGygBx7lKzhjIY34TJY8ooU1FDJ/vylmToJ23k2qpQsH+CnbXT0VnugB4fhHrkwL6fnk2BM4X8CEkFAf336C3WlDr9DpGAqEV6tDmqNByDHK+ieCn0+oRKbwIwZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752241399; c=relaxed/simple;
	bh=UnEI4muUADZ5zpMTgy6BKoCDNPlTWj8P2msElIAC3Rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mx36UGJoRijg3tiJTy0rC1FRzb0SNPS1LiKorxU+sndJKGZqYdqUVk9dPsDeAEW6bru0xYcriaEwGYSu+AZhCR2KUbgnBVd9Ti3VhPVKzbAJCRDT4Kmzi6NPmPUROc+rS/H0gYOEVoGTg0mQoSJS+pAeRobyBIZrPQ4Fv7CM9SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iQF9VXqS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iQF9VXqS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9lS7KPt+jcz/EsX2kKv24aFsmS73Ot2iEzdH1aESnNQ=; b=iQF9VXqSaAVr0JTF/IFb/y7K8A
	c96rLEcFJKKMaUh/MFxCbB1hIBv927eaAi9X6N6zew8TPTX9taafgP3e4c+r528tnCaeYhMZWWlf+
	IWXfSlpQObDpP0VGbJ8Kis6JSl1o+hBS149yzHEEG+jI0+uAAzIjqsoG6rIWsPTgPeJGqdPA625Ln
	x4H90PqhTq4MfyTpZrl8Z3PU+/whMWvpUYeKy+1rp6nCa1vaZXcHrMQpelDx9cqJXXcgoPZCRbNvn
	XTMjRUfKZfMa9jHkURe6ChSQA/0CkjJlU6+63lz0rVShjY3tDsA6XGUq8VqUaiSNIypLbSCWKPT2r
	urcarAeQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uaE1y-0000000045B-0ZCz;
	Fri, 11 Jul 2025 15:43:14 +0200
Date: Fri, 11 Jul 2025 15:43:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aHEU8juop6ztbVip@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
 <aGwfPqpymU17BFHw@calendula>
 <aG0tdPnwKitQWYA6@orbyte.nwl.cc>
 <aG7wd6ALR7kXb1fl@calendula>
 <aHEBOFfIk3B2bxxr@orbyte.nwl.cc>
 <aHEOtz_Ekj0QV15d@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHEOtz_Ekj0QV15d@strlen.de>

On Fri, Jul 11, 2025 at 03:16:39PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Thu, Jul 10, 2025 at 12:43:03AM +0200, Pablo Neira Ayuso wrote:
> > [...]
> > > If you accept this suggestion, it is a matter of:
> > > 
> > > #1 revert the patch in nf.git for the incomplete event notification
> > >    (you have three more patches pending for nf-next to complete this
> > >     for control plane notifications).
> > > #2 add event notifications to net/netfilter/core.c and nfnetlink_hook.
> > 
> > Since Florian wondered whether I am wasting my time with a quick attempt
> > at #2, could you please confirm/deny whether this is a requirement for
> > the default to name-based interface hooks or does the 'list hooks'
> > extension satisfy the need for user space traceability?
> 
> My main point is that rtnetlink has a notifier for new/removed links,
> see 'ip monitor.'.
> 
> So even if we want a 'nft hooks monitor', I don't see why kernel changes
> are needed for it: subscribe to rtnetlink, then for a new link dump
> the interfaces hooks *should* work.

Oh, I didn't get that. Does it work with removed interfaces? 'nft
monitor' will notice, but fetching hooks for the removed interface won't
return anything then, right?

Cheers, Phil
