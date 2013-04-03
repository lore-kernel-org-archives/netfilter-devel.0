From: holger@eitzenberger.org
Subject: [PATCH RFC 1/2] icmp6: match on errors and informational types
Date: Wed, 03 Apr 2013 16:27:30 +0200
Message-ID: <20130403144245.298678947@eitzenberger.org>
References: <20130403142729.484857089@eitzenberger.org>
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:65169 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760325Ab3DCOmt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:42:49 -0400
Content-Disposition: inline; filename=iptables/iptables-icmp6-match-errors-and-info.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: iptables/extensions/libip6t_icmp6.c
===================================================================
--- iptables.orig/extensions/libip6t_icmp6.c	2013-04-03 14:35:43.000000000 +0200
+++ iptables/extensions/libip6t_icmp6.c	2013-04-03 14:55:47.000000000 +0200
@@ -7,8 +7,17 @@
 
 enum {
 	O_ICMPV6_TYPE = 0,
+	O_ICMPV6_ERROR,
+	O_ICMPV6_INFO,
 };
 
+enum {
+	F_ICMPV6_TYPE = 1 << O_ICMPV6_TYPE,
+	F_ICMPV6_ERROR = 1 << O_ICMPV6_ERROR,
+	F_ICMPV6_INFO = 1 << O_ICMPV6_INFO,
+};
+#define F_ICMPV6_ALL	(F_ICMPV6_TYPE | F_ICMPV6_ERROR | F_ICMPV6_INFO)
+
 struct icmpv6_names {
 	const char *name;
 	uint8_t type;
@@ -80,13 +89,19 @@
 	printf(
 "icmpv6 match options:\n"
 "[!] --icmpv6-type typename	match icmpv6 type\n"
-"				(or numeric type or type/code)\n");
+"				(or numeric type or type/code)\n\n"
+"    --icmpv6-error		match any icmpv6 error type\n"
+"    --icmpv6-info		match any icmpv6 informational type\n");
 	print_icmpv6types();
 }
 
 static const struct xt_option_entry icmp6_opts[] = {
 	{.name = "icmpv6-type", .id = O_ICMPV6_TYPE, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	 .flags = XTOPT_INVERT, .excl = F_ICMPV6_ALL},
+	{.name = "icmpv6-error", .id = O_ICMPV6_ERROR, .type = XTTYPE_NONE,
+	 .excl = F_ICMPV6_ALL},
+	{.name = "icmpv6-info", .id = O_ICMPV6_INFO, .type = XTTYPE_NONE,
+	 .excl = F_ICMPV6_ALL},
 	XTOPT_TABLEEND,
 };
 
@@ -155,9 +170,19 @@
 	struct ip6t_icmp *icmpv6info = cb->data;
 
 	xtables_option_parse(cb);
-	parse_icmpv6(cb->arg, &icmpv6info->type, icmpv6info->code);
-	if (cb->invert)
-		icmpv6info->invflags |= IP6T_ICMP_INV;
+	switch (cb->entry->id) {
+	case O_ICMPV6_TYPE:
+		parse_icmpv6(cb->arg, &icmpv6info->type, icmpv6info->code);
+		if (cb->invert)
+			icmpv6info->flags |= IP6T_ICMP_INV;
+		break;
+	case O_ICMPV6_ERROR:
+		icmpv6info->flags |= IP6T_ICMP_ERROR;
+		break;
+	case O_ICMPV6_INFO:
+		icmpv6info->flags |= IP6T_ICMP_INFO;
+		break;
+	}
 }
 
 static void print_icmpv6type(uint8_t type,
@@ -198,25 +223,35 @@
 	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
 
 	printf(" ipv6-icmp");
-	print_icmpv6type(icmpv6->type, icmpv6->code[0], icmpv6->code[1],
-		       icmpv6->invflags & IP6T_ICMP_INV,
-		       numeric);
-
-	if (icmpv6->invflags & ~IP6T_ICMP_INV)
-		printf(" Unknown invflags: 0x%X",
-		       icmpv6->invflags & ~IP6T_ICMP_INV);
+	if (icmpv6->flags & IP6T_ICMP_ERROR)
+		printf(" icmp6-error");
+	else if (icmpv6->flags & IP6T_ICMP_INFO)
+		printf(" icmp6-info");
+	else
+		print_icmpv6type(icmpv6->type, icmpv6->code[0], icmpv6->code[1],
+				 icmpv6->flags & IP6T_ICMP_INV,
+				 numeric);
+
+	if (icmpv6->flags & ~IP6T_ICMP_MASK)
+		printf(" Unknown flags: 0x%X", icmpv6->flags & ~IP6T_ICMP_INV);
 }
 
 static void icmp6_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
 
-	if (icmpv6->invflags & IP6T_ICMP_INV)
+	if (icmpv6->flags & IP6T_ICMP_INV)
 		printf(" !");
 
-	printf(" --icmpv6-type %u", icmpv6->type);
-	if (icmpv6->code[0] != 0 || icmpv6->code[1] != 0xFF)
-		printf("/%u", icmpv6->code[0]);
+	if (icmpv6->flags & IP6T_ICMP_ERROR)
+		printf(" --icmpv6-error");
+	else if (icmpv6->flags & IP6T_ICMP_INFO)
+		printf(" --icmpv6-info");
+	else {
+		printf(" --icmpv6-type %u", icmpv6->type);
+		if (icmpv6->code[0] != 0 || icmpv6->code[1] != 0xFF)
+			printf("/%u", icmpv6->code[0]);
+	}
 }
 
 static struct xtables_match icmp6_mt6_reg = {
Index: iptables/include/linux/netfilter_ipv6/ip6_tables.h
===================================================================
--- iptables.orig/include/linux/netfilter_ipv6/ip6_tables.h	2013-04-03 14:36:02.000000000 +0200
+++ iptables/include/linux/netfilter_ipv6/ip6_tables.h	2013-04-03 14:36:31.000000000 +0200
@@ -180,11 +180,14 @@
 struct ip6t_icmp {
 	u_int8_t type;				/* type to match */
 	u_int8_t code[2];			/* range of code */
-	u_int8_t invflags;			/* Inverse flags */
+	u_int8_t flags;
 };
 
-/* Values for "inv" field for struct ipt_icmp. */
+/* Values for "flags" of struct ipt_icmp. */
 #define IP6T_ICMP_INV	0x01	/* Invert the sense of type/code test */
+#define IP6T_ICMP_ERROR 0x02	/* Match any error type */
+#define IP6T_ICMP_INFO	0x04	/* Match any informational type */
+#define IP6T_ICMP_MASK	0x07
 
 /* The argument to IP6T_SO_GET_INFO */
 struct ip6t_getinfo {
Index: iptables/extensions/libip6t_icmp6.man
===================================================================
--- iptables.orig/extensions/libip6t_icmp6.man	2012-05-24 13:36:24.000000000 +0200
+++ iptables/extensions/libip6t_icmp6.man	2013-04-03 15:05:26.000000000 +0200
@@ -1,5 +1,5 @@
 This extension can be used if `\-\-protocol ipv6\-icmp' or `\-\-protocol icmpv6' is
-specified. It provides the following option:
+specified. It provides the following options:
 .TP
 [\fB!\fP] \fB\-\-icmpv6\-type\fP \fItype\fP[\fB/\fP\fIcode\fP]|\fItypename\fP
 This allows specification of the ICMPv6 type, which can be a numeric
@@ -12,3 +12,9 @@
 .nf
  ip6tables \-p ipv6\-icmp \-h
 .fi
+.TP
+\fB\-\-icmpv6\-error\fP
+Match ICMPv6 error types (< 128).
+.TP
+\fB\-\-icmpv6\-info\fP
+Match ICMPv6 informational types (>= 128).

