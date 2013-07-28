From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/5] netfilter: nf_conntrack: remove net_ratelimit() for LOG_INVALID()
Date: Sun, 28 Jul 2013 22:54:07 +0200
Message-ID: <1375044851-12471-2-git-send-email-kaber@trash.net>
References: <1375044851-12471-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45253 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3G1VCn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Jul 2013 17:02:43 -0400
In-Reply-To: <1375044851-12471-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Logging of invalid packets has to be explicitly enabled. Rate-limiting these
messages is inconsistent with other netfilter logging features and makes
debugging harder.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 914d8d9..b411d7b 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -148,17 +148,10 @@ extern int nf_ct_port_nlattr_tuple_size(void);
 extern const struct nla_policy nf_ct_port_nla_policy[];
 
 #ifdef CONFIG_SYSCTL
-#ifdef DEBUG_INVALID_PACKETS
 #define LOG_INVALID(net, proto)				\
 	((net)->ct.sysctl_log_invalid == (proto) ||	\
 	 (net)->ct.sysctl_log_invalid == IPPROTO_RAW)
 #else
-#define LOG_INVALID(net, proto)				\
-	(((net)->ct.sysctl_log_invalid == (proto) ||	\
-	  (net)->ct.sysctl_log_invalid == IPPROTO_RAW)	\
-	 && net_ratelimit())
-#endif
-#else
 static inline int LOG_INVALID(struct net *net, int proto) { return 0; }
 #endif /* CONFIG_SYSCTL */
 
-- 
1.8.1.4

