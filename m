From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ctnetlink: fix incorrect nf_ct_put during
 hash resize
Date: Wed, 24 May 2017 12:24:44 +0200
Message-ID: <20170524102444.GA23086@salvia>
References: <1495322569-63361-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39524 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969405AbdEXKYu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 06:24:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25A461EF5E5
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 12:24:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 164E0FF2F6
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 12:24:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9F1710078E
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 12:24:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1495322569-63361-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 21, 2017 at 07:22:49AM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> If nf_conntrack_htable_size was adjusted by the user during the ct
> dump operation, we may invoke nf_ct_put twice for the same ct, i.e.
> the "last" ct. This will cause the ct will be freed but still linked
> in hash buckets.
> 
> It's very easy to reproduce the problem by the following commands:
>   # while : ; do
>   echo $RANDOM > /proc/sys/net/netfilter/nf_conntrack_buckets
>   done
>   # while : ; do
>   conntrack -L
>   done
>   # iperf -s 127.0.0.1 &
>   # iperf -c 127.0.0.1 -P 60 -t 36000
> 
> After a while, the system will hang like this:
>   NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [bash:20184]
>   NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [iperf:20382]
>   ...
> 
> So at last if we find cb->args[1] is equal to "last", this means hash
> resize happened, then we can set cb->args[1] to 0 to fix the above
> issue.

Applied, thanks.

I have added:

Fixes: d205dc40798d ("[NETFILTER]: ctnetlink: fix deadlock in table dumping")
