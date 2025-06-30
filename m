Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329A528C01E
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2025 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751294762; cv=none; b=VPNKhdbAB7sTH9dhK182eYzOkjKnF+aptGOl6EQy+Iuon0H6TGv9fU2kkJnEE2yRiE2t3sOTxRX9EhvT199sEfOlBuEYcYMl56EEywMPPMQ3qWD9t/+8i4rGB3LIE7eew8KhtgBtQBfWlUrS/F//65sFYGnrc6muG0muwCFecVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751294762; c=relaxed/simple;
	bh=pg9jqC9Z6JSAX3zuHJ2CpMMGLbvpOW9qpw3idaHE9i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxypM94ylRiRrrg5GCsT5ZoaDlbYMsCdZdPw5yEE5KdLahYqlb4m0en4QTuckf7oMo7r9HW8NEYbuCNypNhOJqXLnt9jpNH0P3NjnD4Yy3NQzHZi0xifQ4TxBNZiR/h4MiMVl56BK+ga8fha/yBDIzgdpHqpilcXKqd1zr9wSr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E841960489; Mon, 30 Jun 2025 16:45:57 +0200 (CEST)
Date: Mon, 30 Jun 2025 16:45:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Message-ID: <aGKjJaZBOjpuB6Rw@strlen.de>
References: <20250404152815.LilZda0r@linutronix.de>
 <Z_5335rrIYsyVq6E@calendula>
 <20250613125052.SdD-4SPS@linutronix.de>
 <aExEJSKtc4sq1MHf@strlen.de>
 <20250627105818._VVB4weS@linutronix.de>
 <aF6n762WP1U-sLph@strlen.de>
 <20250630143639.jPnUbTvr@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630143639.jPnUbTvr@linutronix.de>

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
> index c981d2a38ed68..79d5b33966ba1 100644
> --- a/tools/testing/selftests/net/netfilter/config
> +++ b/tools/testing/selftests/net/netfilter/config
> @@ -97,4 +97,4 @@ CONFIG_XFRM_STATISTICS=y
>  CONFIG_NET_PKTGEN=m
>  CONFIG_TUN=m
>  CONFIG_INET_DIAG=m
> -CONFIG_SCTP_DIAG=m
> +CONFIG_INET_SCTP_DIAG=m
> diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
> index db176fe7d0c3f..8e902f7f1a181 100644
> --- a/tools/testing/selftests/tc-testing/config
> +++ b/tools/testing/selftests/tc-testing/config
> @@ -21,6 +21,7 @@ CONFIG_NF_NAT=m
>  CONFIG_NETFILTER_XT_TARGET_LOG=m
>  
>  CONFIG_NET_SCHED=y
> +CONFIG_IP_SET=m
>  
>  #
>  # Queueing/Scheduling
> 
> The CONFIG_SCTP_DIAG switch probably never existed.
> tc-testing asks for NET_EMATCH_IPSET but this one always required
> IP_SET. We can either remove them or fix them as suggested.
> Preferences?

Fix them as suggested.

> > I suspect that it would make sense to split the config tweaks into
> > a distinct patch, however.
> 
> I can split the config tweaks out of it if you want. 

That would be my preference, will also help to root-cause in case
something breaks.

> If we are not making the legacy bits default, because we want to get rid
> of them eventually, and therefore we fix the configs for the testsuite:
> What about those under arch/*/configs?

I don't see many changes to those, so looks like they can be left alone.
