Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F496370AD7
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2026 11:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783076875; cv=none; b=CDmOwxju7L4u3jErx+duq8RuL8K5ZpyFYySunm4IP+v0iN3rZG0a1QwPNWc33rNxucNDX9u+LNQAKbuk/CppYrNlpkfiyBLh0xEFCzJT9N549C7Uf0e5cmGF5FO2XorExov8arfTRpQ6jo1dVtnxrxHguPX8b3XyBPqXzEADd1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783076875; c=relaxed/simple;
	bh=3+dmOCwAwSq/L1HG5HjviSd25oGKbeJ9PGzY0up6CoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=njrH6zIrWtVDURR2kGi60Opb4s5uNQFwAMzlNZWPb5Tu3UY+w3JIkHRBFyQysi2jTzIkiLC8FtAFseJKHdd5L9L4h58BkwZLGL3Ga2tmJRDkv4GFnIJtc08ZS22IwdCf/ch+d4xs4+xUCZc02JS2N8OSoZQuU/keuoGfHA63FvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tk2iVxUb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tk2iVxUb"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C1D0260177;
	Fri,  3 Jul 2026 13:07:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783076870;
	bh=f0UpdHi2pNOrgdlmMgaMs2n7uzNbvlXerNbh92zldpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tk2iVxUbw/5B4up1KjNDK5kJ9PEMHhswBsZXbjeCACa0jsM7v/ESGKmj/W/Gp3gz1
	 K6WjYPN0+knOcB8iCDmwBPHy9Dyhzw29ibACexiAWVPJoAIeGawcOnEyDE5uHyAFIr
	 lYOF4e28ps6UEXERddn1ASNzsLqbA5+hZynZ1sIx3TNB4qwKVzR1jBrSrz8dvstzMX
	 g6mOcLopQI2UfQJ5mXM3nF9oNVfV+E+2kGzCzKxl0ihqKLzqjK9BumxQayNtWCWzi3
	 YupS080y7KL4G8mR2cbT2oBW80HQy0UTX8yDbz015AnWqVqniq18kj1J8la0elFigj
	 mAS4wGH2DTNvA==
Date: Fri, 3 Jul 2026 13:07:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, Ren Wei <enjou1224z@gmail.com>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
	yuantan098@gmail.com, dstsmallbird@foxmail.com,
	chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 1/1] netfilter: xt_time: reject pre-epoch calendar
 matching
Message-ID: <akeYAxWNWVhQz1wB@chamomile>
References: <cover.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <779d223ad31c493cbfc3c483293e435dca89cf90.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <akd6KZo1lwQ719d0@orbyte.nwl.cc>
 <akeKGXmzONKkGqOl@strlen.de>
 <akeLxWXP7Y-5I8BQ@orbyte.nwl.cc>
 <akeO-v0H9QP1psep@strlen.de>
 <akeXD_GwEFarWAuK@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <akeXD_GwEFarWAuK@orbyte.nwl.cc>

On Fri, Jul 03, 2026 at 01:03:43PM +0200, Phil Sutter wrote:
> On Fri, Jul 03, 2026 at 12:29:14PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > > This is silly.  I'm not sure this is even a bug.
> > > > We're in 2026 not 1970.  I really don't see why this patch is required.
> > > 
> > > I imagined a system with broken BIOS clock which boots at epoch until
> > > NTP has fixed it. Then stamp will be close to zero, no?
> > 
> > So what?  Rule won't match either way.  I wish we could get somehow
> > get rid of xt_time and nft_meta time matching, this was a very bad
> > idea from the start.
> 
> Sure, time-based packet matching won't work on a system with wrong time,
> but AIUI the patch is merely trying to prevent the unexpectedly large
> lshift. It seems harmless, though:
> - current_time.weekday can't exceed 7, it is assigned the result of a
>   modulo operation
> - current_time.monthday is type u8, so worst case the kernel will
>   compute '1U << 255'

Maybe it can be added as hardening for nf-next, just for correctness.
Remove Fixes: tag. I don't see this as a bug either.
