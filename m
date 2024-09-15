Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBFB4644E;
	Sun, 15 Sep 2024 21:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726434484; cv=none; b=lsyaPm7fWMZLNpvKaWbnJMzqEJ8l0xn+iCREqLtpTIU3VZ2PLUwgem77StTUy94mFPFbg2MB5unARqaAWCrt6sTE1VV4aXWxckNN+GqjPdLayP9K5SKmaPiFVzBCQbSBbVtSa/E5IQN9vopRHnxwUD+MK8GBUVpNGqPUVXEhtAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726434484; c=relaxed/simple;
	bh=3zgSFbu8PXX7ZYghpZqp4ia+Cb3a7UGY+xDKtliP2GE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kk1ORKARiVdpDaRdC6UD8JD+POEa1rc2kKV90k8pbBarJ6RoI8bE5np49d2kcr9k+rIGU2qaLVjByfPXKlU7fapTVzUxbEBtlmDy4MpNghPbxSJw983ZrUMm63lfOI0FJL/pgzOevNPCsEkTCapNONGlqXwHz1jxGRfDY1sqCR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56300 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1spwTM-00EIaN-HT; Sun, 15 Sep 2024 23:07:58 +0200
Date: Sun, 15 Sep 2024 23:07:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, rbc@meta.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <ZudMq7TfC2CbNJyu@calendula>
References: <20240909084620.3155679-1-leitao@debian.org>
 <20240911-weightless-maize-ferret-5c23e1@devvm32600>
 <ZuIVIDubGwLMh1RS@calendula>
 <20240912-omniscient-imposing-lynx-2bf5ac@leitao>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240912-omniscient-imposing-lynx-2bf5ac@leitao>
X-Spam-Score: -1.9 (-)

On Thu, Sep 12, 2024 at 05:18:29AM -0700, Breno Leitao wrote:
> On Thu, Sep 12, 2024 at 12:09:36AM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 11, 2024 at 08:25:52AM -0700, Breno Leitao wrote:
> > > Hello,
> > > 
> > > On Mon, Sep 09, 2024 at 01:46:17AM -0700, Breno Leitao wrote:
> > > > These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
> > > > Kconfigs user selectable, avoiding creating an extra dependency by
> > > > enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.
> > > 
> > > Any other feedback regarding this change? This is technically causing
> > > user visible regression and blocks us from rolling out recent kernels.
> > 
> > What regressions? This patch comes with no Fixes: tag.
> 
> Sorry, I should have said "This is technically causing user lack of
> flexibility when configuring the kernel"

Sure, to allow for in-kernel iptables compilation but extensions as
modules? How in the world is that ever used, really?
