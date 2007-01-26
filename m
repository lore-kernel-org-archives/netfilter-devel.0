From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [NETFILTER]: ip6_tables: Support MH match.
Date: Fri, 26 Jan 2007 18:53:55 +0900 (JST)
Message-ID: <200701260953.l0Q9rvv9022736@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Jan_26_18_53_55_2007_810)--"
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

----Next_Part(Fri_Jan_26_18_53_55_2007_810)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Patrick and all,

This introduces match for Mobility Header (MH) described by Mobile IPv6
specification (RFC3775). User can specify the MH type or its range to be
matched.

MH is defined as extention header in RFC3775, but this patch handles it
as layer 4 protocol header like ICMPv6 header.

The reasons are
- The reason why it's defined as extentin header is mainly for
  'piggy back'. But that feature was not specified in RFC3775 after all.
- No header follow MH. RFC3775 says
	Implementations conforming to this specification SHOULD set
	the payload protocol type to IPPROTO_NONE (59 decimal).  
- Many parts in RFCs assume that it's like layer 4 protocol header.
- Actually Linux IPv6 stack, XFRM, setkey, iproute2... handle it as if
  it's layer4 protocol.

So we concludes people expect to do 'ip6tables -p mh ...', not
'ip6tables -m mh ...'.

Please consider to apply this. If no objection, I'll commit
attached the patch for ip6tables as well.

-- Yasuyuki Kozakai

[NETFILTER]: ip6_tables: Support MH match.

This introduces match for Mobility Header (MH) described by Mobile IPv6
specification (RFC3775). User can specify the MH type or its range to be
matched.

Signed-off-by: Masahide NAKAMURA <nakam@linux-ipv6.org>
Signed-off-by: Yasuyuki Kozakai <kozakai@linux-ipv6.org>
---
 include/linux/netfilter_ipv6/ip6t_mh.h |   15 +++++
 net/ipv6/netfilter/Kconfig             |    8 +++
 net/ipv6/netfilter/Makefile            |    1 +
 net/ipv6/netfilter/ip6t_mh.c           |  108 ++++++++++++++++++++++++++++++++
 4 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6t_mh.h b/include/linux/netfilter_ipv6/ip6t_mh.h
new file mode 100644
index 0000000..b9ca9a5
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_mh.h
@@ -0,0 +1,15 @@
+#ifndef _IP6T_MH_H
+#define _IP6T_MH_H
+
+/* MH matching stuff */
+struct ip6t_mh
+{
+	u_int8_t types[2];	/* MH type range */
+	u_int8_t invflags;	/* Inverse flags */
+};
+
+/* Values for "invflags" field in struct ip6t_mh. */
+#define IP6T_MH_INV_TYPE	0x01	/* Invert the sense of type. */
+#define IP6T_MH_INV_MASK	0x01	/* All possible flags. */
+
+#endif /*_IP6T_MH_H*/
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index adcd613..cd549ae 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -114,6 +114,14 @@ config IP6_NF_MATCH_AH
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP6_NF_MATCH_MH
+	tristate "MH match support"
+	depends on IP6_NF_IPTABLES
+	help
+	  This module allows one to match MH packets.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP6_NF_MATCH_EUI64
 	tristate "EUI64 address check"
 	depends on IP6_NF_IPTABLES
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index ac1dfeb..4513eab 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_
 obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
 obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
 obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
+obj-$(CONFIG_IP6_NF_MATCH_MH) += ip6t_mh.o
 
 # objects for l3 independent conntrack
 nf_conntrack_ipv6-objs  :=  nf_conntrack_l3proto_ipv6.o nf_conntrack_proto_icmpv6.o nf_conntrack_reasm.o
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
new file mode 100644
index 0000000..2c7efc6
--- /dev/null
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C)2006 USAGI/WIDE Project
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Author:
+ *	Masahide NAKAMURA @USAGI <masahide.nakamura.cz@hitachi.com>
+ *
+ * Based on net/netfilter/xt_tcpudp.c
+ *
+ */
+#include <linux/types.h>
+#include <linux/module.h>
+#include <net/ip.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#include <net/mip6.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv6/ip6t_mh.h>
+
+MODULE_DESCRIPTION("ip6t_tables match for MH");
+MODULE_LICENSE("GPL");
+
+#ifdef DEBUG_IP_FIREWALL_USER
+#define duprintf(format, args...) printk(format , ## args)
+#else
+#define duprintf(format, args...)
+#endif
+
+/* Returns 1 if the type is matched by the range, 0 otherwise */
+static inline int
+type_match(u_int8_t min, u_int8_t max, u_int8_t type, int invert)
+{
+	int ret;
+
+	ret = (type >= min && type <= max) ^ invert;
+	return ret;
+}
+
+static int
+match(const struct sk_buff *skb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 const struct xt_match *match,
+	 const void *matchinfo,
+	 int offset,
+	 unsigned int protoff,
+	 int *hotdrop)
+{
+	struct ip6_mh _mh, *mh;
+	const struct ip6t_mh *mhinfo = matchinfo;
+
+	/* Must not be a fragment. */
+	if (offset)
+		return 0;
+
+	mh = skb_header_pointer(skb, protoff, sizeof(_mh), &_mh);
+	if (mh == NULL) {
+		/* We've been asked to examine this packet, and we
+		   can't.  Hence, no choice but to drop. */
+		duprintf("Dropping evil MH tinygram.\n");
+		*hotdrop = 1;
+		return 0;
+	}
+
+	return type_match(mhinfo->types[0], mhinfo->types[1], mh->ip6mh_type,
+			  !!(mhinfo->invflags & IP6T_MH_INV_TYPE));
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+mh_checkentry(const char *tablename,
+	      const void *entry,
+	      const struct xt_match *match,
+	      void *matchinfo,
+	      unsigned int hook_mask)
+{
+	const struct ip6t_mh *mhinfo = matchinfo;
+
+	/* Must specify no unknown invflags */
+	return !(mhinfo->invflags & ~IP6T_MH_INV_MASK);
+}
+
+static struct xt_match mh_match = {
+	.name		= "mh",
+	.family		= AF_INET6,
+	.checkentry	= mh_checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_mh),
+	.proto		= IPPROTO_MH,
+	.me		= THIS_MODULE,
+};
+
+static int __init ip6t_mh_init(void)
+{
+	return xt_register_match(&mh_match);
+}
+
+static void __exit ip6t_mh_fini(void)
+{
+	xt_unregister_match(&mh_match);
+}
+
+module_init(ip6t_mh_init);
+module_exit(ip6t_mh_fini);
-- 
1.4.4


----Next_Part(Fri_Jan_26_18_53_55_2007_810)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0001-add-support-to-Mobility-Header-match-to-ip6tables.txt"

add support for Mobility Header match to ip6tables

Signed-off-by: Masahide NAKAMURA <nakam@linux-ipv6.org>
Signed-off-by: Yasuyuki Kozakai <kozakai@linux-ipv6.org>
---
 extensions/.mh-test6      |    2 +
 extensions/libip6t_mh.c   |  252 +++++++++++++++++++++++++++++++++++++++++++++
 extensions/libip6t_mh.man |   12 ++
 ip6tables.c               |    5 +
 libip6t_mh.c              |  252 +++++++++++++++++++++++++++++++++++++++++++++
 libip6t_mh.man            |   12 ++
 6 files changed, 535 insertions(+), 0 deletions(-)

diff --git a/extensions/.mh-test6 b/extensions/.mh-test6
new file mode 100755
index 0000000..1142096
--- /dev/null
+++ b/extensions/.mh-test6
@@ -0,0 +1,2 @@
+#!/bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_mh.h ] && echo mh
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
new file mode 100644
index 0000000..2475b4d
--- /dev/null
+++ b/extensions/libip6t_mh.c
@@ -0,0 +1,252 @@
+/* Shared library add-on to ip6tables to add mobility header support. */
+/*
+ * Copyright (C)2006 USAGI/WIDE Project
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Author:
+ *	Masahide NAKAMURA @USAGI <masahide.nakamura.cz@hitachi.com>
+ *
+ * Based on libip6t_{icmpv6,udp}.c
+ */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_mh.h>
+
+struct mh_name {
+	const char *name;
+	u_int8_t type;
+};
+
+static const struct mh_name mh_names[] = {
+	{ "binding-refresh-request", 0, },
+	/* Alias */ { "brr", 0, },
+	{ "home-test-init", 1, },
+	/* Alias */ { "hoti", 1, },
+	{ "careof-test-init", 2, },
+	/* Alias */ { "coti", 2, },
+	{ "home-test", 3, },
+	/* Alias */ { "hot", 3, },
+	{ "careof-test", 4, },
+	/* Alias */ { "cot", 4, },
+	{ "binding-update", 5, },
+	/* Alias */ { "bu", 5, },
+	{ "binding-acknowledgement", 6, },
+	/* Alias */ { "ba", 6, },
+	{ "binding-error", 7, },
+	/* Alias */ { "be", 7, },
+};
+
+static void print_types_all(void)
+{
+	unsigned int i;
+	printf("Valid MH types:");
+
+	for (i = 0; i < sizeof(mh_names)/sizeof(struct mh_name); i++) {
+		if (i && mh_names[i].type == mh_names[i-1].type)
+			printf(" (%s)", mh_names[i].name);
+		else
+			printf("\n%s", mh_names[i].name);
+	}
+	printf("\n");
+}
+
+static void help(void)
+{
+	printf(
+"MH v%s options:\n"
+" --mh-type [!] type[:type]	match mh type\n",
+IPTABLES_VERSION);
+	print_types_all();
+}
+
+static void init(struct ip6t_entry_match *m, unsigned int *nfcache)
+{
+	struct ip6t_mh *mhinfo = (struct ip6t_mh *)m->data;
+
+	mhinfo->types[1] = 0xFF;
+}
+
+static unsigned int name_to_type(const char *name)
+{
+	int namelen = strlen(name);
+	unsigned int limit = sizeof(mh_names)/sizeof(struct mh_name);
+	unsigned int match = limit;
+	unsigned int i;
+
+	for (i = 0; i < limit; i++) {
+		if (strncasecmp(mh_names[i].name, name, namelen) == 0) {
+			int len = strlen(mh_names[i].name);
+			if (match == limit || len == namelen)
+				match = i;
+		}
+	}
+
+	if (match != limit) {
+		return mh_names[match].type;
+	} else {
+		unsigned int number;
+
+		if (string_to_number(name, 0, 255, &number) == -1)
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid MH type `%s'\n", name);
+		return number;
+	}
+}
+
+static void parse_mh_types(const char *mhtype, u_int8_t *types)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(mhtype);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		types[0] = types[1] = name_to_type(buffer);
+	else {
+		*cp = '\0';
+		cp++;
+
+		types[0] = buffer[0] ? name_to_type(buffer) : 0;
+		types[1] = cp[0] ? name_to_type(cp) : 0xFF;
+
+		if (types[0] > types[1])
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid MH type range (min > max)");
+	}
+	free(buffer);
+}
+
+#define MH_TYPES 0x01
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		 const struct ip6t_entry *entry,
+		 unsigned int *nfcache,
+		 struct ip6t_entry_match **match)
+{
+	struct ip6t_mh *mhinfo = (struct ip6t_mh *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & MH_TYPES)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--mh-type' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_mh_types(argv[optind-1], mhinfo->types);
+		if (invert)
+			mhinfo->invflags |= IP6T_MH_INV_TYPE;
+		*flags |= MH_TYPES;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Final check; we don't care. */
+static void final_check(unsigned int flags)
+{
+}
+
+static const char *type_to_name(u_int8_t type)
+{
+	unsigned int i;
+
+	for (i = 0; i < sizeof(mh_names)/sizeof(struct mh_name); i++) {
+		if (mh_names[i].type == type)
+			return mh_names[i].name;
+	}
+
+	return NULL;
+}
+
+static void print_type(u_int8_t type, int numeric)
+{
+	const char *name;
+	if (numeric || !(name = type_to_name(type)))
+		printf("%u", type);
+	else
+		printf("%s", name);
+}
+
+static void print_types(u_int8_t min, u_int8_t max, int invert, int numeric)
+{
+	const char *inv = invert ? "!" : "";
+
+	if (min != 0 || max != 0xFF || invert) {
+		if (min == max) {
+			printf("%s", inv);
+			print_type(min, numeric);
+		} else {
+			printf("%s", inv);
+			print_type(min, numeric);
+			printf(":");
+			print_type(max, numeric);
+		}
+		printf(" ");
+	}
+}
+
+static void print(const struct ip6t_ip6 *ip,
+		  const struct ip6t_entry_match *match,
+		  int numeric)
+{
+	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
+
+	printf("mh ");
+	print_types(mhinfo->types[0], mhinfo->types[1],
+		    mhinfo->invflags & IP6T_MH_INV_TYPE,
+		    numeric);
+	if (mhinfo->invflags & ~IP6T_MH_INV_MASK)
+		printf("Unknown invflags: 0x%X ",
+		       mhinfo->invflags & ~IP6T_MH_INV_MASK);
+}
+
+static void save(const struct ip6t_ip6 *ip,
+		 const struct ip6t_entry_match *match)
+{
+	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
+
+	if (mhinfo->types[0] == 0 && mhinfo->types[1] == 0xFF)
+		return;
+
+	if (mhinfo->invflags & IP6T_MH_INV_TYPE)
+		printf("! ");
+
+	if (mhinfo->types[0] != mhinfo->types[1])
+		printf("--mh-type %u:%u ", mhinfo->types[0], mhinfo->types[1]);
+	else
+		printf("--mh-type %u ", mhinfo->types[0]);
+}
+
+static struct option opts[] = {
+	{ "mh-type", 1, 0, '1' },
+	{0}
+};
+
+static struct ip6tables_match mh = {
+	.name		= "mh",
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ip6t_mh)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_mh)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
+};
+
+void _init(void)
+{
+	register_match6(&mh);
+}
diff --git a/extensions/libip6t_mh.man b/extensions/libip6t_mh.man
new file mode 100644
index 0000000..14f1c64
--- /dev/null
+++ b/extensions/libip6t_mh.man
@@ -0,0 +1,12 @@
+This extension is loaded if `--protocol ipv6-mh' or `--protocol mh' is
+specified. It provides the following option:
+.TP
+.BR "--mh-type " "[!] \fItype\fP[:\fItype\fP]"
+This allows specification of the Mobility Header(MH) type, which can be
+a numeric MH
+.IR type ,
+.IR type
+or one of the MH type names shown by the command
+.nf
+ ip6tables -p ipv6-mh -h
+.fi
diff --git a/ip6tables.c b/ip6tables.c
index 211b81a..ebdaa62 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -219,6 +219,9 @@ struct pprot {
 #define IPPROTO_AH 51
 #endif
 #endif
+#ifndef IPPROTO_MH
+#define IPPROTO_MH 135
+#endif
 
 static const struct pprot chain_protos[] = {
 	{ "tcp", IPPROTO_TCP },
@@ -228,6 +231,8 @@ static const struct pprot chain_protos[]
 	{ "ipv6-icmp", IPPROTO_ICMPV6 },
 	{ "esp", IPPROTO_ESP },
 	{ "ah", IPPROTO_AH },
+	{ "ipv6-mh", IPPROTO_MH },
+	{ "mh", IPPROTO_MH },
 };
 
 static char *
diff --git a/libip6t_mh.c b/libip6t_mh.c
new file mode 100644
index 0000000..7cdfaf1
--- /dev/null
+++ b/libip6t_mh.c
@@ -0,0 +1,252 @@
+/* Shared library add-on to ip6tables to add mobility header support. */
+/*
+ * Copyright (C)2006 USAGI/WIDE Project
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Author:
+ *	Masahide NAKAMURA @USAGI <masahide.nakamura.cz@hitachi.com>
+ *
+ * Based on libip6t_{icmpv6,udp}.c
+ */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_mh.h>
+
+struct mh_name {
+	const char *name;
+	u_int8_t type;
+};
+
+static const struct mh_name mh_names[] = {
+	{ "binding-refresh-request", 0, },
+	/* Alias */ { "brr", 0, },
+	{ "home-test-init", 1, },
+	/* Alias */ { "hoti", 1, },
+	{ "careof-test-init", 2, },
+	/* Alias */ { "coti", 2, },
+	{ "home-test", 3, },
+	/* Alias */ { "hot", 3, },
+	{ "careof-test", 4, },
+	/* Alias */ { "cot", 4, },
+	{ "binding-update", 5, },
+	/* Alias */ { "bu", 5, },
+	{ "binding-acknowledgement", 6, },
+	/* Alias */ { "ba", 6, },
+	{ "binding-error", 7, },
+	/* Alias */ { "be", 7 },
+};
+
+static void print_types_all(void)
+{
+	unsigned int i;
+	printf("Valid MH types:");
+
+	for (i = sizeof(mh_names)/sizeof(struct mh_name) - 1; i >= 0; i--) {
+		if (i && mh_names[i].type == mh_names[i-1].type)
+			printf(" (%s)", mh_names[i].name);
+		else
+			printf("\n%s", mh_names[i].name);
+	}
+	printf("\n");
+}
+
+static void help(void)
+{
+	printf(
+"MH v%s options:\n"
+" --mh-type [!] type[:type]	match mh type\n",
+IPTABLES_VERSION);
+	print_types_all();
+}
+
+static void init(struct ip6t_entry_match *m, unsigned int *nfcache)
+{
+	struct ip6t_mh *mhinfo = (struct ip6t_mh *)m->data;
+
+	mhinfo->types[1] = 0xFF;
+}
+
+static unsigned int name_to_type(const char *name)
+{
+	int namelen = strlen(name);
+	unsigned int limit = sizeof(mh_names)/sizeof(struct mh_name);
+	unsigned int match = limit;
+	unsigned int i;
+
+	for (i = 0; i < limit; i++) {
+		if (strncasecmp(mh_names[i].name, name, namelen) == 0) {
+			int len = strlen(mh_names[i].name);
+			if (match == limit || len == namelen)
+				match = i;
+		}
+	}
+
+	if (match != limit) {
+		return mh_names[match].type;
+	} else {
+		unsigned int number;
+
+		if (string_to_number(name, 0, 255, &number) == -1)
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid MH type `%s'\n", name);
+		return number;
+	}
+}
+
+static void parse_mh_types(const char *mhtype, u_int8_t *types)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(mhtype);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		types[0] = types[1] = name_to_type(buffer);
+	else {
+		*cp = '\0';
+		cp++;
+
+		types[0] = buffer[0] ? name_to_type(buffer) : 0;
+		types[1] = cp[0] ? name_to_type(cp) : 0xFF;
+
+		if (types[0] > types[1])
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid MH type range (min > max)");
+	}
+	free(buffer);
+}
+
+#define MH_TYPES 0x01
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		 const struct ip6t_entry *entry,
+		 unsigned int *nfcache,
+		 struct ip6t_entry_match **match)
+{
+	struct ip6t_mh *mhinfo = (struct ip6t_mh *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & MH_TYPES)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--mh-type' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_mh_types(argv[optind-1], mhinfo->types);
+		if (invert)
+			mhinfo->invflags |= IP6T_MH_INV_TYPE;
+		*flags |= MH_TYPES;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Final check; we don't care. */
+static void final_check(unsigned int flags)
+{
+}
+
+static const char *type_to_name(u_int8_t type)
+{
+	unsigned int i;
+
+	for (i = 0; i < sizeof(mh_names)/sizeof(struct mh_name); i++) {
+		if (mh_names[i].type == type)
+			return mh_names[i].name;
+	}
+
+	return NULL;
+}
+
+static void print_type(u_int8_t type, int numeric)
+{
+	const char *name;
+	if (numeric || !(name = type_to_name(type)))
+		printf("%u", type);
+	else
+		printf("%s", name);
+}
+
+static void print_types(u_int8_t min, u_int8_t max, int invert, int numeric)
+{
+	const char *inv = invert ? "!" : "";
+
+	if (min != 0 || max != 0xFF || invert) {
+		if (min == max) {
+			printf("%s", inv);
+			print_type(min, numeric);
+		} else {
+			printf("%s", inv);
+			print_type(min, numeric);
+			printf(":");
+			print_type(max, numeric);
+		}
+		printf(" ");
+	}
+}
+
+static void print(const struct ip6t_ip6 *ip,
+		  const struct ip6t_entry_match *match,
+		  int numeric)
+{
+	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
+
+	printf("mh ");
+	print_types(mhinfo->types[0], mhinfo->types[1],
+		    mhinfo->invflags & IP6T_MH_INV_TYPE,
+		    numeric);
+	if (mhinfo->invflags & ~IP6T_MH_INV_MASK)
+		printf("Unknown invflags: 0x%X ",
+		       mhinfo->invflags & ~IP6T_MH_INV_MASK);
+}
+
+static void save(const struct ip6t_ip6 *ip,
+		 const struct ip6t_entry_match *match)
+{
+	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
+
+	if (mhinfo->types[0] == 0 && mhinfo->types[1] == 0xFF)
+		return;
+
+	if (mhinfo->invflags & IP6T_MH_INV_TYPE)
+		printf("! ");
+
+	if (mhinfo->types[0] != mhinfo->types[1])
+		printf("--mh-type %u:%u ", mhinfo->types[0], mhinfo->types[1]);
+	else
+		printf("--mh-type %u ", mhinfo->types[0]);
+}
+
+static struct option opts[] = {
+	{ "mh-type", 1, 0, '1' },
+	{0}
+};
+
+static struct ip6tables_match mh = {
+	.name		= "mh",
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ip6t_mh)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_mh)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
+};
+
+void _init(void)
+{
+	register_match6(&mh);
+}
diff --git a/libip6t_mh.man b/libip6t_mh.man
new file mode 100644
index 0000000..14f1c64
--- /dev/null
+++ b/libip6t_mh.man
@@ -0,0 +1,12 @@
+This extension is loaded if `--protocol ipv6-mh' or `--protocol mh' is
+specified. It provides the following option:
+.TP
+.BR "--mh-type " "[!] \fItype\fP[:\fItype\fP]"
+This allows specification of the Mobility Header(MH) type, which can be
+a numeric MH
+.IR type ,
+.IR type
+or one of the MH type names shown by the command
+.nf
+ ip6tables -p ipv6-mh -h
+.fi
-- 
1.4.4


----Next_Part(Fri_Jan_26_18_53_55_2007_810)----
