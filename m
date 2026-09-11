Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90EC3176EE;
	Fri, 11 Sep 2026 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789136181; cv=none; b=T/NPYJUbAV+3pZ/3HDGpOzGIWOZ1PBGuE+MERSeYimtaRQw9HzRgHZl6mP1Cti40WuQLHgYbG4JZraezGrjqcejXzQKPJtXJp//v6rgOLFT9CV6ZaoK7ZBH9rqzdGkBye1+u3ghUUtL5juqZtDeB8dbkFyuXeIRCgEj8lfoR49w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789136181; c=relaxed/simple;
	bh=EYbbpQ3y37CueHq6a/zzfaBp4Zfxr4lAJheNpVlMvc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8yt8554nxLzbNJS9i69xiehcKGQeVEo1U91SgEOAJJ+UY0GBPx8NTV/KtCRbWF6r35nASq9dNWyFKR0g4uld3wprJPZREt04vyEUz+nwClFWbfr4dVegN0Rh4gPZkpaXAOCfMrDPCS78q3qQs8IYSPK6gB5kG4IXCn1qphX6nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ku5QvH3g; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ku5QvH3g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789136177;
	bh=zTB5FaGnMQ9Eajoy9Go/iErsiV2SixZ9YqiLKCvyUGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ku5QvH3gVAX3uEzdSpe3/zK3/5JtfJGwqpq6zXAOTYLVQbsvx4jzXUL25cxOLROWa
	 2FHEfNzk7zzLuAIq/NbkGwtvunFCUh2XjgfXn0DCFJek5K5roqKblGIY8RLaFApm9f
	 +qTs/qDuYSr16EEDwblP5onlCKHSYiAhD6dr50v6SEZ421gAMkxUiszKVx9PuHgboi
	 363PXcfCTLbXnqTgqkWM4xFF50MjXbQSlOgXt6+B4BpzAykjAuKOInIGfCSmsEbcHQ
	 dW7cbU3JaYBNHtamJyKGGW+NcGMkRUGFa0XpzlqJddMyagXTQ8EJMJgsV7Cqy2mKIh
	 f4/i+8hO8BECg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B2FD5603DB;
	Fri, 11 Sep 2026 16:16:17 +0200 (CEST)
Date: Fri, 11 Sep 2026 16:16:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	geldot@protonmail.com
Subject: Re: [PATCH nf-next 0/4] netfilter: offload a TCP flow whose reply is
 never seen
Message-ID: <aqQNL0qIkmFNGANg@chamomile>
References: <20260910090052.2034970-1-julius@bairaktaris.de>
 <aqPpBJvfTwKrxSGG@chamomile>
 <CAC1t37KDNB6+v7Xq51AGrPtYZ4U95kUEQ6HDJSKt5YYE6+0zdA@mail.gmail.com>
 <aqQLqwJVRROZ-cvH@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqQLqwJVRROZ-cvH@chamomile>

On Fri, Sep 11, 2026 at 04:09:51PM +0200, Pablo Neira Ayuso wrote:
> Hi Julius,
> 
> On Fri, Sep 11, 2026 at 12:10:04PM +0000, Julius Bairaktaris wrote:
> > Hi Pablo,
> > 
> > thanks for taking your time to review.
> > 
> > > conntrack needs to see packets in both directions, are you assuming a
> > > packet-based load balancer in front of it?
> > 
> > No, an asymmetric route is in front of it, with two subnets sharing one
> > L2 segment and the server answering over that link, so the router only
> > ever sees one direction.
> 
> I see this requirement to support asymmetric path keeps coming, but
> how hard is really to maintain this TCP state machine to deal with all
> possible scenarios? ie. invalid transitions, retransmissions, etc.
> this all without having access to full TCP connection.  Is it that you
> need NAT and the stateless NAT in nftables does not fulfill your
> requirements?

I can reply myself, you're targetting at offloading this flow via the
flowtable.

Let me take a look what can be done here for this assymetric case.
