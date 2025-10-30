Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A65B3328F7
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 23:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761866555; cv=none; b=O8hC5vlcS0+yAsjLjMbAMooGzrQwRRi4Njbmo7Fhoe7kPKlgHpoYrsWhidrd+SW1Ov2B/yo7ExM3qyO6c5NR5eYJhLNHG+femN/kMeJwpEMlqUDfOc+31jjL/nzeHazy1nfGcP9/0lUHLQsNmQe6We5r0ErdlPidMiFspFbjta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761866555; c=relaxed/simple;
	bh=jpRPbC10FoYGOd9dD3VdyfC6XP0kOg239BwE702AfRw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cSD5rNZUMQ68yK5gc62h+pY0TMfo/z7crPSDHkdv4FgHiyyiUvGc8rDZCbVJfkX/NTts9NvgtmV7j7Rvz9nRsd/qrlm7IJgWNSXn6qE9oAxCWZVhfiOZuRLpySrSNbFSu3Rr9ylNHcR4PChx99Pc93VWQn2/MaK1srjqe6zhbac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=P1cH06rD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="P1cH06rD"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7D04460285;
	Fri, 31 Oct 2025 00:22:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761866551;
	bh=80O5mKbCW9AT/oQ4bCd+nS5zpq3mrPsUgIe5taQsG/E=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=P1cH06rDIq11mtoALJjKIkIQGmUQiIN/wvvbBjF2+q/AvdrTkMNsLzKZsxuvMYYqn
	 Z2GaKjpxPewV7OqtAC6S4w9q4IfeU24wm9WY3XHJi6NAojndhfGg8We9Jg0IjndEER
	 ZOT4+VesgVcZYxOlPVGpP+b2OrY4LFAB1XLOWilJMzLvQCNxrsg7Ni8OcenuU5E0HS
	 LQ2btuahtAwj6fCznuSITbcIBYOzL0/ty87z5RbyGF4PdylT/0ccXuF/EffW/y7EL/
	 9tDMDXGYlL/W5PCl2M5FpBqmtkViY0FhQilHFv8FdzstmVgV4od2Vuqz2H01H2+Z9a
	 ZioAdU9QLS8eQ==
Date: Fri, 31 Oct 2025 00:22:28 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 10/28] datatype: Increase symbolic constant printer
 robustness
Message-ID: <aQPzNJYx6rTE4xTT@calendula>
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-11-phil@nwl.cc>
 <aQJesgR0qPoO4SfP@calendula>
 <aQNFYAfsuDn-LkPJ@orbyte.nwl.cc>
 <aQPe2073x5p7lUKo@calendula>
 <aQPoPIVk8Matl0i9@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aQPoPIVk8Matl0i9@orbyte.nwl.cc>

On Thu, Oct 30, 2025 at 11:35:40PM +0100, Phil Sutter wrote:
> On Thu, Oct 30, 2025 at 10:56:04PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Oct 30, 2025 at 12:00:48PM +0100, Phil Sutter wrote:
> > > On Wed, Oct 29, 2025 at 07:36:34PM +0100, Pablo Neira Ayuso wrote:
> > > > On Thu, Oct 23, 2025 at 06:13:59PM +0200, Phil Sutter wrote:
> > > > > Do not segfault if passed symbol table is NULL.
> > > >
> > > > Is this a fix, or a cleanup?
> > >
> > > It is a fix but for a case which normally doesn't happen. It is
> > > triggered by the macro in patch 26 due to the ad-hoc struct output_ctx
> > > definition not populating the symbol tables.
> > 
> > For the debug thing that is unused? ie. #define expr_print_debug(expr)
> 
> Yes, exactly. It basically does:
> 
> | {
> | 	struct output_ctx octx = { .output_fp = stdout };
> | 
> | 	expr_print(expr, &octx);
> | }
> 
> Depending on type of 'expr', this may then call
> symbolic_constant_print(NULL, ...).
> 
> > This cannot ever happen in the code:
> > 
> > src/datatype.c: return symbolic_constant_print(octx->tbl.mark, expr, true, octx);
> > src/meta.c:     return symbolic_constant_print(&pkttype_type_tbl, expr, false, octx);
> > src/meta.c:     return symbolic_constant_print(octx->tbl.devgroup, expr, true, octx);
> > src/meta.c:     return symbolic_constant_print(&day_type_tbl, expr, true, octx);
> > src/proto.c:    return symbolic_constant_print(&ethertype_tbl, expr, false, octx);
> > src/rt.c:       return symbolic_constant_print(octx->tbl.realm, expr, true, octx);
> > 
> > And here:
> > 
> > void datatype_print(const struct expr *expr, struct output_ctx *octx)
> > {
> > ...
> >                 if (dtype->sym_tbl != NULL)
> >                         return symbolic_constant_print(dtype->sym_tbl, expr,
> >                                                        false, octx);
> > 
> > Sorry but this is all sufficiently complex to add misleading hints.
> > 
> > If you need to extend anything, then please have a look at extending
> > --debug to expose more information that you need.
> > 
> > Sorry, I do not see this is an improvement.
> 
> OK, no problem. I can just drop patch 26 and this one from the series.

I inclined to think that this is scaffolding that has helped you to
develop this series, but I am not sure expr_print_debug() will be of
use for me in the future.
