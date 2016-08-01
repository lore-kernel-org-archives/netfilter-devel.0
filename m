From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: don't set data_len to zero when returning pointers
Date: Mon,  1 Aug 2016 14:02:08 +0200
Message-ID: <1470052928-13111-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46887 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbcHAMCx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 08:02:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 399C1168389
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:02:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2BCAC114D68
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:02:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B4527FB468
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:02:44 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft already assumes that passing NULL as data_len is valid, otherwise
it crashes. Fix this by leave data_len unset in this specific case.

Fixes: bda7102 ("src: Fix nftnl_*_get_data() to return the real attribute length")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/dynset.c | 1 -
 src/set_elem.c    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 111bf8c..0eaa409 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -94,7 +94,6 @@ nftnl_expr_dynset_get(const struct nftnl_expr *e, uint16_t type,
 		*data_len = sizeof(dynset->set_id);
 		return &dynset->set_id;
 	case NFTNL_EXPR_DYNSET_EXPR:
-		*data_len = 0;
 		return dynset->expr;
 	}
 	return NULL;
diff --git a/src/set_elem.c b/src/set_elem.c
index 4e89210..7908661 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -184,7 +184,6 @@ const void *nftnl_set_elem_get(struct nftnl_set_elem *s, uint16_t attr, uint32_t
 		*data_len = s->user.len;
 		return s->user.data;
 	case NFTNL_SET_ELEM_EXPR:
-		*data_len = 0;
 		return s->expr;
 	}
 	return NULL;
-- 
2.1.4

