From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v2 2/2] iptables-restore: support acquiring the
 lock.
Date: Fri, 17 Mar 2017 14:20:03 +0100
Message-ID: <20170317132003.GC12186@salvia>
References: <20170316075502.2337-1-lorenzo@google.com>
 <20170316075502.2337-3-lorenzo@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jscherpelz@google.com,
        subashab@codeaurora.org, zlpnobody@gmail.com,
        Narayan Kamath <narayan@google.com>
To: Lorenzo Colitti <lorenzo@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41674 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751018AbdCQN2n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 09:28:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26F7AFF2C7
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:20:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0C53CA6CE
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:20:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44244A7CD3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:20:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170316075502.2337-3-lorenzo@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Lorenzo,

On Thu, Mar 16, 2017 at 04:55:02PM +0900, Lorenzo Colitti wrote:
> Currently, ip[6]tables-restore does not perform any locking, so it
> is not safe to use concurrently with ip[6]tables.
> 
> This patch makes ip[6]tables-restore wait for the lock if -w
> was specified. Arguments to -w and -W are supported in the same
> was as they are in ip[6]tables.
> 
> The lock is not acquired on startup. Instead, it is acquired when
> a new table handle is created (on encountering '*') and released
> when the table is committed (COMMIT). This makes it possible to
> keep long-running iptables-restore processes in the background
> (for example, reading commands from a pipe opened by a system
> management daemon) and simultaneously run iptables commands.
> 
> If -w is not specified, then the command proceeds without taking
> the lock.
> 
> Tested as follows:
> 
> 1. Run iptables-restore -w, and check that iptables commands work
>    with or without -w.
> 2. Type "*filter" into the iptables-restore input. Verify that
>    a) ip[6]tables commands without -w fail with "another app is
>       currently holding the xtables lock...".
>    b) ip[6]tables commands with "-w 2" fail after 2 seconds.
>    c) ip[6]tables commands with "-w" hang until "COMMIT" is
>       typed into the iptables-restore window.
> 3. With the lock held by an ip6tables-restore process:
>      strace -e flock /tmp/iptables/sbin/iptables-restore -w 1 -W 100000
>    shows 11 calls to flock and fails.
> 4. Run an iptables-restore with -w and one without -w, and check:
>    a) Type "*filter" in the first and then the second, and the
>       second exits with an error.
>    b) Type "*filter" in the second and "*filter" "-S" "COMMIT"
>       into the first. The rules are listed only when the first
>       copy sees "COMMIT".

My concern with this is that one iptables-restore instance may
postpone any other iptables call indefinitely, by simply typing
"*filter" with no COMMIT ever.

The other instance can simply kill this process, as they would be both
running with CAP_NET_ADMIN though.
