From: kaber@trash.net
Subject: [PATCH 2/7] extensions: add IPv6 MASQUERADE extension
Date: Thu,  9 Aug 2012 22:11:08 +0200
Message-ID: <1344543073-11660-3-git-send-email-kaber@trash.net>
References: <1344543073-11660-1-git-send-email-kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65366 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2HIUXi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:23:38 -0400
Received: from gw.localnet (localhost [127.0.0.1])
	by stinky.trash.net (Postfix) with ESMTP id EAE93B2C60
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Aug 2012 22:11:15 +0200 (MEST)
In-Reply-To: <1344543073-11660-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 extensions/libip6t_MASQUERADE.c   |  150 +++++++++++++++++++++++++++++++++++++
 extensions/libip6t_MASQUERADE.man |   30 ++++++++
 include/linux/netfilter/nf_nat.h  |    8 ++
 3 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libip6t_MASQUERADE.c
 create mode 100644 extensions/libip6t_MASQUERADE.man

diff --git a/extensions/libip6t_MASQUERADE.c b/extensions/libip6t_MASQUERADE.c
new file mode 100644
index 0000000..eb9213e
--- /dev/null
+++ b/extensions/libip6t_MASQUERADE.c
@@ -0,0 +1,150 @@
+/*
+ * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
+ *
+ * Based on Rusty Russell's IPv4 MASQUERADE target. Development of IPv6 NAT
+ * funded by Astaro.
+ */
+
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <xtables.h>
+#include <limits.h> /* INT_MAX in ip_tables.h */
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/nf_nat.h>
+
+enum {
+	O_TO_PORTS = 0,
+	O_RANDOM,
+};
+
+static void MASQUERADE_help(void)
+{
+	printf(
+"MASQUERADE target options:\n"
+" --to-ports <port>[-<port>]\n"
+"				Port (range) to map to.\n"
+" --random\n"
+"				Randomize source port.\n");
+}
+
+static const struct xt_option_entry MASQUERADE_opts[] = {
+	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING},
+	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
+};
+
+/* Parses ports */
+static void
+parse_ports(const char *arg, struct nf_nat_range *r)
+{
+	char *end;
+	unsigned int port, maxport;
+
+	r->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+
+	if (!xtables_strtoui(arg, &end, &port, 0, UINT16_MAX))
+		xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
+
+	switch (*end) {
+	case '\0':
+		r->min_proto.tcp.port
+			= r->max_proto.tcp.port
+			= htons(port);
+		return;
+	case '-':
+		if (!xtables_strtoui(end + 1, NULL, &maxport, 0, UINT16_MAX))
+			break;
+
+		if (maxport < port)
+			break;
+
+		r->min_proto.tcp.port = htons(port);
+		r->max_proto.tcp.port = htons(maxport);
+		return;
+	default:
+		break;
+	}
+	xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
+}
+
+static void MASQUERADE_parse(struct xt_option_call *cb)
+{
+	const struct ip6t_entry *entry = cb->xt_entry;
+	struct nf_nat_range *r = cb->data;
+	int portok;
+
+	if (entry->ipv6.proto == IPPROTO_TCP ||
+	    entry->ipv6.proto == IPPROTO_UDP ||
+	    entry->ipv6.proto == IPPROTO_SCTP ||
+	    entry->ipv6.proto == IPPROTO_DCCP ||
+	    entry->ipv6.proto == IPPROTO_ICMP)
+		portok = 1;
+	else
+		portok = 0;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_TO_PORTS:
+		if (!portok)
+			xtables_error(PARAMETER_PROBLEM,
+				   "Need TCP, UDP, SCTP or DCCP with port specification");
+		parse_ports(cb->arg, r);
+		break;
+	case O_RANDOM:
+		r->flags |=  NF_NAT_RANGE_PROTO_RANDOM;
+		break;
+	}
+}
+
+static void
+MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
+                 int numeric)
+{
+	const struct nf_nat_range *r = (const void *)target->data;
+
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		printf(" masq ports: ");
+		printf("%hu", ntohs(r->min_proto.tcp.port));
+		if (r->max_proto.tcp.port != r->min_proto.tcp.port)
+			printf("-%hu", ntohs(r->max_proto.tcp.port));
+	}
+
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
+		printf(" random");
+}
+
+static void
+MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct nf_nat_range *r = (const void *)target->data;
+
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		printf(" --to-ports %hu", ntohs(r->min_proto.tcp.port));
+		if (r->max_proto.tcp.port != r->min_proto.tcp.port)
+			printf("-%hu", ntohs(r->max_proto.tcp.port));
+	}
+
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
+		printf(" --random");
+}
+
+static struct xtables_target masquerade_tg_reg = {
+	.name		= "MASQUERADE",
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_IPV6,
+	.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
+	.help		= MASQUERADE_help,
+	.x6_parse	= MASQUERADE_parse,
+	.print		= MASQUERADE_print,
+	.save		= MASQUERADE_save,
+	.x6_options	= MASQUERADE_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&masquerade_tg_reg);
+}
diff --git a/extensions/libip6t_MASQUERADE.man b/extensions/libip6t_MASQUERADE.man
new file mode 100644
index 0000000..c63d826
--- /dev/null
+++ b/extensions/libip6t_MASQUERADE.man
@@ -0,0 +1,30 @@
+This target is only valid in the
+.B nat
+table, in the
+.B POSTROUTING
+chain.  It should only be used with dynamically assigned IPv6 (dialup)
+connections: if you have a static IP address, you should use the SNAT
+target.  Masquerading is equivalent to specifying a mapping to the IP
+address of the interface the packet is going out, but also has the
+effect that connections are
+.I forgotten
+when the interface goes down.  This is the correct behavior when the
+next dialup is unlikely to have the same interface address (and hence
+any established connections are lost anyway).
+.TP
+\fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
+This specifies a range of source ports to use, overriding the default
+.B SNAT
+source port-selection heuristics (see above).  This is only valid
+if the rule also specifies
+\fB\-p tcp\fP
+or
+\fB\-p udp\fP.
+.TP
+\fB\-\-random\fP
+Randomize source port mapping
+If option
+\fB\-\-random\fP
+is used then port mapping will be randomized.
+.RS
+.PP
diff --git a/include/linux/netfilter/nf_nat.h b/include/linux/netfilter/nf_nat.h
index 8df2d13..bf0cc37 100644
--- a/include/linux/netfilter/nf_nat.h
+++ b/include/linux/netfilter/nf_nat.h
@@ -22,4 +22,12 @@ struct nf_nat_ipv4_multi_range_compat {
 	struct nf_nat_ipv4_range	range[1];
 };
 
+struct nf_nat_range {
+	unsigned int			flags;
+	union nf_inet_addr		min_addr;
+	union nf_inet_addr		max_addr;
+	union nf_conntrack_man_proto	min_proto;
+	union nf_conntrack_man_proto	max_proto;
+};
+
 #endif /* _NETFILTER_NF_NAT_H */
-- 
1.7.1

