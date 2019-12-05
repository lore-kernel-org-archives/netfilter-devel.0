Return-Path: <SRS0=LaOm=Z3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B71EC43603
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 18:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D12E24249
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 18:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfLESHO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 13:07:14 -0500
Received: from correo.us.es ([193.147.175.20]:54558 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbfLESHN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 13:07:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ED17CE2C41
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 19:07:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD005DA707
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 19:07:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2A98DA702; Thu,  5 Dec 2019 19:07:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA0B5DA703
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 19:07:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Dec 2019 19:07:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9FFA84265A5A
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 19:07:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_set_rbtree: bogus lookup/get on consecutive elements in named sets
Date:   Thu,  5 Dec 2019 19:07:06 +0100
Message-Id: <20191205180706.134232-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The existing rbtree implementation might store consecutive elements
where the closing element and the opening element might overlap, eg.

	[ a, a+1) [ a+1, a+2)

This patch removes the optimization for non-anonymous sets in the exact
matching case, where it is assumed to stop searching in case that the
closing element is found. Instead, invalidate candidate interval and
keep looking further in the tree.

This patch fixes the lookup and get operations.

Fixes: e701001e7cbe ("netfilter: nft_rbtree: allow adjacent intervals with dynamic updates")
Fixes: ba0e4d9917b4 ("netfilter: nf_tables: get set elements via netlink")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 57123259452f..510169e28065 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -74,8 +74,13 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 				parent = rcu_dereference_raw(parent->rb_left);
 				continue;
 			}
-			if (nft_rbtree_interval_end(rbe))
-				goto out;
+			if (nft_rbtree_interval_end(rbe)) {
+				if (set->flags & NFT_SET_ANONYMOUS)
+					return false;
+				parent = rcu_dereference_raw(parent->rb_left);
+				interval = NULL;
+				continue;
+			}
 
 			*ext = &rbe->ext;
 			return true;
@@ -88,7 +93,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 		*ext = &interval->ext;
 		return true;
 	}
-out:
+
 	return false;
 }
 
@@ -141,6 +146,8 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 		} else {
 			if (!nft_set_elem_active(&rbe->ext, genmask))
 				parent = rcu_dereference_raw(parent->rb_left);
+				continue;
+			}
 
 			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
 			    (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END) ==
@@ -148,7 +155,11 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 				*elem = rbe;
 				return true;
 			}
-			return false;
+
+			if (nft_rbtree_interval_end(rbe))
+				interval = NULL;
+
+			parent = rcu_dereference_raw(parent->rb_left);
 		}
 	}
 
-- 
2.11.0

