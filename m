Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6830148F022
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 23:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791502177; cv=none; b=awfB3Y1Ylucd+r6EzXtfZutwUovqyqgLlUrxfKcxDei1brhupXcXYnQG1eViEPEOiVtn/nqbHRRVEMvdnQXUXVaofB5o9j98oV+Nj0eWPPd3ajr8fQQTAPa8aHovbMOavFkyF+5kSBypPRlw4RadbdFpXr031TIFrWScE0smac0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791502177; c=relaxed/simple;
	bh=hajGkdyoxZEnKe4k/ud2e4gQslNuV8jejoA2No3P/K0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeeltQoQPyuY1GOj9W9o+GuIXLVUhOqS8ztFKfdlQ3Xio7uMHCz8kuTRqqe3qNIKJKwG2Y/e72GqKCFuzXlL4ovyc3oij5cL1aKAUobMM9T3TkFHmhkXhjkoJIMW/oMvS5JEzdSVyXB9JjlHtRZ7qeuyEpWaGLdaaixwnvs8Ld0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JDKFkHS4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JDKFkHS4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791502170;
	bh=8zQoBx1PQKq4raoFz+beJHGXiCLkUhT8QSbxzcFF2j0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JDKFkHS408SkfbHNnyS58Uan57Glh6M5D57N9XGmG/EJDvXooDFF3V/KUM1oGcCiu
	 fqpbMoqwaojAKotyv1gbyXrILlPKT+Snl4V9qMyHD2f697P+rHMleM8cy13kZ2gAw+
	 jCwpO3xHYnQlY4aiGgvPf/Jy3uTxV37ZbA3t2ztWcLNR1hWtJg+fjOgoANJCMyver1
	 tBp8UtNVHO08/B9IY7S6bu3lzHgip0muDQFzUJN2snbJiDRqoFJBSi12CbE7ZrTsaB
	 BLQEksu1LCFmy/SHsqJURMDtGBLlTVBavjCs7T7KTHoEoZDL5Ha+1NNRYtWfUaxrKo
	 Wxo9Yu0hhXvdA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 691F56007D;
	Fri,  9 Oct 2026 01:29:30 +0200 (CEST)
Date: Fri, 9 Oct 2026 01:29:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Zixuan Chai <petalzu987@gmail.com>, Ren Wei <weir@nebusec.ai>,
	netfilter-devel@vger.kernel.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, kaber@trash.net, vega@nebusec.ai
Subject: Re: [PATCH nf 0/1] netfilter: nf_ip6_checksum: validate checksum
 offset
Message-ID: <asgnV5XFaS3V8g4W@chamomile>
References: <cover.1789660425.git.petalzu987@gmail.com>
 <aq0UpHHbvxjR2jLb@strlen.de>
 <aq1HaYS96SNn7HJY@strlen.de>
 <CADTzadLvrvqbnUipgw4YG+ssa78vm5aUpDSoFZCnwQoOoeMYog@mail.gmail.com>
 <asfR13j04mKUELMQ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <asfR13j04mKUELMQ@strlen.de>

On Thu, Oct 08, 2026 at 07:24:59PM +0200, Florian Westphal wrote:
> Zixuan Chai <petalzu987@gmail.com> wrote:
> > On Fri, 18 Sept 2026 at 22:15, Florian Westphal <fw@strlen.de> wrote:
> > >
> > > Florian Westphal <fw@strlen.de> wrote:
> > > > > We will provide detailed information about the bug in this email,
> > > > > along with a PoC to trigger it.
> > > >
> > > > patch is fine, but could you make another patch that either fixes
> > > > ipv6_find_hdr() or ip6_packet_match() / nft_set_pktinfo_ipv6() as well?
> 
> FTR, ipv6_find_hdr() gained this check in
> ee319bd3a0e9 ("ipv6: do not let ipv6_find_hdr() return an offset past the packet end")

Then this is fixed upstream in the core, now it validates that the
offset provides enough room for the announced header.

This patch is now hardening that can follow up to nf-next using 
DEBUG_NET_WARN_ON_ONCE?
