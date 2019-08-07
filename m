Return-Path: <SRS0=iSAz=WD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31558C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 23:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0666A20880
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 23:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfHGXpz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Aug 2019 19:45:55 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:56912 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729624AbfHGXpz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Aug 2019 19:45:55 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hvVcu-0004sS-D2; Thu, 08 Aug 2019 01:45:52 +0200
Date:   Thu, 8 Aug 2019 01:45:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Dirk Morris <dmorris@metaloft.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: Use consistent ct id hash calculation
Message-ID: <20190807234552.lnfuktyr7cpvocki@breakpoint.cc>
References: <e5d48c19-508d-e1ed-1f16-8e0a3773c619@metaloft.com>
 <20190807003416.v2q3qpwen6cwgzqu@breakpoint.cc>
 <33301d87-0bc2-b332-d48c-6aa6ef8268e8@metaloft.com>
 <20190807163641.vrid7drwsyk2cer4@salvia>
 <20190807180157.ogsx435gxih7wo7r@breakpoint.cc>
 <20190807203146.bmlvjw4kvkbd5dns@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807203146.bmlvjw4kvkbd5dns@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Aug 07, 2019 at 08:01:57PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > @Florian: by mangling this patch not to use ct->ext, including Dirk's
> > > update, conntrackd works again (remember that bug we discussed during
> > > NFWS).
> > 
> > But conntrackd is still borken.
> > It can't rely on id recycling  -- it will just take a lot
> > longer before it starts to fill up.
> 
> Conntrackd does not rely on ID recycling. Conntrackd is in trouble
> because of event loss. It seems the event re-delivery routine is
> buggy, if the destroy event gets to userspace sooner or later, then
> this entry would not get stuck in the cache forever. I can just remove
> the check for the ID in userspace, so conntrackd would get rid of the
> stale entry by when a new entry with the same tuple shows up (lazy
> garbage collection).

Pardon my ignorance, but why is the id compared at all in conntrackd?

> > > @@ -470,8 +470,8 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
> > >  
> > >         a = (unsigned long)ct;
> > >         b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
> > > -       c = (unsigned long)ct->ext;
> > > -       d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL], sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL]),
> > > +       c = (unsigned long)0;
> > > +       d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
> >  
> > > I think it's safe to turn this into:
> > > 
> > >         a = (unsigned long)ct;
> > >         b = (unsigned long)ct->master;
> > >         c = (unsigned long)nf_ct_net(ct));
> > >         d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
> > 
> > No, not if we allow using the function before confirmation, the tuple
> > can also change in original dir when e.g. queuing before NAT hooks.

My claim is bogus, only the reply tuple is altered of course.

So Pablos suggestion above should work just fine.
Dirk, can you spin a v2 with that change?

> This hash-based ID calculation is a simple approach, but it looks weak
> / easy to break.

It works fine for what its intended, I did not consider
the node pointer change after we link the ct to the dying list.

Might also resolve the earlier reported bug wrt. conntrackd table
exhaustion as the id changed after relink to dying list.

Alternative is to use IDA and allocate ID based on object,
thats very similar to the original (u32)addr but we need to store
the additional identifier in the conntrack object which i tried to avoid.
