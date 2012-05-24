From: Florian Westphal <fw@strlen.de>
Subject: Re: [v4 PATCH 1/1] netfilter: Add fail-open support
Date: Thu, 24 May 2012 12:53:14 +0200
Message-ID: <20120524105314.GB30569@breakpoint.cc>
References: <20120524082518.13146.25740.sendpatchset@localhost.localdomain>
 <20120524082531.13146.347.sendpatchset@localhost.localdomain>
 <20120524093043.GA30569@breakpoint.cc>
 <OF029AE6DA.E5969DF9-ON65257A08.003984EF-65257A08.0039E951@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, kaber@trash.net,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	sri@us.ibm.com, Sulakshan Vajipayajula <svajipay@in.ibm.com>,
	vivk@us.ibm.com
To: Krishna Kumar2 <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59965 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837Ab2EXKxR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 May 2012 06:53:17 -0400
Content-Disposition: inline
In-Reply-To: <OF029AE6DA.E5969DF9-ON65257A08.003984EF-65257A08.0039E951@in.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krishna Kumar2 <krkumar2@in.ibm.com> wrote:
> > if (queue->queue_total >= queue->queue_maxlen) {
> >    if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
> >       nf_reinject(entry, NF_ACCEPT);
> >       err = 0;
> >       goto err_out_free_nskb;
> >    }
> >    queue->queue_dropped++;
> >    net_warn_ratelimited("nf_queue: full at %d entries, dropping packets
> (s)\n",
> >
> > [..]
> >
> > Do you see any problems with that?
> 
> No, I think it should work fine. Do this after dropping the lock?

Good catch.  Yes, the lock should be dropped, else we
deadlock when same queue is hit in next table/chain.

> > > +   if (nfqa[NFQA_CFG_FLAGS]) {
> > > +      __be32 flags, mask;
> >
> > [..]
> >
> > > +      flags = ntohl(nla_get_be32(nfqa[NFQA_CFG_FLAGS]));
> > > +      mask = ntohl(nla_get_be32(nfqa[NFQA_CFG_MASK]));
> >
> > ntohl returns __u32 type.
> 
> Maybe just use __u32 type for flags/mask?

Yes.

Thanks,
Florian
