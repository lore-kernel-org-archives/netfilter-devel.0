From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft crap] ct original ip saddr ... handling
Date: Wed, 28 Jun 2017 18:35:45 +0200
Message-ID: <20170628163545.GA3874@salvia>
References: <20170628100659.26976-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45960 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751489AbdF1Qfy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 12:35:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 40D4B25D48
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jun 2017 18:35:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31EE7DA57E
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jun 2017 18:35:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A092D1D96
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jun 2017 18:35:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 28, 2017 at 12:06:42PM +0200, Florian Westphal wrote:
> I am running out of time so I have to send this unfinished/non-working
> state.
> 
> It breaks because ct is riddled with conflicts,
> in nft we've handled original/reply as STRING to avoid conflicts
> with 'arp reply', so we cannot add
> 
> ct original ip saddr
> 
> because it is
> ct STRING	IP	SADDR
> 
> and that conflicts with basic use where 'ip saddr' could be payload
> expression, and STRING is one of the normal ct tokens and not a direction.
> 
> I am trying to fix this here by moving all ct keywords back to tokens.

Yes. We have a very compact syntax here, tokens helps bison decide
where to go. If we would have a well-structure syntax, looking less
human-readable, it would be more simple. But given what we have, we
have to use many tokens.

> There are no shift/reduce errors, things compile fine, and all
> test cases work.  Its just that we break 'ct event set label':
> 
> Works:
> ct event set new or reply
> ct event set new,reply
> ct event set new,label
> fails:
> ct event set label ('expects COMMA')

This can be fixed, it's just a matter we need more time, right?

No problem, we can take the time.

Thanks for working on this!
