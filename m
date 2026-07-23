Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EB6438004
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 10:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801359; cv=none; b=I0EvUXsyWnQ6whlvrkrScRoJYe+KfOD3TNdrFvuHsKuhQNnBiXg4jeQyJgZ83JJHMmptqN76iS+D8lPQ8R+DsHHUOnPL9uXAgQA2/iiPiTBpAZeqX1GlFCBwDcoDPaWaqKM50EaYeAQS84yVCm/kEpQFIliKA9rT8wGeVTuHh20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801359; c=relaxed/simple;
	bh=/wtTFpC1al9eM2eU7GN4X/RrC8Uc3TV47/zic1b7I/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAHmraVW5SS5GB011m9orbki20gbMBldho5hu8exZ3x8UlI/hEgS9i1Gj5wCR2UlLA2KrXWkInc8UcboTqGHJlnTl6J3jDONj2JazwB1Bi88MArKH1Lb67REGZO3T1hqgyIX2rEi21TxXKO5DCPhLweqfMjoc4Qyy0W0TY74KQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fMl/XTkP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fMl/XTkP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U2YnnQ5c+l6I7taS/adj5ZyMdcN1yx1MOutvV86Be7E=; b=fMl/XTkPZol+GGfeC5JhxeXppm
	BXBDcL9n4gCfa1sB8LDOmyEDcuXagCrkO1MAhwqURqT19KOPSyCqFI95FAve9wA3WrT22GpYzwERI
	EgkC+Ke5xsj0RLsuct+b+IdB4fRFuVv4t26CbKgiKMt/CQeF3K2OPKXCMwmyAX8qc3q7xm7nFcGjd
	KjToZOtiTpbCKNwyH3LXhz2nRhuOti9FmfgpFwm5AEIsXNO0YpSD9in9ztwVADqfcOeyt/uvDdTuV
	5/xRy+nMFSFaj5p4p1Gj65vdpXY5Kbezw43D4GsY4pm+DsOi+5L2yaqmUp6pitDnQwXZjOgvgiXs5
	jHOsZ20A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wmqMc-000000003bW-42e3;
	Thu, 23 Jul 2026 12:09:14 +0200
Date: Thu, 23 Jul 2026 12:09:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Jan =?utf-8?Q?Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
Subject: Re: [nft PATCH v2] parser_bison: Fix for bison < 3.6
Message-ID: <amHoSglXwfNia7V7@orbyte.nwl.cc>
References: <20260611125231.652353-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260611125231.652353-1-phil@nwl.cc>

On Thu, Jun 11, 2026 at 02:52:25PM +0200, Phil Sutter wrote:
> Support for 'custom' parse.error value was added in bison-3.6. Fall back
> to previous value for earlier versions.
> 
> This is harder to get right than it seems: On one hand, preprocessor
> macros can't be used in parser_bison.y's declaration section and
> automake forbids conditional changes to AM_YFLAGS on the other.
> 
> Another aspect complicating things is compiling with (an up to date)
> parser_bison.c in place vs. without: Dist tarballs generally have it in
> place, relieving users from having to provide a YACC when compiling. The
> existing parser_bison.c either uses parse.error=custom or not which does
> not (should not) change when compiling. Hiding yyreport_syntax_error()
> behind a CPPFLAG which may be set or not depending on bison presence and
> version then causes trouble if it doesn't match how parser_bison.c was
> created.
> 
> Avoid these pitfalls by:
> - Not relying upon a preprocessor define to control parser_bison.c
>   compilation, instead check existence of the bison-internal
>   YY_LAC_ESTABLISH macro
> - Exporting the above macro existence check in a variable for use by
>   main.c (thereby crossing the libnftables library boundary)
> 
> Also:
> - Introduce have_prebuilt_bison variable in configure.ac, unifying the
>   parser_bison.c existence check and solidify the latter by also
>   comparing its timestamp
> - Report extended parser errors enableval in configure only if
>   parser_bison.c will be recreated, otherwise we can't quite tell if it
>   will turn out to be enabled or not
> 
> Suggested-by: Jan Kończak <jan.konczak@cs.put.poznan.pl>
> Fixes: 67b822f2b2624 ("parser_bison: on syntax errors, output expected tokens")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
