From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nf-next 0/3] netfilter: x_tables: pack percpu counter
 allocations
Date: Sun, 4 Dec 2016 21:09:38 +0100
Message-ID: <20161204200938.GA32460@salvia>
References: <1479822259-28786-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60532 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751003AbcLDUKN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 15:10:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A7ECBB6C6B
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:09:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99448DA853
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:09:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C310DA849
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:09:43 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479822259-28786-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 22, 2016 at 02:44:16PM +0100, Florian Westphal wrote:
> ... to speed up iptables(-restore) calls.
> 
> Especially a pattern like
> 
> for i in $(seq 1 1000) ; iptables -A FORWARD ;done
> 
> is expensive, because adding the rule doubles the percpu counters (allocate
> 		2nd blob, then free old one, including its percpu counters).
> This causes frequent expansion and shrinking of percpu memory pool.
> 
> This change batches calls to the allocator by packing multiple counters
> in 4k memory chunks.
> 
> Heavily based on suggestions from Eric Dumazet.
> 
> The only change in v3 is in patch #2 which assigned garbage on UP
> (was fixed by next patch, but better to not do it in first place).

Series applied, thanks!
