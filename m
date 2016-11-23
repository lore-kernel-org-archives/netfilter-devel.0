From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nat: fix crash when conntrack entry is re-used
Date: Wed, 23 Nov 2016 01:11:03 +0100
Message-ID: <1479859863-1067-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45254 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752188AbcKWAKq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2016 19:10:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stas Nichiporovich reports oops in nf_nat_bysource_cmp(), trying to
access nf_conn struct at address 0xffffffffffffff50.

This is the result of fetching a null rhash list (struct embedded at
offset 176; 0 - 176 gets us ...fff50).

The problem is that conntrack entries are allocated from a
SLAB_DESTROY_BY_RCU cache, i.e. entries can be free'd and reused
on another cpu while nf nat bysource hash access the same conntrack entry.

Freeing is fine (we hold rcu read lock); zeroing rhlist_head isn't.

-> Move the rhlist struct outside of the memset()-inited area.

Fixes: 7c9664351980aaa6a ("netfilter: move nat hlist_head to nf_conn")
Reported-by: Stas Nichiporovich <stasn77@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This is on top of https://patchwork.ozlabs.org/patch/695587/ .

 include/net/netfilter/nf_conntrack.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index dc143ada9762..d9d52c020a70 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -100,6 +100,9 @@ struct nf_conn {
 
 	possible_net_t ct_net;
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+	struct rhlist_head nat_bysource;
+#endif
 	/* all members below initialized via memset */
 	u8 __nfct_init_offset[0];
 
@@ -117,9 +120,6 @@ struct nf_conn {
 	/* Extensions */
 	struct nf_ct_ext *ext;
 
-#if IS_ENABLED(CONFIG_NF_NAT)
-	struct rhlist_head nat_bysource;
-#endif
 	/* Storage reserved for other modules, must be the last member */
 	union nf_conntrack_proto proto;
 };
-- 
2.7.3

