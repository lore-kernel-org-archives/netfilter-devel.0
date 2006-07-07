From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/10][CONNTRACK] mark conntrack event
Date: Fri, 07 Jul 2006 04:12:24 +0200
Message-ID: <44ADC308.3020504@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060409000304040000040507"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060409000304040000040507
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch introduces the mark event. ctnetlink can use this to know if
the mark needs to be dumped.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris


--------------060409000304040000040507
Content-Type: text/plain;
 name="01mark.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01mark.patch"

[CONNTRACK] mark conntrack event

This patch introduces the mark event. ctnetlink can use this to know if
the mark needs to be dumped.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/include/linux/netfilter/nf_conntrack_common.h
===================================================================
--- net-2.6.orig/include/linux/netfilter/nf_conntrack_common.h	2006-07-06 18:24:40.000000000 +0200
+++ net-2.6/include/linux/netfilter/nf_conntrack_common.h	2006-07-06 18:31:52.000000000 +0200
@@ -125,6 +125,10 @@
 	/* Counter highest bit has been set */
 	IPCT_COUNTER_FILLING_BIT = 11,
 	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
+
+	/* Mark is set */
+	IPCT_MARK_BIT = 12,
+	IPCT_MARK = (1 << IPCT_MARK_BIT),
 };
 
 enum ip_conntrack_expect_events {
Index: net-2.6/net/netfilter/xt_CONNMARK.c
===================================================================
--- net-2.6.orig/net/netfilter/xt_CONNMARK.c	2006-07-06 18:24:40.000000000 +0200
+++ net-2.6/net/netfilter/xt_CONNMARK.c	2006-07-06 18:36:23.000000000 +0200
@@ -52,13 +52,25 @@
 	    switch(markinfo->mode) {
 	    case XT_CONNMARK_SET:
 		newmark = (*ctmark & ~markinfo->mask) | markinfo->mark;
-		if (newmark != *ctmark)
+		if (newmark != *ctmark) {
 		    *ctmark = newmark;
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+		    ip_conntrack_event_cache(IPCT_MARK, *pskb);
+#else
+		    nf_conntrack_event_cache(IPCT_MARK, *pskb);
+#endif
+		}
 		break;
 	    case XT_CONNMARK_SAVE:
 		newmark = (*ctmark & ~markinfo->mask) | ((*pskb)->nfmark & markinfo->mask);
-		if (*ctmark != newmark)
+		if (*ctmark != newmark) {
 		    *ctmark = newmark;
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+		    ip_conntrack_event_cache(IPCT_MARK, *pskb);
+#else
+		    nf_conntrack_event_cache(IPCT_MARK, *pskb);
+#endif
+		}
 		break;
 	    case XT_CONNMARK_RESTORE:
 		nfmark = (*pskb)->nfmark;

--------------060409000304040000040507--
