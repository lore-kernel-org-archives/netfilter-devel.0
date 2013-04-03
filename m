From: holger@eitzenberger.org
Subject: [PATCH RFC 2/2] icmp6: match on errors and informational messages
Date: Wed, 03 Apr 2013 16:27:31 +0200
Message-ID: <20130403144245.789797754@eitzenberger.org>
References: <20130403142729.484857089@eitzenberger.org>
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760328Ab3DCOms (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:42:48 -0400
Content-Disposition: inline; filename=net-next/icmp6-match-errors-and-info.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: linux-stable-3.8.y/include/uapi/linux/netfilter_ipv6/ip6_tables.h
===================================================================
--- linux-stable-3.8.y.orig/include/uapi/linux/netfilter_ipv6/ip6_tables.h	2013-04-03 09:59:41.000000000 +0200
+++ linux-stable-3.8.y/include/uapi/linux/netfilter_ipv6/ip6_tables.h	2013-04-03 15:20:25.000000000 +0200
@@ -185,11 +185,14 @@
 struct ip6t_icmp {
 	__u8 type;				/* type to match */
 	__u8 code[2];				/* range of code */
-	__u8 invflags;				/* Inverse flags */
+	__u8 flags;
 };
 
 /* Values for "inv" field for struct ipt_icmp. */
 #define IP6T_ICMP_INV	0x01	/* Invert the sense of type/code test */
+#define IP6T_ICMP_ERROR 0x02	/* Match any error type */
+#define IP6T_ICMP_INFO	0x04	/* Match any informational type */
+#define IP6T_ICMP_MASK	0x07
 
 /* The argument to IP6T_SO_GET_INFO */
 struct ip6t_getinfo {
Index: linux-stable-3.8.y/net/ipv6/netfilter/ip6_tables.c
===================================================================
--- linux-stable-3.8.y.orig/net/ipv6/netfilter/ip6_tables.c	2013-04-03 09:59:41.000000000 +0200
+++ linux-stable-3.8.y/net/ipv6/netfilter/ip6_tables.c	2013-04-03 15:19:26.000000000 +0200
@@ -2149,11 +2149,15 @@
 		return false;
 	}
 
+	if (icmpinfo->flags & IP6T_ICMP_ERROR)
+		return ic->icmp6_type < ICMPV6_ECHO_REQUEST;
+	if (icmpinfo->flags & IP6T_ICMP_INFO)
+		return ic->icmp6_type >= ICMPV6_ECHO_REQUEST;
 	return icmp6_type_code_match(icmpinfo->type,
 				     icmpinfo->code[0],
 				     icmpinfo->code[1],
 				     ic->icmp6_type, ic->icmp6_code,
-				     !!(icmpinfo->invflags&IP6T_ICMP_INV));
+				     !!(icmpinfo->flags & IP6T_ICMP_INV));
 }
 
 /* Called when user tries to insert an entry of this type. */
@@ -2161,8 +2165,8 @@
 {
 	const struct ip6t_icmp *icmpinfo = par->matchinfo;
 
-	/* Must specify no unknown invflags */
-	return (icmpinfo->invflags & ~IP6T_ICMP_INV) ? -EINVAL : 0;
+	/* Must specify no unknown flags */
+	return (icmpinfo->flags & ~IP6T_ICMP_MASK) ? -EINVAL : 0;
 }
 
 /* The built-in targets: standard (NULL) and error. */

