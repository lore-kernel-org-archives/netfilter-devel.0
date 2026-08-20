Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A46411670
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 11:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787224563; cv=none; b=MGToHFaAF4LbqBbexcalXHLpci2mCSBKRuy/c00vLjXRjl+odZj/daxlYmrt8LEV9MPmcdFdpERtXzD0EPTam99ImX3hOTzM6fhjUikmrurEW8NYi9Wk0vtzBf9Cj9M1aJ0tsEbJ9X7UtVyNwC2DZ+0PmMR/HO0NEMggz6+cfnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787224563; c=relaxed/simple;
	bh=jkmmn3OBy8jTozWh0CCHPDaE1SSNzvV0r7Dq7rewSAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xf7TP5vcir2wZFgUXf3UqbeAi46+vTEEd95HXcHdfteDX2npfODjxLxR+p02sLV7mOAJTCl4RTOBIlK6qDKD2D+Y5ryDSaH4u8oMp3ITiT99ooz6wi2uhfa1H2YsjeC1/s+Gi/CblvVdK2X3vE4YRNr/iFV8XxlrazBgJAChsfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IgtGO1b3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IgtGO1b3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787224559;
	bh=2nq3qA9YxSsSdwuGqhob9nIbnhrF3NPCp4r5DKUMhH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IgtGO1b3TD2la8Fy2UH3SIMuBTUc5aVceDl9u8H1bZR8IHJGSsxB92hkEsajaAhII
	 WHHMA2kTYYDo5L1/T4qyu7Yev5JhTFNLAylCTjUOI6KUdvzYoHKBSmVXzEbqlZxeeY
	 UjcdtMzgDJitw4/ZcZ/KT/Cz3dZnnJBD29+Vt3AOOsc2wEppmg3EHrukGxZ2XhDsdt
	 LBDk8IGcQFYSzeke2bP5w5tE07AP2oL3Bxwc8cVCaaMQt5VvodZb6yJr9AN5U+iZds
	 lsjghmVycHw1x75BfeW2i8Xmsly3U+SIn6BAz2Qb1GuSmfORuuS4C4xmHHWLvkLaoW
	 pkQFQrEkEZSlQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6DE536008E;
	Thu, 20 Aug 2026 13:15:59 +0200 (CEST)
Date: Thu, 20 Aug 2026 13:15:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Adrian Moisey <adrian@changeover.za.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netlink_linearize: size nat register allocation by
 address expression
Message-ID: <aobh7eQw-eqF1iQI@chamomile>
References: <20260806185020.95154-1-adrian@changeover.za.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260806185020.95154-1-adrian@changeover.za.net>

On Thu, Aug 06, 2026 at 08:50:20PM +0200, Adrian Moisey wrote:
> nat statements with a literal concatenation of address and port, e.g.
> 
>   dnat ip6 addr . port to fd00:10:244::4 . 6443
> 
> allocated a fixed 128-bit register block for the address, but the ip6
> address . port concatenation is 144 bits (5 registers), so
> netlink_gen_concat overran into unallocated registers and hit the
> assertion 'dreg < ctx->reg_low' in netlink_gen_expr. IPv4 escaped by
> luck since its 48-bit concatenation fits into the padded block.
> 
> Allocate the register based on the address expression instead, which
> sizes by expr->len for concatenations, and add the matching
> release_register() call. Extend the nat_addr_port test with literal
> concatenation rules for ip and ip6.

Applied, thanks
