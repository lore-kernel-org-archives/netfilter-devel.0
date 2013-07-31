From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 6/7] netfilter: conntrack: don't send destroy events from
 iterator
Date: Wed, 31 Jul 2013 22:43:59 +0200
Message-ID: <20130731204359.GA27170@breakpoint.cc>
References: <1375105316-13216-1-git-send-email-fw@strlen.de>
 <1375105316-13216-7-git-send-email-fw@strlen.de>
 <20130731170436.GF25900@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34015 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757339Ab3GaUoB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:44:01 -0400
Content-Disposition: inline
In-Reply-To: <20130731170436.GF25900@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jul 29, 2013 at 03:41:55PM +0200, Florian Westphal wrote:
> > Let nf_ct_delete handle delivery of the DESTROY event.
> > 
> > This means we now also no longer send such events for conntracks that
> > are still unconfirmed.
> 
> Not sure why this happens by looking at the patch. Are you refering to
> conntrack with IPS_CONFIRMED unset?

Doh.  You are right of course.

get_next_corpse also iterates over the unconfirmed list, and ivokes
iter() for those (and iter is kill_report() which calls
nf_conntrack_event_report()).

But nf_conntrack_event_report() just returns in !IPS_CONFIRMED case.

Thanks for pointing it out.
