Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573425;
	b=hvwWcmjbDpX46AMxLK1WIr/5S9L5alJPz9sQCD2XSuC1/elO4dP2Xv+V9pSDEyFpXTZz
	 a15Glomb8X16YxLTLW8+YUFFGFyZTbH1IF6P8OsUmS7uPz04/Q4WLcvoiaSQdvgT2X7RA
	 axL63uL78/H3z0Dk6XjblvsGYrPSNkySZKBirR7FRpCTak4sLQNpR88f/3dLGk1VvW2uw
	 CnBWDyfLydG/G8EeKrojlcI7zgVvpzSafRijuhlXaXzQv0PsQ21VgtfhjT33Cwi1XbOfh
	 NR4YB1wBV6xPRb+1aGJaFVFXe7joxDPVkjPU0+nAxI2QyoJFGqx8EyWmm633orMj0dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573425;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=CldUw93C0Ojngf/XHy1jZQ3E3Ij6ioRtiYskpa4cLxM=;
	b=jpgRY+h1z8A61vlN5zfvetKEFmeoldq73Wy9GCRv3dfm6PnC/i6wqgdZGVRKUystAwMT
	 CLctnZvT7sF1RiSy1Zl+NfdBzTdHuQokwvMrzKXngPLEbXFkub/FSa3w/rAqnjTMmzQ9X
	 zt7Lf4BAxYWwO+v4oPbq+Q2X2mNtEv5Yij7upGg/bjAS6eZx7uadYcEExpmSbIvKx5lJl
	 +5UGI2gF1n107ypTOOWesxy4h5+LlnuRA32ZR1xFY4PZMvlHuS2ULhC2cZfne5N4z+iyR
	 xsUYh3W+e3ujVTxpkQnAgnbjYgVjq3510E8xFfSXaAu3gb8fQby1DMdAUroI2mYUfcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594AB606A31F
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 09:03:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 594AB606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0E1B060460; Wed, 21 Oct 2026 11:03:42 +0200 (CEST)
Date: Wed, 21 Oct 2026 11:03:41 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_payload: restrict checksum offsets to
 known values
Message-ID: <ath_7a3pT6AOj0_l@strlen.de>
References: <20260904095723.18368-1-fw@strlen.de>
 <ath6GRzpTiUBUS1B@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ath6GRzpTiUBUS1B@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Sep 04, 2026 at 11:57:23AM +0200, Florian Westphal wrote:
> > We need to prevent userspace from corrupting e.g. tcp->doff, because
> > many locations in conntrack and conntrack helpers rely on
> > nf_conntrack_in() having validated the packet headers.
> > nft_payload allows to alter headers later which invalidates this
> > assumption.
> > 
> > The 'Fixes' commit restricts writes to safe fields, but there is
> > another side channel: the checksum location.
> > 
> > Restrict this too.  Reported via sashiko/gemini.
> > 
> > v2: add missing IPPROTO_ICMP handling, else 'icmp code set 42' won't
> > update icmp checksum.
> 
> This patch is now upstream.
> 
> Would it be possible to fully/partially revert this patch?
> 
> commit 968cc2c96390f06e56ed6a43f935bfebdefed28f
> Author: Florian Westphal <fw@strlen.de>
> Date:   Sat May 16 23:23:21 2026 +0800
>  
>     netfilter: disable payload mangling in userns

I hope so, I will follow up on this.
