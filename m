From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: delete the old cache when dumping is interrupted
Date: Wed, 17 May 2017 20:14:07 +0200
Message-ID: <20170517181407.GA15476@salvia>
References: <20170514075612.29226-1-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56670 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754329AbdEQSOU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 May 2017 14:14:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 04012396275
        for <netfilter-devel@vger.kernel.org>; Wed, 17 May 2017 20:14:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA05DFF2F7
        for <netfilter-devel@vger.kernel.org>; Wed, 17 May 2017 20:14:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC5A0FF2CF
        for <netfilter-devel@vger.kernel.org>; Wed, 17 May 2017 20:14:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170514075612.29226-1-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 14, 2017 at 03:56:12PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> When the dumping operation is interrupted, we will restart the
> cache_init(), but unfortunatly, we forget to delete the old cache.
> So in extreme case, we will leak a huge amount of memory.
> 
> Running the following commands can simulate the extreme case:
>   # nft add table t
>   # nft add set t s {type inet_service \;}
>   # for i in $(seq 65000); do
>   nft add element t s {$i}
>   done &
>   # while : ; do
>   time nft list ruleset -nn
>   done
> 
> After a while, oom killer will be triggered:
>   [ 2808.243537] Out of memory: Kill process 16975 (nft) score 649 or
>                  sacrifice child
>   [ 2808.255372] Killed process 16975 (nft) total-vm:1955348kB,
>                  anon-rss:1952120kB, file-rss:0kB, shmem-rss:0kB
>   [ 2858.353729] nft invoked oom-killer: gfp_mask=0x14201ca(GFP_HIGHUSER_
>                  MOVABLE|__GFP_COLD), nodemask=(null),  order=0,
>                  oom_score_adj=0
>   [ 2858.374521] nft cpuset=/ mems_allowed=0
>   ...

Applied, thanks.
