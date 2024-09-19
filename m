Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932BC13AF2
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 12:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726747336; cv=none; b=TrulkKeIRycI0PQABzn+XSfUKVmMJ3B4DZyS3xP3vWhZdcf+9QRwP108CDgBhnjuWuWXinXyMEQwmkLMNeL2C1emKv8XT1NDX4jYIxU9hSQbh1KKq07pc4aMNy2OGjkZVV5tyZ2ajaTTZNJMR7GOAlLr7hqbXvXV+QbICuFVAaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726747336; c=relaxed/simple;
	bh=LqQjOKMzxG5TWuiOfV3ViqeStwxR+a9K9PGFKyJIX1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grKAVqgw5FMA8kKrHjemZFTdVTqBLx+rjXaxAp9oO33J/xmfZK3HgqQwc5NcREipSbziJfLrDg95Dk004scR7FWDjPKcfaIS6138MOifGYbVIj5WAnxLapI5jwa+1D34G8DYeixHxptew8Ntij5vgFCwyR23YqF0ZhTgVn39KlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41248 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1srFrM-003IjR-Up; Thu, 19 Sep 2024 14:02:11 +0200
Date: Thu, 19 Sep 2024 14:02:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected
 packets from postrouting
Message-ID: <ZuwSwAqKgCB2a51-@calendula>
References: <20240912185832.11962-1-pablo@netfilter.org>
 <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
 <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
 <Zus9trdyfiTNk2NI@calendula>
 <CABhP=tbVrpr1MuYSubw4LKUNP=_PFap3CN9bc3M_mzo6yxeqpw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABhP=tbVrpr1MuYSubw4LKUNP=_PFap3CN9bc3M_mzo6yxeqpw@mail.gmail.com>
X-Spam-Score: -1.8 (-)

On Wed, Sep 18, 2024 at 10:42:25PM +0100, Antonio Ojea wrote:
> On Wed, 18 Sept 2024 at 21:53, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Tue, Sep 17, 2024 at 11:01:31PM +0100, Antonio Ojea wrote:
> > > On Fri, 13 Sept 2024 at 07:24, Antonio Ojea
> > > <antonio.ojea.garcia@gmail.com> wrote:
> > > >
> > > > On Thu, 12 Sept 2024 at 20:58, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > >
> > > > > 368982cd7d1b ("netfilter: nfnetlink_queue: resolve clash for unconfirmed
> > > > > conntracks") adjusts NAT again in case that packet loses race to confirm
> > > > > the conntrack entry.
> > > > >
> > > > > The reinject path triggers a route lookup again for the output hook, but
> > > > > not for the postrouting hook where queue to userspace is also possible.
> > > > >
> > > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > > Reported-by: Antonio Ojea <antonio.ojea.garcia@gmail.com>
> > > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > > ---
> > > > > I tried but I am not managing to make a selftest that runs reliable.
> > > > > I can reproduce it manually and validate that this works.
> > > > >
> > > > > ./nft_queue -d 1000 helps by introducing a delay of 1000ms in the
> > > > > userspace queue processing which helps trigger the race more easily,
> > > > > socat needs to send several packets in the same UDP flow.
> > > > >
> > > > > @Antonio: Could you try this patch meanwhile there is a testcase for
> > > > > this.
> > > >
> > > > Let me test it and report back
> > > >
> > >
> > > Ok, I finally managed to get this tested, and it does not seem to
> > > solve the problem, it keeps dnating twice after the packet is enqueued
> > > by nfqueue
> >
> > I really don't understand why my patch did not work.
> >
> > In this new test run you have use postrouting/filter chain, but it
> > does not call nf_reroute as in the previous trace.
> >
> > Does program issues the NF_STOP verdict instead?
> >
> 
> The program is the same and the environment the same, I just change
> the kernel of the VM.
> I have observed different drops reasons, see my original comment
> https://bugzilla.netfilter.org/show_bug.cgi?id=1766#c0 has
> SKB_DROP_REASON_IP_RPFILTER and SKB_DROP_REASON_NEIGH_FAILED, and in
> this trace we have SKB_DROP_REASON_OTHERHOST ... , can it be possible
> you fixed one scenario with your patch but not the others?

It could be different scenario. I was expecting consistency in UDP packet
distribution is a requirement, but I understood goal at this stage is
to ensure packets are not dropped while dealing with clash resolution.

I have applied Florian's patch to nf.git, thanks.
