From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3 v2] netfilter: nf_tables: export rule-set
 generation ID
Date: Thu, 11 Sep 2014 18:57:31 +0200
Message-ID: <20140911165731.GA6965@salvia>
References: <1410448819-6694-1-git-send-email-pablo@netfilter.org>
 <1410448819-6694-3-git-send-email-pablo@netfilter.org>
 <20140911153243.GE7600@acer.localdomain>
 <20140911161040.GA5824@salvia>
 <20140911164558.GF7600@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35659 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbaIKQ4i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:56:38 -0400
Content-Disposition: inline
In-Reply-To: <20140911164558.GF7600@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 11, 2014 at 05:45:58PM +0100, Patrick McHardy wrote:
> On Thu, Sep 11, 2014 at 06:10:40PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Sep 11, 2014 at 04:32:44PM +0100, Patrick McHardy wrote:
> > > On Thu, Sep 11, 2014 at 05:20:19PM +0200, Pablo Neira Ayuso wrote:
> > > > This patch exposes the ruleset generation ID in three ways:
> > > > 
> > > > 1) The new command NFT_MSG_GETGEN that exposes the 32-bits ruleset
> > > >    generation ID. This ID is incremented in every commit and it
> > > >    should be large enough to avoid wraparound problems.
> > > > 
> > > > 2) The less significant 16-bits of the generation ID is exposed through
> > > >    the nfgenmsg->res_id header field. This allows us to quickly catch
> > > >    if the ruleset has change between two consecutive list dumps from
> > > >    different object lists (in this specific case I think the risk of
> > > >    wraparound is unlikely).
> > > > 
> > > > 3) Userspace subscribers may receive notifications of new rule-set
> > > >    generation after every commit. This also provides an alternative
> > > >    way to monitor the generation ID. If the events are lost, the
> > > >    userspace process hits a overrun error, so it knows that it is
> > > >    working with a stale ruleset anyway.
> > > 
> > > Correct, there's just one thing to consider here, which is what happens
> > > once we add active ruleset state notifications, like counters, limit
> > > etc. At that point its not clear anymore whether changes have happened.
> > > OTOH it would be just a false positive, so at least things would keep
> > > working.
> > 
> > Right, I can put the genid notification in a different nfnetlink
> > multicast group (NFNLGRP_NFTABLES_GENID) to avoid false positives if
> > you like the idea, we have plenty of spare groups.
> 
> I don't think that's a really good idea since the ordering between the
> rule notifications and the commit notification wouldn't be reliable.
> Same thing is probably true for state notifications, not entirely
> sure yet if they could reasonably be sent to a different group.

Indeed, we have to stick to one single group.
