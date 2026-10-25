Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792906726;
	b=asvBojGPVWNi6RdnXoqY2lKdCwqhGVskrQTqE7mvwSmkgXMUfbQ07AcFkaEPZXQazf0N
	 vZuo1Iwk9U69vNx04HayYlRzq0RNfoSF3sFXJVDms1P2fEgbva3llyK5dFj0TGqALFEAb
	 oUnM/MtFK+eXMzILSKliMoeHSdnASVAstHVPX2jssKTVXV5L2hw00uQRScdGZxjj19cqi
	 FyH4RBV3HLKViqQt3V8wpbuwmuwAfqZSFkzuZzA1R4kf2N5Mkt6d1JjAhv3n/SkI6GSuJ
	 /V66I/LJknF5RrYGlgIPnwsRhMl6fYJTV4uMcidL5ODs4u/N2zwAWP7TL0QG7QUrZTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792906726;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SN6wOZUIlZ///Jc+P20zHJ6bq1VafVf3nqSx9XZrB0k=;
	b=GavnyA3Yx17f5LKjX1PATq5B02gXtnbotjpIb5/qxq5IaCoLik6pI0wI8fbN4FXDpSJ7
	 nieVQfofOCiklc7tsEnksLpoZ5cTyHykOeuhBuh9XCmGy4YVIHhQaLm1rxrBGWgNQJW89
	 Kv67+FTx1Uh4FHLBUKBHOiEuZgNMC6pWdFs2vgHkBtQQjqL/aSaShDrrlqL8M4N6HqNUQ
	 HKE+BIc6vcqu2KSkZfHhCRqavbi3aaYkxKG1m46pWcsRqVxJaEs07N0+xWtrxipDjFsha
	 my2zZu8GzdfOT5AudrT2vMHsNuGcjHHXDn6vD08Pamh6sQN37lOfbXeidLdbCMg5W8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40EF606A31A;
	Sun, 25 Oct 2026 05:38:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F40EF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A01C660796; Sun, 25 Oct 2026 06:38:42 +0100 (CET)
Date: Sun, 25 Oct 2026 06:38:38 +0100
From: Florian Westphal <fw@strlen.de>
To: Joas Antonio dos Santos <joasantonio108@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Weiming Shi <bestswngs@gmail.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: skip transaction elements
 during GC
Message-ID: <at2V3g-B1Ko2x1iK@strlen.de>
References: <179287943591.17355.17353179557993329094@gmail.com>
 <at0vzdlVTF8XAzHj@strlen.de>
 <179288180870.24716.7833838593165388250@gmail.com>
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
In-Reply-To: <179288180870.24716.7833838593165388250@gmail.com>

Joas Antonio dos Santos <joasantonio108@gmail.com> wrote:
> The catch is that the expiration isn't stamped at activation, it's
> stamped when the element is allocated. nft_set_elem_init() does:
> 
> 	nft_set_ext_timeout(ext)->expiration = get_jiffies_64() + expiration;
> 
> and that happens back in the parse phase (nft_add_set_elem), while we're
> still going through the batch. The element only goes active later, in
> nf_tables_commit(), which is also where the gc tstamp is taken
> (nft_net->tstamp = get_jiffies_64()).


Can you name the line in the source code?
I am not seeing it :-(

> So the expiration is really parse_time + timeout, and the commit-time gc
> scan checks it against commit_time. If you add a big batch of elements
> with a short timeout, they get parsed one by one and the commit only
> happens at the very end, so the ones parsed early in the batch have
> already gone past their timeout by the time we reach the commit tstamp.

Thats not supposed to cause a gc?

All the sync gc functions are supposed to check against the reference
timestamp taken at the beginning of the transaction start, in
nf_tables_valid_genid().

They are NOT supposed to check against wall clock time.
Even if transaction takes 5 minutes: the sync gc step should
NOT observe even a single timed out elemenent.

They become stale only AFTER the sync gc step.

tstamp is coming from nft_nat->tstamp, i.e. start of transaction.
e->ext timestamp therefore should never be in the past compared
to that reference time.

1751                 if (__nft_set_elem_expired(&e->ext, tstamp)) {
1752                         if (!nft_trans_gc_space(gc)) {
1753                                 gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
1754                                 if (!gc)

> I confirmed it on an unpatched 7.3-rc6 + KASAN: add 20000 elements with
> "timeout 10ms" to an interval+timeout pipapo set (the parse alone takes
> ~6s) and the set ends up basically empty. pipapo_gc_scan() collected the
> new, not-yet-activated elements during the same commit that added them.

How? I'm not seeing it :-(

> It's the same thing you already fixed for rbtree in 86b6471e690c, the

I thought that was about false zap of rbtree end nodes which doesn't
apply here :-(

> races the grace period just like the rbtree case, but the precondition
> (gc picking up the not-yet-active elements) reproduces every time.

How?

> If it'd help, I can respin v2 with the parse-time vs commit-time
> expiration written out in the commit message, just let me know.

Yes, please explain in detail how time can advance during transaction,
because its supposedly impossible.
