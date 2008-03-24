From: Krzysztof Oledzki <ole@ans.pl>
Subject: [PATCH 2/3] Fix reply direction for both ICMP and ICMPv6 in
 libnetfilter_conntrack
Date: Mon, 24 Mar 2008 03:05:35 +0100
Message-ID: <47e70c6f.pDuHAR+deWCgDmcZ%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:35810 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYCXCFz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 22:05:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This patch adds invmap support and duplicate code/id for reply direction,
so inserted conntracks get proper type, code and id. Without this fix
"type", "code" and "id" in reply direction were always set to 0. It "automagically"
worked for ICMP and ICMP_ECHOREPLY (ICMP_ECHOREPLY==8 -> ICMP_ECHO==*0*),
but not with with other ICMP codes nor with ICMPv6.

Before:
# conntrack -I -s 192.168.0.1 -d 192.168.0.1 -r 192.168.0.1 -q 192.168.0.1 -p icmp --timeout 100 --status ASSURED  --icmp-type 8 --icmp-code 0 --icmp-id 29261 && conntrack -L|grep 29261
icmp     1 99 src=192.168.0.1 dst=192.168.0.1 type=8 code=0 id=29261 packets=0 bytes=0 [UNREPLIED] src=192.168.0.1 dst=192.168.0.1 type=0 code=0 id=0 packets=0 bytes=0 [ASSURED] mark=0 use=1

After:
# conntrack -I -s 192.168.0.1 -d 192.168.0.1 -r 192.168.0.1 -q 192.168.0.1 -p icmp --timeout 100 --status ASSURED  --icmp-type 8 --icmp-code 0 --icmp-id 29261 && conntrack -L|grep 29261
icmp     1 99 src=192.168.0.1 dst=192.168.0.1 type=8 code=0 id=29261 packets=0 bytes=0 [UNREPLIED] src=192.168.0.1 dst=192.168.0.1 type=0 code=0 id=29261 packets=0 bytes=0 [ASSURED] mark=0 use=1

ICMPv6:
# conntrack -I  -s ::1 -d ::1 -r ::1 -q  ::1 -p icmpv6 -t 4 -u ASSURED --icmpv6-type 128  --icmpv6-code 1 --icmpv6-id 66 ; conntrack -L -f ipv6
icmpv6   58 3 src=::1 dst=::1 type=128 code=1 id=66 packets=0 bytes=0 [UNREPLIED] src=::1 dst=::1 type=129 code=1 id=66 packets=0 bytes=0 [ASSURED] mark=0 use=1

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur libnetfilter_conntrack-20080309-orig/src/conntrack/setter.c libnetfilter_conntrack-20080309-tmp2/src/conntrack/setter.c
--- libnetfilter_conntrack-20080309-orig/src/conntrack/setter.c	2008-02-09 21:01:39.000000000 +0100
+++ libnetfilter_conntrack-20080309-tmp2/src/conntrack/setter.c	2008-03-24 00:16:00.000000000 +0100
@@ -6,6 +6,26 @@
  */
 
 #include "internal.h"
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+
+static const u_int8_t invmap_icmp[] = {
+	[ICMP_ECHO]		= ICMP_ECHOREPLY + 1,
+	[ICMP_ECHOREPLY]	= ICMP_ECHO + 1,
+	[ICMP_TIMESTAMP]	= ICMP_TIMESTAMPREPLY + 1,
+	[ICMP_TIMESTAMPREPLY]	= ICMP_TIMESTAMP + 1,
+	[ICMP_INFO_REQUEST]	= ICMP_INFO_REPLY + 1,
+	[ICMP_INFO_REPLY]	= ICMP_INFO_REQUEST + 1,
+	[ICMP_ADDRESS]		= ICMP_ADDRESSREPLY + 1,
+	[ICMP_ADDRESSREPLY]	= ICMP_ADDRESS + 1
+};
+
+static u_int8_t invmap_icmpv6[] = {
+	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
+	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
+	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
+	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_REPLY + 1
+};
 
 static void set_attr_orig_ipv4_src(struct nf_conntrack *ct, const void *value)
 {
@@ -69,17 +89,40 @@
 
 static void set_attr_icmp_type(struct nf_conntrack *ct, const void *value)
 {
+	u_int8_t rtype;
+
 	ct->tuple[__DIR_ORIG].l4dst.icmp.type = *((u_int8_t *) value);
+
+	switch(ct->tuple[__DIR_ORIG].l3protonum) {
+		case AF_INET:
+			rtype = invmap_icmp[*((u_int8_t *) value)];
+			break;
+
+		case AF_INET6:
+			rtype = invmap_icmpv6[*((u_int8_t *) value) - 128];
+			break;
+
+		default:
+			rtype = 0;	/* not found */
+	}
+
+	if (rtype)
+		ct->tuple[__DIR_REPL].l4dst.icmp.type = rtype - 1;
+	else
+		ct->tuple[__DIR_REPL].l4dst.icmp.type = 255;	/* will fail with -EINVAL */
+
 }
 
 static void set_attr_icmp_code(struct nf_conntrack *ct, const void *value)
 {
 	ct->tuple[__DIR_ORIG].l4dst.icmp.code = *((u_int8_t *) value);
+	ct->tuple[__DIR_REPL].l4dst.icmp.code = *((u_int8_t *) value);
 }
 
 static void set_attr_icmp_id(struct nf_conntrack *ct, const void *value)
 {
 	ct->tuple[__DIR_ORIG].l4src.icmp.id = *((u_int16_t *) value);
+	ct->tuple[__DIR_REPL].l4src.icmp.id = *((u_int16_t *) value);
 }
 
 static void set_attr_orig_l3proto(struct nf_conntrack *ct, const void *value)
