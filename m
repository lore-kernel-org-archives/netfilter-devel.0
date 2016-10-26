From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: avoid excess memory allocation
Date: Wed, 26 Oct 2016 23:46:17 +0200
Message-ID: <1477518377-26894-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57986 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932673AbcJZVqr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2016 17:46:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is now a fixed-size extension, so we don't need to pass a variable
alloc size.  This (harmless) error results in allocating 32 instead of
the needed 16 bytes for this extension as the size gets passed twice.

Fixes: 23014011ba420 ("netfilter: conntrack: support a fixed size of 128 distinct labels")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
index 498814626e28..1723a67c0b0a 100644
--- a/include/net/netfilter/nf_conntrack_labels.h
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -30,8 +30,7 @@ static inline struct nf_conn_labels *nf_ct_labels_ext_add(struct nf_conn *ct)
 	if (net->ct.labels_used == 0)
 		return NULL;
 
-	return nf_ct_ext_add_length(ct, NF_CT_EXT_LABELS,
-				    sizeof(struct nf_conn_labels), GFP_ATOMIC);
+	return nf_ct_ext_add(ct, NF_CT_EXT_LABELS, GFP_ATOMIC);
 #else
 	return NULL;
 #endif
-- 
2.7.3

