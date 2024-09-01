Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D24A37171;
	Sun,  1 Sep 2024 20:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725221265; cv=none; b=FvmdKpVa49PX6olrPEaG6nwpYrOwqsuX9y+6qp3WBA1p5FSV+aw9fRbO1ib3L5R04rc6mdfaXWiYejtSd7d905Xd3JEvCfsSF9PSEB28rj8adQCSi9u+PLpzyto+tqyr/UbSn6fSd/Cg7S68AuxzBUNboecJWMDk1JVGY2w2Ar8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725221265; c=relaxed/simple;
	bh=MPRROHEnFSIe5ZjwbnWH1r0MeA4+tacF4asUwpXskzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IhuMMTPy4pP+zY6Oh1FHlNBA9NqHJeFw8BCtkdJRm3YLgCzhhtxWfccqZVlu0UT8g53h1CVYA/Uk2o71oue16cRNQSPDBIK6XRAre5J9L5vvgc3d4WGaJ0jvcY88SwRJPzxqZd004YM5EYe6UWvtoOmJNdDXAj/ZGSi1hkfMsIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=47100 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1skqrA-007tFb-PA; Sun, 01 Sep 2024 22:07:30 +0200
Date: Sun, 1 Sep 2024 22:07:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Simon Horman <horms@kernel.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/2] netfilter: Add missing Kernel doc to headers
Message-ID: <ZtTJfzkFWlNgpVO-@calendula>
References: <20240830-nf-kdoc-v1-0-b974bb701b61@kernel.org>
 <20240831200307.GA15693@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240831200307.GA15693@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Sat, Aug 31, 2024 at 10:03:07PM +0200, Florian Westphal wrote:
> Simon Horman <horms@kernel.org> wrote:
> > Hi,
> > 
> > This short series addresses some minor Kernel doc problems
> > in Netfilter header files.
> 
> Thanks Simon, this looks good to me.
> Series:
> Reviewed-by: Florian Westphal <fw@strlen.de>

Thanks for reviewing.

If you both don't mind, I am going to collapse the three pending
patches from Simon that are targeting kdoc stuff.
