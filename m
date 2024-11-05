Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E321D5158
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730824124; cv=none; b=BZ+BHuYvrrY/gce+HpSKybqojJuoYen7XjWj/0w2e+25zTjgtKpARVC2OCDFD8AGybR/vRhLmlY2TjgkeE57V4v7JBHn07BEoQJXoSqmGItmIEC/l0pHCUHhcfw4NQptAFA/bTubCewLQW/HQEaYgrPGAggW2i3J67zdBpMUSjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730824124; c=relaxed/simple;
	bh=HxhWqt3bezKy3rbiKzU/MCXakH76puhIJ8pDtdt8tCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TYps0VgRrE4grKvQqDHZQqZcxdqmjqIHPSJMn+mGZkQr2tbH/b8qATt/WVRAv4nSU9OHccOOPHNigkH5bz+s38ejFtZOdXZP0o0G9tiCLD+jFjUXw9YBOxCM1KOe6HonLDY8ScN+seSwT9P+WkwLzW2124kEGkZJ7Vlwfkhx8Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=38122 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8MQ0-005QkR-QA; Tue, 05 Nov 2024 17:28:39 +0100
Date: Tue, 5 Nov 2024 17:28:35 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Nadia Pinaeva <n.m.pinaeva@gmail.com>, netfilter-devel@vger.kernel.org,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <ZypHs3XO4J2QKGJ-@calendula>
References: <20241030131232.15524-1-fw@strlen.de>
 <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZypDF4Suic4REwM8@calendula>
 <20241105162346.GA9442@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105162346.GA9442@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Tue, Nov 05, 2024 at 05:23:46PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Nov 03, 2024 at 11:26:36AM +0100, Nadia Pinaeva wrote:
> > > I would like to provide some more context from the user point of view.
> > > I am working on a tool that allows collecting network performance
> > > metrics by using conntrack events.
> > > Start time of a conntrack entry is used to evaluate seen_reply
> > > latency, therefore the sooner it is timestamped, the better the
> > > precision is.
> > > In particular, when using this tool to compare the performance of the
> > > same feature implemented using iptables/nftables/OVS it is crucial
> > > to have the entry timestamped earlier to see any difference.
> > > 
> > > I am not sure if current timestamping logic is used for anything, but
> > > changing it would definitely help with my use case.
> > > I am happy to provide more details, if you have any questions.
> > 
> > The start time will be accurate. However, stop time will not be very
> > accurate: the netlink message containing the SEEN_REPLY status flag
> > can sit in the socket queue for some quite time until the userspace
> > software has a chance to receive and parse it.
> > 
> > @Florian: Would you explore instead to extend the nf_conntrack_ecache
> > infrastructure to allow to provide timestamps for netlink events? This
> > can be enabled via toggle. That would allow to have a more accurate
> > delta between two events messages.
> 
> Simply using current time in ctnetlink won't help, the NEW event comes
> after confirm.
> 
> It will help for SEEN_REPLY.  But I don't see how it will avoid this
> patch.

Not current time from ctnetlink, but use the ecache extension to store
the timestamp when the conntrack is allocated, ecache is already
initialized from init_conntrack() path.
