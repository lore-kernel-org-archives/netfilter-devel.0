Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288ED174EF0
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742975246; cv=none; b=qtT/AanL+ubct/phaC6j04dqjel0hggpsu95BA9fGcYiVlu3LiCSFpG6ZO/WVuETMKPgRwkKWQ9Uh7edxET2EWzDBlwbHmjF/U/+mYehQu40eFlvOBCBWQZFEnfQbbjiAoXBooGEAkLUciG87sMOdnmMhqz1lWm4cC8gTVhcEzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742975246; c=relaxed/simple;
	bh=oqAuSfMSrS/28Q2GlIxVDyjqiXyOJkjIwsmu+aBfnw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ls7ZeybewgYlYb8qGmH8MiNW6DWpRNRZJQkg7K+JPu+dFVxnQXcrTyaruUOCKqY2BQh3bmVFz5/3Akz9iM6Ct4/8QDesrm2XFVJWYPVY7h+vCg0X8dBHRNdAJjihBJWfwbG3v9XeW5bvIO+q81hjyCfEo1P+8SwHKo9Yu1nxutk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=hK5zvcZp; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=GV/Mvi4n; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="hK5zvcZp";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GV/Mvi4n"
Date: Wed, 26 Mar 2025 08:47:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742975243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=085+LICjdE/m6qka7IOcxyXwv2893fXbhrLDfmQ7/PU=;
	b=hK5zvcZpEfRsCuXQj8D46bBIwPoVxudFvYDoB0Y4derVKsrxb5wNkFfeXirfq6qBiEXLFN
	0QhdVoCbErmfZF15fgVSzV2tL82XO/7CVm/90Kn5C6zmjqGiDRc5BqkneMxtBb4BF/j02j
	ysLIarpYTpzOuyWChSHXbbKjW2Orrgye+fsfYu9jEDcKnX+WzYgN25D2qSwmEzNuhKY/ov
	hnD76X18QkD5kKGEatzOuTYVNl5GEP219vPZnGDoH+P4+WUO097EUt8PohTCG8Ts5eNOSt
	sUjTre9+dC/stB/+DU0/TOuVkZ4wl5eflqXgjA5qabhGeLDqdz46Vk/s3N3pNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742975243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=085+LICjdE/m6qka7IOcxyXwv2893fXbhrLDfmQ7/PU=;
	b=GV/Mvi4nHM3YtCUFjEht6JHJfPApjrkxS6HF6ImKlmTxLEhwtzeRa/Bw3jAaLunUXzbnSh
	oniODT3+i7HmSvBQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [net-next v3 0/3] Disable LEGACY iptables on PREEMPT_RT
Message-ID: <20250326074721.Y1sIc4Al@linutronix.de>
References: <20250325165832.3110004-1-bigeasy@linutronix.de>
 <20250325194804.GA18860@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250325194804.GA18860@breakpoint.cc>

On 2025-03-25 20:48:04 [+0100], Florian Westphal wrote:
> I applied following diff on top of this series, after that
> ./iptables-test.py -n
> and
> iptables/tests/shell/run-tests.sh
> 
> pass (legacy version fails as expected).
> The change in xt_mark is awkward but its the only place that
> needs it so its not worth to add a new kconfig symbol to avoid ||
> test.

Thank you. I'm going to fold this into 1/3.

Sebastian
