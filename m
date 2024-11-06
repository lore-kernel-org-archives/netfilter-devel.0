Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDF610F2
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 08:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881940; cv=none; b=uilcyfw4f4EgsR8ZMoeOOplWVML6RdbQUyLFZwCqcD9hd8IrVY3fpM//BK6PROuFqwlTdkjWW1tyCFtf3Wh6WEuWLpUkuwvNGFyLw9hJBbfife9lbSL5EqIcNi8abru4gGQJIxEAnYhJCDWrDq0/wdb2QjBPYz5VU52VRIZ3SFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881940; c=relaxed/simple;
	bh=xlWp3Lpdjxzsiwc9ho0FBWBRm2k8MNlDRadRS837fvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YiQNhR8FpT2AY8KAj6tF4sLZtctDUE+N7AaKGROVFOxDS0yVnzjNd20KfYKlS/cwrE6tzcQbJ/5FzWigM7HhmPO2K6wFhSmmolirPQyRxf31uNEZGMmJPZWOmOFFP0PjmU24gwbB6edpjLI6q2UPYcF3OFR0fqYRht2ZBhNLm+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55636 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8bSV-008ivy-6N; Wed, 06 Nov 2024 09:32:13 +0100
Date: Wed, 6 Nov 2024 09:32:09 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Nadia Pinaeva <n.m.pinaeva@gmail.com>, netfilter-devel@vger.kernel.org,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <Zyspid81oTuwYtcQ@calendula>
References: <20241030131232.15524-1-fw@strlen.de>
 <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZypDF4Suic4REwM8@calendula>
 <20241105162346.GA9442@breakpoint.cc>
 <ZypHs3XO4J2QKGJ-@calendula>
 <20241105163308.GA9779@breakpoint.cc>
 <ZypLmxmAb_Hp2HBS@calendula>
 <20241105173247.GA10152@breakpoint.cc>
 <ZyqoReoNkhz_fo3p@calendula>
 <20241106082644.GA474@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241106082644.GA474@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Wed, Nov 06, 2024 at 09:26:44AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Nov 05, 2024 at 06:32:47PM +0100, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Thanks, I'd rather convince you this is the way to go, if after
> > > > quickly sketching a patchset you think it is not worth for more
> > > > reasons, we can revisit.
> > > 
> > > Untested.  I'm not sure about skb_tstamp() usage.
> > > As-is CTA_EVENT_TIMESTAMP in the NEW event would be before
> > > the start time reported as the start time by the timestamp extension.
> > 
> > Is there any chance this timestamp can be enabled via toggle?
> 
> Can you clarify?  Do you mean skb_tstamp() vs ktime_get_real_ns()
> or tstamp sampling in general?

I am referring to ktime_get_real_ns(), I remember to have measured
25%-30% performance drop when this is used, but I have not refreshed
those numbers for long time.

As for skb_tstamp(), I have to dig in the cost of it.

> > > +	CTA_EVENT_TIMESTAMP,
> > 
> >         CTA_TIMESTAMP_EVENT
> > 
> > for consistency with CTA_TIMESTAMP_{START,...}
> 
> Sure, updated.
