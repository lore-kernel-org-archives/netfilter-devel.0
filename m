From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 02/04]: netfilter: nf_conntrack_gre: more locking around keymap list
Date: Thu,  4 Sep 2008 16:15:56 +0200 (MEST)
Message-ID: <20080904141556.6414.7786.sendpatchset@x2.localnet>
References: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62495 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYIDOP5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:15:57 -0400
In-Reply-To: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f36591226052551244397113ddccb7677c9f3dbf
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Thu Sep 4 14:22:06 2008 +0200

    netfilter: nf_conntrack_gre: more locking around keymap list
    
    gre_keymap_list should be protected in all places.
    (unless I'm misreading something)
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 654a4f7..b308bb4 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -97,10 +97,14 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	kmp = &help->help.ct_pptp_info.keymap[dir];
 	if (*kmp) {
 		/* check whether it's a retransmission */
+		read_lock_bh(&nf_ct_gre_lock);
 		list_for_each_entry(km, &gre_keymap_list, list) {
-			if (gre_key_cmpfn(km, t) && km == *kmp)
+			if (gre_key_cmpfn(km, t) && km == *kmp) {
+				read_unlock_bh(&nf_ct_gre_lock);
 				return 0;
+			}
 		}
+		read_unlock_bh(&nf_ct_gre_lock);
 		pr_debug("trying to override keymap_%s for ct %p\n",
 			 dir == IP_CT_DIR_REPLY ? "reply" : "orig", ct);
 		return -EEXIST;
