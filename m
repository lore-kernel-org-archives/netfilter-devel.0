From: kaber@trash.net
Subject: [PATCH 1/6] extensions: convert NAT target to use nf_nat.h
Date: Wed, 23 Nov 2011 17:12:25 +0100
Message-ID: <1322064750-26744-2-git-send-email-kaber@trash.net>
References: <1322064750-26744-1-git-send-email-kaber@trash.net>
Cc: kaber@trash.net, ulrich.weber@sophos.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55466 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab1KWQMh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:12:37 -0500
In-Reply-To: <1322064750-26744-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Convert the NAT targets to use the kernel supplied nf_nat.h header.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 extensions/libipt_DNAT.c                           |   36 +++---
 extensions/libipt_MASQUERADE.c                     |   32 +++---
 extensions/libipt_NETMAP.c                         |   18 ++--
 extensions/libipt_REDIRECT.c                       |   34 +++---
 extensions/libipt_SAME.c                           |   18 ++--
 extensions/libipt_SNAT.c                           |   36 +++---
 .../linux/netfilter/nf_conntrack_tuple_common.h    |   27 +++++
 include/linux/netfilter/nf_nat.h                   |   25 +++++
 include/linux/netfilter_ipv4/ipt_SAME.h            |    2 +-
 include/net/netfilter/nf_conntrack_tuple.h         |  114 --------------------
 include/net/netfilter/nf_nat.h                     |   55 ----------
 11 files changed, 140 insertions(+), 257 deletions(-)
 create mode 100644 include/linux/netfilter/nf_nat.h
 delete mode 100644 include/net/netfilter/nf_conntrack_tuple.h
 delete mode 100644 include/net/netfilter/nf_nat.h

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 3b55c69..6d2662d 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -6,7 +6,7 @@
 #include <iptables.h> /* get_kernel_version */
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <net/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_nat.h>
 
 enum {
 	O_TO_DEST = 0,
@@ -23,7 +23,7 @@ enum {
 struct ipt_natinfo
 {
 	struct xt_entry_target t;
-	struct nf_nat_multi_range mr;
+	struct nf_nat_ipv4_multi_range_compat mr;
 };
 
 static void DNAT_help(void)
@@ -44,7 +44,7 @@ static const struct xt_option_entry DNAT_opts[] = {
 };
 
 static struct ipt_natinfo *
-append_range(struct ipt_natinfo *info, const struct nf_nat_range *range)
+append_range(struct ipt_natinfo *info, const struct nf_nat_ipv4_range *range)
 {
 	unsigned int size;
 
@@ -66,7 +66,7 @@ append_range(struct ipt_natinfo *info, const struct nf_nat_range *range)
 static struct xt_entry_target *
 parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 {
-	struct nf_nat_range range;
+	struct nf_nat_ipv4_range range;
 	char *arg, *colon, *dash, *error;
 	const struct in_addr *ip;
 
@@ -83,7 +83,7 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
-		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
 		port = atoi(colon+1);
 		if (port <= 0 || port > 65535)
@@ -122,7 +122,7 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 		*colon = '\0';
 	}
 
-	range.flags |= IP_NAT_RANGE_MAP_IPS;
+	range.flags |= NF_NAT_RANGE_MAP_IPS;
 	dash = strchr(arg, '-');
 	if (colon && dash && dash > colon)
 		dash = NULL;
@@ -176,22 +176,22 @@ static void DNAT_parse(struct xt_option_call *cb)
 		*cb->target = parse_to(cb->arg, portok, info);
 		/* WTF do we need this for?? */
 		if (cb->xflags & F_RANDOM)
-			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+			info->mr.range[0].flags |= NF_NAT_RANGE_PROTO_RANDOM;
 		cb->xflags |= F_X_TO_DEST;
 		break;
 	case O_RANDOM:
 		if (cb->xflags & F_TO_DEST)
-			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+			info->mr.range[0].flags |= NF_NAT_RANGE_PROTO_RANDOM;
 		break;
 	case O_PERSISTENT:
-		info->mr.range[0].flags |= IP_NAT_RANGE_PERSISTENT;
+		info->mr.range[0].flags |= NF_NAT_RANGE_PERSISTENT;
 		break;
 	}
 }
 
-static void print_range(const struct nf_nat_range *r)
+static void print_range(const struct nf_nat_ipv4_range *r)
 {
-	if (r->flags & IP_NAT_RANGE_MAP_IPS) {
+	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
@@ -201,7 +201,7 @@ static void print_range(const struct nf_nat_range *r)
 			printf("-%s", xtables_ipaddr_to_numeric(&a));
 		}
 	}
-	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 		printf(":");
 		printf("%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
@@ -218,9 +218,9 @@ static void DNAT_print(const void *ip, const struct xt_entry_target *target,
 	printf(" to:");
 	for (i = 0; i < info->mr.rangesize; i++) {
 		print_range(&info->mr.range[i]);
-		if (info->mr.range[i].flags & IP_NAT_RANGE_PROTO_RANDOM)
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM)
 			printf(" random");
-		if (info->mr.range[i].flags & IP_NAT_RANGE_PERSISTENT)
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT)
 			printf(" persistent");
 	}
 }
@@ -233,9 +233,9 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 	for (i = 0; i < info->mr.rangesize; i++) {
 		printf(" --to-destination ");
 		print_range(&info->mr.range[i]);
-		if (info->mr.range[i].flags & IP_NAT_RANGE_PROTO_RANDOM)
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM)
 			printf(" --random");
-		if (info->mr.range[i].flags & IP_NAT_RANGE_PERSISTENT)
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT)
 			printf(" --persistent");
 	}
 }
@@ -244,8 +244,8 @@ static struct xtables_target dnat_tg_reg = {
 	.name		= "DNAT",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.size		= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
 	.help		= DNAT_help,
 	.x6_parse	= DNAT_parse,
 	.print		= DNAT_print,
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 7ba42df..ea07445 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -6,7 +6,7 @@
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <net/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_nat.h>
 
 enum {
 	O_TO_PORTS = 0,
@@ -31,7 +31,7 @@ static const struct xt_option_entry MASQUERADE_opts[] = {
 
 static void MASQUERADE_init(struct xt_entry_target *t)
 {
-	struct nf_nat_multi_range *mr = (struct nf_nat_multi_range *)t->data;
+	struct nf_nat_ipv4_multi_range_compat *mr = (struct nf_nat_ipv4_multi_range_compat *)t->data;
 
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
@@ -39,12 +39,12 @@ static void MASQUERADE_init(struct xt_entry_target *t)
 
 /* Parses ports */
 static void
-parse_ports(const char *arg, struct nf_nat_multi_range *mr)
+parse_ports(const char *arg, struct nf_nat_ipv4_multi_range_compat *mr)
 {
 	char *end;
 	unsigned int port, maxport;
 
-	mr->range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+	mr->range[0].flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
 	if (!xtables_strtoui(arg, &end, &port, 0, UINT16_MAX))
 		xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
@@ -75,7 +75,7 @@ static void MASQUERADE_parse(struct xt_option_call *cb)
 {
 	const struct ipt_entry *entry = cb->xt_entry;
 	int portok;
-	struct nf_nat_multi_range *mr = cb->data;
+	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
 
 	if (entry->ip.proto == IPPROTO_TCP
 	    || entry->ip.proto == IPPROTO_UDP
@@ -95,7 +95,7 @@ static void MASQUERADE_parse(struct xt_option_call *cb)
 		parse_ports(cb->arg, mr);
 		break;
 	case O_RANDOM:
-		mr->range[0].flags |=  IP_NAT_RANGE_PROTO_RANDOM;
+		mr->range[0].flags |=  NF_NAT_RANGE_PROTO_RANDOM;
 		break;
 	}
 }
@@ -104,33 +104,33 @@ static void
 MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
                  int numeric)
 {
-	const struct nf_nat_multi_range *mr = (const void *)target->data;
-	const struct nf_nat_range *r = &mr->range[0];
+	const struct nf_nat_ipv4_multi_range_compat *mr = (const void *)target->data;
+	const struct nf_nat_ipv4_range *r = &mr->range[0];
 
-	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 		printf(" masq ports: ");
 		printf("%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
 			printf("-%hu", ntohs(r->max.tcp.port));
 	}
 
-	if (r->flags & IP_NAT_RANGE_PROTO_RANDOM)
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		printf(" random");
 }
 
 static void
 MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 {
-	const struct nf_nat_multi_range *mr = (const void *)target->data;
-	const struct nf_nat_range *r = &mr->range[0];
+	const struct nf_nat_ipv4_multi_range_compat *mr = (const void *)target->data;
+	const struct nf_nat_ipv4_range *r = &mr->range[0];
 
-	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 		printf(" --to-ports %hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
 			printf("-%hu", ntohs(r->max.tcp.port));
 	}
 
-	if (r->flags & IP_NAT_RANGE_PROTO_RANDOM)
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		printf(" --random");
 }
 
@@ -138,8 +138,8 @@ static struct xtables_target masquerade_tg_reg = {
 	.name		= "MASQUERADE",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.size		= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
 	.help		= MASQUERADE_help,
 	.init		= MASQUERADE_init,
 	.x6_parse	= MASQUERADE_parse,
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 5c4471a..dee7b01 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -7,7 +7,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <net/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_nat.h>
 
 #define MODULENAME "NETMAP"
 
@@ -45,7 +45,7 @@ netmask2bits(uint32_t netmask)
 
 static void NETMAP_init(struct xt_entry_target *t)
 {
-	struct nf_nat_multi_range *mr = (struct nf_nat_multi_range *)t->data;
+	struct nf_nat_ipv4_multi_range_compat *mr = (struct nf_nat_ipv4_multi_range_compat *)t->data;
 
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
@@ -53,11 +53,11 @@ static void NETMAP_init(struct xt_entry_target *t)
 
 static void NETMAP_parse(struct xt_option_call *cb)
 {
-	struct nf_nat_multi_range *mr = cb->data;
-	struct nf_nat_range *range = &mr->range[0];
+	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
+	struct nf_nat_ipv4_range *range = &mr->range[0];
 
 	xtables_option_parse(cb);
-	range->flags |= IP_NAT_RANGE_MAP_IPS;
+	range->flags |= NF_NAT_RANGE_MAP_IPS;
 	range->min_ip = cb->val.haddr.ip & cb->val.hmask.ip;
 	range->max_ip = range->min_ip | ~cb->val.hmask.ip;
 }
@@ -65,8 +65,8 @@ static void NETMAP_parse(struct xt_option_call *cb)
 static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
                          int numeric)
 {
-	const struct nf_nat_multi_range *mr = (const void *)target->data;
-	const struct nf_nat_range *r = &mr->range[0];
+	const struct nf_nat_ipv4_multi_range_compat *mr = (const void *)target->data;
+	const struct nf_nat_ipv4_range *r = &mr->range[0];
 	struct in_addr a;
 	int bits;
 
@@ -90,8 +90,8 @@ static struct xtables_target netmap_tg_reg = {
 	.name		= MODULENAME,
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.size		= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
 	.help		= NETMAP_help,
 	.init		= NETMAP_init,
 	.x6_parse	= NETMAP_parse,
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index e67360a..610a949 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -4,7 +4,7 @@
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <net/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_nat.h>
 
 enum {
 	O_TO_PORTS = 0,
@@ -30,7 +30,7 @@ static const struct xt_option_entry REDIRECT_opts[] = {
 
 static void REDIRECT_init(struct xt_entry_target *t)
 {
-	struct nf_nat_multi_range *mr = (struct nf_nat_multi_range *)t->data;
+	struct nf_nat_ipv4_multi_range_compat *mr = (struct nf_nat_ipv4_multi_range_compat *)t->data;
 
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
@@ -38,12 +38,12 @@ static void REDIRECT_init(struct xt_entry_target *t)
 
 /* Parses ports */
 static void
-parse_ports(const char *arg, struct nf_nat_multi_range *mr)
+parse_ports(const char *arg, struct nf_nat_ipv4_multi_range_compat *mr)
 {
 	char *end = "";
 	unsigned int port, maxport;
 
-	mr->range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+	mr->range[0].flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
 	if (!xtables_strtoui(arg, &end, &port, 0, UINT16_MAX) &&
 	    (port = xtables_service_to_port(arg, NULL)) == (unsigned)-1)
@@ -75,7 +75,7 @@ parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 static void REDIRECT_parse(struct xt_option_call *cb)
 {
 	const struct ipt_entry *entry = cb->xt_entry;
-	struct nf_nat_multi_range *mr = (void *)(*cb->target)->data;
+	struct nf_nat_ipv4_multi_range_compat *mr = (void *)(*cb->target)->data;
 	int portok;
 
 	if (entry->ip.proto == IPPROTO_TCP
@@ -95,11 +95,11 @@ static void REDIRECT_parse(struct xt_option_call *cb)
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 		parse_ports(cb->arg, mr);
 		if (cb->xflags & F_RANDOM)
-			mr->range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+			mr->range[0].flags |= NF_NAT_RANGE_PROTO_RANDOM;
 		break;
 	case O_RANDOM:
 		if (cb->xflags & F_TO_PORTS)
-			mr->range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+			mr->range[0].flags |= NF_NAT_RANGE_PROTO_RANDOM;
 		break;
 	}
 }
@@ -107,30 +107,30 @@ static void REDIRECT_parse(struct xt_option_call *cb)
 static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
                            int numeric)
 {
-	const struct nf_nat_multi_range *mr = (const void *)target->data;
-	const struct nf_nat_range *r = &mr->range[0];
+	const struct nf_nat_ipv4_multi_range_compat *mr = (const void *)target->data;
+	const struct nf_nat_ipv4_range *r = &mr->range[0];
 
-	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 		printf(" redir ports ");
 		printf("%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
 			printf("-%hu", ntohs(r->max.tcp.port));
-		if (mr->range[0].flags & IP_NAT_RANGE_PROTO_RANDOM)
+		if (mr->range[0].flags & NF_NAT_RANGE_PROTO_RANDOM)
 			printf(" random");
 	}
 }
 
 static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 {
-	const struct nf_nat_multi_range *mr = (const void *)target->data;
-	const struct nf_nat_range *r = &mr->range[0];
+	const struct nf_nat_ipv4_multi_range_compat *mr = (const void *)target->data;
+	const struct nf_nat_ipv4_range *r = &mr->range[0];
 
-	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 		printf(" --to-ports ");
 		printf("%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
 			printf("-%hu", ntohs(r->max.tcp.port));
-		if (mr->range[0].flags & IP_NAT_RANGE_PROTO_RANDOM)
+		if (mr->range[0].flags & NF_NAT_RANGE_PROTO_RANDOM)
 			printf(" --random");
 	}
 }
@@ -139,8 +139,8 @@ static struct xtables_target redirect_tg_reg = {
 	.name		= "REDIRECT",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.size		= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
 	.help		= REDIRECT_help,
 	.init		= REDIRECT_init,
  	.x6_parse	= REDIRECT_parse,
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 2ff6c82..251844e 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -2,7 +2,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <xtables.h>
-#include <net/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_nat.h>
 #include <linux/netfilter_ipv4/ipt_SAME.h>
 
 enum {
@@ -36,7 +36,7 @@ static const struct xt_option_entry SAME_opts[] = {
 };
 
 /* Parses range of IPs */
-static void parse_to(const char *orig_arg, struct nf_nat_range *range)
+static void parse_to(const char *orig_arg, struct nf_nat_ipv4_range *range)
 {
 	char *dash, *arg;
 	const struct in_addr *ip;
@@ -44,7 +44,7 @@ static void parse_to(const char *orig_arg, struct nf_nat_range *range)
 	arg = strdup(orig_arg);
 	if (arg == NULL)
 		xtables_error(RESOURCE_PROBLEM, "strdup");
-	range->flags |= IP_NAT_RANGE_MAP_IPS;
+	range->flags |= NF_NAT_RANGE_MAP_IPS;
 	dash = strchr(arg, '-');
 
 	if (dash)
@@ -87,7 +87,7 @@ static void SAME_parse(struct xt_option_call *cb)
 		/* WTF do we need this for? */
 		if (cb->xflags & F_RANDOM)
 			mr->range[mr->rangesize].flags 
-				|= IP_NAT_RANGE_PROTO_RANDOM;
+				|= NF_NAT_RANGE_PROTO_RANDOM;
 		mr->rangesize++;
 		break;
 	case O_NODST:
@@ -95,7 +95,7 @@ static void SAME_parse(struct xt_option_call *cb)
 		break;
 	case O_RANDOM:
 		for (count=0; count < mr->rangesize; count++)
-			mr->range[count].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+			mr->range[count].flags |= NF_NAT_RANGE_PROTO_RANDOM;
 		break;
 	}
 }
@@ -110,7 +110,7 @@ static void SAME_print(const void *ip, const struct xt_entry_target *target,
 	printf(" same:");
 
 	for (count = 0; count < mr->rangesize; count++) {
-		const struct nf_nat_range *r = &mr->range[count];
+		const struct nf_nat_ipv4_range *r = &mr->range[count];
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
@@ -120,7 +120,7 @@ static void SAME_print(const void *ip, const struct xt_entry_target *target,
 		
 		if (r->min_ip != r->max_ip)
 			printf("-%s", xtables_ipaddr_to_numeric(&a));
-		if (r->flags & IP_NAT_RANGE_PROTO_RANDOM) 
+		if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 			random_selection = 1;
 	}
 	
@@ -138,7 +138,7 @@ static void SAME_save(const void *ip, const struct xt_entry_target *target)
 	int random_selection = 0;
 
 	for (count = 0; count < mr->rangesize; count++) {
-		const struct nf_nat_range *r = &mr->range[count];
+		const struct nf_nat_ipv4_range *r = &mr->range[count];
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
@@ -147,7 +147,7 @@ static void SAME_save(const void *ip, const struct xt_entry_target *target)
 
 		if (r->min_ip != r->max_ip)
 			printf("-%s", xtables_ipaddr_to_numeric(&a));
-		if (r->flags & IP_NAT_RANGE_PROTO_RANDOM) 
+		if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 			random_selection = 1;
 	}
 	
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 8023306..e92557d 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -6,7 +6,7 @@
 #include <iptables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <net/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_nat.h>
 
 enum {
 	O_TO_SRC = 0,
@@ -23,7 +23,7 @@ enum {
 struct ipt_natinfo
 {
 	struct xt_entry_target t;
-	struct nf_nat_multi_range mr;
+	struct nf_nat_ipv4_multi_range_compat mr;
 };
 
 static void SNAT_help(void)
@@ -44,7 +44,7 @@ static const struct xt_option_entry SNAT_opts[] = {
 };
 
 static struct ipt_natinfo *
-append_range(struct ipt_natinfo *info, const struct nf_nat_range *range)
+append_range(struct ipt_natinfo *info, const struct nf_nat_ipv4_range *range)
 {
 	unsigned int size;
 
@@ -66,7 +66,7 @@ append_range(struct ipt_natinfo *info, const struct nf_nat_range *range)
 static struct xt_entry_target *
 parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 {
-	struct nf_nat_range range;
+	struct nf_nat_ipv4_range range;
 	char *arg, *colon, *dash, *error;
 	const struct in_addr *ip;
 
@@ -83,7 +83,7 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
-		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
 		port = atoi(colon+1);
 		if (port <= 0 || port > 65535)
@@ -122,7 +122,7 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 		*colon = '\0';
 	}
 
-	range.flags |= IP_NAT_RANGE_MAP_IPS;
+	range.flags |= NF_NAT_RANGE_MAP_IPS;
 	dash = strchr(arg, '-');
 	if (colon && dash && dash > colon)
 		dash = NULL;
@@ -176,22 +176,22 @@ static void SNAT_parse(struct xt_option_call *cb)
 		*cb->target = parse_to(cb->arg, portok, info);
 		/* WTF do we need this for?? */
 		if (cb->xflags & F_RANDOM)
-			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+			info->mr.range[0].flags |= NF_NAT_RANGE_PROTO_RANDOM;
 		cb->xflags |= F_X_TO_SRC;
 		break;
 	case O_RANDOM:
 		if (cb->xflags & F_TO_SRC)
-			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+			info->mr.range[0].flags |= NF_NAT_RANGE_PROTO_RANDOM;
 		break;
 	case O_PERSISTENT:
-		info->mr.range[0].flags |= IP_NAT_RANGE_PERSISTENT;
+		info->mr.range[0].flags |= NF_NAT_RANGE_PERSISTENT;
 		break;
 	}
 }
 
-static void print_range(const struct nf_nat_range *r)
+static void print_range(const struct nf_nat_ipv4_range *r)
 {
-	if (r->flags & IP_NAT_RANGE_MAP_IPS) {
+	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
@@ -201,7 +201,7 @@ static void print_range(const struct nf_nat_range *r)
 			printf("-%s", xtables_ipaddr_to_numeric(&a));
 		}
 	}
-	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 		printf(":");
 		printf("%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
@@ -218,9 +218,9 @@ static void SNAT_print(const void *ip, const struct xt_entry_target *target,
 	printf(" to:");
 	for (i = 0; i < info->mr.rangesize; i++) {
 		print_range(&info->mr.range[i]);
-		if (info->mr.range[i].flags & IP_NAT_RANGE_PROTO_RANDOM)
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM)
 			printf(" random");
-		if (info->mr.range[i].flags & IP_NAT_RANGE_PERSISTENT)
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT)
 			printf(" persistent");
 	}
 }
@@ -233,9 +233,9 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 	for (i = 0; i < info->mr.rangesize; i++) {
 		printf(" --to-source ");
 		print_range(&info->mr.range[i]);
-		if (info->mr.range[i].flags & IP_NAT_RANGE_PROTO_RANDOM)
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM)
 			printf(" --random");
-		if (info->mr.range[i].flags & IP_NAT_RANGE_PERSISTENT)
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT)
 			printf(" --persistent");
 	}
 }
@@ -244,8 +244,8 @@ static struct xtables_target snat_tg_reg = {
 	.name		= "SNAT",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.size		= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
 	.help		= SNAT_help,
 	.x6_parse	= SNAT_parse,
 	.print		= SNAT_print,
diff --git a/include/linux/netfilter/nf_conntrack_tuple_common.h b/include/linux/netfilter/nf_conntrack_tuple_common.h
index 2ea22b0..2f6bbc5 100644
--- a/include/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/linux/netfilter/nf_conntrack_tuple_common.h
@@ -7,6 +7,33 @@ enum ip_conntrack_dir {
 	IP_CT_DIR_MAX
 };
 
+/* The protocol-specific manipulable parts of the tuple: always in
+ * network order
+ */
+union nf_conntrack_man_proto {
+	/* Add other protocols here. */
+	__be16 all;
+
+	struct {
+		__be16 port;
+	} tcp;
+	struct {
+		__be16 port;
+	} udp;
+	struct {
+		__be16 id;
+	} icmp;
+	struct {
+		__be16 port;
+	} dccp;
+	struct {
+		__be16 port;
+	} sctp;
+	struct {
+		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
+	} gre;
+};
+
 #define CTINFO2DIR(ctinfo) ((ctinfo) >= IP_CT_IS_REPLY ? IP_CT_DIR_REPLY : IP_CT_DIR_ORIGINAL)
 
 #endif /* _NF_CONNTRACK_TUPLE_COMMON_H */
diff --git a/include/linux/netfilter/nf_nat.h b/include/linux/netfilter/nf_nat.h
new file mode 100644
index 0000000..8df2d13
--- /dev/null
+++ b/include/linux/netfilter/nf_nat.h
@@ -0,0 +1,25 @@
+#ifndef _NETFILTER_NF_NAT_H
+#define _NETFILTER_NF_NAT_H
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+
+#define NF_NAT_RANGE_MAP_IPS		1
+#define NF_NAT_RANGE_PROTO_SPECIFIED	2
+#define NF_NAT_RANGE_PROTO_RANDOM	4
+#define NF_NAT_RANGE_PERSISTENT		8
+
+struct nf_nat_ipv4_range {
+	unsigned int			flags;
+	__be32				min_ip;
+	__be32				max_ip;
+	union nf_conntrack_man_proto	min;
+	union nf_conntrack_man_proto	max;
+};
+
+struct nf_nat_ipv4_multi_range_compat {
+	unsigned int			rangesize;
+	struct nf_nat_ipv4_range	range[1];
+};
+
+#endif /* _NETFILTER_NF_NAT_H */
diff --git a/include/linux/netfilter_ipv4/ipt_SAME.h b/include/linux/netfilter_ipv4/ipt_SAME.h
index 5bca782..a855167 100644
--- a/include/linux/netfilter_ipv4/ipt_SAME.h
+++ b/include/linux/netfilter_ipv4/ipt_SAME.h
@@ -14,7 +14,7 @@ struct ipt_same_info {
 	__u32 *iparray;
 
 	/* hangs off end. */
-	struct nf_nat_range range[IPT_SAME_MAX_RANGE];
+	struct nf_nat_ipv4_range range[IPT_SAME_MAX_RANGE];
 };
 
 #endif /*_IPT_SAME_H*/
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
deleted file mode 100644
index c40e0b4..0000000
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ /dev/null
@@ -1,114 +0,0 @@
-/* This file was manually copied from the Linux kernel source
- * and manually stripped from __KERNEL__ sections and unused functions.
- */
-
-/*
- * Definitions and Declarations for tuple.
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- generalize L3 protocol dependent part.
- *
- * Derived from include/linux/netfiter_ipv4/ip_conntrack_tuple.h
- */
-
-#ifndef _NF_CONNTRACK_TUPLE_H
-#define _NF_CONNTRACK_TUPLE_H
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/nf_conntrack_tuple_common.h>
-
-/* A `tuple' is a structure containing the information to uniquely
-  identify a connection.  ie. if two packets have the same tuple, they
-  are in the same connection; if not, they are not.
-
-  We divide the structure along "manipulatable" and
-  "non-manipulatable" lines, for the benefit of the NAT code.
-*/
-
-#define NF_CT_TUPLE_L3SIZE	ARRAY_SIZE(((union nf_inet_addr *)NULL)->all)
-
-/* The protocol-specific manipulable parts of the tuple: always in
-   network order! */
-union nf_conntrack_man_proto
-{
-	/* Add other protocols here. */
-	__be16 all;
-
-	struct {
-		__be16 port;
-	} tcp;
-	struct {
-		__be16 port;
-	} udp;
-	struct {
-		__be16 id;
-	} icmp;
-	struct {
-		__be16 port;
-	} dccp;
-	struct {
-		__be16 port;
-	} sctp;
-	struct {
-		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
-	} gre;
-};
-
-/* The manipulable part of the tuple. */
-struct nf_conntrack_man
-{
-	union nf_inet_addr u3;
-	union nf_conntrack_man_proto u;
-	/* Layer 3 protocol */
-	u_int16_t l3num;
-};
-
-/* This contains the information to distinguish a connection. */
-struct nf_conntrack_tuple
-{
-	struct nf_conntrack_man src;
-
-	/* These are the parts of the tuple which are fixed. */
-	struct {
-		union nf_inet_addr u3;
-		union {
-			/* Add other protocols here. */
-			__be16 all;
-
-			struct {
-				__be16 port;
-			} tcp;
-			struct {
-				__be16 port;
-			} udp;
-			struct {
-				u_int8_t type, code;
-			} icmp;
-			struct {
-				__be16 port;
-			} dccp;
-			struct {
-				__be16 port;
-			} sctp;
-			struct {
-				__be16 key;
-			} gre;
-		} u;
-
-		/* The protocol. */
-		u_int8_t protonum;
-
-		/* The direction (for tuplehash) */
-		u_int8_t dir;
-	} dst;
-};
-
-struct nf_conntrack_tuple_mask
-{
-	struct {
-		union nf_inet_addr u3;
-		union nf_conntrack_man_proto u;
-	} src;
-};
-
-#endif /* _NF_CONNTRACK_TUPLE_H */
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
deleted file mode 100644
index c3e2060..0000000
--- a/include/net/netfilter/nf_nat.h
+++ /dev/null
@@ -1,55 +0,0 @@
-#ifndef _NF_NAT_H
-#define _NF_NAT_H
-#include <linux/netfilter_ipv4.h>
-#include <net/netfilter/nf_conntrack_tuple.h>
-
-#define NF_NAT_MAPPING_TYPE_MAX_NAMELEN 16
-
-enum nf_nat_manip_type
-{
-	IP_NAT_MANIP_SRC,
-	IP_NAT_MANIP_DST
-};
-
-/* SRC manip occurs POST_ROUTING or LOCAL_IN */
-#define HOOK2MANIP(hooknum) ((hooknum) != NF_INET_POST_ROUTING && \
-			     (hooknum) != NF_INET_LOCAL_IN)
-
-#define IP_NAT_RANGE_MAP_IPS 1
-#define IP_NAT_RANGE_PROTO_SPECIFIED 2
-#define IP_NAT_RANGE_PROTO_RANDOM 4
-#define IP_NAT_RANGE_PERSISTENT 8
-
-/* NAT sequence number modifications */
-struct nf_nat_seq {
-	/* position of the last TCP sequence number modification (if any) */
-	u_int32_t correction_pos;
-
-	/* sequence number offset before and after last modification */
-	int16_t offset_before, offset_after;
-};
-
-/* Single range specification. */
-struct nf_nat_range
-{
-	/* Set to OR of flags above. */
-	unsigned int flags;
-
-	/* Inclusive: network order. */
-	__be32 min_ip, max_ip;
-
-	/* Inclusive: network order */
-	union nf_conntrack_man_proto min, max;
-};
-
-/* For backwards compat: don't use in modern code. */
-struct nf_nat_multi_range_compat
-{
-	unsigned int rangesize; /* Must be 1. */
-
-	/* hangs off end. */
-	struct nf_nat_range range[1];
-};
-
-#define nf_nat_multi_range nf_nat_multi_range_compat
-#endif
-- 
1.7.1

