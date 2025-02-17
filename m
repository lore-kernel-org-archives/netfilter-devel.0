Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95068223703
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2025 14:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739804279; cv=none; b=KEmgj3A/I1WYplMLOj1nDWP6TUZ69msdV7iZuZIwJKZHObQBCM7v3EPbFlqVxCySKgQYqyGhqNIiZJ0hbAibb7xVnW0vXMfTy0SFR66dyAWtzGUqKZ3X4f1BVZmd2hwxix0KZ9fUH/cnl+pbk42MKXEJojLyUy083W2G8R+wwUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739804279; c=relaxed/simple;
	bh=CQoQ7W/x5xUXIGMWGgtfnxN7lBnq1WyIA5EEZFD5fj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gcm5SpHTNAoUTD+0RMplCz88pP1MyGJu/aK4GaqddwNuQcVCr9jJtCAh1EDk3liI6JWDuVNtgFXZgAioZfmFfmcAsDygFKgQUOy9CAGkL1B0VCn3Qi6kcm0JxeoJBteTFV6KiAaN7sgjJGYBy04MwX5lOOU8dUA0lxOhHKnswm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=givuhoTB; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=274WEIz9; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="givuhoTB";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="274WEIz9"
Date: Mon, 17 Feb 2025 15:57:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739804275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Prspsn828HLCieeEfRnB5lseubp2+M7gUO9Fvzidqt0=;
	b=givuhoTBzNmwICIQhTGmKHFhbMZp9cpwRl4XyKb0Hh2FcNKAM8bdYSyYkrLvWM71+nc8Cp
	oVQA5D8kojEfJtjim+dYSGUIuSzU6eyu0pKPfjsoPH+DBRR8/yUzNKwmWA3b0OLcHtI0IQ
	SAZFd23QOloGr6JUdQpqEzlOT2mIwuNAtsuNWDZS0XL1TkfmSuwfLFksvNOimrnQ5lITYR
	L8eGQzD6IGu57+YR1Zc50dcmuD9otWMZyRd9c21fnArbBiGqQfaNisdeBUhxahsbPl/UHH
	BwQWPmAVNvAGQHQYkQ2TbzlBN0CaLvhkVx2H4Im5Z2LPd/Lt2b7xLOL4KpoHgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739804275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Prspsn828HLCieeEfRnB5lseubp2+M7gUO9Fvzidqt0=;
	b=274WEIz9EypvFjRv49CktwIomNXBW7uqebOkXHdVQT6vdk91Z+dHGWIjaSlQdvzd6+48VU
	f2tsTmNEoky1fTAA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/3] netfilter: Make xt_table::private RCU
 protected.
Message-ID: <20250217145754.KVUio79e@linutronix.de>
References: <20250216125135.3037967-1-bigeasy@linutronix.de>
 <20250216125135.3037967-2-bigeasy@linutronix.de>
 <20250217140538.GA16351@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250217140538.GA16351@breakpoint.cc>

On 2025-02-17 15:05:38 [+0100], Florian Westphal wrote:
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > The seqcount xt_recseq is used to synchronize the replacement of
> > xt_table::private in xt_replace_table() against all readers such as
> > ipt_do_table(). After the pointer is replaced, xt_register_target()
> > iterates over all per-CPU xt_recseq to ensure that none of CPUs is
> > within the critical section.
> > Once this is done, the old pointer can be examined and deallocated
> > safely.
> >=20
> > This can also be achieved with RCU: Each reader of the private pointer
> > will be with in an RCU read section. The new pointer will be published
> > with rcu_assign_pointer() and synchronize_rcu() is used to wait until
> > each reader left its critical section.
>=20
> Note we had this before and it was reverted in
> d3d40f237480 ("Revert "netfilter: x_tables: Switch synchronization to RCU=
"")
>=20
> I'm not saying its wrong, but I think you need a plan b when the same
> complaints wrt table replace slowdown come in.
>=20
> And unfortunately I can't find a solution for this, unless we keep
> either the existing wait-scheme for counters sake or we accept
> that some counter update might be lost between copy to userland and
> destruction (it would need to use rcu_work or similar, the xt
> target/module destroy callbacks can sleep).

Urgh. Is this fast & frequent update a real-world thing or a benchmark
of some sort? I mean adding rule after rule is possible but=E2=80=A6

I used here synchronize_rcu() and there is also
synchronize_rcu_expedited() but I do hate it. With everything.

What are the counters used in userland for? I've seen that they are
copied but did not understood why.
  iptables-legacy -A INPUT -j ACCEPT
ends up in xt_replace_table() but iptables-nft doesn't. Different
interface, better design? Or I just used legacy and now it is considered
as the only?
I see two invocations on iptables-legacy-restore.

But the question remains: Why copy counters after replacing the rule
set?

Sebastian
