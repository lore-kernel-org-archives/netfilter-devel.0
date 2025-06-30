Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746B928C013
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2025 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751294205; cv=none; b=td/tq9IZxbbH2aTQ/fEgBQ3CTCkbE5UNdSpLqStofmLBPBYrPawkTHUwiuaRuP4BDtF9flSppIreI5lN7+0gMNIJKcy+l2gAG82MWe/fudclj5TnC4dQ5HDOci63nYii/VEY6Fh6O47nUp5cNtFJ5jU9Opj6U+aLasmnGvN3uK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751294205; c=relaxed/simple;
	bh=bKp+iAnDtMuAkEwdnqhC88SmHY5WAmJ1tAwWPDIKi0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDYRACfNgcJpU05N58Z3gwm68eCDCuqoXv7kFo8Lr2f0AcByesDpKwECw8Euai+9c8l2sycSd9cDJGOmyjWkoxRLGi4iN9qC0ObZl7cmruSO4JgSxPvRW3+krtHd2KHoelnJ5WeUfTycvuCefyS9ZOeQYK7++5i9u6l6PS8AfUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=4getqTxa; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=2rVuTX8j; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="4getqTxa";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2rVuTX8j"
Date: Mon, 30 Jun 2025 16:36:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751294201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yh394vd7Z0rlaQ/ByLkNc+q5VhFigN7GVnvsD7GhivA=;
	b=4getqTxaDcuoizdNpqv6dAAHYhm3hm3D/v5/W4vrzYdVqsmwBFTXw3rGVXK61uCSuDkv/x
	h/l3ICrglKGnFVHiIuWGmiBQSLXz3DOzS/1y/O4maNhJOvIJoFIK8HicR5+JOvhik7SIjR
	dQuIhk5WRm0QQB3CVDMhlEtFy9SB1e/yFLfGaEEJjmw9jH2cyh7PQ0BjXlW41j74Kbgilw
	HEdtXU02LnHtUV5bP8InYVxiHGN+VSUpCY5LiMbgizCsazGZq/+ZhaXYqyNDdcyDUDoVkl
	N8DFrtnrgZp/8fY4PxzyJUkpclBwqUXuj0jnryaNNHLyqGX01b0qnAgtCZT4/w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751294201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yh394vd7Z0rlaQ/ByLkNc+q5VhFigN7GVnvsD7GhivA=;
	b=2rVuTX8j5E1soka6mhsXzzjnk5uiG48+ZSskV9aqIWnFmAdyEfFQ3dRQLAqzMSy8yjAv5U
	OexB1eKYuu1psRAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Message-ID: <20250630143639.jPnUbTvr@linutronix.de>
References: <20250404152815.LilZda0r@linutronix.de>
 <Z_5335rrIYsyVq6E@calendula>
 <20250613125052.SdD-4SPS@linutronix.de>
 <aExEJSKtc4sq1MHf@strlen.de>
 <20250627105818._VVB4weS@linutronix.de>
 <aF6n762WP1U-sLph@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aF6n762WP1U-sLph@strlen.de>

On 2025-06-27 16:17:19 [+0200], Florian Westphal wrote:
> So some of the problems with CI pipelines are caused by 'config'
> settings having something like:
> 
> IP_NF_TARGET_TTL=m
> 
> ... but if you look at net/ipv4/netfilter/Kconfig this is:
> config IP_NF_TARGET_TTL
>         tristate '"TTL" target support'
>         depends on NETFILTER_ADVANCED && IP_NF_MANGLE
>         select NETFILTER_XT_TARGET_HL
>         help
>         This is a backwards-compatible option for the user's convenience
>         (e.g. when running oldconfig). It selects
>         CONFIG_NETFILTER_XT_TARGET_HL.
> 
> ... and that doesn't do anything anymore due to IP_NF_MANGLE dependency
> (thats a legacy thing, so it will be off).
> 
> So my plan was to zap those old backwards hints first and update
> the configs to make sure none of the old symbols remain.
Oh.

> OTOH one could just add the correct config settings.
> 
> I need to re-test but the attached updated patch should not omit any
> of the required features even with legacy=n at least for the net ci.

I tested the defconfig + the individual config file from
tools/testing/selftests/ and compared the results from -rc4 vs -rc4 and
the patch. Additionally checked defconfig + kselftest-merge.

I don't see any "missing" options which are NF related with this patch
now.

Two options were always missing:

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index c981d2a38ed68..79d5b33966ba1 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -97,4 +97,4 @@ CONFIG_XFRM_STATISTICS=y
 CONFIG_NET_PKTGEN=m
 CONFIG_TUN=m
 CONFIG_INET_DIAG=m
-CONFIG_SCTP_DIAG=m
+CONFIG_INET_SCTP_DIAG=m
diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index db176fe7d0c3f..8e902f7f1a181 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -21,6 +21,7 @@ CONFIG_NF_NAT=m
 CONFIG_NETFILTER_XT_TARGET_LOG=m
 
 CONFIG_NET_SCHED=y
+CONFIG_IP_SET=m
 
 #
 # Queueing/Scheduling

The CONFIG_SCTP_DIAG switch probably never existed.
tc-testing asks for NET_EMATCH_IPSET but this one always required
IP_SET. We can either remove them or fix them as suggested.
Preferences?

> I suspect that it would make sense to split the config tweaks into
> a distinct patch, however.

I can split the config tweaks out of it if you want. 

> If you have cycles please feel free to work on it, I can most likey
> not get back to it until 2nd week of July.

If we are not making the legacy bits default, because we want to get rid
of them eventually, and therefore we fix the configs for the testsuite:
What about those under arch/*/configs?

Sebastian
