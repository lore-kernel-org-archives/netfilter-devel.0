From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH V2] netfilter: x_tables: Fix use-after-free in ipt_do_table.
Date: Wed, 26 Jul 2017 18:16:47 +0900
Message-ID: <20170726091648.20639-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38041 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdGZJQy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2017 05:16:54 -0400
Received: by mail-pf0-f194.google.com with SMTP id c23so15007074pfe.5
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 02:16:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If verdict is NF_STOLEN in the SYNPROXY target,
the skb is consumed.
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
V2:
 - Change commit log message.

V1:
 - Initial Version

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

