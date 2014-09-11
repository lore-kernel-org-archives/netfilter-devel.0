From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/3 v2] netfilter: nf_tables: export rule-set
 generation ID
Date: Thu, 11 Sep 2014 18:35:35 +0100
Message-ID: <20140911173531.GI7600@acer.localdomain>
References: <1410448819-6694-1-git-send-email-pablo@netfilter.org>
 <1410448819-6694-3-git-send-email-pablo@netfilter.org>
 <20140911153243.GE7600@acer.localdomain>
 <20140911161040.GA5824@salvia>
 <20140911164558.GF7600@acer.localdomain>
 <20140911165731.GA6965@salvia>
 <20140911172210.GA3246@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33011 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaIKRgI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:36:08 -0400
Content-Disposition: inline
In-Reply-To: <20140911172210.GA3246@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 11, 2014 at 07:22:10PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 11, 2014 at 06:57:31PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Sep 11, 2014 at 05:45:58PM +0100, Patrick McHardy wrote:
> > > > 
> > > > Right, I can put the genid notification in a different nfnetlink
> > > > multicast group (NFNLGRP_NFTABLES_GENID) to avoid false positives if
> > > > you like the idea, we have plenty of spare groups.
> > > 
> > > I don't think that's a really good idea since the ordering between the
> > > rule notifications and the commit notification wouldn't be reliable.
> > > Same thing is probably true for state notifications, not entirely
> > > sure yet if they could reasonably be sent to a different group.
> > 
> > Indeed, we have to stick to one single group.
> 
> Oh, you can subscribe to several groups from one single socket. So you
> get them notifications in order. IIRC, the grouping just provides a
> way to filter out what you don't want to listen.
> 

Correct, but at that point we're back to square one because we don't
know why the error orginated :)
