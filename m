Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B512B221269;
	Wed, 20 Aug 2025 16:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755707370; cv=none; b=OsdOE8qSZIKcNfx00CefmwL02gVpqBJWd2OXV/cYE2kpkHxQPILo9/X4UtsSMMxi8IBkBDvKAvUEQtRZWhPVLm34wJlJ8GANYH3p89JbCkeZezXwBJVfFLdpnIIru2nekFosv/Q/cs6hHnwz6EvrXAdLELBiBWLPp4k9ReGjZQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755707370; c=relaxed/simple;
	bh=COn9mcsDGFg+f0lHMt5zj1lrm/7iOJz0HhonwEqLvDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtzAmJMHVSrBkfBdWX5Hzg3XyNMYIddwYI10f2Jy6fifPZeAv49Ja4Mvlm0rylStA5TSzlLf5aY6vkaokcSRoS5aNrlfPjh5fq+l76c4BmECnUs2CE9xvcJqovBmsx2ev3qImqtWJwrEfOs+fSg22l9sOTXhUI2PZGhLp4ESlWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=OizYf1LA; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=nfNpzZMY; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="OizYf1LA";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="nfNpzZMY"
Date: Wed, 20 Aug 2025 18:29:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755707366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/H3RlcCAHv8cvLGqmWe5ecEk30s1LyUE1KoSd075mog=;
	b=OizYf1LA2hm0iLV2o1Jcz4HMWWzsZf/D01uqzutMpbHgneBd1yARWtXsEx3oAF3iAlPOP5
	V1iGRFLe9VouJRI5rqWbqoamsCT3mIXJ1oWxED73E2BzoDWuYR9788WzwvSc0CrLk28UIN
	aQUp2ArjICzTmAcrZgAzotfy3y2QlZwDmlrSkmhQMFeuP5AW2EwJevU+WllpMlws/WlZWQ
	x1LIqH19BnbagLBw4gHQ2YSFMckfNH2Xfs/UDpWDz7QQukSYVOsEWtZSZdT1c8c/jiJXlQ
	ahufQ1ySAv/+Oai0AEvTuPipMLw7NgIIeDyKAR0O/zWHJnJxDfyFkgYF91vcHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755707366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/H3RlcCAHv8cvLGqmWe5ecEk30s1LyUE1KoSd075mog=;
	b=nfNpzZMYT0foJdtx1b53TZzMFikRfT90frieV6ixRRLt2yfNq/2qL4AnQICj6xhxIo7qzU
	Saz8SDAGFEO37ABQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netfilter: nft_set_pipapo: Store real
 pointer, adjust later.
Message-ID: <20250820162925.CWZJJo36@linutronix.de>
References: <20250820144738.24250-1-fw@strlen.de>
 <20250820144738.24250-6-fw@strlen.de>
 <20250820174401.5addbfc1@elisabeth>
 <20250820160114.LI90UJWx@linutronix.de>
 <20250820181536.02e50df6@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250820181536.02e50df6@elisabeth>

On 2025-08-20 18:15:36 [+0200], Stefano Brivio wrote:
> > As far as I remember the alignment code expects that the "hole" at the
> > begin does not exceed a certain size and the lock there exceeds it.
> 
> I think you're right. But again, the alignment itself should be fast,
> that's not what I'm concerned about.

Are we good are do you want me to do the performance check, that you
suggested?

Sebastian
