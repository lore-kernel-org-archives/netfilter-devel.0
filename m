Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2B31ABEA5;
	Tue, 18 Feb 2025 12:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739882810; cv=none; b=CicfLggLz2lKyll9n8D7IyFbpRj9G05tfOjGuH8+oK/yXAKtb5TNbfzhT59bjZgNvWbsqPUvA9r4jYaVHpBN8xwjmeYKiGAB6VpNx4hipV09F5BNptl3K899WTQAMOQstd4Sx8UPdSRU8jORkMGQXNki7oxEznoOtqu8AHN6vU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739882810; c=relaxed/simple;
	bh=Ss1FsmBDg411SnOPSDLLM74Y011PBvBROATBKFyJzX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNpKYNTvWs6ETgyH3uGzIn39CV/kCcfcIqWdu2TaAIT/CVfGFvuChWlIoNvUf08wLWCw4BqSjv0lVITmZe7vTepxCMVlyPtTRBjSTYn8TyC1FaHxb0bYp7tDiaKxR3b8jD0doyAuidGVtkRsy8ZMms+Ohi2vBc+YICKFCUw3EMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tkMzq-0007XK-W2; Tue, 18 Feb 2025 13:46:43 +0100
Date: Tue, 18 Feb 2025 13:46:42 +0100
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/3] netfilter: Make xt_table::private RCU
 protected.
Message-ID: <20250218124642.GA28797@breakpoint.cc>
References: <20250216125135.3037967-1-bigeasy@linutronix.de>
 <20250216125135.3037967-2-bigeasy@linutronix.de>
 <20250217140538.GA16351@breakpoint.cc>
 <20250217145754.KVUio79e@linutronix.de>
 <20250217153548.GB16351@breakpoint.cc>
 <20250217155659.jHVTdebO@linutronix.de>
 <20250217162053.GB14330@breakpoint.cc>
 <20250218081859.4tbhN2Wj@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218081859.4tbhN2Wj@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > Yes, since 6c959fd5e17387201dba3619b2e6af213939a0a7
> > the legacy symbol is user visible so next step is to replace
> > various "select ...TABLES_LEGACY" with "depends on" clauses.
> 
> Okay. So I would repost the series fixing what the bot complained in
> 2/3. The action in case people complain about slow insertion would be:
> - Use iptables-legacy-restore if mass insertion is performance critical.
> - Use iptables-nft which does not have this problem.
> - If both option don't work, copy the counters immediately risking to
>   miss in-flight updates, free the memory after a grace period.

Seems like a good plan, thanks Sebastian.

> Any objections?

Not from my side.
