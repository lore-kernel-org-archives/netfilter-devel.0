From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: make comparision helpers stub functions in ZONES=n case
Date: Fri, 10 Jun 2016 23:09:01 +0200
Message-ID: <1465592941-18252-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36966 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbcFJVIp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 17:08:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Those comparisions are useless in case of ZONES=n; all conntracks
will reside in the same zone by definition.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_zones.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index 4e32512..bd46926 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -68,22 +68,34 @@ static inline bool nf_ct_zone_matches_dir(const struct nf_conntrack_zone *zone,
 static inline u16 nf_ct_zone_id(const struct nf_conntrack_zone *zone,
 				enum ip_conntrack_dir dir)
 {
+#ifdef CONFIG_NF_CONNTRACK_ZONES
 	return nf_ct_zone_matches_dir(zone, dir) ?
 	       zone->id : NF_CT_DEFAULT_ZONE_ID;
+#else
+	return NF_CT_DEFAULT_ZONE_ID;
+#endif
 }
 
 static inline bool nf_ct_zone_equal(const struct nf_conn *a,
 				    const struct nf_conntrack_zone *b,
 				    enum ip_conntrack_dir dir)
 {
+#ifdef CONFIG_NF_CONNTRACK_ZONES
 	return nf_ct_zone_id(nf_ct_zone(a), dir) ==
 	       nf_ct_zone_id(b, dir);
+#else
+	return true;
+#endif
 }
 
 static inline bool nf_ct_zone_equal_any(const struct nf_conn *a,
 					const struct nf_conntrack_zone *b)
 {
+#ifdef CONFIG_NF_CONNTRACK_ZONES
 	return nf_ct_zone(a)->id == b->id;
+#else
+	return true;
+#endif
 }
 #endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
 #endif /* _NF_CONNTRACK_ZONES_H */
-- 
2.7.3

