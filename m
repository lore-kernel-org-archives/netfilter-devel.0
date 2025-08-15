Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0352C0F9F
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 15:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755271691; cv=none; b=PqFFS6jvGLzNMeLuTbADg6SDTpcSnGruxK4WSSpgmnBiIbQencU9cu+6j0vG1BfAzdcy/U33Fbvdhs7Q8FQb0jOurbWhMh+5Qg7mp7LZuxehL2brR72igFB/vW1DuUA69PEMLeCyVhUCG53DXBcl5L57N+e1Z4BGneqHitTLkIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755271691; c=relaxed/simple;
	bh=Q43X3ZBJzK2/VU6JQrRZ4dOCybJrQM+cl8AmNQytXK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oLlIx/RXkFHT2uISzGEjGm/LkeSamQlSkIclZ4/TXE2p7k0rw3GVr6lfaI/gMUqP1ufMWqZWWTWocXKZCpqf16ZTwzNM6i1Yr8TPZ311f0h2ZiRp0Q7Xzg1vf9KPfOZfB4S0hcMCxP3PXHOpGIwj44Vtnfyo+vig4HkSSxJsT/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=v53pAsa/; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PFGAERUr; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="v53pAsa/";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PFGAERUr"
Date: Fri, 15 Aug 2025 17:28:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755271688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hahyXfUjU5K3rMWNDn700e8hTZtKcv64tSJoEZYP8vM=;
	b=v53pAsa/mdt13V+hKbxZQ8ukVlOp0mLuI7PE1tyFVrE900UKLo8iH3gZtjjJ8LZPTOqDkP
	IED/Sy4Rcla4YVyi8uS29V6SuGOzC1nD1Q4d1/AUSHc8W33v2qcvsAX11OjHDBJbkBy2cr
	7jDf2mid+vJyS5U+gUX1kl91f7XFdNGjGBLdvnNUsB8aee74B1m5VwOsqrqYy5Au/uNptz
	zSDXZ71nsyF9MxSGlis9Q9qK7lLj6ovFEA6ktf4mzb0cyoiP5lijeDOFfoVgqm+/hxNzoM
	CbNx+BeSyWIg58x0EjlZdOs3TJsZ5DjrQ2rhkO13VtGWJFljIEWqykxqFJTjrw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755271688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hahyXfUjU5K3rMWNDn700e8hTZtKcv64tSJoEZYP8vM=;
	b=PFGAERUrsVIQjOjT28H6wSZ5beZYrT38wNYLQWiJMzZy7aI5iA8/xmzF5wdbq/8+0vMWjb
	AJAh5ztKFRyua+CQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_set_pipapo: Use nested-BH
 locking for nft_pipapo_scratch
Message-ID: <20250815152806.BIcdxBIl@linutronix.de>
References: <20250701221304.3846333-1-bigeasy@linutronix.de>
 <aIKubJyzokB9-_rx@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aIKubJyzokB9-_rx@strlen.de>

On 2025-07-25 00:06:36 [+0200], Florian Westphal wrote:
> 
> Whats your plan here?  This commit is neither in nf-next nor net-next,
> so applying your series breaks the build.
> 
> Which trees do you intend your series to go through?

I just rebased it on top of current -rc1. I'm going to verify vs nf-next
and repost.

Sebastian
