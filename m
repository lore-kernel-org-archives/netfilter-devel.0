Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075C3C77B73
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 May 2023 06:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbjEaGc3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 May 2023 02:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjEaGc2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2023 02:32:28 -0400
X-Greylist: delayed 356 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 May 2023 23:32:25 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2C999;
        Tue, 30 May 2023 23:32:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 76FECCC02B5;
        Wed, 31 May 2023 08:26:24 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 31 May 2023 08:26:22 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id C902ECC02B4;
        Wed, 31 May 2023 08:26:21 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id B5ECD3431A9; Wed, 31 May 2023 08:26:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id B4B253431A8;
        Wed, 31 May 2023 08:26:21 +0200 (CEST)
Date:   Wed, 31 May 2023 08:26:21 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: [PATCH v1 nf] netfilter: ipset: Add schedule point in
 call_ad().
In-Reply-To: <20230518173300.34531-1-kuniyu@amazon.com>
Message-ID: <75355720-85d0-7c50-bc41-522924585336@netfilter.org>
References: <20230518173300.34531-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 18 May 2023, Kuniyuki Iwashima wrote:

> syzkaller found a repro that causes Hung Task [0] with ipset.  The repro
> first creates an ipset and then tries to delete a large number of IPs
> from the ipset concurrently:
> 
>   IPSET_ATTR_IPADDR_IPV4 : 172.20.20.187
>   IPSET_ATTR_CIDR        : 2
> 
> The first deleting thread hogs a CPU with nfnl_lock(NFNL_SUBSYS_IPSET)
> held, and other threads wait for it to be released.
> 
> Previously, the same issue existed in set->variant->uadt() that could run
> so long under ip_set_lock(set).  Commit 5e29dc36bd5e ("netfilter: ipset:
> Rework long task execution when adding/deleting entries") tried to fix it,
> but the issue still exists in the caller with another mutex.
> 
> While adding/deleting many IPs, we should release the CPU periodically to
> prevent someone from abusing ipset to hang the system.
> 
> Note we need to increment the ipset's refcnt to prevent the ipset from
> being destroyed while rescheduling.
> 
> [0]:
> INFO: task syz-executor174:268 blocked for more than 143 seconds.
>       Not tainted 6.4.0-rc1-00145-gba79e9a73284 #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor174 state:D stack:0     pid:268   ppid:260    flags:0x0000000d
> Call trace:
>  __switch_to+0x308/0x714 arch/arm64/kernel/process.c:556
>  context_switch kernel/sched/core.c:5343 [inline]
>  __schedule+0xd84/0x1648 kernel/sched/core.c:6669
>  schedule+0xf0/0x214 kernel/sched/core.c:6745
>  schedule_preempt_disabled+0x58/0xf0 kernel/sched/core.c:6804
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0x6fc/0xdb0 kernel/locking/mutex.c:747
>  __mutex_lock_slowpath+0x14/0x20 kernel/locking/mutex.c:1035
>  mutex_lock+0x98/0xf0 kernel/locking/mutex.c:286
>  nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
>  nfnetlink_rcv_msg+0x480/0x70c net/netfilter/nfnetlink.c:295
>  netlink_rcv_skb+0x1c0/0x350 net/netlink/af_netlink.c:2546
>  nfnetlink_rcv+0x18c/0x199c net/netfilter/nfnetlink.c:658
>  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>  netlink_unicast+0x664/0x8cc net/netlink/af_netlink.c:1365
>  netlink_sendmsg+0x6d0/0xa4c net/netlink/af_netlink.c:1913
>  sock_sendmsg_nosec net/socket.c:724 [inline]
>  sock_sendmsg net/socket.c:747 [inline]
>  ____sys_sendmsg+0x4b8/0x810 net/socket.c:2503
>  ___sys_sendmsg net/socket.c:2557 [inline]
>  __sys_sendmsg+0x1f8/0x2a4 net/socket.c:2586
>  __do_sys_sendmsg net/socket.c:2595 [inline]
>  __se_sys_sendmsg net/socket.c:2593 [inline]
>  __arm64_sys_sendmsg+0x80/0x94 net/socket.c:2593
>  __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>  invoke_syscall+0x84/0x270 arch/arm64/kernel/syscall.c:52
>  el0_svc_common+0x134/0x24c arch/arm64/kernel/syscall.c:142
>  do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:193
>  el0_svc+0x2c/0x7c arch/arm64/kernel/entry-common.c:637
>  el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
>  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/netfilter/ipset/ip_set_core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 46ebee9400da..9a6b64779e64 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1694,6 +1694,14 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
>  	bool eexist = flags & IPSET_FLAG_EXIST, retried = false;
>  
>  	do {
> +		if (retried) {
> +			__ip_set_get(set);
> +			nfnl_unlock(NFNL_SUBSYS_IPSET);
> +			cond_resched();
> +			nfnl_lock(NFNL_SUBSYS_IPSET);
> +			__ip_set_put(set);
> +		}
> +
>  		ip_set_lock(set);
>  		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
>  		ip_set_unlock(set);
> -- 

The patch looks fine to me, thanks!

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
