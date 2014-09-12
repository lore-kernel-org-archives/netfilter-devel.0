From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3 v2] netfilter: nf_tables: export rule-set
 generation ID
Date: Fri, 12 Sep 2014 09:47:46 +0200
Message-ID: <20140912074746.GA4580@salvia>
References: <1410448819-6694-1-git-send-email-pablo@netfilter.org>
 <1410448819-6694-3-git-send-email-pablo@netfilter.org>
 <20140911153243.GE7600@acer.localdomain>
 <20140911161040.GA5824@salvia>
 <20140911164558.GF7600@acer.localdomain>
 <20140911165731.GA6965@salvia>
 <20140911172210.GA3246@salvia>
 <20140911173531.GI7600@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39266 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbaILHq7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:46:59 -0400
Content-Disposition: inline
In-Reply-To: <20140911173531.GI7600@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 11, 2014 at 06:35:35PM +0100, Patrick McHardy wrote:
> On Thu, Sep 11, 2014 at 07:22:10PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Sep 11, 2014 at 06:57:31PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Sep 11, 2014 at 05:45:58PM +0100, Patrick McHardy wrote:
> > > > > 
> > > > > Right, I can put the genid notification in a different nfnetlink
> > > > > multicast group (NFNLGRP_NFTABLES_GENID) to avoid false positives if
> > > > > you like the idea, we have plenty of spare groups.
> > > > 
> > > > I don't think that's a really good idea since the ordering between the
> > > > rule notifications and the commit notification wouldn't be reliable.
> > > > Same thing is probably true for state notifications, not entirely
> > > > sure yet if they could reasonably be sent to a different group.
> > > 
> > > Indeed, we have to stick to one single group.
> > 
> > Oh, you can subscribe to several groups from one single socket. So you
> > get them notifications in order. IIRC, the grouping just provides a
> > way to filter out what you don't want to listen.
> > 
> 
> Correct, but at that point we're back to square one because we don't
> know why the error orginated :)

Right. I'm considering the (likely spamming) stateful notifications
that we'll have at some point. Those we can put them in
NFNLGRP_NFTABLES_STATES or something similar.  So we leave
NFNLGRP_NFTABLES for rule-set updates only (including the genid
notification, of course).
