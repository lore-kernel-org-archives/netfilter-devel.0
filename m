Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421F54C98
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 11:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763550152; cv=none; b=qlHRn1RaqlOaot174L/BSB4TSdDEIUYawuRkN40S4u59hr+AhMVlI60lmgNieRF8gcYD4/qNZGbIRDGKw132Jz+fovgdO3Z1GxBlSofpWJAH7BZafU6xcwtcl9SjpqwifY4AlD0ezrrM5KBmUs8NeYYkFAzOQiZHOZ0HRXbZkUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763550152; c=relaxed/simple;
	bh=WXNkgnzLH5RTioRFo83kR553wlCNXy/8HjolfHRkbHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kySyGc5cFg2tBeQ6dLQirqEBxn1kYk0ZzS9z8EkJd4yGyBu0mYz4Lz0yzyJRXXp7phKIfTkgKcEPgV3D8voSlKvMC0EvftBh3lAtY9jqr5hb30t4NPhxtEr1WN3pVCZZ2KzgdSE7XBZ/pTvUy1gxRyVhujMWEm10jMiznB8QZCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=G20E3eYc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="G20E3eYc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=v9CPM97iKxEvS2CDsRutHbIsnPNsTFEZTms/BaQlmtA=; b=G20E3eYcDbnrdzA2fx3HnxSnhx
	jU+MSZzam/FX4tXhb/F6yxaGO8RWMvn/DusLlXcZjwP6UWcVFVE/1LYrilBtM2EUnI/p3aa9xVS1F
	puJyHQA5XWPrCYkNWgsjdbh1sB9ShXaAIfwm3r6NKu73MrOezqVbJhHEfts+HpAIPZfD9dYle2YYj
	nIbZsmxnHMkm9tXujhaCwOhKgw62DHu3zziv0HhlKrPp8J3p0viyl38AesrgMjGuaZzxzNUCBiZPJ
	mVnOAHT0Gss4QWLCnk9wRra6ed8JQpx5ok4HQ93BouehNEOBgT6uL4NLx4RiglhumHZS0UcWkuWc5
	MxjG1Irg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vLfeS-000000005bI-22Oe;
	Wed, 19 Nov 2025 11:43:04 +0100
Date: Wed, 19 Nov 2025 11:43:04 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] xshared: restore legal options for combined `-L
 -Z` commands
Message-ID: <aR2fON8ju2S7Ww7q@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>, Florian Westphal <fw@strlen.de>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20251114210109.1825562-1-jeremy@azazel.net>
 <20251114213718.GB269079@celephais.dreamlands>
 <aRhotOKf6VjOWX2f@strlen.de>
 <20251115125435.GC269079@celephais.dreamlands>
 <aRh7oi9SGQKCfhWP@strlen.de>
 <20251115131551.GD269079@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115131551.GD269079@celephais.dreamlands>

Hi,

On Sat, Nov 15, 2025 at 01:15:51PM +0000, Jeremy Sowden wrote:
> On 2025-11-15, at 14:09:54 +0100, Florian Westphal wrote:
> > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > On 2025-11-15, at 12:49:24 +0100, Florian Westphal wrote:
> > > > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > > > On 2025-11-14, at 21:01:09 +0000, Jeremy Sowden wrote:
> > > > > > Prior to commit 9c09d28102bb ("xshared: Simplify generic_opt_check()"), if
> > > > > > multiple commands were given, options which were legal for any of the commands
> > > > > > were considered legal for all of them.  This allowed one to do things like:
> > > > >
> > > > >	# iptables -n -L -Z chain
> > > >
> > > > Whats wrong with it?
> > > >
> > > > This failed before
> > > > 192c3a6bc18f ("xshared: Accept an option if any given command allows it"), yes.
> > > >
> > > > Is it still broken?  If yes, what isn't working?
> > >
> > > The iptables man-page description of the `-L` command includes the
> > > following:
> > >
> > > 	Please note that it is often used with the -n option, in order
> > > 	to avoid long reverse DNS lookups.  It is legal to specify the
> > > 	-Z (zero) option as well, in which case the chain(s) will be
> > > 	atomically listed and zeroed.
> > >
> > > This works as expected in 1.8.10:
> > >
> > > 	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft --version
> > > 	iptables v1.8.10 (nf_tables)
> > > 	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft -n -L -Z INPUT
> > > 	# Warning: iptables-legacy tables present, use iptables-legacy to see them
> > > 	Chain INPUT (policy ACCEPT)
> > > 	target     prot opt source               destination
> > > 	LIBVIRT_INP  0    --  0.0.0.0/0            0.0.0.0/0
> > >
> > > However, it does not work in 1.8.11:
> > >
> > > 	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft -n -L -Z INPUT
> > > 	iptables v1.8.11 (nf_tables): Illegal option `--numeric' with this command
> > > 	Try `iptables -h' or 'iptables --help' for more information.
> > 
> > But this works in git :-/
> > 
> > So again, what exactly is broken? AFAICS everything works as expected:
> > 
> > iptables/xtables-nft-multi iptables -n -L -v -Z foo
> > Chain foo (1 references)
> >  pkts bytes target     prot opt in     out     source               destination
> >     1    36            all  --  *      *       0.0.0.0/0            0.0.0.0/0
> > Zeroing chain `foo'
> > iptables/xtables-nft-multi iptables -n -L -v -Z foo
> > Chain foo (1 references)
> >  pkts bytes target     prot opt in     out     source               destination
> >     0     0            all  --  *      *       0.0.0.0/0            0.0.0.0/0
> > Zeroing chain `foo'
> 
> Damn it.  You're right.  Obviously, it's already been fixed.  Apologies.
> Been rather unwell this week and clearly I'm still somewhat dim-witted.

Yes, it is fixed by commit 192c3a6bc18f2 ("xshared: Accept an option if
any given command allows it"). Reminds me that we should release
v1.8.12, v1.8.11 is already a year old. There are only 21 commits on top
in HEAD, but I see six Fixes: tags in there.

Cheers, Phil
