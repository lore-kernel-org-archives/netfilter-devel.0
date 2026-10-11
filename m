Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4433ACF1D
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 22:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756534; cv=none; b=d+kQFQkrLoXxSd+EqnnNLzTWKzpuTxEIGT2vtjgGuFhvi27fBgctXpx/sn3k9vqvQ+HfGahCD7FpBDZNIzdGZ3ijKM8dAkVAABHzeLuqEBd01nmEz+UtFBY77W3bTTcVhf9yOYPs91owItSPJabC2WREplgwCj17+J626wA7gTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756534; c=relaxed/simple;
	bh=i4edLaRSXn9uK6IBkJrGivv0BYiAKK10HCSB/we9C/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNDp6ivFi3cuI81L1ehjvWLe5dN+MZjpayUGQTi2rUHWUGQ4qCC/fwl5bzgWApMcLqilTgyjVEPMAlSIYySrbz3z6PQk7whAfvO3MGlCm8+vWYe1jZEAzrkJMAdJbEX39Wt4sE5bifp6B/xz48P3sg4q1NJqsfbzEYjtxiIu1jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QcroF1JF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QcroF1JF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756531;
	bh=7GajgyjX+9VJozasWeOfLyrwYONphEIjxDF3RNreYrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QcroF1JFFj6UgJZcPVZbyQKBPJ+27BlMKr/Mipr/KLy9OI9pAmm2yag5Uxpxxkw88
	 73x/6rYIzqXORdgEeQ/B4TV17WR5x/ZsgdDbV5LCMfVynnYCwpmXkEakVallIShO8t
	 suGr5hm3Oq7UYmCD9jVsJLmxgh8jmr0QJD/41FFAVtt0snjtm6C2/MXaPTQ0yWplQl
	 qJZna0S1PG5UpOIrlIhDnF1r9o2pDFKlnHDMWEicY8mugPyL43n3kC9HI78lp31JFZ
	 NW8CMmp6eNI0UACKkKNV3Eg3cVL26+AUA6Rg9TtviRxcXaF40r3r/7TSZ3MVfeGjTt
	 oZq8JwMmrnY9A==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0FCB6600B8;
	Mon, 12 Oct 2026 00:08:51 +0200 (CEST)
Date: Mon, 12 Oct 2026 00:08:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
Cc: security@kernel.org, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: Re: [SECURITY] netfilter: nft_limit byte-rate bypass via unchecked
 u64 multiplication
Message-ID: <aswI8NBK6sLj-fdk@chamomile>
References: <CADikNYCzQRErYLwDLoUPrDs8dmuBB8z+45yxKAaps7QTCrLXXA@mail.gmail.com>
 <asu_nz0tXmnsZIFQ@chamomile>
 <CADikNYBiijxQjptcYf-2+omXj8Mf5PTGVwK-Ho53E7JEe_ehvQ@mail.gmail.com>
 <CADikNYA74Zco-PnTvQOih+=A-Hq6ZCV1oyoC+xszGJy756gzMw@mail.gmail.com>
 <asvf-crRnd2ReH9c@strlen.de>
 <CADikNYDzCg46TWPk0dAXQF-Yar+FgEegWEzFZvzCp3x7-k_mOg@mail.gmail.com>
 <CADikNYBZ5MqJWypk5NFYcxYvPKJhKKyJ5iOWN4JTZrUWf1AUAQ@mail.gmail.com>
 <asv7meqLHaULXrYE@chamomile>
 <CADikNYC4P0F7gz4nCxKcJwsAzXEEA-a-8QRu1TE3SUzXvmcuZA@mail.gmail.com>
 <aswDFUpZcFr6jYGL@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aswDFUpZcFr6jYGL@chamomile>

On Sun, Oct 11, 2026 at 11:43:52PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Oct 11, 2026 at 10:27:07PM +0100, SaifAllah benMassaoud wrote:
> > The fact that the kernel does not crash does not, by itself, determine
> > whether a bug is security-relevant ( I mean that a security vulnerability
> > does not have to crash the kernel to be a security issue) .
> > 
> > My PoC demonstrates that the byte-rate limit can be bypassed due to an
> > arithmetic overflow, allowing traffic that should have been rate-limited to
> > pass.
> > I understand that bytes/week is an unusual configuration.
> 
> It is the user itself that configured this esoteric ratelimit...
> 
> > However, nftables accepts it, and the issue is that the kernel
> > incorrectly enforces the resulting rule. If this configuration is
> > not intended to be supported, rejecting it would be a reasonable
> > fix.
> > My question is whether the security implications of the demonstrated
> > rate-limit bypass were evaluated, rather than whether this is a common
> > rate-limit configuration.
> 
> We are busy handling _real_ issues, please stop the bullshit.

Apologies for the blunt, this went a bit far on emphasizing what my
point it when categorizing this bug.

I agree this is a control plane bug. And I agree a much better
behaviour is to reject it upfront via EOVERFLOW too, so user does not
get unexpect behaviour for this corner case configuration.

Let's please just focus on materialising this in a fix patch.

Thanks.
