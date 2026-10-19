Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30045493635;
	Mon, 19 Oct 2026 09:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792401125; cv=none; b=F8Xi0tXBHqKl1BLISIS8z6JmhmHJUQdj0IlLv/8BDaLiZuUwA9dFyMkynnVXY6PmFw/MDoT/kTYmDxSEsX0kZEHRhDeAaXRHl6Y5Z81Kn7LwBLRmRl5VJ2fvTpXqYeLSADigkt8a7mx7VvUdd4nP49QD3w6Lqq+HUfJ0BqqFM30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792401125; c=relaxed/simple;
	bh=05P3N1/O3Mh+BZT3a1VwQynUd5tcNA84Z+9ixTM8d8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHOuFQOmz5qpQR7mfUoeXL17FIKN6HFKMHgWrD2TIQx3LPGcfMtRNa9zzZYoMz3WPMW+TwJUdCCtCEr1E5fgqasE8ZZoMou5fr2pcmK2fy00Q5pT7BsUQ2H3sl3zqFjjwiIrnaA6f/zmDaaVJqIFrGI62ugjj9C3OIa9ha7ai/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ISJaS88P; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ISJaS88P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792401122;
	bh=qpB7o/ErM9PPW/v99I7HqjsRQo7rsG9qrHmSNPoLSJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ISJaS88PjBH4+cvmk4Z7aarxmFuSToDCldb9v+Z46YW8fdtyjblfayY4/5KdfZwXo
	 aXE09QzcXjdJprR3m2TT683efiEeBROPLZ9VWYROwAcb3wIgdWRdu3rMKTPGTTVYWP
	 a97iqyOCT0LVoKAWGK9yNQWSYWcTWwMjsUH8G15aLHO2FikuRtszPzsmH9e2c2YNAK
	 3mRN4QL8Q4x3UKvJqkC+bqbwJw3DQ881PGcvK7s7+r7JtMycofyWRL44r/N7Q52ofW
	 IE/1rH3cp/NR4m3adAw9eMiiw7kJzrEzlxkt9ycsNdF62+MisL8NCC1M6sb4wJ1Ygc
	 0njjU8Og9MslA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1356360057;
	Mon, 19 Oct 2026 11:12:02 +0200 (CEST)
Date: Mon, 19 Oct 2026 11:11:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 12/15] netfilter: flowtable: set inner protocol
 when popping tunnel header
Message-ID: <atXe37WHV1gw5hkA@chamomile>
References: <20261018005638.1776148-13-pablo@netfilter.org>
 <179237288830.3135.1355021906814917621@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179237288830.3135.1355021906814917621@kernel.org>

On Mon, Oct 19, 2026 at 01:21:28AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] The commit message says the patch makes nf_flow_ip_tunnel_pop()
>   pop the outer header and set skb->protocol "instead of bailing out…
> 
> Pre-existing issues:
> - [Medium] This problem wasn't introduced by this patch, but
>   nf_flow_ip_tunnel_pop() strips the outer tunnel header with plain…
> 
> --
> 
> netfilter: flowtable: set inner protocol when popping tunnel header
> 
> This commit makes nf_flow_ip_tunnel_pop() set skb->protocol from
> ctx->tun.inner_proto after it pulls the outer tunnel header. The commit
> message calls it a preliminary patch for IPv4 over IPv6 and SIT tunnel
> flowtable offload.
> 
> > Pop the outer tunnel header and set skb->protocol to the inner protocol
> > derived from ctx->tun.inner_proto in nf_flow_ip_tunnel_pop(), instead of
> > bailing out unless the tunnel carries IP-in-IP or IPv6-in-IPv6.
> 
> [Severity: Low]
> Is this description accurate?

I think description is good enough, this is pedantic.
