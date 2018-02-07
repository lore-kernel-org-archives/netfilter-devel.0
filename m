From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: remove useless prototype
Date: Wed,  7 Feb 2018 11:50:41 +0900
Message-ID: <20180207025041.9569-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:42434 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752439AbeBGCut (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 21:50:49 -0500
Received: by mail-pf0-f194.google.com with SMTP id b25so1547764pfd.9
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Feb 2018 18:50:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

prototype nf_ct_nat_offset is not used anymore.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/netfilter/nf_conntrack.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f5223bf..062dc19 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -213,11 +213,6 @@ static inline bool nf_ct_kill(struct nf_conn *ct)
 	return nf_ct_delete(ct, 0, 0);
 }
 
-/* These are for NAT.  Icky. */
-extern s32 (*nf_ct_nat_offset)(const struct nf_conn *ct,
-			       enum ip_conntrack_dir dir,
-			       u32 seq);
-
 /* Set all unconfirmed conntrack as dying */
 void nf_ct_unconfirmed_destroy(struct net *);
 
-- 
2.9.3

