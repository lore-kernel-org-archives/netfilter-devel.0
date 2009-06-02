From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/9] netfilter: conntrack: remove events flags from userspace
	exposed file
Date: Tue, 02 Jun 2009 20:20:26 +0200
Message-ID: <20090602182026.18573.96355.stgit@Decadence>
References: <20090602181336.18573.85368.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37133 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbZFBS30 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:29:26 -0400
In-Reply-To: <20090602181336.18573.85368.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves the event flags from linux/netfilter/nf_conntrack_common.h
to net/netfilter/nf_conntrack_ecache.h. This flags are not of any use
from userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/nf_conntrack_common.h |   69 -------------------------
 include/net/netfilter/nf_conntrack_ecache.h   |   69 +++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 885cbe2..a8248ee 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -75,75 +75,6 @@ enum ip_conntrack_status {
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
 };
 
-/* Connection tracking event bits */
-enum ip_conntrack_events
-{
-	/* New conntrack */
-	IPCT_NEW_BIT = 0,
-	IPCT_NEW = (1 << IPCT_NEW_BIT),
-
-	/* Expected connection */
-	IPCT_RELATED_BIT = 1,
-	IPCT_RELATED = (1 << IPCT_RELATED_BIT),
-
-	/* Destroyed conntrack */
-	IPCT_DESTROY_BIT = 2,
-	IPCT_DESTROY = (1 << IPCT_DESTROY_BIT),
-
-	/* Timer has been refreshed */
-	IPCT_REFRESH_BIT = 3,
-	IPCT_REFRESH = (1 << IPCT_REFRESH_BIT),
-
-	/* Status has changed */
-	IPCT_STATUS_BIT = 4,
-	IPCT_STATUS = (1 << IPCT_STATUS_BIT),
-
-	/* Update of protocol info */
-	IPCT_PROTOINFO_BIT = 5,
-	IPCT_PROTOINFO = (1 << IPCT_PROTOINFO_BIT),
-
-	/* Volatile protocol info */
-	IPCT_PROTOINFO_VOLATILE_BIT = 6,
-	IPCT_PROTOINFO_VOLATILE = (1 << IPCT_PROTOINFO_VOLATILE_BIT),
-
-	/* New helper for conntrack */
-	IPCT_HELPER_BIT = 7,
-	IPCT_HELPER = (1 << IPCT_HELPER_BIT),
-
-	/* Update of helper info */
-	IPCT_HELPINFO_BIT = 8,
-	IPCT_HELPINFO = (1 << IPCT_HELPINFO_BIT),
-
-	/* Volatile helper info */
-	IPCT_HELPINFO_VOLATILE_BIT = 9,
-	IPCT_HELPINFO_VOLATILE = (1 << IPCT_HELPINFO_VOLATILE_BIT),
-
-	/* NAT info */
-	IPCT_NATINFO_BIT = 10,
-	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
-
-	/* Counter highest bit has been set, unused */
-	IPCT_COUNTER_FILLING_BIT = 11,
-	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
-
-	/* Mark is set */
-	IPCT_MARK_BIT = 12,
-	IPCT_MARK = (1 << IPCT_MARK_BIT),
-
-	/* NAT sequence adjustment */
-	IPCT_NATSEQADJ_BIT = 13,
-	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
-
-	/* Secmark is set */
-	IPCT_SECMARK_BIT = 14,
-	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
-};
-
-enum ip_conntrack_expect_events {
-	IPEXP_NEW_BIT = 0,
-	IPEXP_NEW = (1 << IPEXP_NEW_BIT),
-};
-
 #ifdef __KERNEL__
 struct ip_conntrack_stat
 {
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 0ff0dc6..892b8cd 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -11,6 +11,75 @@
 #include <net/net_namespace.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
+/* Connection tracking event bits */
+enum ip_conntrack_events
+{
+	/* New conntrack */
+	IPCT_NEW_BIT = 0,
+	IPCT_NEW = (1 << IPCT_NEW_BIT),
+
+	/* Expected connection */
+	IPCT_RELATED_BIT = 1,
+	IPCT_RELATED = (1 << IPCT_RELATED_BIT),
+
+	/* Destroyed conntrack */
+	IPCT_DESTROY_BIT = 2,
+	IPCT_DESTROY = (1 << IPCT_DESTROY_BIT),
+
+	/* Timer has been refreshed */
+	IPCT_REFRESH_BIT = 3,
+	IPCT_REFRESH = (1 << IPCT_REFRESH_BIT),
+
+	/* Status has changed */
+	IPCT_STATUS_BIT = 4,
+	IPCT_STATUS = (1 << IPCT_STATUS_BIT),
+
+	/* Update of protocol info */
+	IPCT_PROTOINFO_BIT = 5,
+	IPCT_PROTOINFO = (1 << IPCT_PROTOINFO_BIT),
+
+	/* Volatile protocol info */
+	IPCT_PROTOINFO_VOLATILE_BIT = 6,
+	IPCT_PROTOINFO_VOLATILE = (1 << IPCT_PROTOINFO_VOLATILE_BIT),
+
+	/* New helper for conntrack */
+	IPCT_HELPER_BIT = 7,
+	IPCT_HELPER = (1 << IPCT_HELPER_BIT),
+
+	/* Update of helper info */
+	IPCT_HELPINFO_BIT = 8,
+	IPCT_HELPINFO = (1 << IPCT_HELPINFO_BIT),
+
+	/* Volatile helper info */
+	IPCT_HELPINFO_VOLATILE_BIT = 9,
+	IPCT_HELPINFO_VOLATILE = (1 << IPCT_HELPINFO_VOLATILE_BIT),
+
+	/* NAT info */
+	IPCT_NATINFO_BIT = 10,
+	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
+
+	/* Counter highest bit has been set, unused */
+	IPCT_COUNTER_FILLING_BIT = 11,
+	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
+
+	/* Mark is set */
+	IPCT_MARK_BIT = 12,
+	IPCT_MARK = (1 << IPCT_MARK_BIT),
+
+	/* NAT sequence adjustment */
+	IPCT_NATSEQADJ_BIT = 13,
+	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
+
+	/* Secmark is set */
+	IPCT_SECMARK_BIT = 14,
+	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
+};
+
+enum ip_conntrack_expect_events {
+	IPEXP_NEW_BIT = 0,
+	IPEXP_NEW = (1 << IPEXP_NEW_BIT),
+};
+
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 struct nf_conntrack_ecache {
 	struct nf_conn *ct;

