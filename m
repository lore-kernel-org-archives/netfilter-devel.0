From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC] netfilter: nf_tables: extend tracing infrastructure
Date: Tue, 17 Nov 2015 11:40:03 +0100
Message-ID: <20151117104003.GA16707@salvia>
References: <20151109133608.GD8098@macbook.localdomain>
 <1447343209-28029-1-git-send-email-fw@strlen.de>
 <20151116215635.GA6601@salvia>
 <20151117000352.GC14892@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53048 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbbKQKkI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Nov 2015 05:40:08 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D016F11D8E1
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2015 11:40:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BFDC11BC642
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2015 11:40:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BCF971BC64E
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2015 11:40:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151117000352.GC14892@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 17, 2015 at 01:03:52AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > 
> > BTW, any reason to remove the existing infrastructure? It's been there
> > since almost the beginning (this would break users that are expecting
> > the existing behaviour).
> 
> No specific reason, but I question the need to keep it around.
> Once we have native tooling there should be no reason whatsover
> to wade through dmesg output + manual matching of rules...

It is not only dmesg.

You can also configure this thing to send trace messages through
nfnetlink_log through group 0.

> its just a PITA and thats why I removed it -- 'nft monitor trace'
> (or whatever, I've not decided on what nft side should look like)
> would be much simpler/easier to use.

It's always a PITA to keep extra code around to keep things
compatible, but there is no other way to deprecate things.

Don't forget this tracing infrastructure has been there for nearly two
years.

[...]
> Wouldn't it make more sense to convince people to go with real nft
> rather than the compat layer?

I wish there could be a way to "convice" users to move in a quick way,
but there is not. We can just provide something better and wait for
quite some time to deprecate things.

> If you don't mind, i would prefer to work on this patch + nft +
> libnftables integration and then submit that formally.

I would like to see a nice netlink-based tracing infrastructure like
the one you're currently shaping, no question about that.
