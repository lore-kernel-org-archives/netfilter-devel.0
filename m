From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 17:43:16 +0100
Message-ID: <20151126164316.GA4495@salvia>
References: <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
 <20151126150726.GD32716@breakpoint.cc>
 <20151126151229.GA3412@salvia>
 <20151126152410.GN16828@macbook.localdomain>
 <20151126155426.GA4108@salvia>
 <20151126160227.GQ16828@macbook.localdomain>
 <20151126161529.GA4350@salvia>
 <20151126162528.GS16828@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Michal Kubecek <mkubecek@suse.cz>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45067 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbbKZQn2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 11:43:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E93ED9663D
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 17:43:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D1846DA7E0
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 17:43:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DB105DA80B
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 17:43:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151126162528.GS16828@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 26, 2015 at 04:25:28PM +0000, Patrick McHardy wrote:
> > This doesn't sound so complicated to me:
> > 
> >         add rule filter prerouting \
> >                 ip protocol { tcp, udp, sctp } track
> > 
> > You just specify what you need for stateful tracking.
> 
> Sure, or "filter prerouting track" for everything. Let's stay at that
> example because it will be a common case and we don't know anything about
> protocols.
>
> > The case above you indicate is enabling conntrack for all packets, the
> > -j CT --track is what should govern this IMO.
> 
> How does it prevent exactly that case we're talking about - someone is
> saying "CT --track" without further qualification and means "track
> everything".

That indeed means to me track everything based on what conntrack knows
how to track.

> And the SCTP connection tracking module is not available or not
> loaded.

If the module is not available, then this is a custom kernel
compilation. IMO we should focus on providing good defaults to typical
kernel that are included by most distributors.

If the SCTP tracker becomes part of nf_conntrack by default, then we
don't have to worry about the "SCTP module not loaded" case.
