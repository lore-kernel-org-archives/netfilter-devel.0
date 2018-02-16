From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 0/2] netfilter: ipt_CLUSTERIP: two more fixes
Date: Fri, 16 Feb 2018 14:57:32 +0100
Message-ID: <20180216135731.whazhomjq4wrwkor@salvia>
References: <20180216114933.23667-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032862AbeBPN5e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 08:57:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0C5822EFEA4
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2018 14:57:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F18E6DA787
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2018 14:57:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180216114933.23667-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 16, 2018 at 12:49:31PM +0100, Florian Westphal wrote:
> During code audit I found two more bugs in CLUSTERIP,
> first one is a refcount leak, second is possible use-after free
> due to kfree() of rcu-protected (and already visible) structure.
> 
> I think its time to remove this target, so, if anyone has a good
> reason to not nuke it in nf-next please let me know soon.

We have the cluster match replacement that has been around for ~10
years, it just needs an extra arptable rules.

So I'm fine with this nuke, actually I remember we talked about
deprecating it.
