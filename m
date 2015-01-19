From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 7/7] ebtables-compat: add 'ip' match
 extension
Date: Mon, 19 Jan 2015 14:28:07 +0100
Message-ID: <20150119132807.7422.79807.stgit@nfdev.cica.es>
References: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:48790 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751558AbbASN2R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:28:17 -0500
In-Reply-To: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the 'ip' match extension to ebtables-compat.

It involves adapting old ebtables extension code to the xtables-compat
environment.

For testing:
% sudo ebtables-compat -p 0x0800 --ip-src 1.1.1.1 -j ACCEPT

The patch includes a cached copy of the extension kernel header.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/libebt_ip.c                  |  326 +++++++++++++++++++++++++++++++
 include/linux/netfilter_bridge/ebt_ip.h |   44 ++++
 iptables/xtables-eb.c                   |    1 
 3 files changed, 371 insertions(+)
 create mode 100644 extensions/libebt_ip.c
 create mode 100644 include/linux/netfilter_bridge/ebt_ip.h

diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
new file mode 100644
index 0000000..ffb7ed6
--- /dev/null
+++ b/extensions/libebt_ip.c
@@ -0,0 +1,326 @@
+/* ebt_ip
+ *
+ * Authors:
+ * Bart De Schuymer <bdschuym@pandora.be>
+ *
+ * Changes:
+ *    added ip-sport and ip-dport; parsing of port arguments is
+ *    based on code from iptables-1.2.7a
+ *    Innominate Security Technologies AG <mhopf@innominate.com>
+ *    September, 2002
+ *
+ * Adapted by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * to use libxtables for ebtables-compat in 2015.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <xtables.h>
+#include <linux/netfilter_bridge/ebt_ip.h>
+
+#define IP_SOURCE	'1'
+#define IP_DEST		'2'
+#define IP_EBT_TOS	'3' /* include/bits/in.h seems to already define IP_TOS */
+#define IP_PROTO	'4'
+#define IP_SPORT	'5'
+#define IP_DPORT	'6'
+
+static const struct option brip_opts[] = {
+	{ .name = "ip-source",		.has_arg = true, .val = IP_SOURCE },
+	{ .name = "ip-src",		.has_arg = true, .val = IP_SOURCE },
+	{ .name = "ip-destination",	.has_arg = true, .val = IP_DEST },
+	{ .name = "ip-dst",		.has_arg = true, .val = IP_DEST },
+	{ .name = "ip-tos",		.has_arg = true, .val = IP_EBT_TOS },
+	{ .name = "ip-protocol",	.has_arg = true, .val = IP_PROTO },
+	{ .name = "ip-proto",		.has_arg = true, .val = IP_PROTO },
+	{ .name = "ip-source-port",	.has_arg = true, .val = IP_SPORT },
+	{ .name = "ip-sport",		.has_arg = true, .val = IP_SPORT },
+	{ .name = "ip-destination-port",.has_arg = true, .val = IP_DPORT },
+	{ .name = "ip-dport",		.has_arg = true, .val = IP_DPORT },
+	XT_GETOPT_TABLEEND,
+};
+
+static void brip_print_help(void)
+{
+	printf(
+"ip options:\n"
+"--ip-src    [!] address[/mask]: ip source specification\n"
+"--ip-dst    [!] address[/mask]: ip destination specification\n"
+"--ip-tos    [!] tos           : ip tos specification\n"
+"--ip-proto  [!] protocol      : ip protocol specification\n"
+"--ip-sport  [!] port[:port]   : tcp/udp source port or port range\n"
+"--ip-dport  [!] port[:port]   : tcp/udp destination port or port range\n");
+}
+
+static void brip_init(struct xt_entry_match *match)
+{
+	struct ebt_ip_info *info = (struct ebt_ip_info *)match->data;
+
+	info->invflags = 0;
+	info->bitmask = 0;
+}
+
+static void
+parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(portstring);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		ports[0] = ports[1] = xtables_parse_port(buffer, NULL);
+	else {
+		*cp = '\0';
+		cp++;
+
+		ports[0] = buffer[0] ? xtables_parse_port(buffer, NULL) : 0;
+		ports[1] = cp[0] ? xtables_parse_port(cp, NULL) : 0xFFFF;
+
+		if (ports[0] > ports[1])
+			xtables_error(PARAMETER_PROBLEM,
+				      "invalid portrange (min > max)");
+	}
+	free(buffer);
+}
+
+/* original code from ebtables: useful_functions.c */
+static int undot_ip(char *ip, unsigned char *ip2)
+{
+	char *p, *q, *end;
+	long int onebyte;
+	int i;
+	char buf[20];
+
+	strncpy(buf, ip, sizeof(buf) - 1);
+
+	p = buf;
+	for (i = 0; i < 3; i++) {
+		if ((q = strchr(p, '.')) == NULL)
+			return -1;
+		*q = '\0';
+		onebyte = strtol(p, &end, 10);
+		if (*end != '\0' || onebyte > 255 || onebyte < 0)
+			return -1;
+		ip2[i] = (unsigned char)onebyte;
+		p = q + 1;
+	}
+
+	onebyte = strtol(p, &end, 10);
+	if (*end != '\0' || onebyte > 255 || onebyte < 0)
+		return -1;
+	ip2[3] = (unsigned char)onebyte;
+
+	return 0;
+}
+
+static int ip_mask(char *mask, unsigned char *mask2)
+{
+	char *end;
+	long int bits;
+	uint32_t mask22;
+
+	if (undot_ip(mask, mask2)) {
+		/* not the /a.b.c.e format, maybe the /x format */
+		bits = strtol(mask, &end, 10);
+		if (*end != '\0' || bits > 32 || bits < 0)
+			return -1;
+		if (bits != 0) {
+			mask22 = htonl(0xFFFFFFFF << (32 - bits));
+			memcpy(mask2, &mask22, 4);
+		} else {
+			mask22 = 0xFFFFFFFF;
+			memcpy(mask2, &mask22, 4);
+		}
+	}
+	return 0;
+}
+
+static void ebt_parse_ip_address(char *address, uint32_t *addr, uint32_t *msk)
+{
+	char *p;
+
+	/* first the mask */
+	if ((p = strrchr(address, '/')) != NULL) {
+		*p = '\0';
+		if (ip_mask(p + 1, (unsigned char *)msk)) {
+			xtables_error(PARAMETER_PROBLEM,
+				      "Problem with the IP mask '%s'", p + 1);
+			return;
+		}
+	} else
+		*msk = 0xFFFFFFFF;
+
+	if (undot_ip(address, (unsigned char *)addr)) {
+		xtables_error(PARAMETER_PROBLEM,
+			      "Problem with the IP address '%s'", address);
+		return;
+	}
+	*addr = *addr & *msk;
+}
+
+static int
+brip_parse(int c, char **argv, int invert, unsigned int *flags,
+	   const void *entry, struct xt_entry_match **match)
+{
+	struct ebt_ip_info *info = (struct ebt_ip_info *)(*match)->data;
+
+	switch (c) {
+	case IP_SOURCE:
+		if (invert)
+			info->invflags |= EBT_IP_SOURCE;
+		ebt_parse_ip_address(optarg, &info->saddr, &info->smsk);
+		info->bitmask |= EBT_IP_SOURCE;
+		break;
+	case IP_DEST:
+		if (invert)
+			info->invflags |= EBT_IP_DEST;
+		ebt_parse_ip_address(optarg, &info->daddr, &info->dmsk);
+		info->bitmask |= EBT_IP_DEST;
+		break;
+	case IP_SPORT:
+		if (invert)
+			info->invflags |= EBT_IP_SPORT;
+		parse_port_range(NULL, optarg, info->sport);
+		info->bitmask |= EBT_IP_SPORT;
+		break;
+	case IP_DPORT:
+		if (invert)
+			info->invflags |= EBT_IP_DPORT;
+		parse_port_range(NULL, optarg, info->dport);
+		info->bitmask |= EBT_IP_DPORT;
+		break;
+	case IP_EBT_TOS:
+		if (invert)
+			info->invflags |= EBT_IP_TOS;
+		if (!xtables_strtoul(optarg, NULL, (uintmax_t *)&info->tos,
+				     0, 255))
+			xtables_error(PARAMETER_PROBLEM,
+				      "Problem with specified IP tos");
+		info->bitmask |= EBT_IP_TOS;
+		break;
+	case IP_PROTO:
+		if (invert)
+			info->invflags |= EBT_IP_PROTO;
+		info->protocol = xtables_parse_protocol(optarg);
+		if (info->protocol == -1)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Unknown specified IP protocol - %s",
+				      optarg);
+		info->bitmask |= EBT_IP_PROTO;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void brip_final_check(unsigned int flags)
+{
+/*	struct ebt_ip_info *ipinfo = (struct ebt_ip_info *)match->data;
+
+	if (entry->ethproto != ETH_P_IP || entry->invflags & EBT_IPROTO) {
+		ebt_print_error("For IP filtering the protocol must be "
+		            "specified as IPv4");
+	} else if (info->bitmask & (EBT_IP_SPORT|EBT_IP_DPORT) &&
+		(!(info->bitmask & EBT_IP_PROTO) ||
+		info->invflags & EBT_IP_PROTO ||
+		(info->protocol!=IPPROTO_TCP &&
+		 info->protocol!=IPPROTO_UDP &&
+		 info->protocol!=IPPROTO_SCTP &&
+		 info->protocol!=IPPROTO_DCCP)))
+		ebt_print_error("For port filtering the IP protocol must be "
+				"either 6 (tcp), 17 (udp), 33 (dccp) or "
+				"132 (sctp)");
+*/
+	if (!flags)
+		xtables_error(PARAMETER_PROBLEM,
+			      "You must specify proper arguments");
+}
+
+static void print_port_range(uint16_t *ports)
+{
+	if (ports[0] == ports[1])
+		printf("%d ", ports[0]);
+	else
+		printf("%d:%d ", ports[0], ports[1]);
+}
+
+static void brip_print(const void *ip, const struct xt_entry_match *match,
+		       int numeric)
+{
+	struct ebt_ip_info *info = (struct ebt_ip_info *)match->data;
+	struct in_addr *addrp, *maskp;
+
+	if (info->bitmask & EBT_IP_SOURCE) {
+		printf("--ip-src ");
+		if (info->invflags & EBT_IP_SOURCE)
+			printf("! ");
+		addrp = (struct in_addr *)&info->saddr;
+		maskp = (struct in_addr *)&info->smsk;
+		printf("%s%s ", xtables_ipaddr_to_numeric(addrp),
+		       xtables_ipmask_to_numeric(maskp));
+	}
+	if (info->bitmask & EBT_IP_DEST) {
+		printf("--ip-dst ");
+		if (info->invflags & EBT_IP_DEST)
+			printf("! ");
+		addrp = (struct in_addr *)&info->daddr;
+		maskp = (struct in_addr *)&info->dmsk;
+		printf("%s%s ", xtables_ipaddr_to_numeric(addrp),
+		       xtables_ipmask_to_numeric(maskp));
+	}
+	if (info->bitmask & EBT_IP_TOS) {
+		printf("--ip-tos ");
+		if (info->invflags & EBT_IP_TOS)
+			printf("! ");
+		printf("0x%02X ", info->tos);
+	}
+	if (info->bitmask & EBT_IP_PROTO) {
+		struct protoent *pe;
+
+		printf("--ip-proto ");
+		if (info->invflags & EBT_IP_PROTO)
+			printf("! ");
+		pe = getprotobynumber(info->protocol);
+		if (pe == NULL) {
+			printf("%d ", info->protocol);
+		} else {
+			printf("%s ", pe->p_name);
+		}
+	}
+	if (info->bitmask & EBT_IP_SPORT) {
+		printf("--ip-sport ");
+		if (info->invflags & EBT_IP_SPORT)
+			printf("! ");
+		print_port_range(info->sport);
+	}
+	if (info->bitmask & EBT_IP_DPORT) {
+		printf("--ip-dport ");
+		if (info->invflags & EBT_IP_DPORT)
+			printf("! ");
+		print_port_range(info->dport);
+	}
+}
+
+static struct xtables_match brip_match = {
+	.name		= "ip",
+	.revision	= 0,
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_BRIDGE,
+	.size		= XT_ALIGN(sizeof(struct ebt_ip_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct ebt_ip_info)),
+	.init		= brip_init,
+	.help		= brip_print_help,
+	.parse		= brip_parse,
+	.final_check	= brip_final_check,
+	.print		= brip_print,
+	.extra_opts	= brip_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&brip_match);
+}
diff --git a/include/linux/netfilter_bridge/ebt_ip.h b/include/linux/netfilter_bridge/ebt_ip.h
new file mode 100644
index 0000000..c4bbc41
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_ip.h
@@ -0,0 +1,44 @@
+/*
+ *  ebt_ip
+ *
+ *	Authors:
+ *	Bart De Schuymer <bart.de.schuymer@pandora.be>
+ *
+ *  April, 2002
+ *
+ *  Changes:
+ *    added ip-sport and ip-dport
+ *    Innominate Security Technologies AG <mhopf@innominate.com>
+ *    September, 2002
+ */
+
+#ifndef __LINUX_BRIDGE_EBT_IP_H
+#define __LINUX_BRIDGE_EBT_IP_H
+
+#include <linux/types.h>
+
+#define EBT_IP_SOURCE 0x01
+#define EBT_IP_DEST 0x02
+#define EBT_IP_TOS 0x04
+#define EBT_IP_PROTO 0x08
+#define EBT_IP_SPORT 0x10
+#define EBT_IP_DPORT 0x20
+#define EBT_IP_MASK (EBT_IP_SOURCE | EBT_IP_DEST | EBT_IP_TOS | EBT_IP_PROTO |\
+ EBT_IP_SPORT | EBT_IP_DPORT )
+#define EBT_IP_MATCH "ip"
+
+/* the same values are used for the invflags */
+struct ebt_ip_info {
+	__be32 saddr;
+	__be32 daddr;
+	__be32 smsk;
+	__be32 dmsk;
+	__u8  tos;
+	__u8  protocol;
+	__u8  bitmask;
+	__u8  invflags;
+	__u16 sport[2];
+	__u16 dport[2];
+};
+
+#endif
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index a078679..27a1c16 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -639,6 +639,7 @@ static void ebt_load_matches(void)
 {
 	opts = ebt_original_options;
 	ebt_load_match("802_3");
+	ebt_load_match("ip");
 }
 
 static void ebt_add_match(struct xtables_match *m,

