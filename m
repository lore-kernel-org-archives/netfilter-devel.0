Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B46139D12
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 07:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619604; cv=none; b=jDDrWN5Xbpzsqfa1lBq+RP6iGAXmTdFONIVu4DSrE06x79Tk+JphCNtlzkIYqk13RW1t1414GhQTDnz2Y5BfRiiIUtURA+K+TAd/pBlStiye45TeLXyqFOxW51qiNrvjUYs/rxbHjcX3UoB/7VPKyR6qTGYTfp9/N+0TvyJAeOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619604; c=relaxed/simple;
	bh=MDo88ZEzxftErxY15dAxYHE1oXSnRxq2/D+w4toFS4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O+IoytDb3GuvyGpejnE3cQk2T17bLHBjkUmsRUz3fxV5YPJmaINdhFpoJXtqqj6pT0oK8otjkuk3AQIzspxdtD/hMpL/oKeVFfSbnaza6XUkgZLBIhr8jCaOxauFn9Ik1rE3tJ939yx7r6Rg4ZLsI/ESY4aQXkvShOM4isIsAM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=p4tPWHGq; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=wG95ecOX; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="p4tPWHGq";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="wG95ecOX"
Date: Wed, 14 Aug 2024 09:13:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1723619599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MDo88ZEzxftErxY15dAxYHE1oXSnRxq2/D+w4toFS4g=;
	b=p4tPWHGqLHe2HlqORmsx7PzdZVfjfLPrO3WAUUyZxJJgYHz2UvLcjJkaI59b/kbZdCxIVu
	3w6HbgGiuacn1OEueYst81R1jcyy4Fq5CmDDG56OwRpZWYaDvK8uV5/hQQ2St7CwLUmp9/
	rHQ4qRuzuFn3chvOaTTb607kCKjaa5m4nr2qlz5KEFfgHHhnvX1J+62Nz4ZVCCGlGokVY4
	1GOD0XaKweG9/bR7PRD8xViiOOISn4ew3wfzzSGOcbIjjEnmUG1ZjtN829GH+krGHRstbR
	ihLZNmY2gq3PrsA+4N4DMqkkbkXpUWFpGyTxEavwLG5mg5SpMoJxdhNPFH7T1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1723619599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MDo88ZEzxftErxY15dAxYHE1oXSnRxq2/D+w4toFS4g=;
	b=wG95ecOXYcVVGx/j/xywS6rj9kMp1Rw3a4dtW1q4uVCY75j7Yes6pr6Sb7Mm7P0OryIriB
	pdX3NqLlQBdpqiDw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [netfilter-core] [Q] The usage of xt_recseq.
Message-ID: <20240814071317.YbKDH7yA@linutronix.de>
References: <20240813140121.QvV8fMbm@linutronix.de>
 <20240813143719.GA5147@breakpoint.cc>
 <20240813152810.iBu4Tg20@linutronix.de>
 <20240813183202.GA13864@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240813183202.GA13864@breakpoint.cc>

On 2024-08-13 20:32:02 [+0200], Florian Westphal wrote:
> Or, just tag the x_tables traversers as incompatible with
> CONFIG_PREEMPT_RT in Kconfig...

After reading all this I am kind of leaning in for the Kconfig option
because it is legacy code. Do you have any schedule for removal? There
is nft and there is an iptables wrapper for it. It is around in Debian
since Buster/ 2019 and only because it wasn't packaged in the previous
releases.

Sebastian
