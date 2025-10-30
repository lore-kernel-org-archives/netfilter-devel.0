Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164ED33B979
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 22:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761863752; cv=none; b=SWbHiEir1oZ6ETmRE/AjcMk5j53q0LnGYsIwBQVvmu7tenEt0kf9oq93w+H7bgiUJm8aRRXQKiXLGK5Ub5mF9QFRF2vqPE1PxwVZnXopAUmoNAS/pXTau8K3PoC7T2z2m7l/RLOwqssGI97VebNZKgCpwQqK4Tt5ciEaDjcgxB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761863752; c=relaxed/simple;
	bh=AxRVvCQ/ljKuQgajTyK3HtlcJuSblZGF2mOqMWQaXFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDpby8J3MCLdcrtw3rKe50ETCs9vWAlUJDsb6/arGPUUeWr/BnXr4S2GZVIDvLTiFWaFIYzpmqqfGBIUY2rNp4euMBTAZnOo70eIe4RiOlZBd6wIjM+L1rCQ9UqQDd8EHNml/rfEo1VCxccA3GnDbjoql7SHpvCEbG6m8eXD0Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Tj7vTHjO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Tj7vTHjO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mo9IR9rmo2qOJ2XGIlacLOqVUlQpXpWuXtb1cnZP+qY=; b=Tj7vTHjOImds6Z2HEc/IKkZFzo
	L7LxC45TPG64o30Kc1OYl8d/V/mVvnR3EBE5E6+okRC8BimaY6Dnai2AhtSmdkc85wFkYFRCqBS5u
	waRS9y8G5vR5ZCcTJj7mqiw06ADyZjuSyfuzIHTQWZJTqK+WOpkuikajiYjrdHZvrKiJUZ00uahtw
	9MtN2rKSuS4b2kQvqWc6LVf/2Btca49Q6nJvswkGNNrU5pghjAW1jtTgfrMZvDqu0hg9tT0jT8UIk
	FL9xAIO8bpHZ22ko6KsVuyYtOC46TzQowcWFePt7fDF96YyqjURmFD6OwMvexLLQohU/sVszIC5qQ
	W6d9pS+A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEbF6-000000000hA-2R0D;
	Thu, 30 Oct 2025 23:35:40 +0100
Date: Thu, 30 Oct 2025 23:35:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 10/28] datatype: Increase symbolic constant printer
 robustness
Message-ID: <aQPoPIVk8Matl0i9@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-11-phil@nwl.cc>
 <aQJesgR0qPoO4SfP@calendula>
 <aQNFYAfsuDn-LkPJ@orbyte.nwl.cc>
 <aQPe2073x5p7lUKo@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQPe2073x5p7lUKo@calendula>

On Thu, Oct 30, 2025 at 10:56:04PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 30, 2025 at 12:00:48PM +0100, Phil Sutter wrote:
> > On Wed, Oct 29, 2025 at 07:36:34PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Oct 23, 2025 at 06:13:59PM +0200, Phil Sutter wrote:
> > > > Do not segfault if passed symbol table is NULL.
> > >
> > > Is this a fix, or a cleanup?
> >
> > It is a fix but for a case which normally doesn't happen. It is
> > triggered by the macro in patch 26 due to the ad-hoc struct output_ctx
> > definition not populating the symbol tables.
> 
> For the debug thing that is unused? ie. #define expr_print_debug(expr)

Yes, exactly. It basically does:

| {
| 	struct output_ctx octx = { .output_fp = stdout };
| 
| 	expr_print(expr, &octx);
| }

Depending on type of 'expr', this may then call
symbolic_constant_print(NULL, ...).

> This cannot ever happen in the code:
> 
> src/datatype.c: return symbolic_constant_print(octx->tbl.mark, expr, true, octx);
> src/meta.c:     return symbolic_constant_print(&pkttype_type_tbl, expr, false, octx);
> src/meta.c:     return symbolic_constant_print(octx->tbl.devgroup, expr, true, octx);
> src/meta.c:     return symbolic_constant_print(&day_type_tbl, expr, true, octx);
> src/proto.c:    return symbolic_constant_print(&ethertype_tbl, expr, false, octx);
> src/rt.c:       return symbolic_constant_print(octx->tbl.realm, expr, true, octx);
> 
> And here:
> 
> void datatype_print(const struct expr *expr, struct output_ctx *octx)
> {
> ...
>                 if (dtype->sym_tbl != NULL)
>                         return symbolic_constant_print(dtype->sym_tbl, expr,
>                                                        false, octx);
> 
> Sorry but this is all sufficiently complex to add misleading hints.
> 
> If you need to extend anything, then please have a look at extending
> --debug to expose more information that you need.
> 
> Sorry, I do not see this is an improvement.

OK, no problem. I can just drop patch 26 and this one from the series.

Cheers, Phil
