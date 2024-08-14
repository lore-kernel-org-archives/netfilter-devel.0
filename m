Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA831AED24
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723648955; cv=none; b=dBQi8vZZSM0jzFmLVMxJJrw+ygn3hN6yAyY02B8ImNw6CcU9/4g8jloV8dSYygIEWf3wxCeHV5trxhZwIIcKI/3i+bcSXA9tP5hrDoIiOWkj2g26szHMqCwwAPAdU1lpnoOx8sooNMALOG62Nnxx1W5CbnIvDleJVSv/0qBjAno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723648955; c=relaxed/simple;
	bh=0bLX6K1Yi/hvACaklrk8i2CpXCqhYCkw5culB6uHHj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czi41WF6eZCkXI+Eht772vdprrA70vCmqPiXKzaJR5kmTy/Y2hyYsoc3+D4W8WjBj61VNCb0jizH25LPyOadxWDnrDUac5KnK6CegTHeGHxi6tkLJKNk+MN9Fzp7kss1Fz1hSoJh03RO/TL8kQEuxliEIwSZEFNlcllQs3tbZcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vYhCd6cg; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=qMch8WJh; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vYhCd6cg";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="qMch8WJh"
Date: Wed, 14 Aug 2024 17:22:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1723648951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lbN4Lf421wb+j/1osNYciXe0dBjUsPhX0UkchG6F/38=;
	b=vYhCd6cg/9xD981lfF0JdAyvvY0qySTIHJKFlSHFBsfMAcFQUT0MXG+SzE2yjZM/vA3mDm
	2VmpNFs2jI6VZ2JCTAiQyZxDcSU5gUgj7C4VN6stC1JkIH2ZFNFec5VEEagm2cFM7Xq91f
	gPMJ7Ib+8LGrygAtyPGLcA7bFXO3rmjydq6W2AKcjoqXNwDVEv1FBEN7W5HQD2cUH2mIjw
	JFq/WPl2XDK9tK13lrJdJZrOSx0VzrWiD8iDdKTgCQGXrmMpZtI+M6/Fj449SfqoEM92aK
	Xl57kNybDTTT9RSBYOpiTzLsKOgjJg1I7YH6YoX5m6kR9lLr2LU3vld2nxg6+Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1723648951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lbN4Lf421wb+j/1osNYciXe0dBjUsPhX0UkchG6F/38=;
	b=qMch8WJhuaN7jVTvbQ2wKOKetE0QEgDXC5XkM+bbOHRWEX5ddxocLMoS+ZUZ42SZEUulei
	F/m7UP++FxJGSCDQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [netfilter-core] [Q] The usage of xt_recseq.
Message-ID: <20240814152230.9vBVtL04@linutronix.de>
References: <20240813140121.QvV8fMbm@linutronix.de>
 <20240813143719.GA5147@breakpoint.cc>
 <20240813152810.iBu4Tg20@linutronix.de>
 <20240813183202.GA13864@breakpoint.cc>
 <20240814071317.YbKDH7yA@linutronix.de>
 <20240814150919.GA22825@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240814150919.GA22825@breakpoint.cc>

On 2024-08-14 17:09:19 [+0200], Florian Westphal wrote:
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > On 2024-08-13 20:32:02 [+0200], Florian Westphal wrote:
> > > Or, just tag the x_tables traversers as incompatible with
> > > CONFIG_PREEMPT_RT in Kconfig...
> > 
> > After reading all this I am kind of leaning in for the Kconfig option
> > because it is legacy code. Do you have any schedule for removal?
> 
> No.  I added a hidden kconfig symbol to allow for disabling it in
> a9525c7f6219 ("netfilter: xtables: allow xtables-nft only builds")

thank you for the pointer.

> I think we should wait a bit more before exposing the symbol
> in Kconfig to reduce oldconfig breakage chances.
> 
> But I think all pieces are in place to allow for the removal.

Awesome. 

Sebastian
