Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27FA1E49F
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Nov 2025 13:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763212199; cv=none; b=iqQ46iaKcnpfHf3iyzqRPyaYGXsI9V8e349CP5HLxCuVe7SvNXCaD9xdSm2e9fruZ8pHfT/hrJxhG0HMJw/tEI2JG073izy7u8QN2h+/PSsX1gcVZRo6WAECxWkP1qhG7U4DYP93xvOQ4BqYCsiryf2yO1Wgu2rtLLIRQSS7cBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763212199; c=relaxed/simple;
	bh=TzPN2VeBEf4cGz/fiMgEjGZAAtIjZUXUiKUshi6Qfkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrZL6KXJfwLKP++P/Nrf2yvNXdhqVzVaur0cZpE+fXVrPwjcsfsquLPfUIqvNV13TEbZmIQX59StKL/8iQFaRT5EhlFXuiZibrzzwicDN/y9xs0zG1j09iPwnTrlh0ZOdcAGbfyh/xS78GZxce1rh3T4rtzj/KZuOPnnd9foFt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 986DE60325; Sat, 15 Nov 2025 14:09:54 +0100 (CET)
Date: Sat, 15 Nov 2025 14:09:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] xshared: restore legal options for combined `-L
 -Z` commands
Message-ID: <aRh7oi9SGQKCfhWP@strlen.de>
References: <20251114210109.1825562-1-jeremy@azazel.net>
 <20251114213718.GB269079@celephais.dreamlands>
 <aRhotOKf6VjOWX2f@strlen.de>
 <20251115125435.GC269079@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115125435.GC269079@celephais.dreamlands>

Jeremy Sowden <jeremy@azazel.net> wrote:
> On 2025-11-15, at 12:49:24 +0100, Florian Westphal wrote:
> > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > On 2025-11-14, at 21:01:09 +0000, Jeremy Sowden wrote:
> > > > Prior to commit 9c09d28102bb ("xshared: Simplify generic_opt_check()"), if
> > > > multiple commands were given, options which were legal for any of the commands
> > > > were considered legal for all of them.  This allowed one to do things like:
> > >
> > >	# iptables -n -L -Z chain
> > 
> > Whats wrong with it?
> > 
> > This failed before
> > 192c3a6bc18f ("xshared: Accept an option if any given command allows it"), yes.
> > 
> > Is it still broken?  If yes, what isn't working?
> 
> The iptables man-page description of the `-L` command includes the
> following:
> 
> 	Please note that it is often used with the -n option, in order
> 	to avoid long reverse DNS lookups.  It is legal to specify the
> 	-Z (zero) option as well, in which case the chain(s) will be
> 	atomically listed and zeroed.
> 
> This works as expected in 1.8.10:
> 
> 	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft --version
> 	iptables v1.8.10 (nf_tables)
> 	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft -n -L -Z INPUT
> 	# Warning: iptables-legacy tables present, use iptables-legacy to see them
> 	Chain INPUT (policy ACCEPT)
> 	target     prot opt source               destination
> 	LIBVIRT_INP  0    --  0.0.0.0/0            0.0.0.0/0
> 
> However, it does not work in 1.8.11:
> 
> 	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft -n -L -Z INPUT
> 	iptables v1.8.11 (nf_tables): Illegal option `--numeric' with this command
> 	Try `iptables -h' or 'iptables --help' for more information.

But this works in git :-/

So again, what exactly is broken? AFAICS everything works as expected:

iptables/xtables-nft-multi iptables -n -L -v -Z foo
Chain foo (1 references)
 pkts bytes target     prot opt in     out     source               destination
    1    36            all  --  *      *       0.0.0.0/0            0.0.0.0/0
Zeroing chain `foo'
iptables/xtables-nft-multi iptables -n -L -v -Z foo
Chain foo (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0            all  --  *      *       0.0.0.0/0            0.0.0.0/0
Zeroing chain `foo'
