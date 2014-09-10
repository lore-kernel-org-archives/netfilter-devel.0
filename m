From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: export rule-set generation
 ID
Date: Wed, 10 Sep 2014 16:40:54 +0200
Message-ID: <20140910144054.GA3578@salvia>
References: <1410282105-12880-1-git-send-email-pablo@netfilter.org>
 <20140909182014.GA25039@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50535 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaIJOkD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:40:03 -0400
Content-Disposition: inline
In-Reply-To: <20140909182014.GA25039@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 09, 2014 at 07:20:16PM +0100, Patrick McHardy wrote:
> On Tue, Sep 09, 2014 at 07:01:45PM +0200, Pablo Neira Ayuso wrote:
> > This patch adds the NFT_MSG_GENID command to nf_tables that exposes
> > the 16-bits ruleset generation ID. This ID is incremented in every
> > commit. The generation ID is also exposed to userspace through the
> > nfnetlink res_id header field when dumping object lists.
> > 
> > This generation ID allows a userspace client to detect that an update
> > has happened between two consecutive object list dumps, so it can
> > retry from scratch.
> > 
> > This is complementary to the NLM_F_DUMP_INTR approach, which allows
> > us to detect an interference in the middle one single list dumping.
> > There is no way to explicitly check that an interference has occurred
> > between two list dumps from the kernel, since it doesn't know how
> > many lists the userspace client is actually going to dump.
> 
> Well, the obvious question is, are we sure that 16 bit is enough?
> I mean, sure, it most likely is for almost any usecase, but if you
> want to write a reliable piece of software using it, can you be
> sure and how could you handle the case that it overflows?
> 
> If we for instance consider an optimization algorithm that wants to
> perform an update and has to dump all objects, perform its change,
> reoptimize the resulting ruleset and then insert it. This might take
> some considerable amount of time. I guess its at least possible that
> 2^16 updates could be performed in the same period.

Right. nf-hipac was taking quite some time to perform those
transformations (I remember they were masking the update time by using
a kernel thread in the netlink receive path), so it's reasonable to
assume that those transformation algorithms may take enough time to
see a wrap-around.

I think of several alternatives:

1) Switch to 2^32. With this approach, I don't see a way to
expose it via the existing headers (ie. nfnetlink res_id was easy).
Thus, we don't have a way to stop a dump immediately after when we
notice the objects we're getting are stale. So the approach should
look more like:

request genID and annotate it
dump objects
request genID and compare what we annotated, if unequal, retry.

This can be expensive when we get an unfortunate update between two
list dumps when we operate with large object list though. BTW, the
update between two list dumps is unlikely but still possible.

2) Stick to 2^16 but introduce a commit event. The optimization
algorithm can subscribe to this events so it notices when it's been
working with stale objects. The optimization software would need to
poll for commit events and we still may lose events.

I think we have to go 1).

Regarding the commit event, Arturo wants this for nft-sync anyway, so
he knows where the batch ends to consistently replicate and apply the
rules to the other peer. So this can come in a separated patch.

Let me know, thanks!
