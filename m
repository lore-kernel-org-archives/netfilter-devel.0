Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979602980BF
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2025 10:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751021903; cv=none; b=ql1qu4aY9/SgXznX1YThNfiwSJi71zE1gfOuiZIXtoh6oDUgAgkpwUnNaTNxTSzVXxK7dSwYOFIIkTnSQuVv+YnK958vCfNZYYZD7Wm9LRetHe8LiohdO2aPmMzts33UDP0l9f+/gY5I7BGhOVPEzROPOQxe5s/MRcEdOk3N7RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751021903; c=relaxed/simple;
	bh=nokczJdNjBeOe5ze5EQmRsffE/70hbbfIGaoQd/8LAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DSvQS/eCGoaNZ8j8EAyZcqrEx6QKA0YI6dblOqbG3S/WhoE901m9N5gy2+3EojCG6bkEeZmZqrkDkgxd3M7FHiIXVHYqHY1CzrZIoWvYph7t2T1U8uKyek42uOUviEoXNB16s9B7+YS/csVz4w7XT3vHH1Pqb/u7gjpwDBOrbmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=imXipUDs; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PYyWBG/0; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="imXipUDs";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PYyWBG/0"
Date: Fri, 27 Jun 2025 12:58:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751021899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMI2XEketbNhS5bh80KpnDXH13ZRLP9sA5GUJ0OzeUE=;
	b=imXipUDsNpAJlJe4Vw/pF7qOQ0XbPAKXOgFnS0NjdXxc3XgcDOVnQyOfFf+KErDu3D9lgu
	+QwUCzYk0nDeXvkvjvdDmGBXIfcrPEI0/btoupKGIX9XsMXvGMRTAI6dJu+dp0DhI3Llhi
	ea7xSywEw0ufqtILKEpDmDpdYxQVpQF4PMD/iscTyI6TsbZTblY2+5iOFRbyIM6tyLSb17
	HOLYVFDomJay3+3Q2GsxYoNI+7YRWpPe79UVJWr82fCFfgLrWt0NpaamjaAJadcioEgYFv
	fj5o6vg/J92nq1Xc2PlUxRNew+ESXfDGlTbxPRwlcpQNJwwXxi9W5f5F9NBbFg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751021899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMI2XEketbNhS5bh80KpnDXH13ZRLP9sA5GUJ0OzeUE=;
	b=PYyWBG/0qp6EM/mKDZi4/LEQ2ovDKiGYpKiNZEWLhKCTcAZdiXuiJwKVcH0+IfFl1b9pAm
	3BvHOvd42SqoLGAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Message-ID: <20250627105818._VVB4weS@linutronix.de>
References: <20250404152815.LilZda0r@linutronix.de>
 <Z_5335rrIYsyVq6E@calendula>
 <20250613125052.SdD-4SPS@linutronix.de>
 <aExEJSKtc4sq1MHf@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aExEJSKtc4sq1MHf@strlen.de>

On 2025-06-13 17:30:45 [+0200], Florian Westphal wrote:
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > I've been rebasing my trees on top of v6.16-rc1 and noticed that this
> > patch remained (because it still applies). My other nf patches were
> > dropped because they made it into v6.16-rc1.
> > 
> > Did something happen to this one?
> 
> It had to be dropped due to fallout in net and bpf CI
> pipelines.

Oh.

> There are problems with kconfig settings.
> 
> A small subset of this patch has been upstreamed
> c38eb2973c18 ("netfilter: xtables: support arpt_mark and ipv6 optstrip for iptables-nft only builds").
> 
> My plan was to zap some of the backwards-compat kconfig
> knobs that we have and update various selftest config files,
> then rebase this and retry.

Anything that I can help with?

Sebastian
