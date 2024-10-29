Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0E1A23
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215841; cv=none; b=ZF60jDPkze7E8YEzx7g22/Xbfid5H4+Vq8PDC1BXZzbk5A1YPZaeoCgIAy1pum7OwB4FAWKtud0m3bSVY+wrIqiqvc8U4bKmWIwXZ+25U4+1bsGAcYsUmPk/IA4ERgMuaebWtAqFe0plTcOjHMWGakFVsjIQxitkLZ9vfcy36qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215841; c=relaxed/simple;
	bh=akNzEQvXuScxkploeBH5jAnJq3CIrSSGKmDCgD0yv10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NMa/KYYoSQufMwbhgrsGZ/wkh6EZsFYxkOlYIMYLAq6Yq6khK0HvqTvImTbZxlreOZU4vZobmyE4UnOBWNoWB//ol/bszR/pHxhRauIzA4ZiDNTEVh+iM+l2WAVh+shFwnXXSxVoBcnlqYA80laELHMUGQ9rC5LTMoGOtQH1r6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aMsjEEEa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aMsjEEEa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RVHdLM1zwt1IFqze55CXe7303yoatqZymP7a1YAGAz4=; b=aMsjEEEaEh+Mc+QZ9JTaXfki1x
	xmvkds5WlHcIjKuMrGJzQq95ZXCANrqPdvMNis5nW0scOxI6IyPiwm1ARsnTelZKlcsFqA3TMMKHF
	qDKzFpD8kZm9Yt+CFbHrwAgNIDfcWLSwY4DE3tc1pmL5+olM4ZAoZUJUsOcwUc4yvt/BDKRYg9skf
	hMgnhrKU8XSKH14AxWhCxnd361W1Nb3WkxU07+pE+1AzTk+LQEvlUP2VTSHSGg08Q3cvimTxp2sg+
	RsFF0XGLPNzUyvV3CKQrcR+7pmsm3S402bY1ANnI2BtB7cTiFt4aMpFezviYO/KBNXlyHHHzj+xvA
	0VD3Qn8A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t5oB3-0000000020J-2Nph;
	Tue, 29 Oct 2024 16:30:37 +0100
Date: Tue, 29 Oct 2024 16:30:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH v3] Introduce struct nftnl_str_array
Message-ID: <ZyD_nZQ7J9aXpBCf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20241029131942.15250-1-phil@nwl.cc>
 <ZyDwDD5ISoOZrUY_@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyDwDD5ISoOZrUY_@calendula>

On Tue, Oct 29, 2024 at 03:24:12PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Oct 29, 2024 at 02:16:56PM +0100, Phil Sutter wrote:
> > This data structure holds an array of allocated strings for use in
> > nftnl_chain and nftnl_flowtable structs. For convenience, implement
> > functions to clear, populate and iterate over contents.
> > 
> > While at it, extend chain and flowtable tests to cover these attributes,
> > too.
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v2:
> > - Add also missing include/str_array.h
> > - Drop left-over chunk from src/utils.c
> > - No need to zero sa->array in nftnl_str_array_clear(), sa->len being
> >   zero should sufficiently prevent access
> > ---
> >  include/internal.h         |  1 +
> >  include/str_array.h        | 22 +++++++++
> >  src/Makefile.am            |  1 +
> >  src/chain.c                | 90 ++++++------------------------------
> >  src/flowtable.c            | 94 ++++++--------------------------------
> >  src/str_array.c            | 68 +++++++++++++++++++++++++++
> >  tests/nft-chain-test.c     | 37 ++++++++++++++-
> >  tests/nft-flowtable-test.c | 21 +++++++++
> >  8 files changed, 175 insertions(+), 159 deletions(-)
> >  create mode 100644 include/str_array.h
> >  create mode 100644 src/str_array.c
> 
> One more nitpick: Missing update of include/Makefile.am breaks
> `make distcheck` for libnftnl.

Fixed in v4, thanks for your patience.
