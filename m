From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 8/9] libiptc: use a family-invariant xtc_ops struct for code reduction
Date: Sun, 11 Sep 2011 17:35:57 +0200
Message-ID: <1315755359-7012-9-git-send-email-jengelh@medozas.de>
References: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51846 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab1IKPgK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 11:36:10 -0400
In-Reply-To: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libiptc/libip6tc.h  |    2 ++
 include/libiptc/libiptc.h   |    2 ++
 include/libiptc/xtcshared.h |   13 +++++++++++++
 libiptc/Makefile.am         |    4 ++--
 libiptc/libip4tc.c          |    1 +
 libiptc/libip6tc.c          |    1 +
 libiptc/libiptc.c           |   12 ++++++++++++
 7 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 61c1e7f..c656bc4 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -159,4 +159,6 @@ int ipv6_prefix_length(const struct in6_addr *a);
 
 extern void dump_entries6(struct xtc_handle *const);
 
+extern const struct xtc_ops ip6tc_ops;
+
 #endif /* _LIBIP6TC_H */
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index 6f64f5a..24cdbdb 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -162,6 +162,8 @@ const char *iptc_strerror(int err);
 
 extern void dump_entries(struct xtc_handle *const);
 
+extern const struct xtc_ops iptc_ops;
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/include/libiptc/xtcshared.h b/include/libiptc/xtcshared.h
index 89a5151..773ebc4 100644
--- a/include/libiptc/xtcshared.h
+++ b/include/libiptc/xtcshared.h
@@ -3,5 +3,18 @@
 
 typedef char xt_chainlabel[32];
 struct xtc_handle;
+struct xt_counters;
+
+struct xtc_ops {
+	int (*commit)(struct xtc_handle *);
+	void (*free)(struct xtc_handle *);
+	int (*builtin)(const char *, struct xtc_handle *const);
+	int (*is_chain)(const char *, struct xtc_handle *const);
+	int (*flush_entries)(const xt_chainlabel, struct xtc_handle *);
+	int (*create_chain)(const xt_chainlabel, struct xtc_handle *);
+	int (*set_policy)(const xt_chainlabel, const xt_chainlabel,
+			  struct xt_counters *, struct xtc_handle *);
+	const char *(*strerror)(int);
+};
 
 #endif /* _LIBXTC_SHARED_H */
diff --git a/libiptc/Makefile.am b/libiptc/Makefile.am
index 22c920f..0b59007 100644
--- a/libiptc/Makefile.am
+++ b/libiptc/Makefile.am
@@ -10,6 +10,6 @@ libiptc_la_SOURCES  =
 libiptc_la_LIBADD   = libip4tc.la libip6tc.la
 libiptc_la_LDFLAGS  = -version-info 0:0:0 ${libiptc_LDFLAGS2}
 libip4tc_la_SOURCES = libip4tc.c
-libip4tc_la_LDFLAGS = -version-info 0:0:0
+libip4tc_la_LDFLAGS = -version-info 1:0:1
 libip6tc_la_SOURCES = libip6tc.c
-libip6tc_la_LDFLAGS = -version-info 0:0:0 ${libiptc_LDFLAGS2}
+libip6tc_la_LDFLAGS = -version-info 1:0:1 ${libiptc_LDFLAGS2}
diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index c55cbc7..dd59951 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -90,6 +90,7 @@ typedef unsigned int socklen_t;
 #define TC_STRERROR		iptc_strerror
 #define TC_NUM_RULES		iptc_num_rules
 #define TC_GET_RULE		iptc_get_rule
+#define TC_OPS			iptc_ops
 
 #define TC_AF			AF_INET
 #define TC_IPPROTO		IPPROTO_IP
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index 9febee3..7128e1c 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -88,6 +88,7 @@ typedef unsigned int socklen_t;
 #define TC_STRERROR		ip6tc_strerror
 #define TC_NUM_RULES		ip6tc_num_rules
 #define TC_GET_RULE		ip6tc_get_rule
+#define TC_OPS			ip6tc_ops
 
 #define TC_AF			AF_INET6
 #define TC_IPPROTO		IPPROTO_IPV6
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 593c5de..63fcfc2 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -33,6 +33,7 @@
 #include <sys/socket.h>
 #include <stdbool.h>
 #include <xtables.h>
+#include <libiptc/xtcshared.h>
 
 #include "linux_list.h"
 
@@ -2731,3 +2732,14 @@ TC_STRERROR(int err)
 
 	return strerror(err);
 }
+
+const struct xtc_ops TC_OPS = {
+	.commit        = TC_COMMIT,
+	.free          = TC_FREE,
+	.builtin       = TC_BUILTIN,
+	.is_chain      = TC_IS_CHAIN,
+	.flush_entries = TC_FLUSH_ENTRIES,
+	.create_chain  = TC_CREATE_CHAIN,
+	.set_policy    = TC_SET_POLICY,
+	.strerror      = TC_STRERROR,
+};
-- 
1.7.3.4

