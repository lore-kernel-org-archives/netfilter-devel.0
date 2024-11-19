Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF95F1876
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 22:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732056450; cv=none; b=QrqHPoiHwH6lKVbdX+R3d19KdWa/H1rQVrelx1LHkHnWD/+YnaF15s6smGSnqDPz5JBMByTX6dzJa1k2Uyb24/h9X7bHtgKF6JoyVllz/3+25r1jHieA7YEIOleggkJ1LujJikwXqBhVW4uevL4kgU9DKqjHIF+PvbSdEKLACP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732056450; c=relaxed/simple;
	bh=vuJil+MAtQ21jzHIDehb6Vriq0hXv/GNd1PfPo9rPJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fd4AVTMwuRUNuSlZOeyV6lC51sF7gmCIiA09DplX6erhdws595YqVNVSiQ9DtbTuISVPRBg60tWY1fkSN35kadDbVfXeVasVvYVQBIuRcfz3wWLGB3DyCz2CxyZ/Tfz813+vpdQEZO4PQOUIRf7kEFsHehTo7yoVlhTRfhzVu7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fbrAGrLI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fbrAGrLI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lM6UhHL1ktFcdKyMYkiuOXk/v/fta3/CXupyiiJAsa4=; b=fbrAGrLIqm3N3lX60fG5DVa2al
	Lp2UHY7ocFXqvWZcrTaSiek4fiCVYgB5SzoIz2SLHy3n4tJh0hCkZ0E6oKs4vmEyWcgmLxx3qpqTB
	SAs7a+W79GnJ1aDfcikI5toeDPCs6bJW4eEHErSy0Fy4a60geeZQK6fzVV55tCnFidZ1+3/bYfSNX
	cUZ9jvlcTLr8MPuN9yJVBVVANgAqenNpzx/XpyXJ8IzzvHasIIPW9Vcz3Ms3jkOrZ+OG2341kcgPN
	Xpn99Wmdh/QjLYzB+qstinu8sOySGbpYfjE02STCKSTKxXjsvUv4v9Wx+dE0XTSnpMvXnS6I6Gbm2
	d7l//CzA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tDX0H-000000001v4-0p2I;
	Tue, 19 Nov 2024 23:47:25 +0100
Date: Tue, 19 Nov 2024 23:47:25 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 1/2] nft: fix interface comparisons in `-C`
 commands
Message-ID: <Zz0VfQBXjYEeP_Zo@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org
References: <20241119220325.30700-1-phil@nwl.cc>
 <20241119223410.GB3017153@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119223410.GB3017153@celephais.dreamlands>

On Tue, Nov 19, 2024 at 10:34:10PM +0000, Jeremy Sowden wrote:
> On 2024-11-19, at 23:03:24 +0100, Phil Sutter wrote:
> > From: Jeremy Sowden <jeremy@azazel.net>
> > 
> > Commit 9ccae6397475 ("nft: Leave interface masks alone when parsing from
> > kernel") removed code which explicitly set interface masks to all ones.  The
> > result of this is that they are zero.  However, they are used to mask interfaces
> > in `is_same_interfaces`.  Consequently, the masked values are alway zero, the
> > comparisons are always true, and check commands which ought to fail succeed:
> > 
> >   # iptables -N test
> >   # iptables -A test -i lo \! -o lo -j REJECT
> >   # iptables -v -L test
> >   Chain test (0 references)
> >    pkts bytes target     prot opt in     out     source               destination
> >       0     0 REJECT     all  --  lo     !lo     anywhere             anywhere             reject-with icmp-port-unreachable
> >   # iptables -v -C test -i abcdefgh \! -o abcdefgh -j REJECT
> >   REJECT  all opt -- in lo out !lo  0.0.0.0/0  -> 0.0.0.0/0   reject-with icmp-port-unreachable
> > 
> > Remove the mask parameters from `is_same_interfaces`.  Add a test-case.
> > 
> > Fixes: 9ccae6397475 ("nft: Leave interface masks alone when parsing from kernel")
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v1:
> > - Replace the loop by strncmp() calls.
> 
> LGTM.

Thanks for the quick review, both patches applied!

Cheers, Phil
