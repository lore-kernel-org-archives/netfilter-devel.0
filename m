Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C1918C939
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 10:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724149746; cv=none; b=MLYnSj3qZ6P+OHCHv1FH6o/u427/h/eFIshrCH63cEBHnw1wIHKrmOiIuUCAfnxi8juRi2ctwLk/h/UG3AeRoWKvSARWR/rd7vtUvr4lJuowFtCqwLocg9o8gcGMx8o9kJzrMVU4VOo0plF3ux/UZBSj1/BXASMen9rqk25ne0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724149746; c=relaxed/simple;
	bh=0M8oVwWU339VW65lUB68y207fMxfIOWDUoECiEYdv9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fj5QfBaQzgjLO0GlOqha1TvGv4Yz8/PSB9YwBvbsELmFSkpC3ONcJWj7F0Ia1LinJq8xqDMBRqJty0uTm5Qzcc53JXSS1rpUZDUWowpb1c17RJ8i7nYQjtRHLLU7crLW0jqLgNRtrldHi7nE8LJcApRU7851mp3tcr9bwV+ZOPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=37132 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sgM6j-006hSd-3W; Tue, 20 Aug 2024 12:28:59 +0200
Date: Tue, 20 Aug 2024 12:28:56 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net 0/3] netfilter: nft_counter: Statistics fixes/
 optimisation.
Message-ID: <ZsRv6Kx6mQyQxSIc@calendula>
References: <20240820080644.2642759-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240820080644.2642759-1-bigeasy@linutronix.de>
X-Spam-Score: -1.9 (-)

On Tue, Aug 20, 2024 at 09:54:29AM +0200, Sebastian Andrzej Siewior wrote:
> Hi,
> 
> I've been looking at nft_counter and identified two bugs and then added
> an optimisation on top.
> 
> This is just compile tested, I didn't manage to trigger some of the
> pathes I changed (especially nft_counter_offload_stats()).

Applied 1/3 and 2/3 to nf.git, thanks Sebastian
