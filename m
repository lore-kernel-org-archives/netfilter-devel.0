Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3B3C001DB
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Sep 2023 18:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjIBS5G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Sep 2023 14:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjIBS5F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Sep 2023 14:57:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C9EAED
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Sep 2023 11:57:01 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nf] netfilter: nf_tables: ensure audit reset access to table under rcu read side lock
Date:   Sat,  2 Sep 2023 20:56:56 +0200
Message-Id: <20230902185656.12022-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The table list iteration holds rcu read lock side, but recent audit code
dereferences table object out of the rcu read lock side:

[ 4137.407349] BUG: unable to handle page fault for address: 00000000001f3c50
[ 4137.407357] #PF: supervisor read access in kernel mode
[ 4137.407359] #PF: error_code(0x0000) - not-present page
[ 4137.407360] PGD 0 P4D 0
[ 4137.407363] Oops: 0000 [#1] PREEMPT SMP PTI
[ 4137.407365] CPU: 4 PID: 500177 Comm: nft Not tainted 6.5.0+ #277
[ 4137.407369] RIP: 0010:string+0x49/0xd0
[ 4137.407374] Code: ff 77 36 45 89 d1 31 f6 49 01 f9 66 45 85 d2 75 19 eb 1e 49 39 f8 76 02 88 07 48 83 c7 01 83 c6 01 48 83 c2 01 4c 39 cf 74 07 <0f> b6 02 84 c0 75 e2 4c 89 c2 e9 58 e5 ff ff 48 c7 c0 0e b2 ff 81
[ 4137.407377] RSP: 0018:ffff8881179737f0 EFLAGS: 00010286
[ 4137.407379] RAX: 00000000001f2c50 RBX: ffff888117973848 RCX: ffff0a00ffffff04
[ 4137.407380] RDX: 00000000001f3c50 RSI: 0000000000000000 RDI: 0000000000000000
[ 4137.407381] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000ffffffff
[ 4137.407383] R10: ffffffffffffffff R11: ffff88813584d200 R12: 0000000000000000
[ 4137.407384] R13: ffffffffa15cf709 R14: 0000000000000000 R15: ffffffffa15cf709
[ 4137.407385] FS:  00007fcfc18bb580(0000) GS:ffff88840e700000(0000) knlGS:0000000000000000
[ 4137.407387] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4137.407388] CR2: 00000000001f3c50 CR3: 00000001055b2001 CR4: 00000000001706e0
[ 4137.407390] Call Trace:
[ 4137.407392]  <TASK>
[ 4137.407393]  ? __die+0x1b/0x60
[ 4137.407397]  ? page_fault_oops+0x6b/0xa0
[ 4137.407399]  ? exc_page_fault+0x60/0x120
[ 4137.407403]  ? asm_exc_page_fault+0x22/0x30
[ 4137.407408]  ? string+0x49/0xd0
[ 4137.407410]  vsnprintf+0x257/0x4f0
[ 4137.407414]  kvasprintf+0x3e/0xb0
[ 4137.407417]  kasprintf+0x3e/0x50
[ 4137.407419]  nf_tables_dump_rules+0x1c0/0x360 [nf_tables]
[ 4137.407439]  ? __alloc_skb+0xc3/0x170
[ 4137.407442]  netlink_dump+0x170/0x330
[ 4137.407447]  __netlink_dump_start+0x227/0x300
[ 4137.407449]  nf_tables_getrule+0x205/0x390 [nf_tables]

Fixes: ea078ae9108e ("netfilter: nf_tables: Audit log rule reset")
Fixes: 7e9be1124dbe ("netfilter: nf_tables: Audit log setelem reset")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2c81cee858d6..68aa8e4ea2e2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3538,11 +3538,12 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 			break;
 	}
 done:
-	rcu_read_unlock();
 
 	if (reset && idx > cb->args[0])
 		audit_log_rule_reset(table, cb->seq, idx - cb->args[0]);
 
+	rcu_read_unlock();
+
 	cb->args[0] = idx;
 	return skb->len;
 }
@@ -5760,8 +5761,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (!args.iter.err && args.iter.count == cb->args[0])
 		args.iter.err = nft_set_catchall_dump(net, skb, set,
 						      reset, cb->seq);
-	rcu_read_unlock();
-
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
@@ -5769,6 +5768,8 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 		audit_log_nft_set_reset(table, cb->seq,
 					args.iter.count - args.iter.skip);
 
+	rcu_read_unlock();
+
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
 		return args.iter.err;
 	if (args.iter.count == cb->args[0])
-- 
2.30.2

