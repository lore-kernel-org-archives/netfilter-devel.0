From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] iptables: nft: fix memory leaks in nft_fini
Date: Mon,  2 Dec 2013 11:45:14 +0100
Message-ID: <1385981114-3131-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50443 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3LBKsH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:48:07 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so9868536wgh.23
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Dec 2013 02:48:06 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Those errors are shown with valgrind tool:

valgrind --leak-check=full xtables -A INPUT -i eth0 -p tcp --dport 80

==12554== 40 bytes in 1 blocks are still reachable in loss record 1 of 10
==12554==    at 0x4C2935B: malloc (vg_replace_malloc.c:270)
==12554==    by 0x574D755: mnl_nlmsg_batch_start (nlmsg.c:447)
==12554==    by 0x416520: nft_action (nft.c:2281)
==12554==    by 0x41355E: xtables_main (xtables-standalone.c:75)
==12554==    by 0x5B87994: (below main) (libc-start.c:260)

==12554== 135,168 bytes in 1 blocks are still reachable in loss record 9 of 10
==12554==    at 0x4C2935B: malloc (vg_replace_malloc.c:270)
==12554==    by 0x415A24: mnl_nft_batch_alloc (nft.c:102)
==12554==    by 0x416520: nft_action (nft.c:2281)
==12554==    by 0x41355E: xtables_main (xtables-standalone.c:75)
==12554==    by 0x5B87994: (below main) (libc-start.c:260)

These objects are allocated from nft_init but they were not released
appropriately in the exit path.
---
 iptables/nft.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 0599beb..a015947 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -618,6 +618,8 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
 void nft_fini(struct nft_handle *h)
 {
 	mnl_socket_close(h->nl);
+	free(mnl_nlmsg_batch_head(h->batch));
+	mnl_nlmsg_batch_stop(h->batch);
 }
 
 int nft_table_add(struct nft_handle *h, const struct nft_table *t)
-- 
1.8.4.rc3

