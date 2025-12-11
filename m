Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791103D544
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Dec 2025 00:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765414638; cv=none; b=NuJxknhK1fpP+W+3Om9TfnPHtTWEKGUrYEphI0yJaS3ndaAIjuZcvyUkLspxu+TfAp7ERmXDYR019hE05NrMOxPNVDtsgAPfBm8bm8lFgdeS2a26nw1EsgEls5SOLtC3O6iH23JSS4P812VDcMvYrEYkzhjxjvAp2o2NeGO2MoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765414638; c=relaxed/simple;
	bh=xDWdecjQVZ0C2ywX/ozBxkdxpF8Sr2C4tUMAqFQlAD0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHO2wKbEvBe/4+2/ZX+75MlQhb7R16Mh1jLdplnRManRZ9K2C4UPrbD8RrWUsCUMA/nSBxuERk+/OuycX8TiiaqphfAyMn0UzbnYdTOLgE5CUd4gmZdOmupB2oRrWuyUVMevlwPO1GWoOlV9lPMSDE6lBk75HzF/58iRk2XLRco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C225960371; Thu, 11 Dec 2025 01:57:12 +0100 (CET)
Date: Thu, 11 Dec 2025 01:57:13 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nft PATCH] datatype: Accept IPv4 addresses for ip6addr_type
Message-ID: <aToW6QiVA99zbkAe@strlen.de>
References: <20251210214945.31389-1-phil@nwl.cc>
 <aTnvXiYTlQtqVvug@strlen.de>
 <aToRHispbspGtCY0@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aToRHispbspGtCY0@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> > > +dnat ip6 to 1.2.3.4;ok;dnat ip6 to ::ffff:1.2.3.4
> > 
> > Pablo, what do you think about this?
> > 
> > I think nft should always return an error here.
> > I don't see how this makes sense (implicit dnat to a
> > mapped address).
> > 
> > Phil/Pablo, do you see a way to limit the 1.2.3.4 -> ::ffff:1.2.3.4
> > expansion to 'add element' ?
> 
> It might be possible for dnat statement to set a flag in eval phase
> controlling ip6addr_type_parse() strictness. This should work even with
> an anonymous map, e.g.

True, but it was more of a usability question, i.e. catch ip vs ipv6
typo in 'dnat ip to 1.2.3.4'.

> | dnat ip6 to ip6 saddr map { fec0::1 : 1.2.3.4 }
> 
> But this could also be a named map and we probably don't want to check
> how it's used before accepting an element.

Right.

> So all this kind of opens pandora's box and we probably either have to
> accept the new ways for users to shoot their feet or:

Yes, indeed.  Or add a cast operator for this.  This was discussed
before (for other things like 'mark set ip saddr').
