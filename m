Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE192E11CF
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 15:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749828649; cv=none; b=hKM0HfKid3gBCTUQ1t6bwTr9SJvoQGOSb9mIo+eOrDH7+/2VtjweKb9tGnmaQbUVZcbPnV0MrLRq37MGoLc2yacP25ecB7BORPeGfsq5racaO6JrDb9G2C/N9IuAeQYIngty3yWkyMwMg55tLaSrtEX95+eywdSY/bdQuxHwv6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749828649; c=relaxed/simple;
	bh=LY8QPgKIaydZacvfNjiHAA5FliuQHzoamw+B20DR66E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sT+aXgDCfrltkNsQUAWVDJ+GAP9+wr9DKbVr/4wTdVO7rlujqqsGHMuy+SPU6bZU2I+JFUFAYaNDUKb95TPDzoH0e8XwNjdJwy2eUEKsazhBWAzTkOIa/fZFLxXAAZZ4roSngYpuG8SuTv33g+r4HJO291vCAoeXgLvMjvTwZxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F2DD761322; Fri, 13 Jun 2025 17:30:45 +0200 (CEST)
Date: Fri, 13 Jun 2025 17:30:45 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Message-ID: <aExEJSKtc4sq1MHf@strlen.de>
References: <20250404152815.LilZda0r@linutronix.de>
 <Z_5335rrIYsyVq6E@calendula>
 <20250613125052.SdD-4SPS@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613125052.SdD-4SPS@linutronix.de>

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> I've been rebasing my trees on top of v6.16-rc1 and noticed that this
> patch remained (because it still applies). My other nf patches were
> dropped because they made it into v6.16-rc1.
> 
> Did something happen to this one?

It had to be dropped due to fallout in net and bpf CI
pipelines.

There are problems with kconfig settings.

A small subset of this patch has been upstreamed
c38eb2973c18 ("netfilter: xtables: support arpt_mark and ipv6 optstrip for iptables-nft only builds").

My plan was to zap some of the backwards-compat kconfig
knobs that we have and update various selftest config files,
then rebase this and retry.
