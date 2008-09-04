From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 03/04]: netfilter: nf_conntrack_gre: nf_ct_gre_keymap_flush() fixlet
Date: Thu,  4 Sep 2008 16:15:57 +0200 (MEST)
Message-ID: <20080904141557.6414.90200.sendpatchset@x2.localnet>
References: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62500 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYIDOP6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:15:58 -0400
In-Reply-To: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 73826640c5b48cd471ceca2d904e34b96ba0ecf8
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Thu Sep 4 14:22:06 2008 +0200

    netfilter: nf_conntrack_gre: nf_ct_gre_keymap_flush() fixlet
    
    It does "kfree(list_head)" which looks wrong because entity that was
    allocated is definitely not list_head.
    
    However, this all works because list_head is first item in
    struct nf_ct_gre_keymap.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index b308bb4..9bd0396 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -45,12 +45,12 @@ static LIST_HEAD(gre_keymap_list);
 
 void nf_ct_gre_keymap_flush(void)
 {
-	struct list_head *pos, *n;
+	struct nf_ct_gre_keymap *km, *tmp;
 
 	write_lock_bh(&nf_ct_gre_lock);
-	list_for_each_safe(pos, n, &gre_keymap_list) {
-		list_del(pos);
-		kfree(pos);
+	list_for_each_entry_safe(km, tmp, &gre_keymap_list, list) {
+		list_del(&km->list);
+		kfree(km);
 	}
 	write_unlock_bh(&nf_ct_gre_lock);
 }
