From: Krzysztof Oledzki <ole@ans.pl>
Subject: [PATCH 1/3] Add ICMPv6 support in libnetfilter_conntrack
Date: Mon, 24 Mar 2008 03:05:35 +0100
Message-ID: <47e70c6f.atN8uVjpm1W+EHK3%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:35812 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbYCXCF6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 22:05:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This rather trivial patch adds ICMPv6 support for libnetfilter_conntrack,
but only for the new API - deprecated/extensions was left unchanged.

Before:
# conntrack -E
    [NEW] unknown  58 30 src=::1 dst=::1 [UNREPLIED] src=::1 dst=::1
 [UPDATE] unknown  58 30 src=::1 dst=::1 src=::1 dst=::1
[DESTROY] unknown  58 src=::1 dst=::1 packets=1 bytes=104 src=::1 dst=::1 packets=0 bytes=0

After:
# conntrack -E 
    [NEW] icmpv6   58 30 src=::1 dst=::1 type=128 code=0 id=38737 [UNREPLIED] src=::1 dst=::1 type=129 code=0 id=38737
 [UPDATE] icmpv6   58 30 src=::1 dst=::1 type=128 code=0 id=38737 src=::1 dst=::1 type=129 code=0 id=38737
[DESTROY] icmpv6   58 src=::1 dst=::1 type=128 code=0 id=38737 packets=1 bytes=104 src=::1 dst=::1 type=129 code=0 id=38737 packets=0 bytes=0

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur libnetfilter_conntrack-20080309-orig/src/conntrack/build.c libnetfilter_conntrack-20080309-tmp/src/conntrack/build.c
--- libnetfilter_conntrack-20080309-orig/src/conntrack/build.c	2008-02-09 21:01:39.000000000 +0100
+++ libnetfilter_conntrack-20080309-tmp/src/conntrack/build.c	2008-03-23 20:30:05.000000000 +0100
@@ -55,6 +55,7 @@
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_DST_PORT,
 			       &t->l4dst.tcp.port, sizeof(u_int16_t));
 		break;
+
 	case IPPROTO_ICMP:
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_CODE,
 			       &t->l4dst.icmp.code, sizeof(u_int8_t));
@@ -63,6 +64,16 @@
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_ID,
 			       &t->l4src.icmp.id, sizeof(u_int16_t));
 		break;
+
+	case IPPROTO_ICMPV6:
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMPV6_CODE,
+			       &t->l4dst.icmp.code, sizeof(u_int8_t));
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMPV6_TYPE,
+			       &t->l4dst.icmp.type, sizeof(u_int8_t));
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMPV6_ID,
+			       &t->l4src.icmp.id, sizeof(u_int16_t));
+		break;
+
 	default:
 		break;
 	}
diff -Nur libnetfilter_conntrack-20080309-orig/src/conntrack/parse.c libnetfilter_conntrack-20080309-tmp/src/conntrack/parse.c
--- libnetfilter_conntrack-20080309-orig/src/conntrack/parse.c	2008-02-09 21:01:39.000000000 +0100
+++ libnetfilter_conntrack-20080309-tmp/src/conntrack/parse.c	2008-03-23 20:26:57.000000000 +0100
@@ -152,6 +152,24 @@
 			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
 		set_bit(ATTR_ICMP_ID, set);
 	}
+
+	if (tb[CTA_PROTO_ICMPV6_TYPE-1]) {
+		tuple->l4dst.icmp.type =
+			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_TYPE-1]);
+		set_bit(ATTR_ICMP_TYPE, set);
+	}
+	
+	if (tb[CTA_PROTO_ICMPV6_CODE-1]) {
+		tuple->l4dst.icmp.code =
+			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_CODE-1]);
+		set_bit(ATTR_ICMP_CODE, set);
+	}
+	
+	if (tb[CTA_PROTO_ICMPV6_ID-1]) {
+		tuple->l4src.icmp.id =
+			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_ID-1]);
+		set_bit(ATTR_ICMP_ID, set);
+	}
 }
 
 void __parse_tuple(const struct nfattr *attr,
diff -Nur libnetfilter_conntrack-20080309-orig/src/conntrack/snprintf_default.c libnetfilter_conntrack-20080309-tmp/src/conntrack/snprintf_default.c
--- libnetfilter_conntrack-20080309-orig/src/conntrack/snprintf_default.c	2008-02-22 23:59:18.000000000 +0100
+++ libnetfilter_conntrack-20080309-tmp/src/conntrack/snprintf_default.c	2008-03-23 20:28:24.000000000 +0100
@@ -12,6 +12,7 @@
         [IPPROTO_UDP] = "udp",
         [IPPROTO_UDPLITE] = "udplite",
         [IPPROTO_ICMP] = "icmp",
+        [IPPROTO_ICMPV6] = "icmpv6",
         [IPPROTO_SCTP] = "sctp"
 };
 
@@ -144,7 +145,9 @@
 			        ntohs(tuple->l4src.tcp.port),
 			        ntohs(tuple->l4dst.tcp.port));
 		break;
+
 	case IPPROTO_ICMP:
+	case IPPROTO_ICMPV6:
 		/* The ID only makes sense some ICMP messages but we want to
 		 * display the same output that /proc/net/ip_conntrack does */
 		return (snprintf(buf, len, "type=%d code=%d id=%d ",
diff -Nur libnetfilter_conntrack-20080309-orig/src/conntrack/snprintf_xml.c libnetfilter_conntrack-20080309-tmp/src/conntrack/snprintf_xml.c
--- libnetfilter_conntrack-20080309-orig/src/conntrack/snprintf_xml.c	2008-02-22 23:59:18.000000000 +0100
+++ libnetfilter_conntrack-20080309-tmp/src/conntrack/snprintf_xml.c	2008-03-23 20:33:20.000000000 +0100
@@ -57,6 +57,7 @@
         [IPPROTO_UDP] = "udp",
         [IPPROTO_UDPLITE] = "udplite",
         [IPPROTO_ICMP] = "icmp",
+        [IPPROTO_ICMPV6] = "icmp6",
         [IPPROTO_SCTP] = "sctp"
 };
 static char *l3proto2str[AF_MAX] = {
