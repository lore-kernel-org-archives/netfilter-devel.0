Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A17C20DF4;
	Thu, 27 Jun 2024 10:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719484167; cv=none; b=TiEGJm9s671X7rmwz0NcRhG8xws7eZ0H6Fu+v0bXqQ7LjdzJd/bxVS6rdpx5ZlDdimoMsW8utYA9z9Ce2Oh45Ip6Ow5r4tLW/Rbn39+CAtDI0FuVXMZ/HB++qkAuZJqemgCXjgo4zs6bniNOXUSqUHu5UEAaCnGCUtYiGgSzRZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719484167; c=relaxed/simple;
	bh=IdqjzRHNY0nGgHYWNsVffTXfQxyGQs7a1xW41jATcR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IyMAVDUx6yjQqLpvg/31KqhBW/HsAhG1hR5xdgxg3ALb+QwbqFsYYX/ZpikQfnYZkXr52hee/TdZIKJRBhfvHNh5Xm3F6ZBZBEFyeFn6aDVcYxy1fdVhrhI5ZqhX2/DRSfG+gh04Dh4V4QMzoNW5EanAXBNG+UJyegZ7dXdayoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=52690 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMmNS-009VyX-Nc; Thu, 27 Jun 2024 12:29:20 +0200
Date: Thu, 27 Jun 2024 12:29:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net 2/2] netfilter: nf_tables: fully validate
 NFT_DATA_VALUE on store to data registers
Message-ID: <Zn0-_YTghuD5lAcv@calendula>
References: <20240626233845.151197-1-pablo@netfilter.org>
 <20240626233845.151197-3-pablo@netfilter.org>
 <CAHk-=wibyec=ObQrd3pR+cUUchDGXFk3bTp435jOz+NP0xEzXw@mail.gmail.com>
 <Zny8zPf1UAYNKL0E@calendula>
 <af44f85c7d27910c27d47436eff5813cee13452c.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af44f85c7d27910c27d47436eff5813cee13452c.camel@redhat.com>
X-Spam-Score: -1.9 (-)

On Thu, Jun 27, 2024 at 12:26:49PM +0200, Paolo Abeni wrote:
> Hi,
> On Thu, 2024-06-27 at 03:13 +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jun 26, 2024 at 05:51:13PM -0700, Linus Torvalds wrote:
> > > On Wed, 26 Jun 2024 at 16:38, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > 
> > > > Reported-by: Linus Torvalds <torvalds@linuxfoundation.org>
> > > 
> > > Oh, I was only the messenger boy, not the actual reporter.
> > > 
> > > I think reporting credit should probably go to HexRabbit Chen
> > > <hexrabbit@devco.re>
> > 
> > I would not have really know if you don't tell me TBH, else it would
> > have taken even longer for me to react and fix it. Because they did
> > not really contact me to report this issue this time.
> > 
> > But if you insist, I will do so.
> 
> I'm sorry for the late reply.
> 
> I guess the most fair option would be adding both tags. 
> 
> With a repost, this will not make it into todays PR, I hope it's not a
> problem.

It is a addressing a public issue, the reporter decided to follow a
different channel other than security@ for whatever reason.

I'd prefer if you can take it in this round.
