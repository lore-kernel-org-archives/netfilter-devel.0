Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6131386BF;
	Thu, 27 Jun 2024 10:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719484763; cv=none; b=ZHSmb+YZbtgZHZ3qsi/mZYAB0k0IK8O8K7YHTuZiAtLtOnikClm00015tqpApV94bAUdFkOZ7V9L3kEOKAuQ5/vqY94VWVdnUn7LSob9P2CqV55Vvn1zcS749ARYQT08YKC6/0Yl9VqkP7dgY50IOAhJrf582jCzCm71ND4lZWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719484763; c=relaxed/simple;
	bh=mbRl9CuoIi0h2v+HI8bWtxsCjQWgBhjPZ7uXqaZnHc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EQNZeDLpVQnUadVP0LswFSbZ7GaSp8LA1sNShDHFR4Rv7qvm+6G4+QwILIbyDLwVfGdPvzMk6p1zeEY8DHIIOEHpfj5Haq3x+yQ4Z0aYzSBUflKq1ncU9v3OS0YzYpl2N6lZdawPWBIs1rLTufxQPeZoPIgQT7gqpxIPwuc9wY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46200 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMmX7-009Wia-B2; Thu, 27 Jun 2024 12:39:19 +0200
Date: Thu, 27 Jun 2024 12:39:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net 2/2] netfilter: nf_tables: fully validate
 NFT_DATA_VALUE on store to data registers
Message-ID: <Zn1BVN1RATipMy0M@calendula>
References: <20240626233845.151197-1-pablo@netfilter.org>
 <20240626233845.151197-3-pablo@netfilter.org>
 <CAHk-=wibyec=ObQrd3pR+cUUchDGXFk3bTp435jOz+NP0xEzXw@mail.gmail.com>
 <Zny8zPf1UAYNKL0E@calendula>
 <af44f85c7d27910c27d47436eff5813cee13452c.camel@redhat.com>
 <Zn0-_YTghuD5lAcv@calendula>
 <f811d2c0f5b87f0ab8b3b9b32dcdd03ea8c2c076.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f811d2c0f5b87f0ab8b3b9b32dcdd03ea8c2c076.camel@redhat.com>
X-Spam-Score: -1.9 (-)

On Thu, Jun 27, 2024 at 12:37:59PM +0200, Paolo Abeni wrote:
> On Thu, 2024-06-27 at 12:29 +0200, Pablo Neira Ayuso wrote:
> > On Thu, Jun 27, 2024 at 12:26:49PM +0200, Paolo Abeni wrote:
> > > On Thu, 2024-06-27 at 03:13 +0200, Pablo Neira Ayuso wrote:
> > > > On Wed, Jun 26, 2024 at 05:51:13PM -0700, Linus Torvalds wrote:
> > > > > On Wed, 26 Jun 2024 at 16:38, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > > 
> > > > > > Reported-by: Linus Torvalds <torvalds@linuxfoundation.org>
> > > > > 
> > > > > Oh, I was only the messenger boy, not the actual reporter.
> > > > > 
> > > > > I think reporting credit should probably go to HexRabbit Chen
> > > > > <hexrabbit@devco.re>
> > > > 
> > > > I would not have really know if you don't tell me TBH, else it would
> > > > have taken even longer for me to react and fix it. Because they did
> > > > not really contact me to report this issue this time.
> > > > 
> > > > But if you insist, I will do so.
> > > 
> > > I'm sorry for the late reply.
> > > 
> > > I guess the most fair option would be adding both tags. 
> > > 
> > > With a repost, this will not make it into todays PR, I hope it's not a
> > > problem.
> > 
> > It is a addressing a public issue, the reporter decided to follow a
> > different channel other than security@ for whatever reason.
> > 
> > I'd prefer if you can take it in this round.
> 
> Sure, we are still (barely ;) on time!
> 
> Thanks for the prompt feedback.

Thanks a lot Paolo!
