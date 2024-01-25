Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D268A1CD15;
	Thu, 25 Jan 2024 09:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706174991; cv=none; b=DuYIo4BrB9Evi7d2YZsVOKJRaPxFdiAvrNJPBd+ta3Kj3QSL5g8qSee2/GHlbACqM6JPM+ZR/GJqKwHdXj0qgv5wuQwv1aZTR9av3jQXtzsDSrHCt0ZyMq3Far5q6L0v2p9xwuk9hK5BqXH94VndiiCFNcvxI4I7oIF33Y/+uXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706174991; c=relaxed/simple;
	bh=8HtSjAB6qgMc15CF6i8kHSkllLp/aD5PDJeSxeq5RZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUB1hhliqS7+WkkIgYNOi+VbOszUFaSz9GBQx1IGmvmWK4ZvQhUxxHtcMjvYU9LTle5J0jtX8U9sjNG8qgeCft0sKAL6hQr74W6JsmM1abLO052cQrEVyoC/lq7g2P4KocYdBByMF9AmbISgE5VEhNx51GPacma3IZurk0xQ7s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=57586 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rSw3K-007bw0-GV; Thu, 25 Jan 2024 10:29:44 +0100
Date: Thu, 25 Jan 2024 10:29:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	David Ahern <dsahern@kernel.org>, coreteam@netfilter.org,
	"netdev-driver-reviewers@vger.kernel.org" <netdev-driver-reviewers@vger.kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <ZbIqBU9I009KVqZT@calendula>
References: <20240123072010.7be8fb83@kernel.org>
 <d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
 <65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
 <20240124082255.7c8f7c55@kernel.org>
 <20240124090123.32672a5b@kernel.org>
 <ZbFiF2HzyWHAyH00@calendula>
 <20240124114057.1ca95198@kernel.org>
 <ZbFsyEfMRt8S+ef1@calendula>
 <20240124121343.6ce76eff@kernel.org>
 <20240124210724.2b0e08ff@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240124210724.2b0e08ff@kernel.org>
X-Spam-Score: -1.9 (-)

On Wed, Jan 24, 2024 at 09:07:24PM -0800, Jakub Kicinski wrote:
> On Wed, 24 Jan 2024 12:13:43 -0800 Jakub Kicinski wrote:
> > > if that is the nftables backend, it might be also that .config is
> > > missing CONFIG_NF_TABLES and CONFIG_NFT_COMPAT there, among other
> > > options.  
> > 
> > FWIW full config:
> > 
> > https://netdev-2.bots.linux.dev/vmksft-net-mp/results/435321/config
> > 
> > CONFIG_NFT_COMPAT was indeed missing! Let's see how it fares with it enabled.
> 
> NFT_COMPAT fixed a lot! One remaining warning comes from using 
> -m length. Which NFT config do we need for that one?

May I have a look at the logs? How does the error look like?
