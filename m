From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 2/2] Operations for bridge family
Date: Wed,  5 Feb 2014 19:17:59 +0100
Message-ID: <1391624279-4323-3-git-send-email-giuseppelng@gmail.com>
References: <1391624279-4323-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:42411 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaBESSj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:18:39 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so416203ead.20
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Feb 2014 10:18:37 -0800 (PST)
In-Reply-To: <1391624279-4323-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch implements the operations for bridge family.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/Makefile.am  |   2 +-
 iptables/nft-bridge.c | 384 ++++++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-shared.c |   3 +
 iptables/nft.h        |   5 +-
 4 files changed, 392 insertions(+), 2 deletions(-)
 create mode 100644 iptables/nft-bridge.c

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index be31d0e..e322afb 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -31,7 +31,7 @@ xtables_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
 xtables_multi_SOURCES += xtables-save.c xtables-restore.c \
 			 xtables-standalone.c xtables.c nft.c \
 			 nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
-			 xtables-config.c xtables-events.c \
+			 nft-bridge.c xtables-config.c xtables-events.c \
 			 xtables-arp-standalone.c xtables-arp.c \
 			 getethertype.c nft-bridge.c \
 			 xtables-eb-standalone.c xtables-eb.c
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
new file mode 100644
index 0000000..0239ef9
--- /dev/null
+++ b/iptables/nft-bridge.c
@@ -0,0 +1,384 @@
+/*
+ * (C) 2013 by Giuseppe Longo <giuseppelng@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/ether.h>
+
+#include <xtables.h>
+#include <libiptc/libxtc.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter_bridge/ethernetdb.h>
+
+#include "xtables-ebtables.h"
+#include "nft-shared.h"
+#include "nft.h"
+
+static unsigned char mac_type_unicast[ETH_ALEN] =   {0,0,0,0,0,0};
+static unsigned char msk_type_unicast[ETH_ALEN] =   {1,0,0,0,0,0};
+static unsigned char mac_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
+static unsigned char msk_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
+static unsigned char mac_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
+static unsigned char msk_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
+static unsigned char mac_type_bridge_group[ETH_ALEN] = {0x01,0x80,0xc2,0,0,0};
+static unsigned char msk_type_bridge_group[ETH_ALEN] = {255,255,255,255,255,255};
+
+/* 0: default, print only 2 digits if necessary
+ * 2: always print 2 digits, a printed mac address
+ * then always has the same length */
+int ebt_printstyle_mac;
+
+static void ebt_print_mac(const unsigned char *mac)
+{
+	if (ebt_printstyle_mac == 2) {
+		int j;
+		for (j = 0; j < ETH_ALEN; j++)
+			printf("%02x%s", mac[j],
+				(j==ETH_ALEN-1) ? "" : ":");
+	} else
+		printf("%s", ether_ntoa((struct ether_addr *) mac));
+}
+
+/* Put the mac address into 6 (ETH_ALEN) bytes returns 0 on success. */
+int ebt_get_mac_and_mask(const char *from, unsigned char *to,
+  unsigned char *mask)
+{
+	char *p;
+	int i;
+	struct ether_addr *addr = NULL;
+
+	if (strcasecmp(from, "Unicast") == 0) {
+		memcpy(to, mac_type_unicast, ETH_ALEN);
+		memcpy(mask, msk_type_unicast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "Multicast") == 0) {
+		memcpy(to, mac_type_multicast, ETH_ALEN);
+		memcpy(mask, msk_type_multicast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "Broadcast") == 0) {
+		memcpy(to, mac_type_broadcast, ETH_ALEN);
+		memcpy(mask, msk_type_broadcast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "BGA") == 0) {
+		memcpy(to, mac_type_bridge_group, ETH_ALEN);
+		memcpy(mask, msk_type_bridge_group, ETH_ALEN);
+		return 0;
+	}
+	if ( (p = strrchr(from, '/')) != NULL) {
+		*p = '\0';
+		if (!(addr = ether_aton(p + 1)))
+			return -1;
+		memcpy(mask, addr, ETH_ALEN);
+	} else
+		memset(mask, 0xff, ETH_ALEN);
+	if (!(addr = ether_aton(from)))
+		return -1;
+	/*memcpy(to, addr, ETH_ALEN);*/
+	for (i = 0; i < ETH_ALEN; i++)
+		to[i] &= mask[i];
+	return 0;
+}
+
+static void ebt_print_mac_and_mask(const unsigned char *mac, const unsigned char *mask)
+{
+	char hlpmsk[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
+	if (!memcmp(mac, mac_type_unicast, 6) &&
+	    !memcmp(mask, msk_type_unicast, 6))
+		printf("Unicast");
+	else if (!memcmp(mac, mac_type_multicast, 6) &&
+	         !memcmp(mask, msk_type_multicast, 6))
+		printf("Multicast");
+	else if (!memcmp(mac, mac_type_broadcast, 6) &&
+	         !memcmp(mask, msk_type_broadcast, 6))
+		printf("Broadcast");
+	else if (!memcmp(mac, mac_type_bridge_group, 6) &&
+	         !memcmp(mask, msk_type_bridge_group, 6))
+		printf("BGA");
+	else {
+		ebt_print_mac(mac);
+		if (memcmp(mask, hlpmsk, 6)) {
+			printf("/");
+			ebt_print_mac(mask);
+		}
+	}
+}
+
+static uint8_t ebt_to_ipt_flags(uint16_t invflags)
+{
+	uint8_t result = 0;
+
+	if (invflags & EBT_IIN)
+		result |= IPT_INV_VIA_IN;
+
+	if (invflags & EBT_IOUT)
+		result |= IPT_INV_VIA_OUT;
+
+	if (invflags & EBT_IPROTO)
+		result |= IPT_INV_PROTO;
+
+	if (invflags & EBT_INV_MASK)
+		result |= IPT_INV_MASK;
+
+	return result;
+}
+
+static uint16_t ipt_to_ebt_flags(uint8_t invflags)
+{
+	uint16_t result = 0;
+
+	if (invflags & IPT_INV_VIA_IN)
+		result |= EBT_IIN;
+
+	if (invflags & IPT_INV_VIA_OUT)
+		result |= EBT_IOUT;
+
+	if (invflags & IPT_INV_PROTO)
+		result |= EBT_IPROTO;
+
+	if (invflags & IPT_INV_MASK)
+		result |= EBT_INV_MASK;
+
+	return result;
+}
+
+static int _add_action(struct nft_rule *r, struct xtables_ebt_entry *fw)
+{
+	int ret = 0;
+
+       /* If no target at all, add nothing (default to continue) */
+       if (fw->target != NULL) {
+	       /* Standard target? */
+	       if (strcmp(fw->jumpto, XTC_LABEL_ACCEPT) == 0)
+		       ret = add_verdict(r, NF_ACCEPT);
+	       else if (strcmp(fw->jumpto, XTC_LABEL_DROP) == 0)
+		       ret = add_verdict(r, NF_DROP);
+	       else if (strcmp(fw->jumpto, XTC_LABEL_RETURN) == 0)
+		       ret = add_verdict(r, NFT_RETURN);
+	       else
+		       ret = add_target(r, fw->target->t);
+       } else if (strlen(fw->jumpto) > 0)
+		/* Not standard, then it's a jump to chain */
+		ret = add_jumpto(r, fw->jumpto, NFT_JUMP);
+
+       return ret;
+}
+
+static int nft_bridge_add(struct nft_rule *r, void *data)
+{
+	struct xtables_ebt_entry *fw = data;
+	uint8_t flags = ebt_to_ipt_flags(fw->invflags);
+
+	if (fw->in[0] != '\0')
+		add_iniface(r, fw->in, flags);
+
+	if (fw->out[0] != '\0')
+		add_outiface(r, fw->out, flags);
+
+	if (fw->ethproto != 0) {
+		add_payload(r, offsetof(struct ethhdr, h_proto), 2);
+		add_cmp_u16(r, fw->ethproto, NFT_CMP_EQ);
+	}
+
+	return _add_action(r,fw);
+}
+
+static void nft_bridge_parse_meta(struct nft_rule_expr *e, uint8_t key,
+				  void *data)
+{
+	struct xtables_ebt_entry *fw = data;
+	uint8_t flags = 0;
+
+	parse_meta(e, key, fw->in, fw->sourcemsk,
+		   fw->out, fw->destmsk,
+		   &flags);
+
+	fw->invflags |= ipt_to_ebt_flags(flags);
+}
+
+static void nft_bridge_parse_immediate(const char *jumpto, bool nft_goto,
+				       void *data)
+{
+	struct xtables_ebt_entry *fw = data;
+
+	fw->jumpto = jumpto;
+}
+
+static void nft_bridge_parse_target(struct xtables_target *t, void *data)
+{
+	struct xtables_ebt_entry *fw = data;
+
+	fw->target = t;
+}
+
+void nft_rule_to_xtables_ebt_entry(struct nft_rule *r, struct xtables_ebt_entry *fw)
+{
+	struct nft_rule_expr_iter *iter;
+	struct nft_rule_expr *expr;
+	int family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+
+	iter = nft_rule_expr_iter_create(r);
+	if (iter == NULL)
+		return;
+
+	expr = nft_rule_expr_iter_next(iter);
+	while (expr != NULL) {
+		const char *name =
+			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
+
+		if (strcmp(name, "counter") == 0)
+			nft_parse_counter(expr, iter, &fw->counters);
+		else if (strcmp(name, "payload") == 0)
+			nft_parse_payload(expr, iter, family, fw);
+		else if (strcmp(name, "meta") == 0)
+			nft_parse_meta(expr, iter, family, fw);
+		else if (strcmp(name, "immediate") == 0)
+			nft_parse_immediate(expr, iter, family, fw);
+		else if (strcmp(name, "target") == 0)
+			nft_parse_target(expr, iter, family, fw);
+
+		expr = nft_rule_expr_iter_next(iter);
+	}
+
+	nft_rule_expr_iter_destroy(iter);
+	
+	if (fw->target != NULL)
+		fw->jumpto = fw->target->name;
+	else if (fw->jumpto != NULL)
+		fw->target = xtables_find_target(fw->jumpto, XTF_TRY_LOAD);
+	else
+		fw->jumpto = "";
+}
+	
+static void print_iface(const char *iface)
+{
+	char *c;
+
+	if ((c = strchr(iface, IF_WILDCARD)))
+		*c = '+';
+	printf("%s ", iface);
+	if (c)
+		*c = IF_WILDCARD;
+}
+
+static void
+nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
+		       unsigned int format)
+{
+	struct xtables_ebt_entry fw = {};
+
+
+	nft_rule_to_xtables_ebt_entry(r, &fw);
+
+	/* Dont print anything about the protocol if no protocol was
+	 * specified, obviously this means any protocol will do. */
+	if (!(fw.bitmask & EBT_NOPROTO)) {
+		printf("-p ");
+		if (fw.invflags & EBT_IPROTO)
+			printf("! ");
+		if (fw.bitmask & EBT_802_3)
+			printf("Length ");
+		else {
+			struct ethertypeent *ent;
+
+			ent = getethertypebynumber(ntohs(fw.ethproto));
+			if (!ent)
+				printf("0x%x ", ntohs(fw.ethproto));
+			else
+				printf("%s ", ent->e_name);
+		}
+	}
+
+	if (fw.bitmask & EBT_SOURCEMAC) {
+		printf("-s ");
+		if (fw.invflags & EBT_ISOURCE)
+			printf("! ");
+		ebt_print_mac_and_mask(fw.sourcemac, fw.sourcemsk);
+		printf(" ");
+	}
+
+	if (fw.bitmask & EBT_DESTMAC) {
+		printf("-d ");
+		if (fw.invflags & EBT_IDEST)
+			printf("! ");
+		ebt_print_mac_and_mask(fw.destmac, fw.destmsk);
+		printf(" ");
+	}
+
+	if (fw.in[0] != '\0') {
+		printf("-i ");
+		if (fw.invflags & EBT_IIN)
+			printf("! ");
+		print_iface(fw.in);
+	}
+
+	if (fw.logical_in[0] != '\0') {
+		printf("--logical-in ");
+		if (fw.invflags & EBT_ILOGICALIN)
+			printf("! ");
+		print_iface(fw.logical_in);
+	}
+
+	if (fw.logical_out[0] != '\0') {
+		printf("--logical-out ");
+		if (fw.invflags & EBT_ILOGICALOUT)
+			printf("! ");
+		print_iface(fw.logical_out);
+	}
+
+	if (fw.out[0] != '\0') {
+		printf("-o ");
+		if (fw.invflags & EBT_IOUT)
+			printf("! ");
+		print_iface(fw.out);
+	}
+
+	/* old code to adapt
+	m_l = hlp->m_list;
+	while (m_l) {
+		m = ebt_find_match(m_l->m->u.name);
+		if (!m)
+			ebt_print_bug("Match not found");
+		m->print(hlp, m_l->m);
+		m_l = m_l->next;
+	}
+	w_l = hlp->w_list;
+	while (w_l) {
+		w = ebt_find_watcher(w_l->w->u.name);
+		if (!w)
+			ebt_print_bug("Watcher not found");
+		w->print(hlp, w_l->w);
+		w_l = w_l->next;
+	}*/
+	printf("-j ");
+	if (fw.target != NULL) {
+		if (fw.target->print != NULL) {
+			fw.target->print(&fw, fw.target->t,
+					 format & FMT_NUMERIC);
+		}
+	}	
+}
+
+struct nft_family_ops nft_family_ops_bridge = {
+	.add			= nft_bridge_add,
+	.is_same		= NULL,
+	.print_payload		= NULL,
+	.parse_meta		= nft_bridge_parse_meta,
+	.parse_payload		= NULL,
+	.parse_immediate	= nft_bridge_parse_immediate,
+	.print_firewall		= nft_bridge_print_firewall,
+	.post_parse		= NULL,
+	.rule_find		= NULL,
+	.parse_target		= nft_bridge_parse_target,
+};
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index e0eaa17..233011c 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -32,6 +32,7 @@
 extern struct nft_family_ops nft_family_ops_ipv4;
 extern struct nft_family_ops nft_family_ops_ipv6;
 extern struct nft_family_ops nft_family_ops_arp;
+extern struct nft_family_ops nft_family_ops_bridge;
 
 void add_meta(struct nft_rule *r, uint32_t key)
 {
@@ -649,6 +650,8 @@ struct nft_family_ops *nft_family_ops_lookup(int family)
 		return &nft_family_ops_ipv6;
 	case NFPROTO_ARP:
 		return &nft_family_ops_arp;
+	case NFPROTO_BRIDGE:
+		return &nft_family_ops_bridge;
 	default:
 		break;
 	}
diff --git a/iptables/nft.h b/iptables/nft.h
index 2a8831e..68f674e 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -177,6 +177,9 @@ void nft_rule_to_arpt_entry(struct nft_rule *r, struct arpt_entry *fw);
  * BRIDGE
  */
 
-struct ebt_entry;
+#include "xtables-ebtables.h"
 
+struct xtables_ebt_entry;
+
+void nft_rule_to_xtables_ebt_entry(struct nft_rule *r, struct xtables_ebt_entry *fw);
 #endif
-- 
1.8.1.5

