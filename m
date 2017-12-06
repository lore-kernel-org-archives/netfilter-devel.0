From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH ipset nf-next] netfilter: ipset: add resched points
 during set listing
Date: Wed, 6 Dec 2017 09:18:48 +0100
Message-ID: <20171206081848.GB4027@salvia>
References: <20171130200805.2895-1-fw@strlen.de>
 <alpine.DEB.2.11.1712012018190.26668@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752410AbdLFISw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 03:18:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B51B0C0B2B
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 09:18:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4FDADA80E
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 09:18:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1712012018190.26668@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 01, 2017 at 08:25:55PM +0100, Jozsef Kadlecsik wrote:
> Hi Florian,
> 
> On Thu, 30 Nov 2017, Florian Westphal wrote:
> 
> > When sets are extremely large we can get softlockup during ipset -L. We 
> > could fix this by adding cond_resched_rcu() at the right location during 
> > iteration, but this only works if RCU nesting depth is 1.
> > 
> > At this time entire variant->list() is called under under 
> > rcu_read_lock_bh. This used to be a read_lock_bh() but as rcu doesn't 
> > really lock anything, it does not appear to be needed, so remove it 
> > (ipset increments set reference count before this, so a set deletion 
> > should not be possible).
> 
> Yes, the call of rcu_read_lock_bh() seems to be unnecessary, the
> set->variant->list() functions protect the sensitive parts with 
> rcu_read_lock() anyway. Thanks!
> 
> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Also applied, thanks.
