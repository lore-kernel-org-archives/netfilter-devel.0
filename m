From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH nf] netfilter: conntrack: refine gc worker heuristics,
 redux
Date: Mon, 16 Jan 2017 17:42:58 +0100
Message-ID: <1fa618d3-4c2a-72f1-d5f8-ddfadc6ad029@6wind.com>
References: <1484564166-5886-1-git-send-email-fw@strlen.de>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: nuclearcat@nuclearcat.com
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37283 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdAPQnB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 11:43:01 -0500
Received: by mail-wm0-f46.google.com with SMTP id c206so183518108wme.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 08:43:01 -0800 (PST)
In-Reply-To: <1484564166-5886-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 16/01/2017 à 11:56, Florian Westphal a écrit :
> This further refines the changes made to conntrack gc_worker in
> commit e0df8cae6c16 ("netfilter: conntrack: refine gc worker heuristics").
> 
> The main of this change is to reduce the scan interval when evictions
> take place.
> 
> However, on the reporters' setup, there are 1-2 Million conntrack entries
> in total, and roughly 8k new connections per second.
> 
> In this case we'll always evict at least one entry per gc cycle and scan
> interval is always at 1 jiffy.
> 
> Given we scan ~10k entries per run its clearly wrong to reduce interval
> based on number of evictions, it will only waste cpu cycles.
> 
> Thus only look at the ratio (scanned entries vs. evicted entries) to make
> a decision on whether to reduce or not.
> 
> Given the fact that evictor is supposed to only kick in when system turns
> idle after a busy period, we should pick a high ratio -- this makes it 50%.
> 
> Also, get rid of GC_MAX_EVICTS.  Instead of breaking loop and instant
> resched, just don't bother checking this at all (the loop calls
> cond_resched for every bucket anyway).
> 
> Removal of GC_MAX_EVICTS was suggested by Nicolas in the past; I
> should have listened.
I (still) agree with that part, maybe it could be done in another patch.

> 
> I tested this with a vm under synflood (with
> sysctl net.netfilter.nf_conntrack_tcp_timeout_syn_recv=3).
> 
> While flood is ongoing, interval now stays at 2 seconds even though
> evictions are ongoing.
> 
> After stopping flood, table got cleaned up in less than 10 seconds.
> 
> Reported-by: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Thank you for CCing me ;-)

> Fixes: b87a2f9199ea82eaadc ("netfilter: conntrack: add gc worker to remove timed-out entries")
> Signed-off-by: Florian Westphal <fw@strlen.de>
With that patch, it's worse than before. I regularly have a delay > 30 seconds
in my tests (this was infrequent before the patch).

A solution, to fix the balance between cpu cycles consumption and short ct
events delays may be to introduce a new sysctl which allows the user to choose
between two predefined configs: short delay or long delay for ct events.
Even if I don't like this, maybe it could be acceptable with a default value set
to 'short delay'.


Regards,
Nicolas
