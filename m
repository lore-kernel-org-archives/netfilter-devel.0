Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A3D29408;
	Mon, 17 Feb 2025 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739809260; cv=none; b=K7aCwnzMLAI7ftHtAPTnQHaR1z1K8HCEz0BcVgJLr4G4X5nccKpMVkaaoyaU50SN2/qAZ9sCLRIrWPTWZGhl9VazJaCqt9bKvDsAUNlwmu2sw522lFER/osoQ2u+z1qz68ARJF8svSOQ4DnLZpxmM0SBqD7ZZ337BBR/DXfFcLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739809260; c=relaxed/simple;
	bh=llGEfOPym+dFnXc9/hIZGTcNFB5YZ99w0GHnUiH2x4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZzI96BURFDKxoZ/Q3cKxq9zZe9pm6tKjhth1thV0miCpcRvWSO+675PGa4a2Hn1JJc8XhSqaMFUEteBJFsEF89uQ7M4c2/RSbgMpmRiWv0a/rFcdKGhlTVn41GbrE1bO/EhCQJGEaHiXp5fCUNGrx3oGE7+mqvNxS+kSLLBVTnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tk3rZ-0005jh-HL; Mon, 17 Feb 2025 17:20:53 +0100
Date: Mon, 17 Feb 2025 17:20:53 +0100
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/3] netfilter: Make xt_table::private RCU
 protected.
Message-ID: <20250217162053.GB14330@breakpoint.cc>
References: <20250216125135.3037967-1-bigeasy@linutronix.de>
 <20250216125135.3037967-2-bigeasy@linutronix.de>
 <20250217140538.GA16351@breakpoint.cc>
 <20250217145754.KVUio79e@linutronix.de>
 <20250217153548.GB16351@breakpoint.cc>
 <20250217155659.jHVTdebO@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217155659.jHVTdebO@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> On 2025-02-17 16:35:48 [+0100], Florian Westphal wrote:
> > I suspect this is whats used by 'iptables -L -v -Z INPUT'.
> > But I don't know if anyone uses this in practice.
> 
> Oh. Wonderful. So even if skip counter updates after pointer
> replacement, the damage is very limited.

Yes, I think so.

> > I think we might get away with losing counters on the update
> > side, i.e. rcu_update_pointer() so new CPUs won't find the old
> > binary blob, copy the counters, then defer destruction via rcu_work
> > or similar and accept that the counters might have marginally
> > changed after the copy to userland and before last cpu left its
> > rcu critical section.
> 
> I could do that if we want to accelerate it. That is if we don't have
> the muscle to point people to iptables-nft or iptables-legacy-restore.
> 
> Speaking of: Are there plans to remove the legacy interface? This could
> be used as meet the users ;) But seriously, the nft part is around for
> quite some time and there is not downside to it.

Yes, since 6c959fd5e17387201dba3619b2e6af213939a0a7
the legacy symbol is user visible so next step is to replace
various "select ...TABLES_LEGACY" with "depends on" clauses.
