Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475BF29C327;
	Wed,  5 Aug 2026 19:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957137; cv=none; b=poZLlg4wp6GrGqQSvaqKFuxZPuEQAyOx9e2Dy2NXPagfXEQ7NcnH0BJCzfhghgLda8FluSIRDTnd5bRXW7IeHlDR6L7WfaqIOhTEEncbOWetJNDrDWUqrQO+3vaMu16eXyNUhJRc8F8j3VhBqmKWtRjwK0N/JwmO5xMU1PayWhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957137; c=relaxed/simple;
	bh=wKuHV8hEUnjAAsu1EC0HVYrKPe4bvkiX0Ci+gBd3qKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nnsu3P1Xxxi2rPnpAlZGQx7a0T4PnqOm1CPxyK86Z9h5tsJLwzKsPkKm3IGHFboijH8KkexYhJiTQOM6wZ21AGqYaN8aDhXZOSLMcHwbJbip3UCDoeOd6TASMjp9yUuLuCMmRSmKfg2z/zh7tebHxpuSGrUcj8wSOgpazPKIfVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DEAE360299; Wed, 05 Aug 2026 21:12:05 +0200 (CEST)
Date: Wed, 5 Aug 2026 21:12:03 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net 02/10] netfilter: ebt_nflog: pin the NFLOG backend
Message-ID: <anOLAwgI8uuhLq7m@strlen.de>
References: <20260731151806.849724-3-pablo@netfilter.org>
 <20260805001529.3978646-1-kuba@kernel.org>
 <anNwSVI29j5-FfwJ@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anNwSVI29j5-FfwJ@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >  	info->prefix[EBT_NFLOG_PREFIX_SIZE - 1] = '\0';
> > > -	return 0;
> > > +
> > > +	ret = nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
> > 
> > [Severity: Medium]
> > Should the commit message mention that this can reject rulesets that used
> > to load?  ebt_nflog_tg_check() previously returned 0 unconditionally, so an
> > ebtables nflog rule installed fine and simply logged nothing when
> > loggers[pf][NF_LOG_TYPE_ULOG] was NULL.  Now the raw -ENOENT from
> > nf_logger_find_get() is propagated out through xt_check_target(), so
> > ebtables -A ... --nflog and ebtables-restore fail.  This seems worth
> > spelling out given the Cc: stable.
> > 
> > Also, is the stated parity with xt_NFLOG complete?  NETFILTER_XT_TARGET_NFLOG
> > carries select NETFILTER_NETLINK_LOG in net/netfilter/Kconfig, while
> > BRIDGE_EBT_NFLOG has no select or depends:
> > 
> > net/bridge/netfilter/Kconfig:
> > config BRIDGE_EBT_NFLOG
> > 	tristate "ebt: nflog support"
> > 	help
> > 	  This option enables the nflog watcher, which allows to LOG
> > 	  messages through the netfilter logging API, which can use
> > 	  either the old LOG target, the old ULOG target or nfnetlink_log
> > 	  as backend.
> > 
> > On a kernel with CONFIG_BRIDGE_EBT_NFLOG set and
> > CONFIG_NETFILTER_NETLINK_LOG=n, the request_module() fallback below can
> > never succeed, so the target becomes unusable.  Should a
> > select NETFILTER_NETLINK_LOG be added here?  The help text claiming the
> > watcher can use the old LOG or ULOG targets as backend also no longer
> > matches the code.
> 
> This sounds again like a pre-existing issue in ebt_nflog's Kconfig.

Yes, this is ancient by kernel standards.

> > > +	if (ret != 0 && !par->nft_compat) {
> > > +		request_module("%s", "nfnetlink_log");
> > > +
> > > +		ret = nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
> > > +	}
> > > +
> > > +	return ret;
> > 
> > [Severity: Medium]
> > Who loads nfnetlink_log for the nft_compat case?
> 
> This is again a pre-existing issue that should be handled in a follow
> up, it affects xt_LOG and xt_NFLOG too.

Its not, actually: in ebtables case, user has to do it manually:
rule did load but doesn't work, now rule load would fail.

I think the best fix is to just add
MODULE_SOFTDEP("pre: nfnetlink_log");

like in xt_NFLOG and let modprobe handle it.
I don't think we should bother extending the workarounds for
modprobe we carry in nft_compat for this.

And also add a kconfig dependency to be sure.

And I think it should be done in a different commit.
