Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D888A2E62C6
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 20:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770841191; cv=none; b=W4uBagRHQD8C5FWCgS9/bZNHNwDQj1v6jWAaS6AD89C9lSPbP6aLmt2/3zrAic1NwdWZ6eT/XDqqN06bQmm6QycRJaHrmRr84pmzplh5gHXStmc0VkG68iTCLPrG2cXMk7McpB4rK8g8GGRYCoMz8thU1Y7fIZ8Cwnh6yl4C/6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770841191; c=relaxed/simple;
	bh=nBQ5oH4z1LgEIizLb3fbBCPNzi0ahqPW/nfiTC+DMSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9hVvsBPVXKkwxU9a6Vf4OLKJj4N7EJSub3FGw0ExGl9Plg1UaukSqfp7yA7c9VrsFujttD8QZNwq4lc9Gc05x/fI2dwNn0UDORyP2EcITrAyA5rBPnEOHnG/fSjYI21KDlXL0KmrJWzyEw9A7+0AfBYZUytxyECXHVeePg7c1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=D8JlJLZw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="D8JlJLZw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1/ssD6Wnl0w86y8W1TvDaot6oh+ARZ2AaMKvwna4q98=; b=D8JlJLZw5vNAoleFi0Of9bd+Pb
	SJsFubX4GQISTV2iBw/UTwsKVOA8ilxVQA1n5Vf+y3o/MjcW8N0dnIbSgjrmn0O5DmMhlZoxlUZRz
	8Bh3AH+HYibyzipHuLGSRNTl4HUcfB3i3+MionDKsUOTQ01c9cpyG9sKsTgf19B2e/vlesUJXOyLt
	IKRoFLsyVIPPxRklZFHwpGt+2gL9PMdvF2BfukqbZBXszbAsPVsR9rLUrcU8+PVc/6kGpCAVT0ODi
	oBpAEWxXiaOXKY03R7lKqMmPejWU18MnsDZl7Ty2A8pYkbaA2ZaQ6j6sSgQl6KrlAcz3hgW99iP1t
	oULAkfgQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqGgd-000000008Pc-2tLY;
	Wed, 11 Feb 2026 21:19:47 +0100
Date: Wed, 11 Feb 2026 21:19:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Alyssa Ross <hi@alyssa.is>,
	netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
Subject: Re: [PATCH nftables] include: fix for musl with iptables v1.8.11
Message-ID: <aYzkY8rwmN6wV4BQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Alyssa Ross <hi@alyssa.is>,
	netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
References: <Z2VaEv0u3ZPcWqye@orbyte.nwl.cc>
 <v654rm6mbtymzhavlbg2fu7irth4mkz4motq7vb7rzjql5ccqa@u7xv7uvdfvsl>
 <Z2VkJrkSLRmY9lAE@orbyte.nwl.cc>
 <Z38Ladz49yJcTC8p@calendula>
 <Z38PIVmu2jAVl1k2@orbyte.nwl.cc>
 <Z38STV2bWSlz4uxo@calendula>
 <Z3-emP_FzgGAYGUJ@orbyte.nwl.cc>
 <aYyI9kN4FAgbFUA-@strlen.de>
 <aYzRlXaSetejciwU@orbyte.nwl.cc>
 <aYzT6kHV7ntq5kfo@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYzT6kHV7ntq5kfo@strlen.de>

On Wed, Feb 11, 2026 at 08:09:30PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > Phil, would you send a formal patch to make this workaround *ONLY* in
> > > netfilter_bridge.h (06e445f740c1)?
> > 
> > DONE.
> 
> Thanks.
> 
> > > That way the fix can be propagated to nftables.git without having to
> > > adjust cached headers on every update.
> > 
> > I assume you prefer to keep headers untouched which are
> > iptables-specific. But why not attempt to patch if_ether.h itself?
> 
> Because this is a quagmire and I prefer to only break netfiler_bridge.h
> users (which should be few) rather than everyone using if_ether.h.

Fine with me! The resulting flame^Wdiscussion from such a patch would
have been entertaining though, maybe even productive in a sense of
"either tell musl to go fix themselves or finish what has been started
by introducing __UAPI_DEF_ETHHDR." :)

Cheers, Phil
