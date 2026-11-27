Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770361;
	b=xVg9OnvCZcb1KOF9xs+GOKqShuFyRMycsmzJtPEjY4VdH570UV6m9tnwuKrvzVDaFiij
	 BXASS+du0Qk427QbUXEditd8gto0vMNk0GgaLKR2jp88TvAjyyPj/FQrW1IO/TkNWlndd
	 queUF7GcR/Bcoz78cxPBtiHuk1+EiXJkDqsw2jqWn8UfiBjmpp+LwDcR87bJ8iGpGzslE
	 TnJ1x/MR6zaMFOjD7Dikz9kRL2h3x76hlSZCXYwHLDX4TK0lVDUPzADzBBZJyd8Gt+yC2
	 oNZWcJYgr20YTRBqSC93kBtvnKAWqC/f918CPw6yQl5d7/7D/TXVVMwOj6D+tX5G2Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770361;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5OxHZAjKmppOAEa0qC/t014Mvi9vslycSUH7py9ELfA=;
	b=LsV/Nsl5SkEVX6Y5p8c0V89bzsUhW8+fp3X5oCN0bj01yiXHop+hiMc74ez/VpKMk1Fz
	 wrRrDlAIDmxe2plRW1g3j6DjP/iWJNSryQJfNTWs7ZNSfRpNMU3j3EYb9ewAYirIs0JDB
	 M2xAwUyUBXYq/8wvQnLcjaJe7SVHprNP1N6Pt2HvpIsQo79nVFtqtlcwg+5VvsUK7pHwo
	 r6uoGvKVZLPYVySMVAGq/YelCQSSQaYjevcG4XdGh+quAV7O4ymRBsmXyUAB88dCZwyPn
	 xg9Itysjq1H/dIvFOG9pagSHJl+hkY/83rk/Q9hrs1l6Q5gkxy9RsUW1Pn+1wqyJypQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F177F606A333
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2026 09:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F177F606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5AB0A602A9; Fri, 27 Nov 2026 10:05:51 +0100 (CET)
Date: Fri, 27 Nov 2026 10:05:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Jack Satu Rumah Net <Jack@saturumah.net>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf] netfilter: xt_nat: drop packet when conntrack is
 missing or invalid
Message-ID: <awlH7zpDVGHdlDv7@strlen.de>
References: <CALZdHNroZj41WOBd9g4+csZ91h_yEzHP496Sm_esQypv-mztVA@mail.gmail.com>
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
In-Reply-To: <CALZdHNroZj41WOBd9g4+csZ91h_yEzHP496Sm_esQypv-mztVA@mail.gmail.com>

Jack Satu Rumah Net <Jack@saturumah.net> wrote:
> Hello Netfilter maintainers,
> 
> When an SNAT or DNAT target in net/netfilter/xt_nat.c processes a packet
> where nf_ct_get() returns NULL or ctinfo is outside the allowed states,
> WARN_ON() only logs a warning and still calls nf_nat_setup_info(),
> resulting in a NULL pointer dereference in nf_ct_net(ct).

> Drop the packet with NF_DROP after WARN_ON_ONCE() when conntrack is
> missing or ctinfo does not match the target's allowed states across
> SNAT and DNAT targets (v0, v1, v2).
> 
> Signed-off-by: Jack Satu Rumah Net <jack@saturumah.net>
> ---
> Observed on Linux v6.12.119 (commit
> e2e4b92c2b2a3ae78423cb343951cb5d2241b405)
> with CONFIG_NF_NAT=y when packets marked NOTRACK in the raw table hit a
> SNAT or DNAT rule.

You need to figure out why and how such packets end up in xt_nat
frontend code.

skb with no conntrack must not ever end up in nat frontend code
to begin with.

nf_nat_inet_fn() returns NF_ACCEPT if ct is NULL, so I have no idea
how what you describe can happen.
