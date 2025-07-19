Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8049328689B
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Jul 2025 15:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752938663; cv=none; b=pDShXQQNyQrFojT0aia4ne1Cf40q01FUyi8yD4vg8jKY7T9k3R5NHe6q6v/PgujTWAT+8goRbRnp+Iuj9Hdh8KXIHMJVF/DS3VcCpxu9uzy/Gmp5foBkqpIXnseDi1s+2fFw+iNy1w9GWdZmdB1VGjz6PspK5g1LY4yPNpiN5wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752938663; c=relaxed/simple;
	bh=eGCKScYok8gpe23cRP9fizAm2myiF6KtyX1+vXbURNM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dAQ7ioKWFslhCXE717Rp2bIZD29uMN7Jh1fxpdMp+g6oa2JUtg9ckIhwnjQeA0WBpky/7bdr3378AA2LuWeCph8+vhtMin/SpGX+lu9+LaqI2HIsdGvictyDGSgwcD2Gg9WCapRXFKgm66BxvmVUK4Tm3HwlRMjvXvBJTY7dYOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3EBFF60491; Sat, 19 Jul 2025 17:24:11 +0200 (CEST)
Date: Sat, 19 Jul 2025 17:24:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	shankerwangmiao@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables v2] extensions: libebt_redirect: prevent
 translation
Message-ID: <aHu4moCviA27DpXO@strlen.de>
References: <20250717-xlat-ebt-redir-v2-1-74fe39757369@gmail.com>
 <aHjmETYGg4UtDdSf@lemonverbena>
 <aHjrV-YUot_fKToY@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHjrV-YUot_fKToY@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> > ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect
> > nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef \
> >         counter meta pkttype set host ether daddr set meta ibrhwdr accept'
> 
> Now in broute table, ebt_redirect.ko sets the ether daddr of the packet
> to that of the incoming interface, i.e. the bridge port not the bridge
> itself. We'll need an extension for that, too right?

Yes, but i don't think the broute feature is that relevant given the lack
of requests for support in nftables.  Most want to make the packet
enter the bridge input path and not pretend that the bridge didn't exist
in the first place.

> I guess just
> calling 'redirect' verdict will manipulate the IP header as well which
> we don't want

Can you point me to the code that alters the IP header?  I can't find
anything.
