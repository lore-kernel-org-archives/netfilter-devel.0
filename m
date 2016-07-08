From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: constify arg to is_dying/confirmed
Date: Fri,  8 Jul 2016 13:08:50 +0200
Message-ID: <1467976130-5902-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34179 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405AbcGHLId (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jul 2016 07:08:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 2a5133e..9bea5b4 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -266,12 +266,12 @@ static inline int nf_ct_is_template(const struct nf_conn *ct)
 }
 
 /* It's confirmed if it is, or has been in the hash table. */
-static inline int nf_ct_is_confirmed(struct nf_conn *ct)
+static inline int nf_ct_is_confirmed(const struct nf_conn *ct)
 {
 	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
 
-static inline int nf_ct_is_dying(struct nf_conn *ct)
+static inline int nf_ct_is_dying(const struct nf_conn *ct)
 {
 	return test_bit(IPS_DYING_BIT, &ct->status);
 }
-- 
2.7.3

