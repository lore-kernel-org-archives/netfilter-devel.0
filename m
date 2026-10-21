Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792590018;
	b=Wwenp2lceYAz6tufG4SH40CyEbFa2PmoLUWD+cKQAgjo0F5eKC0fbSjm6skoDV3g1ZNI
	 4xqFEQ+sy1zPmvW5jB9zxDHjlVWbhQ20Yctmrm9ceBnSwA537VoCqXlRhWYDULkXL2rg0
	 4mikk02YM5CWD/ZUOXyAFI86uKNWYKfsbmm+cHeg/JioepvDETb3fXWgYLQJXhp9y/hnm
	 eBI8wEd9WHTnVmRw5Vq3/vIYod8FakIDkZcxCtIqyDKNfQrolThel9sQCbLD1g2PUsL5G
	 xh9XbAmnwVEpM3UFZfJAsyIVT3BiunLK7Vbodw/vOfYEOwaUcTLSlAiRWXniCTiMHpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590018;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=wV4Mg/OIuGgv1aLTrJYkMSaSo9zuF3rlNySQS1pt5Ew=;
	b=l5tKjxF5oYRP6w0ruG3npkhC6fAnYYoK6sQNqU56xvn61QIj34UTSiAvVtsMGH5J2UGu
	 zgu2X3F4QEOBTapKX28BsFF8A+6ddJbgwJoQAXfd2AAVrcJxC9q54bwDra1ESrO9lJ5Az
	 GL3V1EBl8okBZfXSJRV6Mm6a7gTpKTNIoas86gJIZxxKYG2QTCUkyeuewleSlrFrYiyBo
	 ZoiuX45ayn92vXr3cygDt+JQuWQy5lddOlAZuZvRxZ9cgcfZX+8wueaaqGnZ5HHo5B+X3
	 RioUUu3g4vaEC5ZVsvaNhOI5KJV4DFTG7CbziwNsYIiWJTEfOFFOt0D5jJBEvNUhpHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b="iQ/1TOi7";
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B0B606A31E
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 13:40:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74B0B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=iQ/1TOi7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wV4Mg/OIuGgv1aLTrJYkMSaSo9zuF3rlNySQS1pt5Ew=; b=iQ/1TOi7/zCtmWZGms6CSbUXQc
	0iZCv9xGra64p7p8l7/TkG6fAlbElkv3tPSBDTgqF4s7bP2LGNrTKk/u1E1NATBstDDMlQbtQkeUW
	0fTmmdugcw3dBdMjgNwSqdgVAx3BAXiHa/Xe/Vw40AVjZIh9LvFv1flXUJJJhDnp5YKZ2vb2DYYww
	dGv2EAIGwmMPvzlknbISOPVAXL9oWM3OuAwzTMLCiGWe4J9YdGys5G9gDfA7+Hv7/mTz0jspSLQBj
	cmZ3gS8oZVX/zPNhfhQjNh7AZwUsL1Z2G3o0l0Bee/1X3Au19TPvdEWfzHm7j1kQ/tGC77JJodAC/
	b6mDph/w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xJWYA-0000000048v-2z8W;
	Wed, 21 Oct 2026 15:40:14 +0200
Date: Wed, 21 Oct 2026 15:40:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Balazs Gulacsi <m2gulbal@gmail.com>
Subject: Re: [iptables PATCH] extensions: libxt_conntrack: Fail on
 untranslatable state match
Message-ID: <atjAvjdZTYiqalTz@orbyte.nwl.cc>
References: <20261008182605.257290-1-phil@nwl.cc>
 <atiRNbVh-1ELNyDX@orbyte.nwl.cc>
 <atiUbF-5aXoKdpJk@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atiUbF-5aXoKdpJk@chamomile>

Hi Pablo,

On Wed, Oct 21, 2026 at 12:31:08PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 21, 2026 at 12:17:25PM +0200, Phil Sutter wrote:
> > On Thu, Oct 08, 2026 at 08:23:51PM +0200, Phil Sutter wrote:
> > > Iptables' conntrack match supports combined matching on ct->state bits
> > > as well as the NAT bits in ct->status. The kernel extension matches if
> > > any of the bits is set, i.e. '-m conntrack --ctstate NEW,DNAT' matches
> > > packets in either NEW state or DNAT status or both. Therefore,
> > > translating this sample match into 'ct status dnat ct state new' is
> > > wrong: The nftables rule matches only if both statements match.
> > > 
> > > The only way to achieve this in nftables seems to be by duplicating the
> > > rule which is not feasible within the xlate infrastructure. So instead
> > > just abort the translation.
> > > 
> > > This is a partial revert of commit 1a13277f88099 ("extensions:
> > > libxt_conntrack: Fix for ignored ctstates in translation") which turned
> > > an incomplete translation into an incorrect one.
> > > 
> > > Cc: Balazs Gulacsi <m2gulbal@gmail.com>
> > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1826
> > > Fixes: 26ec09bf6b9b6 ("extensions: libxt_conntrack: provide translation for DNAT and SNAT --ctstate")
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > 
> > Patch applied.
> 
> Thanks.
> 
> I wonder if it is worth filling the gap and expose snat and dnat
> through ct state in nftables.

If it's only for the purpose of providing a translation, I don't think
it's worth the effort. IMO it's just a niche feature of iptables and we
don't know how many people actually use it at all.

> This will take time to propagate before we can expose it via userspace
> (we have here the dilemma of exposing a feature which would be not
> available in old kernel, but it would in newer ones... without having
> an easy way to reject from control plane given the cmp and lookup
> expressions do not have context on the acceptables values.
> 
> Such patch should be relatively small.

I would rather spend the effort on a more fundamental issue in nftables
I found while searching for a fix, namely the lack of an OR operation.
When looking at that ticket for the first time, I assumed a(n anonymous)
helper chain could solve it, but it seems not. To implement an "a OR b"
rule, we would need verdicts which tell the calling chain it should
continue with the next statement or break. Let's try with an example:

chain c {
	jump { a return; b return; drop; } next_match verdict
	next_rule
}

This serves the 'a || b' requirement in that if either a or b (or both)
are true, evaluation continues at next_match. But the failing case does
not work: instead of continuing at next_rule, packet is dropped. Using
'accept' as the final anonymous chain's rule, we jump to the next hook.

Do we have to introduce a new verdict (possibly reactivating an existing
NF_* kernel value)?

Cheers, Phil
