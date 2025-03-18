Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3221A22094
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742312105; cv=none; b=Pg+P8TcwGE1yDhImb5ZfNYAiF5BIy44EnNmfLUGOdFiYdftJqttsaWaiRjJUCFttSGB2PCo4MPAAPIa4w9+qY67tefxmeALhZcBn/s6JW6YtIMa4800Rv68mtUpW1hnKjjI5IW2fedqjFuaj8NDW2sONcXmEroixPWyOa1pnUrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742312105; c=relaxed/simple;
	bh=h8zXPa1/UgtuMmBATgfgAjXZv0tIOrYwwrMu9VXgrWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtUipvooK+7ozbIbIHA6A5JPughu/OW+xtZOxSkeCqRmfWFUL7zBKjQ8gb6BeR9fg7d+XyZKW1USroE/tmYR/7yYfHl8DckB/GkftQBgnZI2+2nRtadvETu8Gy6d8WLHDY/OBepvTZlqpq2qaV8wFYDBenReRul9gMJe4Syb1tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Iz85tDmX; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Iz85tDmX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Iz85tDmX";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Iz85tDmX"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F13826059F; Tue, 18 Mar 2025 16:34:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742312093;
	bh=9a2CnIpBUg2XWpwQV+p49a6MCoSlYfwJwKxIvm6QBM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iz85tDmXefMnN9lZn7zkR5LR9m7o5O2rZOCTTJ3C+Rk+HTmg48gIHQ37YXto0BV0e
	 t5thTqdw/OR6zs58EYfejHAuzseBmDx399uZnz9k0yM8CUY65O884qjkTE/5G+s1d4
	 Mt7tRbbVg7SvaykA0b+etEImoPMV9MgLBVxzL+yMaYDAxjkGm21Aysuo3pIcBcwKm1
	 8k5go9UvVX/oh4cBrLTtlp6ViKOGd0wGPLV5TrjeO3m/1I7W2L8oA4SEtytsMGsG6/
	 Bvd/vzyBEhUMCZ/KCxxDCyIzEDk8XIxTyJp5Av/RHhfK7QprhjjhK/9CZtPS59XDZB
	 Y1QvhYZegrWYA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1101D6026C;
	Tue, 18 Mar 2025 16:34:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742312093;
	bh=9a2CnIpBUg2XWpwQV+p49a6MCoSlYfwJwKxIvm6QBM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iz85tDmXefMnN9lZn7zkR5LR9m7o5O2rZOCTTJ3C+Rk+HTmg48gIHQ37YXto0BV0e
	 t5thTqdw/OR6zs58EYfejHAuzseBmDx399uZnz9k0yM8CUY65O884qjkTE/5G+s1d4
	 Mt7tRbbVg7SvaykA0b+etEImoPMV9MgLBVxzL+yMaYDAxjkGm21Aysuo3pIcBcwKm1
	 8k5go9UvVX/oh4cBrLTtlp6ViKOGd0wGPLV5TrjeO3m/1I7W2L8oA4SEtytsMGsG6/
	 Bvd/vzyBEhUMCZ/KCxxDCyIzEDk8XIxTyJp5Av/RHhfK7QprhjjhK/9CZtPS59XDZB
	 Y1QvhYZegrWYA==
Date: Tue, 18 Mar 2025 16:34:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netlink: fix stack buffer overrun when emitting
 ranged expressions
Message-ID: <Z9mSmiFQPhPfGL3s@calendula>
References: <20250314124159.2131-1-fw@strlen.de>
 <Z9lmBhYELKyJHHOk@calendula>
 <20250318132426.GB20865@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250318132426.GB20865@breakpoint.cc>

On Tue, Mar 18, 2025 at 02:24:26PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Florian,
> > 
> > On Fri, Mar 14, 2025 at 01:41:49PM +0100, Florian Westphal wrote:
> > > Included bogon input generates following Sanitizer splat:
> > > 
> > > AddressSanitizer: dynamic-stack-buffer-overflow on address 0x7...
> > > WRITE of size 2 at 0x7fffffffcbe4 thread T0
> > >     #0 0x0000003a68b8 in __asan_memset (src/nft+0x3a68b8) (BuildId: 3678ff51a5405c77e3e0492b9a985910efee73b8)
> > >     #1 0x0000004eb603 in __mpz_export_data src/gmputil.c:108:2
> > >     #2 0x0000004eb603 in netlink_export_pad src/netlink.c:256:2
> > >     #3 0x0000004eb603 in netlink_gen_range src/netlink.c:471:2
> > >     #4 0x0000004ea250 in __netlink_gen_data src/netlink.c:523:10
> > >     #5 0x0000004e8ee3 in alloc_nftnl_setelem src/netlink.c:205:3
> > >     #6 0x0000004d4541 in mnl_nft_setelem_batch src/mnl.c:1816:11
> > > 
> > > Problem is that the range end is emitted to the buffer at the *padded*
> > > location (rounded up to next register size), but buffer sizing is
> > > based of the expression length, not the padded length.
> > > 
> > > Also extend the test script: Capture stderr and if we see
> > > AddressSanitizer warning, make it fail.
> > > 
> > > Same bug as the one fixed in 600b84631410 ("netlink: fix stack buffer overflow with sub-reg sized prefixes"),
> > > just in a different function.
> > > 
> > > Apply same fix: no dynamic array + add a length check.
> > 
> > While at it, extend it for similar code too until there is a way to
> > consolidate this? See attachment.
> 
> Sure, I can merge your snippet and push it out, is that okay?

Please, do so and push it out. Thanks.
