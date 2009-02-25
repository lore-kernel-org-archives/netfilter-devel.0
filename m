From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: conntrack: don't deliver events for racy packets
Date: Wed, 25 Feb 2009 03:53:34 +0100
Message-ID: <20090225025334.4646.98606.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57436 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753645AbZBYCxr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:53:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch skips the delivery of conntrack events if the packet
was drop due to a race condition in the conntrack insertion.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack_core.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index c25068e..5a449b4 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -62,7 +62,8 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	if (ct && ct != &nf_conntrack_untracked) {
 		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 			ret = __nf_conntrack_confirm(skb);
-		nf_ct_deliver_cached_events(ct);
+		if (likely(ret == NF_ACCEPT))
+			nf_ct_deliver_cached_events(ct);
 	}
 	return ret;
 }

