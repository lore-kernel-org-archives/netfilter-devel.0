From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables 2/3] Operations for bridge family
Date: Fri,  7 Mar 2014 20:33:24 +0100
Message-ID: <1394220805-18021-3-git-send-email-giuseppelng@gmail.com>
References: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:48752 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaCGTcr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:32:47 -0500
Received: by mail-ea0-f173.google.com with SMTP id r15so2487978ead.18
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 11:32:45 -0800 (PST)
In-Reply-To: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch implements the operations for bridge family.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-bridge.c | 439 ++++++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-shared.c |   3 +
 iptables/nft.h        |   5 +-
 3 files changed, 446 insertions(+), 1 deletion(-)
 create mode 100644 iptables/nft-bridge.c

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
new file mode 100644
index 0000000..9f5ad34
--- /dev/null
+++ b/iptables/nft-bridge.c
@@ -0,0 +1,439 @@
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
+#include "nft-shared.h"
+#include "nft.h"
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
+				(j == ETH_ALEN-1) ? "" : ":");
+	} else
+		printf("%s", ether_ntoa((struct ether_addr *) mac));
+}
+
+/* Put the mac address into 6 (ETH_ALEN) bytes returns 0 on success. */
+static void ebt_print_mac_and_mask(const unsigned char *mac,
+				   const unsigned char *mask)
+{
+	char hlpmsk[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
+	if (!memcmp(mac, eb_mac_type_unicast, 6) &&
+	    !memcmp(mask, eb_msk_type_unicast, 6))
+		printf("Unicast");
+	else if (!memcmp(mac, eb_mac_type_multicast, 6) &&
+		 !memcmp(mask, eb_msk_type_multicast, 6))
+		printf("Multicast");
+	else if (!memcmp(mac, eb_mac_type_broadcast, 6) &&
+		 !memcmp(mask, eb_msk_type_broadcast, 6))
+		printf("Broadcast");
+	else if (!memcmp(mac, eb_mac_type_bridge_group, 6) &&
+		 !memcmp(mask, eb_msk_type_bridge_group, 6))
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
+	/* If no target at all, add nothing (default to continue) */
+	if (fw->target != NULL) {
+		/* Standard target? */
+		if (!strcmp(fw->jumpto, XTC_LABEL_ACCEPT))
+			ret = add_verdict(r, NF_ACCEPT);
+		else if (!strcmp(fw->jumpto, XTC_LABEL_DROP))
+			ret = add_verdict(r, NF_DROP);
+		else if (!strcmp(fw->jumpto, XTC_LABEL_RETURN))
+			ret = add_verdict(r, NFT_RETURN);
+		else
+			ret = add_target(r, fw->target->t);
+	} else if (strlen(fw->jumpto) > 0)
+		/* Not standard, then it's a jump to chain */
+		ret = add_jumpto(r, fw->jumpto, NFT_JUMP);
+
+	return ret;
+}
+
+static int nft_bridge_add(struct nft_rule *r, void *data)
+{
+	struct xtables_ebt_entry *fw = data;
+	uint8_t flags = ebt_to_ipt_flags(fw->invflags);
+	char *addr;
+
+	if (fw->in[0] != '\0')
+		add_iniface(r, fw->in, flags);
+
+	if (fw->out[0] != '\0')
+		add_outiface(r, fw->out, flags);
+
+	if (fw->logical_in[0] != '\0')
+		add_iniface(r, fw->logical_in, flags);
+
+	if (fw->logical_out[0] != '\0')
+		add_outiface(r, fw->logical_out, flags);
+
+	addr = ether_ntoa((struct ether_addr *) fw->sourcemac);
+	if (strcmp(addr, "0:0:0:0:0:0")) {
+		add_payload(r, offsetof(struct ethhdr, h_source), 6);
+		add_cmp_ptr(r, NFT_CMP_EQ, fw->sourcemac, 6);
+	}
+
+	addr = ether_ntoa((struct ether_addr *) fw->destmac);
+	if (strcmp(addr, "0:0:0:0:0:0")) {
+		add_payload(r, offsetof(struct ethhdr, h_dest), 6);
+		add_cmp_ptr(r, NFT_CMP_EQ, fw->destmac, 6);
+	}
+
+	if (fw->ethproto != 0) {
+		add_payload(r, offsetof(struct ethhdr, h_proto), 2);
+		add_cmp_u16(r, fw->ethproto, NFT_CMP_EQ);
+	}
+
+	return _add_action(r, fw);
+}
+
+static void nft_bridge_parse_meta(struct nft_rule_expr *e, uint8_t key,
+				  void *data)
+{
+	struct xtables_ebt_entry *fw = data;
+	uint8_t flags = 0;
+
+	parse_meta(e, key, fw->in, fw->sourcemsk,
+		   fw->out, fw->destmsk, &flags);
+
+	fw->invflags |= ipt_to_ebt_flags(flags);
+}
+
+static void nft_bridge_parse_payload(struct nft_rule_expr_iter *iter,
+				     uint32_t offset, void *data)
+{
+	struct xtables_ebt_entry *fw = data;
+
+	switch (offset) {
+	unsigned char addr[ETH_ALEN];
+	unsigned short int ethproto;
+	bool inv;
+	int i;
+
+	case offsetof(struct ethhdr, h_dest):
+		get_cmp_data(iter, addr, sizeof(addr), &inv);
+		for (i = 0; i < ETH_ALEN; i++)
+			fw->destmac[i] = addr[i];
+		break;
+	case offsetof(struct ethhdr, h_source):
+		get_cmp_data(iter, addr, sizeof(addr), &inv);
+		for (i = 0; i < ETH_ALEN; i++)
+			fw->sourcemac[i] = addr[i];
+		break;
+	case offsetof(struct ethhdr, h_proto):
+		get_cmp_data(iter, &ethproto, sizeof(ethproto), &inv);
+		fw->ethproto = ethproto;
+		break;
+	}
+}
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
+void nft_rule_to_xtables_ebt_entry(struct nft_rule *r,
+				   struct xtables_ebt_entry *fw)
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
+	c = strchr(iface, IF_WILDCARD);
+	if (c)
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
+	char *addr;
+
+	nft_rule_to_xtables_ebt_entry(r, &fw);
+
+	if (format & FMT_LINENUMBERS)
+		printf("%d ", num);
+
+	/* Dont print anything about the protocol if no protocol was
+	 * specified, obviously this means any protocol will do. */
+	if (fw.ethproto != 0) {
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
+	addr = ether_ntoa((struct ether_addr *) fw.sourcemac);
+	if (strcmp(addr, "0:0:0:0:0:0")) {
+		printf("-s ");
+		if (fw.invflags & EBT_ISOURCE)
+			printf("! ");
+		ebt_print_mac_and_mask(fw.sourcemac, fw.sourcemsk);
+		printf(" ");
+	}
+
+	addr = ether_ntoa((struct ether_addr *) fw.destmac);
+	if (strcmp(addr, "0:0:0:0:0:0")) {
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
+	if (!(format & FMT_NOTARGET))
+		printf("%s", fw.jumpto);
+
+	if (fw.target != NULL) {
+		if (fw.target->print != NULL) {
+			fw.target->print(&fw, fw.target->t,
+					 format & FMT_NUMERIC);
+		}
+	}
+
+	if (!(format & FMT_NONEWLINE))
+		fputc('\n', stdout);
+}
+
+static bool nft_bridge_is_same(const void *data_a,
+			       const void *data_b)
+{
+	const struct xtables_ebt_entry *a = data_a;
+	const struct xtables_ebt_entry *b = data_b;
+
+	if (a->ethproto != b->ethproto
+	    || a->flags != b->flags
+	    || a->invflags != b->invflags) {
+		DEBUGP("different proto/flags/invflags\n");
+		return false;
+	}
+
+	return is_same_interfaces(a->in, a->out, a->in_mask, a->out_mask,
+				  b->in, b->out, b->in_mask, b->out_mask);
+}
+
+static bool nft_bridge_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
+				 void *data)
+{
+	struct xtables_ebt_entry *fw = data;
+	struct xtables_ebt_entry this;
+
+	nft_rule_to_xtables_ebt_entry(r, &this);
+
+	DEBUGP("comparing with... ");
+
+	if (!ops->is_same(fw, &this))
+		return false;
+
+	if (!compare_matches(fw->matches, this.matches)) {
+		DEBUGP("Different matches\n");
+		return false;
+	}
+
+	if (!compare_targets(fw->target, this.target)) {
+		DEBUGP("Different target\n");
+		return false;
+	}
+
+	if (strcmp(fw->jumpto, this.jumpto) != 0) {
+		DEBUGP("Different verdict\n");
+		return false;
+	}
+
+	return true;
+}
+
+struct nft_family_ops nft_family_ops_bridge = {
+	.add			= nft_bridge_add,
+	.is_same		= nft_bridge_is_same,
+	.print_payload		= NULL,
+	.parse_meta		= nft_bridge_parse_meta,
+	.parse_payload		= nft_bridge_parse_payload,
+	.parse_immediate	= nft_bridge_parse_immediate,
+	.print_firewall		= nft_bridge_print_firewall,
+	.post_parse		= NULL,
+	.rule_find		= nft_bridge_rule_find,
+	.parse_target		= nft_bridge_parse_target,
+};
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index ada71e6..e2bc802 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -32,6 +32,7 @@
 extern struct nft_family_ops nft_family_ops_ipv4;
 extern struct nft_family_ops nft_family_ops_ipv6;
 extern struct nft_family_ops nft_family_ops_arp;
+extern struct nft_family_ops nft_family_ops_bridge;
 
 void add_meta(struct nft_rule *r, uint32_t key)
 {
@@ -680,6 +681,8 @@ struct nft_family_ops *nft_family_ops_lookup(int family)
 		return &nft_family_ops_ipv6;
 	case NFPROTO_ARP:
 		return &nft_family_ops_arp;
+	case NFPROTO_BRIDGE:
+		return &nft_family_ops_bridge;
 	default:
 		break;
 	}
diff --git a/iptables/nft.h b/iptables/nft.h
index b2c6064..bef4d45 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -179,6 +179,9 @@ void nft_rule_to_arpt_entry(struct nft_rule *r, struct arpt_entry *fw);
  * BRIDGE
  */
 
-struct ebt_entry;
+#include "xtables-ebtables.h"
 
+struct xtables_ebt_entry;
+
+void nft_rule_to_xtables_ebt_entry(struct nft_rule *r, struct xtables_ebt_entry *fw);
 #endif
-- 
1.8.3.2

