Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F492EAE4
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730825123; cv=none; b=JWcQwA8YF9T6t9Qsm17xPuQA2wU6NUNklAXkxbkc29a3I8F8Z0kvPqh4//NsdfDRc49XtesyAWYGcUAOgPBo/vOuutIIdGokQUKZlr9U5ESdswKvQOU+YnH48AjaaOuhteu2+Z5uG3YoHPviyJW0HA+RdmQEaZ10RhY20NZhEZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730825123; c=relaxed/simple;
	bh=jlVrZZyHq3A6DgAQeG8LMpDhjO3Z8KcB2fhwF6Fhpxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kqeq+KLcAUc1DJAUbnVcUqnK6gIjpWMLuUqGooT+1oqiObxycjI+VunMXZdtAOq5huVTuibUjLBJBhzrK4KjGh9koRFgAh3q2kJp5cfKqr2j6vGVMym521OR0f73EzWPJEFhnvitsW3nHBo6RFv3y2kL2h9a6MFYN0Es5Fbx01w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48228 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8Mg8-005Us4-5f; Tue, 05 Nov 2024 17:45:18 +0100
Date: Tue, 5 Nov 2024 17:45:15 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Nadia Pinaeva <n.m.pinaeva@gmail.com>, netfilter-devel@vger.kernel.org,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <ZypLmxmAb_Hp2HBS@calendula>
References: <20241030131232.15524-1-fw@strlen.de>
 <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZypDF4Suic4REwM8@calendula>
 <20241105162346.GA9442@breakpoint.cc>
 <ZypHs3XO4J2QKGJ-@calendula>
 <20241105163308.GA9779@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105163308.GA9779@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Tue, Nov 05, 2024 at 05:33:08PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > It will help for SEEN_REPLY.  But I don't see how it will avoid this
> > > patch.
> > 
> > Not current time from ctnetlink, but use the ecache extension to store
> > the timestamp when the conntrack is allocated, ecache is already
> > initialized from init_conntrack() path.
> 
> OK, so we do ktime_get_real() twice.
> I think its way worse than this proposal, but okay.

My proposal is to add more well-known "fixed points" to get numbers.
At this stage, there is start= and stop= ktimestamps, where start=
represents insertion to hashes (confirmation time). I think this adds
more ktimestamp point that can be enabled to collect numbers in an
optional fashion, both two timestamps do not need to be turned on
necessarily.

> I'll work on this.

Thanks, I'd rather convince you this is the way to go, if after
quickly sketching a patchset you think it is not worth for more
reasons, we can revisit.
