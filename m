From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race condition against ctnetlink_del_conntrack
Date: Thu, 30 Aug 2012 05:09:01 +0200
Message-ID: <5239380.eElFyXbOPg@gentoovm>
References: <7353554.n89QJXU3eh@gentoovm> <5427975.6moJlq4F9d@gentoovm> <20120830025009.GA16782@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:39129 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab2H3DIs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Aug 2012 23:08:48 -0400
In-Reply-To: <20120830025009.GA16782@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 30 August 2012 04:50:09 you wrote:
> Not sure what you mean, you're still crashing with the patch below,
> right?
> 
> My proposal is to give a try to the ecache patch, that requires
> removing the previous patch.

Apologies for the confusion;  the patch quoted is essentially the first patch 
you provided me, with my changes to make it work in 3.4.10 *plus* the deletion 
of the change to nf_conntrack_ecache.h where your patch deleted the 
nf_ct_is_dying() check (i.e I have this check left in) - with this 
modification, I find that conntrackd is well-behaved and I have thus far not 
successfully caused a kernel panic.

Having tested your latest patch, I can also confirm that it also does not 
crash, including at exhaustion of the conntrack table.

In terms of overall stability, I would presume your latest patch is superior 
to the previous (i.e. what I attached most recently) ?

Kind Regards,
Oliver
