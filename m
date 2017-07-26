From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: x_tables: Fix use-after-free in ipt_do_table.
Date: Wed, 26 Jul 2017 09:25:09 +0900
Message-ID: <20170726002509.4028-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34395 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbdGZA0A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 20:26:00 -0400
Received: by mail-pg0-f65.google.com with SMTP id v190so15774215pgv.1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 17:26:00 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If verdict is NF_DROP in the target, the skb is freed.
However, ipt_do_table() always tries to get ip header from the skb.
So that, KASAN triggers the use-after-free message.

We can reproduce this message using below command.
  # iptables -I INPUT -p tcp -j SYNPROXY --mss 1460

[ 193.542265] BUG: KASAN: use-after-free in ipt_do_table+0x1405/0x1c10
[ ... ]
[ 193.578603] Call Trace:
[ 193.581590] <IRQ>
[ 193.584107] dump_stack+0x68/0xa0
[ 193.588168] print_address_description+0x78/0x290
[ 193.593828] ? ipt_do_table+0x1405/0x1c10
[ 193.598690] kasan_report+0x230/0x340
[ 193.603194] __asan_report_load2_noabort+0x19/0x20
[ 193.608950] ipt_do_table+0x1405/0x1c10
[ 193.613591] ? rcu_read_lock_held+0xae/0xd0
[ 193.618631] ? ip_route_input_rcu+0x27d7/0x4270
[ 193.624348] ? ipt_do_table+0xb68/0x1c10
[ 193.629124] ? do_add_counters+0x620/0x620
[ 193.634234] ? iptable_filter_net_init+0x60/0x60
[ ... ]

After this patch, only when verdict is XT_CONTINUE,
ipt_do_table() tries to get ip header.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv4/netfilter/ip_tables.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2a55a40..622ed28 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -352,13 +352,14 @@ ipt_do_table(struct sk_buff *skb,
 		acpar.targinfo = t->data;
 
 		verdict = t->u.kernel.target->target(skb, &acpar);
-		/* Target might have changed stuff. */
-		ip = ip_hdr(skb);
-		if (verdict == XT_CONTINUE)
+		if (verdict == XT_CONTINUE) {
+			/* Target might have changed stuff. */
+			ip = ip_hdr(skb);
 			e = ipt_next_entry(e);
-		else
+		} else {
 			/* Verdict */
 			break;
+		}
 	} while (!acpar.hotdrop);
 
 	xt_write_recseq_end(addend);
-- 
2.9.3

