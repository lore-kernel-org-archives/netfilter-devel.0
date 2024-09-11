Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2825E273FC;
	Wed, 11 Sep 2024 22:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726092594; cv=none; b=t9sRz2DVDpgwkiq2VV6R41bKUZSWcRbWDqepjZcV+VQdAFM5oPBWuIy9TzAGkgcvrq9U76KvgwdeJV0c8ajKaDiuuoCaoOUWH6qb5ukQc7tk/ceLTht35KuC/NVxNaIObjQYAFaaLA/qr7r/8zOV60ZeIxnTAmbnFk3OWhQmnjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726092594; c=relaxed/simple;
	bh=9OplBb1J9BEoiWWRyL3mXvlZ4hshNQ4DEgndWzm+tKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVUA8ceMePVp5xhleNhOK9lQQZzhMT8O72+ijzFxUfInj4Ip6Ye4/qq/IlPQ7RvRT57yuO4mtCCh2Dg8Ncr65EpZ02+RHWOPB7w+zm0XHcNWm1hv/iVyvHJeEs1VIhk2ZNfEpeuAcPNrcEwNuus7zLHbF3dRnLwq6ELjf+haU6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=54252 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1soVWr-007WfA-Ii; Thu, 12 Sep 2024 00:09:39 +0200
Date: Thu, 12 Sep 2024 00:09:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, rbc@meta.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <ZuIVIDubGwLMh1RS@calendula>
References: <20240909084620.3155679-1-leitao@debian.org>
 <20240911-weightless-maize-ferret-5c23e1@devvm32600>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240911-weightless-maize-ferret-5c23e1@devvm32600>
X-Spam-Score: -1.9 (-)

On Wed, Sep 11, 2024 at 08:25:52AM -0700, Breno Leitao wrote:
> Hello,
> 
> On Mon, Sep 09, 2024 at 01:46:17AM -0700, Breno Leitao wrote:
> > These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
> > Kconfigs user selectable, avoiding creating an extra dependency by
> > enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.
> 
> Any other feedback regarding this change? This is technically causing
> user visible regression and blocks us from rolling out recent kernels.

What regressions? This patch comes with no Fixes: tag.
