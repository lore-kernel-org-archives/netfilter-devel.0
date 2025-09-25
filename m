Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE734272E42
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 21:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758836705; cv=none; b=O6N1hsdC6SvrXVnB5MUwgy5TDw/BOU60NKBcr4lnHK3fXhMvpcQA3jKDXK6Ty4zZByXRB6RnjaO37KNTIhfDHqPMCSrhenTQsVt9JcXTi7zD49FS5Fnz7u6HVPz3Geehrub/2WzuRc4vLr5eBfeHcY7M60zbV7TnJzb3nqBS+Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758836705; c=relaxed/simple;
	bh=oGFso/bRxk8FdU2BNZ1mgmbAcRtwRy5NObsQGzsQX4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/VnKkTgsCrSXrXm4b59djyl91dDPXUFQbIaI+jkMO3gRnXaiH370gKq/hm9AWimRab0ZY3yMzyPOMK4VJrcONZw7eKTvwcyRyPpyTvU2a5stdtloo+Sq3OWeU8N/6n7m8vntdXtG51YopX6wpcVrYqYrCt9TZWdSucxRjyF2Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=k55FvWmH; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HjCsXuzo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="k55FvWmH";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HjCsXuzo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7337060272; Thu, 25 Sep 2025 23:45:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758836702;
	bh=m3SRcOGi6GSTROGlMzhQcyPZ9T/HTQDt9YY7SlJRtQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k55FvWmH1hEmfiuTHtxcoMKyyuoyszY65NJiPkblXbTX6ZuNXL+0tsZ8suTE0+Czd
	 2PCAoczm2xQ0rwIP7Di4wiktT9g+v1ZDJICoAY4qVKusPpqspNGUG8VbHMwuThr4NP
	 Mza+efqAGz+Wo9H/QpFTEOeG8jntPEfokFN+umgqQwthSiKWdrH7DIqm4fhRRBjXuR
	 mid9aLCHO/uMJ1C7Y2mZ/ZH9aL/yPICmejM84VX7iGVPZ+dl52bL6zfdRpmbIvyCaY
	 JRFiKG7OdrtjWfYJTSRgSbhmxootITGhfIxziV/nFaCaA+WmZepznZAL+9/ClNlAxx
	 WM+YnlFUj5fag==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 614456026C;
	Thu, 25 Sep 2025 23:45:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758836701;
	bh=m3SRcOGi6GSTROGlMzhQcyPZ9T/HTQDt9YY7SlJRtQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HjCsXuzoQUUTBEYIjkk1sDkQf2XBULqeXUX4RwppJeOnoRhX8oG3kGY2pfBibPRbP
	 zcPwEPZrNxxoT2IQk6IuMILSZfDJFjrlhh9Te+wc9j30jbDgvNsTk8mg8Q9VPRCk09
	 VHmZ6dJlXINJGL16Aaev3dyozp3MuSxV3AwulPipyPam7QvbS1Yk2voGh69yPKjzO6
	 RzuXWq36zDQ7kHyo2amHKf93bxtScBeP9WUb/yhhZwsDW6e8euSITCQfp+kItEyD1A
	 mACcyy4jEulYx4Y2Ro33dcOl6Q0jlfv8ozAgVUIwNSvwh+YZ5CIqW/B6NxmrZ2AjlS
	 MX+rIRHuv1FCA==
Date: Thu, 25 Sep 2025 23:44:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: netfilter-devel@vger.kernel.org,
	Christoph Anton Mitterer <calestyo@scientia.org>
Subject: Re: bug: nft include with includedir path with globs loads files
 twice
Message-ID: <aNW32hgObaM7aJs6@calendula>
References: <500beefd7481a43c4068469300e07ca3769a064e.camel@scientia.org>
 <20250925200005.GB6365@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250925200005.GB6365@celephais.dreamlands>

On Thu, Sep 25, 2025 at 09:00:05PM +0100, Jeremy Sowden wrote:
> On 2025-09-24, at 22:23:11 +0200, Christoph Anton Mitterer wrote:
> > Hey.
> > 
> > With:
> >    # nft -v
> >    nftables v1.1.5 (Commodore Bullmoose #6)
> > from Debian sid which uses a default include dir of:
> >    # nft -h | grep includepath
> >      -I, --includepath <directory>   Add <directory> to the paths searched for include files. Default is: /etc
> > 
> > 
> > And e.g.:
> > /etc/nftables.conf
> >    #!/usr/sbin/nft -f
> >    
> >    flush ruleset
> >    
> >    table inet filter {
> >    	chain input {
> >    		type filter hook input priority filter
> >    		ct state {established,related} accept
> >    	}
> >    }
> >    
> >    include "nftables/rules.d/*.nft"
> > 
> > and:
> > /etc/nftables/rules.d/x.nft:
> >    table inet filter {
> >            chain bla {
> >                    type filter hook input priority filter
> >                    ip daddr 1.1.1.1 drop
> >            }
> >    }
> > and no other files in rules.d... nft seem to somehow include x.nft
> > twice:
> > 
> > # nft -f /etc/nftables.conf; nft list ruleset
> > table inet filter {
> > 	chain input {
> > 		type filter hook input priority filter; policy accept;
> > 		ct state { established, related } accept
> > 	}
> > 
> > 	chain bla {
> > 		type filter hook input priority filter; policy accept;
> > 		ip daddr 1.1.1.1 drop
> > 		ip daddr 1.1.1.1 drop
> > 	}
> > }
> > 
> > If I change the include to "nftables/rules.d/x.nft" or to
> > "/etc/nftables/rules.d/*.nft"... it works (i.e. only one ip daddr
> > 1.1.1.1 drop).
> 
> There is a Debian bug report related to this:
> 
>   https://bugs.debian.org/1112512

For the record:

https://git.netfilter.org/nftables/commit/?id=3af59817b8d3994d52db0f1aa5dabeebc84dae45
