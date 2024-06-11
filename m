Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D452739855
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2024 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718124296; cv=none; b=sFfxJdSkooST39N3KUvPOxV1021GHL91kurZFdcyoFN/9mQuhfHs9tXWed0maqy3qrGkhj2EUDI6temBrT6zhcGPOpB6HruCMovtg4x/TQkKYKZDkEAIom7pOhyk2108ZY+HcrX/Qk+6zN1DWmbKPc2G21aCF+TAQdtrnis+sks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718124296; c=relaxed/simple;
	bh=RMvLT723C5ez5HJa+XfwAKM3Xm5vHYD20vgOM0DbGWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6QlZdl9l4KStEMvfLwZUCqSear/rhc96BTcbsow8I527NgtlPQzI6hsJehp5twVvgEsLTKyvfxgkVIO1S7P87/mtWVObAnE3FwmWkK+AyaC0hi6M/fZOx+ZR67ICgkgDerx+TLRxP7aOci2oTvIwoWEuasImu01TVzQsvwBCgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=40076 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sH4c2-002WLO-0X; Tue, 11 Jun 2024 18:44:47 +0200
Date: Tue, 11 Jun 2024 18:44:44 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] netfilter: Use flowlabel flow key when re-routing
 mangled packets
Message-ID: <Zmh-_F9bJJOrnkbY@calendula>
References: <20240606102334.5521-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240606102334.5521-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Thu, Jun 06, 2024 at 12:23:31PM +0200, Florian Westphal wrote:
> 'ip6 dscp set $v' in an nftables outpute route chain has no effect.
> While nftables does detect the dscp change and calls the reroute hook.
> But ip6_route_me_harder never sets the dscp/flowlabel:
> flowlabel/dsfield routing rules are ignored and no reroute takes place.
> 
> Thanks to Yi Chen for an excellent reproducer script that I used
> to validate this change.

Applied to nf.git, thanks Florian
