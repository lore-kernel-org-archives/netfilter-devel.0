From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 1/2] nft-arp: adds nft_arp_save_firewall
Date: Wed, 19 Feb 2014 13:10:28 +0100
Message-ID: <1392811829-5303-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:53319 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaBSMJy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:09:54 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so320242eae.9
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2014 04:09:53 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds nft_arp_save_firewall to arp family.
(Avoids the segfault in xtables-events)

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c | 172 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 109 insertions(+), 63 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 1710136..a494ee6 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -397,36 +397,36 @@ void nft_rule_to_arpt_entry(struct nft_rule *r, struct arpt_entry *fw)
 	nft_rule_expr_iter_destroy(iter);
 }
 
-static void
-nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
-		       unsigned int format)
+static struct xtables_target
+*get_target(struct arpt_entry *fw, unsigned int format)
 {
-	struct arpt_entry fw = {};
 	const char *targname;
 	struct xtables_target *target = NULL;
 	const struct xt_entry_target *t;
-	char buf[BUFSIZ];
-	int i;
-	char iface[IFNAMSIZ+2];
-	int print_iface = 0;
 
-	nft_rule_to_arpt_entry(r, &fw);
+	if (!fw->target_offset)
+		return NULL;
 
-	if (format & FMT_LINENUMBERS)
-		printf("%u ", num);
+	t = nft_arp_get_target(fw);
+	targname = t->u.user.name;
+	target = xtables_find_target(targname, XTF_TRY_LOAD);
+	if (!(format & FMT_NOTARGET))
+		printf("-j %s ", targname);
 
-	if (fw.target_offset) {
-		t = nft_arp_get_target(&fw);
-		targname = t->u.user.name;
-		target = xtables_find_target(targname, XTF_TRY_LOAD);
-		if (!(format & FMT_NOTARGET))
-			printf("-j %s ", targname);
-	}
+	return target;
+}
+
+static void print_fw_details(struct arpt_entry *fw, unsigned int format)
+{
+	char buf[BUFSIZ];
+	char iface[IFNAMSIZ+2];
+	int print_iface = 0;
+	int i;
 
 	iface[0] = '\0';
 
-	if (fw.arp.iniface[0] != '\0') {
-		strcat(iface, fw.arp.iniface);
+	if (fw->arp.iniface[0] != '\0') {
+		strcat(iface, fw->arp.iniface);
 		print_iface = 1;
 	}
 	else if (format & FMT_VIA) {
@@ -435,13 +435,14 @@ nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
 		else strcat(iface, "any");
 	}
 	if (print_iface)
-		printf("%s-i %s ", fw.arp.invflags & ARPT_INV_VIA_IN ? "! ": "", iface);
+		printf("%s-i %s ", fw->arp.invflags & ARPT_INV_VIA_IN ?
+				   "! " : "", iface);
 
 	print_iface = 0;
 	iface[0] = '\0';
 
-	if (fw.arp.outiface[0] != '\0') {
-		strcat(iface, fw.arp.outiface);
+	if (fw->arp.outiface[0] != '\0') {
+		strcat(iface, fw->arp.outiface);
 		print_iface = 1;
 	}
 	else if (format & FMT_VIA) {
@@ -450,108 +451,127 @@ nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
 		else strcat(iface, "any");
 	}
 	if (print_iface)
-		printf("%s-o %s ", fw.arp.invflags & ARPT_INV_VIA_OUT ? "! " : "", iface);
+		printf("%s-o %s ", fw->arp.invflags & ARPT_INV_VIA_OUT ?
+				   "! " : "", iface);
 
-	if (fw.arp.smsk.s_addr != 0L) {
-		printf("%s", fw.arp.invflags & ARPT_INV_SRCIP
+	if (fw->arp.smsk.s_addr != 0L) {
+		printf("%s", fw->arp.invflags & ARPT_INV_SRCIP
 			? "! " : "");
 		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", addr_to_dotted(&(fw.arp.src)));
+			sprintf(buf, "%s", addr_to_dotted(&(fw->arp.src)));
 		else
-			sprintf(buf, "%s", addr_to_anyname(&(fw.arp.src)));
-		strncat(buf, mask_to_dotted(&(fw.arp.smsk)),
+			sprintf(buf, "%s", addr_to_anyname(&(fw->arp.src)));
+		strncat(buf, mask_to_dotted(&(fw->arp.smsk)),
 			sizeof(buf) - strlen(buf) - 1);
 		printf("-s %s ", buf);
 	}
 
 	for (i = 0; i < ARPT_DEV_ADDR_LEN_MAX; i++)
-		if (fw.arp.src_devaddr.mask[i] != 0)
+		if (fw->arp.src_devaddr.mask[i] != 0)
 			break;
 	if (i == ARPT_DEV_ADDR_LEN_MAX)
 		goto after_devsrc;
-	printf("%s", fw.arp.invflags & ARPT_INV_SRCDEVADDR
+	printf("%s", fw->arp.invflags & ARPT_INV_SRCDEVADDR
 		? "! " : "");
 	printf("--src-mac ");
-	print_mac_and_mask((unsigned char *)fw.arp.src_devaddr.addr,
-		(unsigned char *)fw.arp.src_devaddr.mask, ETH_ALEN);
+	print_mac_and_mask((unsigned char *)fw->arp.src_devaddr.addr,
+		(unsigned char *)fw->arp.src_devaddr.mask, ETH_ALEN);
 	printf(" ");
 after_devsrc:
 
-	if (fw.arp.tmsk.s_addr != 0L) {
-		printf("%s",fw.arp.invflags & ARPT_INV_TGTIP
+	if (fw->arp.tmsk.s_addr != 0L) {
+		printf("%s", fw->arp.invflags & ARPT_INV_TGTIP
 			? "! " : "");
 		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", addr_to_dotted(&(fw.arp.tgt)));
+			sprintf(buf, "%s", addr_to_dotted(&(fw->arp.tgt)));
 		else
-			sprintf(buf, "%s", addr_to_anyname(&(fw.arp.tgt)));
-		strncat(buf, mask_to_dotted(&(fw.arp.tmsk)),
+			sprintf(buf, "%s", addr_to_anyname(&(fw->arp.tgt)));
+		strncat(buf, mask_to_dotted(&(fw->arp.tmsk)),
 			sizeof(buf) - strlen(buf) - 1);
 		printf("-d %s ", buf);
 	}
 
 	for (i = 0; i <ARPT_DEV_ADDR_LEN_MAX; i++)
-		if (fw.arp.tgt_devaddr.mask[i] != 0)
+		if (fw->arp.tgt_devaddr.mask[i] != 0)
 			break;
 	if (i == ARPT_DEV_ADDR_LEN_MAX)
 		goto after_devdst;
-	printf("%s",fw.arp.invflags & ARPT_INV_TGTDEVADDR
+	printf("%s", fw->arp.invflags & ARPT_INV_TGTDEVADDR
 		? "! " : "");
 	printf("--dst-mac ");
-	print_mac_and_mask((unsigned char *)fw.arp.tgt_devaddr.addr,
-		(unsigned char *)fw.arp.tgt_devaddr.mask, ETH_ALEN);
+	print_mac_and_mask((unsigned char *)fw->arp.tgt_devaddr.addr,
+		(unsigned char *)fw->arp.tgt_devaddr.mask, ETH_ALEN);
 	printf(" ");
+
 after_devdst:
 
-	if (fw.arp.arhln_mask != 0) {
-		printf("%s",fw.arp.invflags & ARPT_INV_ARPHLN
+	if (fw->arp.arhln_mask != 0) {
+		printf("%s", fw->arp.invflags & ARPT_INV_ARPHLN
 			? "! " : "");
-		printf("--h-length %d", fw.arp.arhln);
-		if (fw.arp.arhln_mask != 255)
-			printf("/%d", fw.arp.arhln_mask);
+		printf("--h-length %d", fw->arp.arhln);
+		if (fw->arp.arhln_mask != 255)
+			printf("/%d", fw->arp.arhln_mask);
 		printf(" ");
 	}
 
-	if (fw.arp.arpop_mask != 0) {
-		int tmp = ntohs(fw.arp.arpop);
+	if (fw->arp.arpop_mask != 0) {
+		int tmp = ntohs(fw->arp.arpop);
 
-		printf("%s",fw.arp.invflags & ARPT_INV_ARPOP
+		printf("%s", fw->arp.invflags & ARPT_INV_ARPOP
 			? "! " : "");
 		if (tmp <= NUMOPCODES && !(format & FMT_NUMERIC))
 			printf("--opcode %s", opcodes[tmp-1]);
 		else
-			printf("--opcode %d", tmp);
-		if (fw.arp.arpop_mask != 65535)
-			printf("/%d", ntohs(fw.arp.arpop_mask));
+
+		if (fw->arp.arpop_mask != 65535)
+			printf("/%d", ntohs(fw->arp.arpop_mask));
 		printf(" ");
 	}
 
-	if (fw.arp.arhrd_mask != 0) {
-		uint16_t tmp = ntohs(fw.arp.arhrd);
+	if (fw->arp.arhrd_mask != 0) {
+		uint16_t tmp = ntohs(fw->arp.arhrd);
 
-		printf("%s", fw.arp.invflags & ARPT_INV_ARPHRD
+		printf("%s", fw->arp.invflags & ARPT_INV_ARPHRD
 			? "! " : "");
 		if (tmp == 1 && !(format & FMT_NUMERIC))
 			printf("--h-type %s", "Ethernet");
 		else
 			printf("--h-type %u", tmp);
-		if (fw.arp.arhrd_mask != 65535)
-			printf("/%d", ntohs(fw.arp.arhrd_mask));
+		if (fw->arp.arhrd_mask != 65535)
+			printf("/%d", ntohs(fw->arp.arhrd_mask));
 		printf(" ");
 	}
 
-	if (fw.arp.arpro_mask != 0) {
-		int tmp = ntohs(fw.arp.arpro);
+	if (fw->arp.arpro_mask != 0) {
+		int tmp = ntohs(fw->arp.arpro);
 
-		printf("%s", fw.arp.invflags & ARPT_INV_ARPPRO
+		printf("%s", fw->arp.invflags & ARPT_INV_ARPPRO
 			? "! " : "");
 		if (tmp == 0x0800 && !(format & FMT_NUMERIC))
 			printf("--proto-type %s", "IPv4");
 		else
 			printf("--proto-type 0x%x", tmp);
-		if (fw.arp.arpro_mask != 65535)
-			printf("/%x", ntohs(fw.arp.arpro_mask));
+		if (fw->arp.arpro_mask != 65535)
+			printf("/%x", ntohs(fw->arp.arpro_mask));
 		printf(" ");
 	}
+}
+
+static void
+nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
+		       unsigned int format)
+{
+	struct arpt_entry fw = {};
+	struct xtables_target *target = NULL;
+	const struct xt_entry_target *t = NULL;
+
+	nft_rule_to_arpt_entry(r, &fw);
+
+	if (format & FMT_LINENUMBERS)
+		printf("%u ", num);
+
+	target = get_target(&fw, format);
+	print_fw_details(&fw, format);
 
 	if (target) {
 		if (target->print)
@@ -570,6 +590,31 @@ after_devdst:
 		fputc('\n', stdout);
 }
 
+static void nft_arp_save_firewall(const void *data,
+				  unsigned int format)
+{
+	const struct arpt_entry *fw = data;
+	struct xtables_target *target = NULL;
+	const struct xt_entry_target *t = NULL;
+
+	print_fw_details((struct arpt_entry *)fw, format);
+
+	if (!(format & FMT_NOCOUNTS)) {
+		printf("-c ");
+		xtables_print_num(fw->counters.pcnt, format);
+		xtables_print_num(fw->counters.bcnt, format);
+	}
+
+	target = get_target((struct arpt_entry *)fw, format);
+
+	if (target) {
+		if (target->print)
+			/* Print the target information. */
+			target->print(&fw->arp, t, format & FMT_NUMERIC);
+	}
+	printf("\n");
+}
+
 static bool nft_arp_is_same(const void *data_a,
 			    const void *data_b)
 {
@@ -643,6 +688,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.parse_payload		= nft_arp_parse_payload,
 	.parse_immediate	= nft_arp_parse_immediate,
 	.print_firewall		= nft_arp_print_firewall,
+	.save_firewall		= nft_arp_save_firewall,
 	.post_parse		= NULL,
 	.rule_find		= nft_arp_rule_find,
 	.parse_target		= nft_arp_parse_target,
-- 
1.8.3.2

