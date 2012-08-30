From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race
 condition against ctnetlink_del_conntrack
Date: Thu, 30 Aug 2012 12:34:37 +0200
Message-ID: <20120830103437.GA13756@1984>
References: <7353554.n89QJXU3eh@gentoovm>
 <5427975.6moJlq4F9d@gentoovm>
 <20120830025009.GA16782@1984>
 <5239380.eElFyXbOPg@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43619 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab2H3Kem (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Aug 2012 06:34:42 -0400
Content-Disposition: inline
In-Reply-To: <5239380.eElFyXbOPg@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 30, 2012 at 05:09:01AM +0200, Oliver wrote:
> On Thursday 30 August 2012 04:50:09 you wrote:
> > Not sure what you mean, you're still crashing with the patch below,
> > right?
> > 
> > My proposal is to give a try to the ecache patch, that requires
> > removing the previous patch.
> 
> Apologies for the confusion;  the patch quoted is essentially the first patch 
> you provided me, with my changes to make it work in 3.4.10 *plus* the deletion 
> of the change to nf_conntrack_ecache.h where your patch deleted the 
> nf_ct_is_dying() check (i.e I have this check left in) - with this 
> modification, I find that conntrackd is well-behaved and I have thus far not 
> successfully caused a kernel panic.
> 
> Having tested your latest patch, I can also confirm that it also does not 
> crash, including at exhaustion of the conntrack table.
>
> In terms of overall stability, I would presume your latest patch is superior 
> to the previous (i.e. what I attached most recently) ?

Yes, I prefer the second patch. There is still races in the first
patch I sent you, harder to trigger, but still there.

There are several cleanups I'd like to recover from the first patch
though. Would you help testing them?

Thanks a lot for testing.
