From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 3/3] libxtables: Port libarptc mangle target into libxtables
Date: Fri,  6 Sep 2013 10:51:50 +0300
Message-ID: <1378453910-17954-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3IFHv6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Sep 2013 03:51:58 -0400
In-Reply-To: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Refactoring original code so functions fits with xtables_target
structure.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 extensions/libarpt_mangle.c               | 388 ++++++++++++++++++++++++++++++
 include/linux/netfilter_arp/arpt_mangle.h |  26 ++
 2 files changed, 414 insertions(+)
 create mode 100644 extensions/libarpt_mangle.c
 create mode 100644 include/linux/netfilter_arp/arpt_mangle.h

diff --git a/extensions/libarpt_mangle.c b/extensions/libarpt_mangle.c
new file mode 100644
index 0000000..1c14c2c
--- /dev/null
+++ b/extensions/libarpt_mangle.c
@@ -0,0 +1,388 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Authors:
+ * 	Libarptc code from: Bart De Schuymer <bdschuym@pandora.be>
+ * 	Port to libxtables: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ */
+
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <getopt.h>
+#include <errno.h>
+#include <netinet/ether.h>
+
+#include <xtables.h>
+#include <linux/netfilter_arp/arpt_mangle.h>
+
+static void mangle_help(void)
+{
+	printf(
+"mangle target options:\n"
+"--mangle-ip-s IP address\n"
+"--mangle-ip-d IP address\n"
+"--mangle-mac-s MAC address\n"
+"--mangle-mac-d MAC address\n"
+"--mangle-target target (DROP, CONTINUE or ACCEPT -- default is ACCEPT)\n"
+	);
+}
+
+#define MANGLE_IPS    '1'
+#define MANGLE_IPT    '2'
+#define MANGLE_DEVS   '3'
+#define MANGLE_DEVT   '4'
+#define MANGLE_TARGET '5'
+static const struct xt_option_entry mangle_opts[] = {
+	{ .name = "mangle-ip-s", .id = MANGLE_IPS, .type = XTTYPE_STRING,
+	  .flags = XTOPT_MAND },
+	{ .name = "mangle-ip-d", .id = MANGLE_IPT, .type = XTTYPE_STRING,
+	  .flags = XTOPT_MAND },
+	{ .name = "mangle-mac-s", .id = MANGLE_DEVS, .type = XTTYPE_STRING,
+	  .flags = XTOPT_MAND },
+	{ .name = "mangle-mac-d", .id = MANGLE_DEVT, .type = XTTYPE_STRING,
+	  .flags = XTOPT_MAND },
+	{ .name = "mangle-target", .id = MANGLE_TARGET, .type = XTTYPE_STRING,
+	  .flags = XTOPT_MAND },
+	XTOPT_TABLEEND,
+};
+
+
+static struct in_addr *network_to_addr(const char *name)
+{
+	struct netent *net;
+	static struct in_addr addr;
+
+	if ((net = getnetbyname(name)) != NULL) {
+		if (net->n_addrtype != AF_INET)
+			return (struct in_addr *) NULL;
+		addr.s_addr = htonl((unsigned long) net->n_net);
+		return &addr;
+	}
+
+	return (struct in_addr *) NULL;
+}
+
+static void inaddrcpy(struct in_addr *dst, struct in_addr *src)
+{
+	dst->s_addr = src->s_addr;
+}
+
+static struct in_addr *host_to_addr(const char *name, unsigned int *naddr)
+{
+	struct hostent *host;
+	struct in_addr *addr;
+	unsigned int i;
+
+	*naddr = 0;
+	if ((host = gethostbyname(name)) != NULL) {
+		if (host->h_addrtype != AF_INET ||
+			host->h_length != sizeof(struct in_addr))
+			return (struct in_addr *) NULL;
+
+		while (host->h_addr_list[*naddr] != (char *) NULL)
+			(*naddr)++;
+		addr = xtables_calloc(*naddr, sizeof(struct in_addr));
+		for (i = 0; i < *naddr; i++)
+			inaddrcpy(&(addr[i]),
+				  (struct in_addr *) host->h_addr_list[i]);
+		return addr;
+	}
+
+	return (struct in_addr *) NULL;
+}
+
+static int string_to_number(const char *s, unsigned int min,
+			    unsigned int max, unsigned int *ret)
+{
+	long number;
+	char *end;
+
+	/* Handle hex, octal, etc. */
+	errno = 0;
+	number = strtol(s, &end, 0);
+	if (*end == '\0' && end != s) {
+		/* we parsed a number, let's see if we want this */
+		if (errno != ERANGE && min <= number && number <= max) {
+			*ret = number;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+static struct in_addr *dotted_to_addr(const char *dotted)
+{
+	static struct in_addr addr;
+	unsigned char *addrp;
+	char *p, *q;
+	unsigned int onebyte;
+	int i;
+	char buf[20];
+
+	/* copy dotted string, because we need to modify it */
+	strncpy(buf, dotted, sizeof(buf) - 1);
+	addrp = (unsigned char *) &(addr.s_addr);
+
+	p = buf;
+	for (i = 0; i < 3; i++) {
+		if ((q = strchr(p, '.')) == NULL)
+			return (struct in_addr *) NULL;
+
+		*q = '\0';
+		if (string_to_number(p, 0, 255, &onebyte) == -1)
+			return (struct in_addr *) NULL;
+
+		addrp[i] = (unsigned char) onebyte;
+		p = q + 1;
+	}
+
+	/* we've checked 3 bytes, now we check the last one */
+	if (string_to_number(p, 0, 255, &onebyte) == -1)
+		return (struct in_addr *) NULL;
+
+	addrp[3] = (unsigned char) onebyte;
+
+	return &addr;
+}
+
+static struct in_addr *parse_hostnetwork(const char *name,
+					 unsigned int *naddrs)
+{
+	struct in_addr *addrp, *addrptmp;
+
+	if ((addrptmp = dotted_to_addr(name)) != NULL ||
+		(addrptmp = network_to_addr(name)) != NULL) {
+		addrp = xtables_malloc(sizeof(struct in_addr));
+		inaddrcpy(addrp, addrptmp);
+		*naddrs = 1;
+		return addrp;
+	}
+	if ((addrp = host_to_addr(name, naddrs)) != NULL)
+		return addrp;
+
+	xtables_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
+}
+
+static void mangle_parse(struct xt_option_call *cb)
+{
+	const struct arpt_entry *e = cb->xt_entry;
+	struct arpt_mangle *mangle =  cb->data;
+	struct in_addr *ipaddr;
+	struct ether_addr *macaddr;
+
+	/* mangle target is by default "ACCEPT". Setting it here,
+	 * since original arpt_mangle.c init() no longer exists*/
+	mangle->target = NF_ACCEPT;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case MANGLE_IPS:
+/*
+		if (e->arp.arpln_mask == 0)
+			xtables_error(PARAMETER_PROBLEM, "no pln defined");
+
+		if (e->arp.invflags & ARPT_INV_ARPPLN)
+			xtables_error(PARAMETER_PROBLEM,
+				   "! pln not allowed for --mangle-ip-s");
+*/
+/*
+		if (e->arp.arpln != 4)
+			xtables_error(PARAMETER_PROBLEM, "only pln=4 supported");
+*/
+		{
+			unsigned int nr;
+			ipaddr = parse_hostnetwork(cb->arg, &nr);
+		}
+		mangle->u_s.src_ip.s_addr = ipaddr->s_addr;
+		free(ipaddr);
+		mangle->flags |= ARPT_MANGLE_SIP;
+		break;
+	case MANGLE_IPT:
+/*
+		if (e->arp.arpln_mask == 0)
+			xtables_error(PARAMETER_PROBLEM, "no pln defined");
+
+		if (e->arp.invflags & ARPT_INV_ARPPLN)
+			xtables_error(PARAMETER_PROBLEM,
+				   "! pln not allowed for --mangle-ip-d");
+*/
+/*
+		if (e->arp.arpln != 4)
+			xtables_error(PARAMETER_PROBLEM, "only pln=4 supported");
+*/
+		{
+			unsigned int nr;
+			ipaddr = parse_hostnetwork(cb->arg, &nr);
+		}
+		mangle->u_t.tgt_ip.s_addr = ipaddr->s_addr;
+		free(ipaddr);
+		mangle->flags |= ARPT_MANGLE_TIP;
+		break;
+	case MANGLE_DEVS:
+		if (e->arp.arhln_mask == 0)
+			xtables_error(PARAMETER_PROBLEM,
+				      "no --h-length defined");
+		if (e->arp.invflags & ARPT_INV_ARPHLN)
+			xtables_error(PARAMETER_PROBLEM,
+				      "! --h-length not allowed for "
+				      "--mangle-mac-s");
+		if (e->arp.arhln != 6)
+			xtables_error(PARAMETER_PROBLEM,
+				      "only --h-length 6 supported");
+		macaddr = ether_aton(cb->arg);
+		if (macaddr == NULL)
+			xtables_error(PARAMETER_PROBLEM, "invalid source MAC");
+		memcpy(mangle->src_devaddr, macaddr, e->arp.arhln);
+		mangle->flags |= ARPT_MANGLE_SDEV;
+		break;
+	case MANGLE_DEVT:
+		if (e->arp.arhln_mask == 0)
+			xtables_error(PARAMETER_PROBLEM,
+				      "no --h-length defined");
+		if (e->arp.invflags & ARPT_INV_ARPHLN)
+			xtables_error(PARAMETER_PROBLEM,
+				      "! hln not allowed for --mangle-mac-d");
+		if (e->arp.arhln != 6)
+			xtables_error(PARAMETER_PROBLEM,
+				      "only --h-length 6 supported");
+		macaddr = ether_aton(cb->arg);
+		if (macaddr == NULL)
+			xtables_error(PARAMETER_PROBLEM, "invalid target MAC");
+		memcpy(mangle->tgt_devaddr, macaddr, e->arp.arhln);
+		mangle->flags |= ARPT_MANGLE_TDEV;
+		break;
+	case MANGLE_TARGET:
+		if (!strcmp(cb->arg, "DROP"))
+			mangle->target = NF_DROP;
+		else if (!strcmp(cb->arg, "ACCEPT"))
+			mangle->target = NF_ACCEPT;
+		else if (!strcmp(cb->arg, "CONTINUE"))
+			mangle->target = ARPT_CONTINUE;
+		else
+			xtables_error(PARAMETER_PROBLEM,
+				      "bad target for --mangle-target");
+		break;
+	}
+}
+
+static void mangle_fcheck(struct xt_fcheck_call *cb)
+{
+}
+
+static char *addr_to_dotted(const struct in_addr *addrp)
+{
+	static char buf[20];
+	const unsigned char *bytep;
+
+	bytep = (const unsigned char *) &(addrp->s_addr);
+	sprintf(buf, "%d.%d.%d.%d", bytep[0], bytep[1], bytep[2], bytep[3]);
+	return buf;
+}
+
+static char *addr_to_host(const struct in_addr *addr)
+{
+	struct hostent *host;
+
+	if ((host = gethostbyaddr((char *) addr,
+				  sizeof(struct in_addr), AF_INET)) != NULL)
+		return (char *) host->h_name;
+
+	return (char *) NULL;
+}
+
+static char *addr_to_network(const struct in_addr *addr)
+{
+	struct netent *net;
+
+	if ((net = getnetbyaddr((long) ntohl(addr->s_addr), AF_INET)) != NULL)
+		return (char *) net->n_name;
+
+	return (char *) NULL;
+}
+
+static char *addr_to_anyname(const struct in_addr *addr)
+{
+	char *name;
+
+	if ((name = addr_to_host(addr)) != NULL ||
+		(name = addr_to_network(addr)) != NULL)
+		return name;
+
+	return addr_to_dotted(addr);
+}
+
+static void print_mac(const unsigned char *mac, int l)
+{
+	int j;
+
+	for (j = 0; j < l; j++)
+		printf("%02x%s", mac[j],
+			(j==l-1) ? "" : ":");
+}
+
+static void mangle_print(const void *ip, const struct xt_entry_target *target,
+			 int numeric)
+{
+	const struct arpt_mangle *m = (const void *)target;
+	char buf[100];
+
+	if (m->flags & ARPT_MANGLE_SIP) {
+		if (numeric)
+			sprintf(buf, "%s", addr_to_dotted(&(m->u_s.src_ip)));
+		else
+			sprintf(buf, "%s", addr_to_anyname(&(m->u_s.src_ip)));
+		printf("--mangle-ip-s %s ", buf);
+	}
+	if (m->flags & ARPT_MANGLE_SDEV) {
+		printf("--mangle-mac-s ");
+		print_mac((unsigned char *)m->src_devaddr, 6);
+		printf(" ");
+	}
+	if (m->flags & ARPT_MANGLE_TIP) {
+		if (numeric)
+			sprintf(buf, "%s", addr_to_dotted(&(m->u_t.tgt_ip)));
+		else
+			sprintf(buf, "%s", addr_to_anyname(&(m->u_t.tgt_ip)));
+		printf("--mangle-ip-d %s ", buf);
+	}
+	if (m->flags & ARPT_MANGLE_TDEV) {
+		printf("--mangle-mac-d ");
+		print_mac((unsigned char *)m->tgt_devaddr, 6);
+		printf(" ");
+	}
+	if (m->target != NF_ACCEPT) {
+		printf("--mangle-target ");
+		if (m->target == NF_DROP)
+			printf("DROP ");
+		else
+			printf("CONTINUE ");
+	}
+}
+
+static void mangle_save(const void *ip, const struct xt_entry_target *target)
+{
+}
+
+static struct xtables_target mangle_tg_reg = {
+	.name		= "mangle",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct arpt_mangle)),
+	.userspacesize	= XT_ALIGN(sizeof(struct arpt_mangle)),
+	.help		= mangle_help,
+	.x6_parse	= mangle_parse,
+	.x6_fcheck	= mangle_fcheck,
+	.print		= mangle_print,
+	.save		= mangle_save,
+	.x6_options	= mangle_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&mangle_tg_reg);
+}
diff --git a/include/linux/netfilter_arp/arpt_mangle.h b/include/linux/netfilter_arp/arpt_mangle.h
new file mode 100644
index 0000000..8c2b16a
--- /dev/null
+++ b/include/linux/netfilter_arp/arpt_mangle.h
@@ -0,0 +1,26 @@
+#ifndef _ARPT_MANGLE_H
+#define _ARPT_MANGLE_H
+#include <linux/netfilter_arp/arp_tables.h>
+
+#define ARPT_MANGLE_ADDR_LEN_MAX sizeof(struct in_addr)
+struct arpt_mangle
+{
+	char src_devaddr[ARPT_DEV_ADDR_LEN_MAX];
+	char tgt_devaddr[ARPT_DEV_ADDR_LEN_MAX];
+	union {
+		struct in_addr src_ip;
+	} u_s;
+	union {
+		struct in_addr tgt_ip;
+	} u_t;
+	__u8 flags;
+	int target;
+};
+
+#define ARPT_MANGLE_SDEV 0x01
+#define ARPT_MANGLE_TDEV 0x02
+#define ARPT_MANGLE_SIP 0x04
+#define ARPT_MANGLE_TIP 0x08
+#define ARPT_MANGLE_MASK 0x0f
+
+#endif /* _ARPT_MANGLE_H */
-- 
1.8.3.2

