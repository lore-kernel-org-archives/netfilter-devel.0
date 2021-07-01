Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C9A0C11F64
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jul 2021 05:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767A96144E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jul 2021 05:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhGAFFW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 01:05:22 -0400
Received: from relay.sw.ru ([185.231.240.75]:50874 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231998AbhGAFFV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 01:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=X3MmUqEsAghnHJMiItDz1JOvURpLinQ6obuSK3/4bBM=; b=CMzKGWuWDG9kLvWokWq
        b7ddyOfhTziVxxR5PwlTY3dDRwsUgL4qRtjJbdioClx0FT+RCWnlw4EVQVsMs4DpWGpFhd7wAR9rI
        Su8gvIRDwJw9rgcHlHrpVx/Sykzq6tPSQG8OTs4wmplVv53j+bfyrklEjNHBKkoWvnHW//hzfiY=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lYVtx-002Tjv-9k; Thu, 01 Jul 2021 08:02:50 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NETFILTER v2] netfilter: nfnetlink: suspicious RCU usage in
 ctnetlink_dump_helpinfo
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Taehee Yoo <ap420073@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Message-ID: <3b140111-8af0-176f-d3d0-567e8051eaf4@virtuozzo.com>
Date:   Thu, 1 Jul 2021 08:02:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Two patches listed below removed ctnetlink_dump_helpinfo call from under
rcu_read_lock. Now its rcu_dereference generates following warning:
=============================
WARNING: suspicious RCU usage
5.13.0+ #5 Not tainted
-----------------------------
net/netfilter/nf_conntrack_netlink.c:221 suspicious rcu_dereference_check() usage!

other info that might help us debug this:
rcu_scheduler_active = 2, debug_locks = 1
stack backtrace:
CPU: 1 PID: 2251 Comm: conntrack Not tainted 5.13.0+ #5
Call Trace:
 dump_stack+0x7f/0xa1
 ctnetlink_dump_helpinfo+0x134/0x150 [nf_conntrack_netlink]
 ctnetlink_fill_info+0x2c2/0x390 [nf_conntrack_netlink]
 ctnetlink_dump_table+0x13f/0x370 [nf_conntrack_netlink]
 netlink_dump+0x10c/0x370
 __netlink_dump_start+0x1a7/0x260
 ctnetlink_get_conntrack+0x1e5/0x250 [nf_conntrack_netlink]
 nfnetlink_rcv_msg+0x613/0x993 [nfnetlink]
 netlink_rcv_skb+0x50/0x100
 nfnetlink_rcv+0x55/0x120 [nfnetlink]
 netlink_unicast+0x181/0x260
 netlink_sendmsg+0x23f/0x460
 sock_sendmsg+0x5b/0x60
 __sys_sendto+0xf1/0x160
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0x36/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 49ca022bccc5 ("netfilter: ctnetlink: don't dump ct extensions of unconfirmed conntracks")
Fixes: 0b35f6031a00 ("netfilter: Remove duplicated rcu_read_lock.")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
v2: resent, original message was graylisted

 net/netfilter/nf_conntrack_netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8690fc07030f..f3e8e6ce82c4 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -218,6 +218,7 @@ static int ctnetlink_dump_helpinfo(struct sk_buff *skb,
 	if (!help)
 		return 0;
 
+	rcu_read_lock();
 	helper = rcu_dereference(help->helper);
 	if (!helper)
 		goto out;
@@ -233,9 +234,11 @@ static int ctnetlink_dump_helpinfo(struct sk_buff *skb,
 
 	nla_nest_end(skb, nest_helper);
 out:
+	rcu_read_unlock();
 	return 0;
 
 nla_put_failure:
+	rcu_read_unlock();
 	return -1;
 }
 
-- 
2.25.1

