Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013172E62A9;
	Wed,  1 Jul 2026 06:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782887775; cv=none; b=cr2ICAkk56vvecDIHrzXEilQPIZxcsSyZQCVvFyLflR6N3hFgxVUQujuPa/d74ogrfphcB5lDHIpNTy5U5IM6uxitumnYZ83PkLxXN8ZWxtWiYA795puBb7oYL8R2zWHd8WpGmCfrJsXIRBKCvQfAaEZEh92E79sukcx6jGLfFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782887775; c=relaxed/simple;
	bh=W0+x3mTxKmE28XoEmmcTzUPx1gA8EEVcbQXsTKdrFM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c3BrBUniBlKOSqdARX8Vc66U8YVYKFvRkBfHUcptB4bIbjOnjIRFRNOYtDexHfF/bLPbo5G+Nf2FgPvX606IXLCzhfer61PJlUMScplItLTF55BIaBmFWmZDD0ff5h8fXJoGVatDaqmfgTCvwdDSCqpw2KEhhwJMyPEvy7D7Hls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A5C4B602F8; Wed, 01 Jul 2026 08:36:11 +0200 (CEST)
Date: Wed, 1 Jul 2026 08:36:11 +0200
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net 4/9] netfilter: nf_conntrack_sip: validate skb_dst()
 before accessing it
Message-ID: <akS1W7XGQ3LiP0LC@strlen.de>
References: <20260630045243.2657-1-fw@strlen.de>
 <20260630045243.2657-5-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630045243.2657-5-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> tc ingress and openvswitch do not guarantee routing information to be
> available. These subsystems use the conntrack helper infrastructure, and
> the SIP helper relies on the skb_dst() to be present if
> sip_external_media is set to 1 (which is disabled by default as a module
> parameter).

The sashiko drive-by appears real, I submitted a patch for it.
Its not a regression added by this patch but a unrelated issue.

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260701062922.9660-1-fw@strlen.de/
