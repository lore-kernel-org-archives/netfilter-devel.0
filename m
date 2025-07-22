Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B192BEFE8
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 08:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753173237; cv=none; b=n2+r05b3S33TT1J/9p2RzmbrSZNPufX90/zZuwn62WO8rCp9crc9MO38mQIPkgp5fYFxVSzcI8rNRZVWb9PVjRW1Db6xOHYw9v8/KaJM2gX/IiRahcaTv8/v6nwcNRR361ZNzxAHIvseqE+EqRs+iychNDv9xLY8pbAzAx0kq6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753173237; c=relaxed/simple;
	bh=VaIEUhMCpRlIbrfL3plmNT5knn5PotSBfbSU5PBli7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A5qMfpZs3AgEMLfsiQXwW/Xruoo8Ti7S0VN9vcwXfEjzIm29FU6izj4wRB6muWfF89dtJGU5REwe+Zyn2f1N+r1cgL1QC0sq6lAD6tPhjND8HLD2ctDUMN5WmKFh4pWdLHU28CqV5IEF16HiNZGi5ABv2z6iweZy2llWi6aNYwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EBiYa7Gm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EBiYa7Gm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P+Slz6tAaAIBiMBzoNpEz3+0lPyrw8slDUK19dRqckA=; b=EBiYa7GmGpY71mcQc5fn0AqCx5
	kXI0T6kauhP49PKz6zOAzFXK9f6vOIvzYRZcwKQgi3Tp2Io6eC6x5M+aLET1m9+V33vXUyr9+VaDz
	D0UFpDrp7VjhZAwCyRtaH4NsqkRo03UoGx4QPVSSNOB6+wqXdE4T55ArleosaPctm/PcixG747Az6
	ig52LN0S5kb6nJFnZ07x9ztx18WomLkSMWmM9aoyBPf13/8CBxB4atgU3Wo0lxqGzrCRyJCI8Iswg
	nufpzYQiLcpyneKeVhLM3WnvPXIusRol3DcpdAsgouY7LrwU4ylfa7t2C2u7KHG06UHsOJEAEJLWt
	t+d3rExw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ue8RW-000000006W6-3U1Q;
	Tue, 22 Jul 2025 10:33:46 +0200
Date: Tue, 22 Jul 2025 10:33:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, shankerwangmiao@gmail.com,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables v2] extensions: libebt_redirect: prevent
 translation
Message-ID: <aH9M6kWerwHmVvGP@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, shankerwangmiao@gmail.com,
	netfilter-devel@vger.kernel.org
References: <20250717-xlat-ebt-redir-v2-1-74fe39757369@gmail.com>
 <aHjmETYGg4UtDdSf@lemonverbena>
 <aHjrV-YUot_fKToY@orbyte.nwl.cc>
 <aHu4moCviA27DpXO@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHu4moCviA27DpXO@strlen.de>

On Sat, Jul 19, 2025 at 05:24:10PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect
> > > nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef \
> > >         counter meta pkttype set host ether daddr set meta ibrhwdr accept'
> > 
> > Now in broute table, ebt_redirect.ko sets the ether daddr of the packet
> > to that of the incoming interface, i.e. the bridge port not the bridge
> > itself. We'll need an extension for that, too right?
> 
> Yes, but i don't think the broute feature is that relevant given the lack
> of requests for support in nftables.  Most want to make the packet
> enter the bridge input path and not pretend that the bridge didn't exist
> in the first place.
> 
> > I guess just
> > calling 'redirect' verdict will manipulate the IP header as well which
> > we don't want
> 
> Can you point me to the code that alters the IP header?  I can't find
> anything.

I guess this is a misunderstanding, but continuing along the lines:
xt_REDIRECT.ko calls nf_nat_redirect() for incoming packets passing the
incoming interface's IP address as 'newdst' parameter. I assume
conntrack then executes, no?

Cheers, Phil
