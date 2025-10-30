Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFAA54918
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761861380; cv=none; b=RodkO7NZUnATLsg2ux5tBzEl5izLMfnbhkVXicX6XMdp3xvfSIhivYnIOGqRNT/peJa9cZ5PdaLDUJMnZeCqQQNPYlFX8H820a4zRsdYIfXmLeDR7JpQpu2xUdJyDOksc2CR5AT5BtYdavmH5xnNcm8dJBzmQaz/ef9hTB+9jkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761861380; c=relaxed/simple;
	bh=2MKW/Gla8B4HnvSP+KNpev0DQv9MeT7TojbmE44zm0Y=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3W0DCk2zFI/y73WsfgFYhM80XnCW5LFaN0mszdqA9isFadn8ILug2/h0v8sN99qGqZq2kjAjSP7ZpQZiHycpgzptK9HkvpK1f8LXaIBZZWqHoaIBUJns7rs1Ib30pUgqsTqmx4MUeEs9sbOr5ZikjudEy5MwQlH9gfSybV/Aj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Qqxbf+Iz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Qqxbf+Iz"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1BB6760312;
	Thu, 30 Oct 2025 22:56:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761861368;
	bh=lYx+j/i4xITVF2Snf9JseFs8QoPf7RMDxWF3aMJ4pIY=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=Qqxbf+Iz36eEWqfyq7AgHOS7gM1pE9pJIhhDel2j7ywk37zJXjBF55Ckc9vtp45W6
	 xnu+RAxTeq7+r5DmU1g6oT04TuNlewDsR13Y8xG2UuR8szhIDecSxhlCeCwbfayA6G
	 yTUZivOffPyose40bNdQuUKn0dSUAxtK4djturiHwNgQpJL2Nhu29RaTrr3lNT4pmb
	 s8sydisGFF5cghKmLiOxDdC+boZ3bhwqgontdQ59tPSeUP6JDQh8B0/ZP1Ffgygsn0
	 P17ytad3N5WEI1v2BfOlzSFXbmxGu4X3i5HWMLdjyAGyvo/kHlnPDJz3BuomqNNK8I
	 Wbp0cn3DJ7KpA==
Date: Thu, 30 Oct 2025 22:56:04 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 10/28] datatype: Increase symbolic constant printer
 robustness
Message-ID: <aQPe2073x5p7lUKo@calendula>
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-11-phil@nwl.cc>
 <aQJesgR0qPoO4SfP@calendula>
 <aQNFYAfsuDn-LkPJ@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aQNFYAfsuDn-LkPJ@orbyte.nwl.cc>

On Thu, Oct 30, 2025 at 12:00:48PM +0100, Phil Sutter wrote:
> On Wed, Oct 29, 2025 at 07:36:34PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Oct 23, 2025 at 06:13:59PM +0200, Phil Sutter wrote:
> > > Do not segfault if passed symbol table is NULL.
> >
> > Is this a fix, or a cleanup?
>
> It is a fix but for a case which normally doesn't happen. It is
> triggered by the macro in patch 26 due to the ad-hoc struct output_ctx
> definition not populating the symbol tables.

For the debug thing that is unused? ie. #define expr_print_debug(expr)

This cannot ever happen in the code:

src/datatype.c: return symbolic_constant_print(octx->tbl.mark, expr, true, octx);
src/meta.c:     return symbolic_constant_print(&pkttype_type_tbl, expr, false, octx);
src/meta.c:     return symbolic_constant_print(octx->tbl.devgroup, expr, true, octx);
src/meta.c:     return symbolic_constant_print(&day_type_tbl, expr, true, octx);
src/proto.c:    return symbolic_constant_print(&ethertype_tbl, expr, false, octx);
src/rt.c:       return symbolic_constant_print(octx->tbl.realm, expr, true, octx);

And here:

void datatype_print(const struct expr *expr, struct output_ctx *octx)
{
...
                if (dtype->sym_tbl != NULL)
                        return symbolic_constant_print(dtype->sym_tbl, expr,
                                                       false, octx);

Sorry but this is all sufficiently complex to add misleading hints.

If you need to extend anything, then please have a look at extending
--debug to expose more information that you need.

Sorry, I do not see this is an improvement.
