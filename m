From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/7] netfilter: conntrack: don't send destroy events from
 iterator
Date: Fri, 9 Aug 2013 12:08:34 +0200
Message-ID: <20130809100834.GA7670@localhost>
References: <1375105316-13216-1-git-send-email-fw@strlen.de>
 <1375105316-13216-7-git-send-email-fw@strlen.de>
 <20130731170436.GF25900@localhost>
 <20130731204359.GA27170@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53034 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934235Ab3HIKIp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:08:45 -0400
Content-Disposition: inline
In-Reply-To: <20130731204359.GA27170@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 31, 2013 at 10:43:59PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Jul 29, 2013 at 03:41:55PM +0200, Florian Westphal wrote:
> > > Let nf_ct_delete handle delivery of the DESTROY event.
> > > 
> > > This means we now also no longer send such events for conntracks that
> > > are still unconfirmed.
> > 
> > Not sure why this happens by looking at the patch. Are you refering to
> > conntrack with IPS_CONFIRMED unset?
> 
> Doh.  You are right of course.
> 
> get_next_corpse also iterates over the unconfirmed list, and ivokes
> iter() for those (and iter is kill_report() which calls
> nf_conntrack_event_report()).
> 
> But nf_conntrack_event_report() just returns in !IPS_CONFIRMED case.
> 
> Thanks for pointing it out.

Removed that line from the description and applied this patch. Thanks Florian.
