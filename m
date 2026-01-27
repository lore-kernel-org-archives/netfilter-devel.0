Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1309F21B185
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769551486; cv=none; b=hlHQkUJgyT8r8BJOdKN+oGlTHR3Hi7rdjau4Qoh+W/AFQcrgKoVM/RUVWTCffIaDdK69GpBKFDYsgxAlBuJcEPxfc5CTtqFLbBgt+5EkRDOKdCiO1+Fdv/xo9Sd1CySK6sAiR+zvOpYulsAfA/8ndTmIWboxDcpi9qWDlXNjmxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769551486; c=relaxed/simple;
	bh=OUDX6BFKImVc+iY4S6DJsGG8kcR9cByHB0c7cTgBwVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+dfW0bKHSJVOUv6RxuvobvH0hAXXxy0hWTGGlqY7d8/0VeQq6aacRzbg/vRqE7Baq8WnuSd2cdzH6et6f/sLncTAUd/GQ4psLLYCECbvQ8Qyr1c4s1XDaVAVFsNu69l7Gyw7xLAXk6hYseAC7ya8zS3JZTg1Ul5PPsv0vY6x24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GqLXIWS2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GqLXIWS2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bVuFDDl1leHwv3Dw/43OvK2ArPz+cGPrRKjysY3K1o0=; b=GqLXIWS2iUgtm0IvdQ2aWYG8tp
	nUXRQSvXupQHWhiyI4CQJq790ePYAxGGiHawiLvl1cicAD4Yo0Lvk9rLJlUUCwkgBS3i8ibHmfQi4
	ial7PD9f0PoK0uPg/aC4JhidQ7RHM2vrVtlbvF5PHSPr6kLtgSwwaF5nfB4u/XisYDc6W792m3S4M
	ec/x2BodMeZaRhQzAvTvWP+Dj2juHJz+huM21jetRgYonasPHk2aZ8McdQO/O0zW5ttHaANbwxkoJ
	7pZp/mTE92p6AWmk9UnRqzDvD9Eq3uwTgxyZ3LyCqz0f8QLy2ot5AJ3mmEd4CB1dxJrJuMoztRZNn
	gWAgRIzg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vkrAx-000000002JK-2IqE;
	Tue, 27 Jan 2026 23:04:43 +0100
Date: Tue, 27 Jan 2026 23:04:43 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 00/11] Fix netlink debug output on Big Endian
Message-ID: <aXk2e-JLML27vR-b@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251114002542.22667-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114002542.22667-1-phil@nwl.cc>

On Fri, Nov 14, 2025 at 01:25:31AM +0100, Phil Sutter wrote:
> Make use of recent changes to libnftnl to make test suites pass on both
> Little and Big Endian systems.
> 
> Changes since v1:
> - First 12 patches accepted and pushed already, patches 27 and 28 as
>   well
> - Minimize changes to existing code: Drop patch 13 changing string-based
>   expressions to be defined as Big Endian as well as related patches 14,
>   17 and 18
> - Pull a fix for concatenated wildcard interface names upfront
> - Follow with set element sorting changes, with improved patch
>   descriptions and related test suite record changes folded into them
>   for clarification of practical effect
> - Review patch descriptions in general
> - Add special casing to patch 5 to avoid string-based values being
>   printed in reverse by libnftnl, also communicate any byteorder
>   conversions from __netlink_gen_concat_key() back to caller for the
>   same purpose
> 
> Patch 1 works around "funny" behaviour of GMP when partially exporting
> data and unwanted prefix-padding when exporting into an oversized
> buffer, all happening on Big Endian only.
> 
> Patches 2 and 3 deal with sorting of set elements. They are effective on
> Little Endian only, changing sort ordering to match that of Big Endian.
> 
> Patches 4 and 5 are preparation for the next two patches.
> 
> Patches 6 and 7 collect data for calls to newly introduced libnftnl API
> functions (in patch 8) to communicate byte order and component sizes in
> data regs to libnftnl.
> 
> Patch 10 contains the big payload records update, created with help from
> the script introduced in patch 9.
> 
> Patch 11 still contains the expr_print_debug() macro definition for use
> with printf-debugging.
> 
> Phil Sutter (11):
>   segtree: Fix range aggregation on Big Endian
>   mergesort: Fix sorting of string values
>   mergesort: Align concatenation sort order with Big Endian
>   intervals: Convert byte order implicitly
>   expression: Set range expression 'len' field
>   netlink: Introduce struct nft_data_linearize::byteorder
>   netlink: Introduce struct nft_data_linearize::sizes
>   netlink: Make use of nftnl_{expr,set_elem}_set_imm()
>   tests: py: tools: Add regen_payloads.sh
>   tests: py: Update payload records
>   utils: Introduce expr_print_debug()

Series applied.
