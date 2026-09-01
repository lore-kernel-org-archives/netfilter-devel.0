Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D1340B0E0
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 15:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274854; cv=none; b=BH7Speivfk7sGwfLpuvytx+xbC2RyBoVNEO5o9tZl0bvtnRwu6Ky0ZhM/qpzUHyAai4C0FMyVzLT7rOlRleLciDc3P5ir4b/StmoNcLAMiVXlXPQdJFwipYP1Rr6l94CuG0S+U8GJ4SXYxcLKJSr3xkVH1EqqaBm4d6+ZjfcmRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274854; c=relaxed/simple;
	bh=Hd9pF/6C9NmR0bvlKG5JBynT24sCA5JvA3JGuPjOk6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ODQCJIMlu/AAB5zA8/QVPiiktG24OFMjCVSc9upiF1Mh1LalDA8t8Dfd7IppPaFXuSgyLPaaqC8ueCYKYPug3f8y7eJgn39wZAxajcjVxCMN3/LH7tMAT2rTRAy/Wg2opeuPdxgpRDkMcg2RDBiR6p8FUR1cIaCA6i3eX3PRgbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RFnGuEyj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RFnGuEyj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788274850;
	bh=VErx+36ofDohdqnIjo/gbF+SRgGDOp5qe4WMjueH4+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RFnGuEyjT7mkC48ZHVIWLVUOtFGmCsk8QXxrzfOol2qY9B2YwkVubvBlmNZT/X/Ws
	 dZUNON/kE0uM2oXs3WGBbLu0ekozvqzCDLk7vQDt88RD1RYrT77yx365eQjRN3fbzJ
	 VGTHTU0/hErFhgSIErPbHme7GNpglb9hOnh4IYgfqk8+UVoJMxAWXRyU1EM6Dmi0VU
	 eAYqrYroOjzjNU4JTApmXtCUeluPoNzU/wXqIiznMDVNaSkr9Rm0CaCmc5qzkHZB7h
	 9C0GgtiWuiFaRA8Cg3p98z1bk1q5oabs+8CssLS/BLP4Pu4OEoIASavV6Tu1rIIGp5
	 uPxc34ESXtoDw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1299D6007E;
	Tue,  1 Sep 2026 17:00:50 +0200 (CEST)
Date: Tue, 1 Sep 2026 17:00:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] libnftables: Drop symbol
 nft_bison_have_extended_errors
Message-ID: <apbon9gjfoUsgSYv@chamomile>
References: <20260901094852.104268-1-phil@nwl.cc>
 <apbnh53-c6IGNYut@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <apbnh53-c6IGNYut@chamomile>

On Tue, Sep 01, 2026 at 04:56:10PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 01, 2026 at 11:48:52AM +0200, Phil Sutter wrote:
> > It was merely used to indicate extended parser error support in 'nft
> > --version' output. Not worth bumping library version just for that, so
> > drop it again.
> > 
> > Fixes: b315dd551dd96 ("parser_bison: Fix for bison < 3.6")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

I have applied this patch to nftables.git to prepare for the nftables
release.
