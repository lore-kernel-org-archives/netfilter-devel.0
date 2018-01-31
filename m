From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [patch 1/1] net/netfilter/x_tables.c: make allocation less
 aggressive
Date: Wed, 31 Jan 2018 09:08:05 +0100
Message-ID: <20180131080805.GN21609@dhcp22.suse.cz>
References: <5a70c7c3.JeIh2XMA2ZATeitK%akpm@linux-foundation.org>
 <1517342038.3715.97.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        fw@strlen.de
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47719 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbeAaIIH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jan 2018 03:08:07 -0500
Content-Disposition: inline
In-Reply-To: <1517342038.3715.97.camel@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue 30-01-18 11:53:58, Eric Dumazet wrote:
[...]
> How is __GFP_NORETRY working exactly ?

this is what the documentation says.
 * __GFP_NORETRY: The VM implementation will try only very lightweight
 *   memory direct reclaim to get some memory under memory pressure (thus
 *   it can sleep). It will avoid disruptive actions like OOM killer. The
 *   caller must handle the failure which is quite likely to happen under
 *   heavy memory pressure. The flag is suitable when failure can easily be
 *   handled at small cost, such as reduced throughput

> Surely, if some firewall tools attempt to load a new iptables rules, we
> do not want to abort them if the request can be satisfied after few
> pages moved on swap or written back to disk.

I am not sure this really goes along with "namespace admin can request
arbitrary amount of memory" very well.
 
> We want to avoid huge allocations, but leave reasonable ones succeed.

Yes, that would be the best way forward. From the previous discussion
with Florian [1] it seems that "reasonable" is not that easy to figure
out. Anyway, this patch merely gets us back to pre eacd86ca3b03 times
where __GFP_NORETRY has been used for both kmalloc and vmalloc paths.
So it is more a quick band aid than a longterm solution.

[1] http://lkml.kernel.org/r/20180129165722.GF5906@breakpoint.cc
-- 
Michal Hocko
SUSE Labs
