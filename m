Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4B233121C
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 14:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783435975; cv=none; b=WmXkOtisEClSF7la/ufL3R0A+yMp9C/hHDqL19+3XyvtgqbX8SB125Uz6I7ZiVP+VIBujYXz82wE4pksZv2a7DEEoOe5BQjMYfy0RnDdMEdmG9f29VWEZvlfa6wfwg5BWxNZJ6eNN2WNSNAxdXL8zfnWHDRO6JVZdb0QzU3lwvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783435975; c=relaxed/simple;
	bh=Wmix684u7o5wtvmVIJwlqlwSccmAfjifzFFsGffuKXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FTn+ekq466hxaSu/t3JDMjgJLefhBzcHQeSIPeUqmCr0ll5lr4twZAikJmc9RkZ5ApkhtKlZMnpOXAOkrk6wJkwHpZ/gjFK6Tk27GLopIyu6vKBkKJEG4HRZbwa6RuuYy0O+LcMXQjhvy/05tHwyoBvsED8nDekhpcb6juwob5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=C3HPI1W1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="C3HPI1W1"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 383A26057B;
	Tue,  7 Jul 2026 16:52:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783435972;
	bh=ZY9kvGsvrphgNwlLIZowUeQWH6LQ+BLdhDa8NVtjtWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C3HPI1W1FUwoYCj3RrwjHffIBW2Lhgy59jQHmuh1OhfDjDDTkA5W3fpXmxc5hF5OX
	 QhAW1dNQLnAl0b9CAZmoMiRGzfzu7o5qtOW9rk0G7/IrEQtdihSyi/vkljlr/abXpD
	 eyN4W06uP7hz/brlGcDsqFfBQtiDK0zt8AR2SMBWLsijJP1jfCfy4IWFQmRXS3AtW6
	 g+tXTrLW0Jz6t0GykP5tXRgnwWpYTxs6lGU+S2KPEEpy+QXFNk3BWI+BZKK6HHPHMT
	 Bmveuzf16KlhNS9VXRZFW34KGAmkDPqb5DG8pEwcUc9isbu3nOci3slhKLyFwy7PAb
	 MhZVQcRgd7NBQ==
Date: Tue, 7 Jul 2026 16:52:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] tests: shell: expand get command test with open
 intervals
Message-ID: <ak0SwqzFAqA06788@chamomile>
References: <20260702123634.349861-1-pablo@netfilter.org>
 <20260702123634.349861-2-pablo@netfilter.org>
 <akz-fH24aKQbjaHm@orbyte.nwl.cc>
 <ak0KITUOuYAXYm5v@chamomile>
 <ak0SE7hrYpUdxjVK@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ak0SE7hrYpUdxjVK@orbyte.nwl.cc>

On Tue, Jul 07, 2026 at 04:49:55PM +0200, Phil Sutter wrote:
> On Tue, Jul 07, 2026 at 04:16:01PM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Tue, Jul 07, 2026 at 03:26:20PM +0200, Phil Sutter wrote:
> > > Hi Pablo,
> > > On Thu, Jul 02, 2026 at 02:36:34PM +0200, Pablo Neira Ayuso wrote:
> > > > Extend the existing test to cover get commands with open internals.
> > > 
> > > This test fails on a Big Endian testing machine running Fedora Rawhide
> > > running 7.2.0-0.rc2.21.fc45. Does this perhaps test a recent kernel fix
> > > or something?
> > 
> > Does this kernel contain this kernel fix?
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git/commit/?id=d63611cbe8af99dd61b118ee6e5b5e3e518250b2
> 
> Ah, thanks for the pointer. Rawhide kernels are "best effort" by early
> rebase vs. excessive backporting, so a fix in nf.git must be rather
> critical to hit it before linus.git.
> 
> > as well as this userspace fix:
> > 
> > https://git.netfilter.org/nftables/commit/?id=4eafc1a2a9ef5a827b1b4e58cb3b2832d2eb1650
> 
> Yes, this is present. To give you a bit of context: I have a script
> which builds current upstream HEAD of iptables, nftables and
> dependencies on a fresh Rawhide for running the test suites. I reserve a
> RH-internal Big Endian machine (s390x VM) for it. The goal is to detect
> Big Endian breakers early.

Thanks for explaining.

> Thanks for clarifying!

OK, then, all good, it is a matter of waiting for the kernel fix to
propagate to the rawhide kernel tree.

Ping back if problem persists by then, thanks.
