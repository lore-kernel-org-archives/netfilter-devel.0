From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net v2] netfilter: drop outermost socket lock in
 getsockopt()
Date: Wed, 14 Feb 2018 20:44:24 +0100
Message-ID: <20180214194424.kdsvn2swo3b4ldy5@salvia>
References: <a4752d0887579496c5db267d9db7ff77719436d8.1518088560.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Xin Long <lucien.xin@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33138 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163061AbeBNTo3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 14:44:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14635FFB79
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:44:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04C9CDA729
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:44:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <a4752d0887579496c5db267d9db7ff77719436d8.1518088560.git.pabeni@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 08, 2018 at 12:19:00PM +0100, Paolo Abeni wrote:
> The Syzbot reported a possible deadlock in the netfilter area caused by
> rtnl lock, xt lock and socket lock being acquired with a different order
> on different code paths, leading to the following backtrace:
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 4.15.0+ #301 Not tainted
> ------------------------------------------------------
> syzkaller233489/4179 is trying to acquire lock:
>   (rtnl_mutex){+.+.}, at: [<0000000048e996fd>] rtnl_lock+0x17/0x20
> net/core/rtnetlink.c:74
> 
> but task is already holding lock:
>   (&xt[i].mutex){+.+.}, at: [<00000000328553a2>]
> xt_find_table_lock+0x3e/0x3e0 net/netfilter/x_tables.c:1041
> 
> which lock already depends on the new lock.
> ===
> 
> Since commit 3f34cfae1230 ("netfilter: on sockopt() acquire sock lock
> only in the required scope"), we already acquire the socket lock in
> the innermost scope, where needed. In such commit I forgot to remove
> the outer-most socket lock from the getsockopt() path, this commit
> addresses the issues dropping it now.

Applied, thanks.
