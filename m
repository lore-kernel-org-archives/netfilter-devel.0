Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A14822D4C4
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2025 08:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866743; cv=none; b=WBoSq4elR08YJzhft5kn0vHikYBe7P3O4+pzAuxmc323ad+p688qh69VZ0tya0Y4XqYUP2oxlCXDnC/XllWk8CvoQfKEonUZgmTNvZYm3C2Fpnhtvu9ftKlW0nDyH5dns5171HVmW3WMFfFGlycJFt2Q79hiNfO/OWX+2jwH0M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866743; c=relaxed/simple;
	bh=UhFNukIPQ+ZvFUQDPrZlbdGxm4zG94NUS7LlT3Y4D0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgHbCjzD2Yly5SwWhMJ6N/ejFy+A+aXeMqv/nJTy1mlTk9m3zZSqxxEATCVc/X24oS1L1sJzrWPZxO41zMEb6TRlGAHLSpzAsZxELsVf/fm1IexGbm6W8I8QE0erYYWI5PBomFV1ElALfVXCxRl48lEYhHfmKhcXKFlk2XFU6BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=zG+ZNjH9; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=P4HDXS9F; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zG+ZNjH9";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="P4HDXS9F"
Date: Tue, 18 Feb 2025 09:18:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739866740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7SDI0CilOwmOjiuN7gjNz218ptWRUk7gqWQM4dMlip4=;
	b=zG+ZNjH9xexKLnR/Ny7pcct4b/6ExNluf4SrmR4s5MGR6RQr2N5s46V2+ssrOz+ThydV8F
	p/oaXb1sUvjnzrSxSL9lO7XqBhYx1cAry/9bWXp/KXUBI6DxkUxgyGAL5EVx+/NpJiTHXQ
	vL0VMULAGCJ2Q+XXtV2QnLZLq2GtG2b49AzGVG55ZIeRHMHal8HmAgJoAXMX4I8I4b1Ts5
	cUh6daDtpPZoAYwrXv0lWn35YuH/v02n7CN9MeCDE6P0JFMb3dM1+h5Y3J5WuXfMUC6eiQ
	2jdOo3lUz3wPpL1UxV5r1UNPk9tADgiYU+Dw1Zqq4uVesf/0geKpAE+98y9CCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739866740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7SDI0CilOwmOjiuN7gjNz218ptWRUk7gqWQM4dMlip4=;
	b=P4HDXS9F8h8nvJjNBlOftopJ0d11LaCEXO+om6FSICtFenSsIdeLidRoOod3jzRYWb03hX
	A9Usn8XRvqkwdgBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/3] netfilter: Make xt_table::private RCU
 protected.
Message-ID: <20250218081859.4tbhN2Wj@linutronix.de>
References: <20250216125135.3037967-1-bigeasy@linutronix.de>
 <20250216125135.3037967-2-bigeasy@linutronix.de>
 <20250217140538.GA16351@breakpoint.cc>
 <20250217145754.KVUio79e@linutronix.de>
 <20250217153548.GB16351@breakpoint.cc>
 <20250217155659.jHVTdebO@linutronix.de>
 <20250217162053.GB14330@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250217162053.GB14330@breakpoint.cc>

On 2025-02-17 17:20:53 [+0100], Florian Westphal wrote:
> > > I think we might get away with losing counters on the update
> > > side, i.e. rcu_update_pointer() so new CPUs won't find the old
> > > binary blob, copy the counters, then defer destruction via rcu_work
> > > or similar and accept that the counters might have marginally
> > > changed after the copy to userland and before last cpu left its
> > > rcu critical section.
> > 
> > I could do that if we want to accelerate it. That is if we don't have
> > the muscle to point people to iptables-nft or iptables-legacy-restore.
> > 
> > Speaking of: Are there plans to remove the legacy interface? This could
> > be used as meet the users ;) But seriously, the nft part is around for
> > quite some time and there is not downside to it.
> 
> Yes, since 6c959fd5e17387201dba3619b2e6af213939a0a7
> the legacy symbol is user visible so next step is to replace
> various "select ...TABLES_LEGACY" with "depends on" clauses.

Okay. So I would repost the series fixing what the bot complained in
2/3. The action in case people complain about slow insertion would be:
- Use iptables-legacy-restore if mass insertion is performance critical.
- Use iptables-nft which does not have this problem.
- If both option don't work, copy the counters immediately risking to
  miss in-flight updates, free the memory after a grace period.

Any objections?

Sebastian
