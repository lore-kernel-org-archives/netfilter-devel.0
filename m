From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 2/7] Kill bogus memsets
Date: Mon, 01 Aug 2005 19:04:57 +0200
Message-ID: <42EE5639.6070808@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020103080602020509010109"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------020103080602020509010109
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

nfattr_parse_attributes already set to zero the array of nfattr, so such 
initialization isn't required.

--------------020103080602020509010109
Content-Type: text/x-patch;
 name="01kill-memset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01kill-memset.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-01 16:20:26.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-01 16:25:00.000000000 +0200
@@ -479,7 +479,6 @@
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
-	memset(tb, 0, CTA_IP_MAX * sizeof(tb));
 	
 	if (nfattr_parse_nested(tb, CTA_IP_MAX, attr) < 0)
 		goto nfattr_failure;
@@ -522,8 +521,6 @@
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
-	memset(tb, 0, CTA_PROTO_MAX * sizeof(tb));
-	
 	if (nfattr_parse_nested(tb, CTA_PROTO_MAX, attr) < 0)
 		goto nfattr_failure;
 
@@ -556,7 +553,6 @@
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
-	memset(tb, 0, CTA_TUPLE_MAX * sizeof(tb));
 	memset(tuple, 0, sizeof(*tuple));
 
 	if (nfattr_parse_nested(tb, CTA_TUPLE_MAX, cda[type-1]) < 0)
@@ -607,8 +603,6 @@
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
-	memset(tb, 0, CTA_PROTONAT_MAX * sizeof(tb));
-
 	if (nfattr_parse_nested(tb, CTA_PROTONAT_MAX, attr) < 0)
 		goto nfattr_failure;
 
@@ -646,7 +640,6 @@
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
-	memset(tb, 0, CTA_NAT_MAX * sizeof(tb));
 	memset(range, 0, sizeof(*range));
 	
 	if (nfattr_parse_nested(tb, CTA_NAT_MAX, cda[CTA_NAT-1]) < 0)
@@ -684,7 +677,6 @@
 	struct nfattr *tb[CTA_HELP_MAX];
 
 	DEBUGP("entered %s\n", __FUNCTION__);
-	memset(tb, 0, CTA_HELP_MAX * sizeof(tb));
 
 	if (nfattr_parse_nested(tb, CTA_HELP_MAX, attr) < 0)
 		goto nfattr_failure;

--------------020103080602020509010109--
