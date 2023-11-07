Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F8AC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Nov 2023 11:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbjKGLQV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 06:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbjKGLQM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 06:16:12 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FE410F6
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 03:16:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r0K3v-0002Ei-4R; Tue, 07 Nov 2023 12:16:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 iptables 2/4] nft-arp: add arptables-translate
Date:   Tue,  7 Nov 2023 12:15:38 +0100
Message-ID: <20231107111544.17166-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231107111544.17166-1-fw@strlen.de>
References: <20231107111544.17166-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libarpt_mangle.c  |  47 +++++++++++
 iptables/nft-arp.c           | 153 +++++++++++++++++++++++++++++++++++
 iptables/xtables-multi.h     |   1 +
 iptables/xtables-nft-multi.c |   1 +
 iptables/xtables-translate.c |  35 +++++++-
 5 files changed, 236 insertions(+), 1 deletion(-)

diff --git a/extensions/libarpt_mangle.c b/extensions/libarpt_mangle.c
index a846e97ec8f2..364c9ce755b9 100644
--- a/extensions/libarpt_mangle.c
+++ b/extensions/libarpt_mangle.c
@@ -170,6 +170,52 @@ static void arpmangle_save(const void *ip, const struct xt_entry_target *target)
 	arpmangle_print(ip, target, 0);
 }
 
+static void print_devaddr_xlate(const char *macaddress, struct xt_xlate *xl)
+{
+	unsigned int i;
+
+	xt_xlate_add(xl, "%02x", macaddress[0]);
+	for (i = 1; i < ETH_ALEN; ++i)
+		xt_xlate_add(xl, ":%02x", macaddress[i]);
+}
+
+static int arpmangle_xlate(struct xt_xlate *xl,
+			 const struct xt_xlate_tg_params *params)
+{
+	const struct arpt_mangle *m = (const void *)params->target->data;
+
+	if (m->flags & ARPT_MANGLE_SIP)
+		xt_xlate_add(xl, "arp saddr ip set %s ",
+			     xtables_ipaddr_to_numeric(&m->u_s.src_ip));
+
+	if (m->flags & ARPT_MANGLE_SDEV) {
+		xt_xlate_add(xl, "arp %caddr ether set ", 's');
+		print_devaddr_xlate(m->src_devaddr, xl);
+	}
+
+	if (m->flags & ARPT_MANGLE_TIP)
+		xt_xlate_add(xl, "arp daddr ip set %s ",
+			     xtables_ipaddr_to_numeric(&m->u_t.tgt_ip));
+
+	if (m->flags & ARPT_MANGLE_TDEV) {
+		xt_xlate_add(xl, "arp %caddr ether set ", 'd');
+		print_devaddr_xlate(m->tgt_devaddr, xl);
+	}
+
+	switch (m->target) {
+	case NF_ACCEPT:
+		xt_xlate_add(xl, "accept");
+		break;
+	case NF_DROP:
+		xt_xlate_add(xl, "drop");
+		break;
+	default:
+		break;
+	}
+
+	return 1;
+}
+
 static struct xtables_target arpmangle_target = {
 	.name		= "mangle",
 	.revision	= 0,
@@ -184,6 +230,7 @@ static struct xtables_target arpmangle_target = {
 	.print		= arpmangle_print,
 	.save		= arpmangle_save,
 	.extra_opts	= arpmangle_opts,
+	.xlate		= arpmangle_xlate,
 };
 
 void _init(void)
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index b3c8dfa453d9..8521cc4f15c1 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -18,6 +18,7 @@
 
 #include <xtables.h>
 #include <libiptc/libxtc.h>
+#include <arpa/inet.h>
 #include <net/if_arp.h>
 #include <netinet/if_ether.h>
 
@@ -663,6 +664,157 @@ nft_arp_replace_entry(struct nft_handle *h,
 	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
 
+static void nft_arp_xlate_mac_and_mask(const struct arpt_devaddr_info *devaddr,
+				       const char *addr,
+				       bool invert,
+				       struct xt_xlate *xl)
+{
+	unsigned int i;
+
+	for (i = 0; i < 6; ++i) {
+		if (devaddr->mask[i])
+			break;
+	}
+
+	if (i == 6)
+		return;
+
+	xt_xlate_add(xl, "arp %s ether ", addr);
+	if (invert)
+		xt_xlate_add(xl, "!= ");
+
+	xt_xlate_add(xl, "%02x", (uint8_t)devaddr->addr[0]);
+	for (i = 1; i < 6; ++i)
+		xt_xlate_add(xl, ":%02x", (uint8_t)devaddr->addr[i]);
+
+	for (i = 0; i < 6; ++i) {
+		int j;
+
+		if ((uint8_t)devaddr->mask[i] == 0xff)
+			continue;
+
+		xt_xlate_add(xl, "/%02x", (uint8_t)devaddr->mask[0]);
+
+		for (j = 1; j < 6; ++j)
+			xt_xlate_add(xl, ":%02x", (uint8_t)devaddr->mask[j]);
+		return;
+	}
+}
+
+static void nft_arp_xlate16(uint16_t v, uint16_t m, const char *what,
+			    bool hex, bool inverse,
+			    struct xt_xlate *xl)
+{
+	const char *fmt = hex ? "0x%x " : "%d ";
+
+	if (m) {
+		xt_xlate_add(xl, "arp %s ", what);
+		if (inverse)
+			xt_xlate_add(xl, " !=");
+		if (m != 0xffff) {
+			xt_xlate_add(xl, "& ");
+			xt_xlate_add(xl, fmt, ntohs(m));;
+
+		}
+		xt_xlate_add(xl, fmt, ntohs(v));
+	}
+}
+
+static void nft_arp_xlate_ipv4_addr(const char *what, const struct in_addr *addr,
+				    const struct in_addr *mask,
+				    bool inv, struct xt_xlate *xl)
+{
+	char mbuf[INET_ADDRSTRLEN], abuf[INET_ADDRSTRLEN];
+	const char *op = inv ? "!= " : "";
+	int cidr;
+
+	if (!inv && !addr->s_addr && !mask->s_addr)
+		return;
+
+	inet_ntop(AF_INET, addr, abuf, sizeof(abuf));
+
+	cidr = xtables_ipmask_to_cidr(mask);
+	switch (cidr) {
+	case -1:
+		xt_xlate_add(xl, "arp %s ip & %s %s %s ", what,
+			     inet_ntop(AF_INET, mask, mbuf, sizeof(mbuf)),
+			     inv ? "!=" : "==", abuf);
+		break;
+	case 32:
+		xt_xlate_add(xl, "arp %s ip %s%s ", what, op, abuf);
+		break;
+	default:
+		xt_xlate_add(xl, "arp %s ip %s%s/%d ", what, op, abuf, cidr);
+	}
+}
+
+static int nft_arp_xlate(const struct iptables_command_state *cs,
+			 struct xt_xlate *xl)
+{
+	const struct arpt_entry *fw = &cs->arp;
+	int ret;
+
+	xlate_ifname(xl, "iifname", fw->arp.iniface,
+		     fw->arp.invflags & IPT_INV_VIA_IN);
+	xlate_ifname(xl, "oifname", fw->arp.outiface,
+		     fw->arp.invflags & IPT_INV_VIA_OUT);
+
+	if (fw->arp.arhrd ||
+	    fw->arp.arhrd_mask != 0xffff ||
+	    fw->arp.invflags & IPT_INV_ARPHRD)
+		nft_arp_xlate16(fw->arp.arhrd, fw->arp.arhrd_mask,
+				"htype", false,
+				 fw->arp.invflags & IPT_INV_ARPHRD, xl);
+
+	if (fw->arp.arhln_mask != 255 || fw->arp.arhln ||
+	    fw->arp.invflags & IPT_INV_ARPHLN) {
+		xt_xlate_add(xl, "arp hlen ");
+		if (fw->arp.invflags & IPT_INV_ARPHLN)
+			xt_xlate_add(xl, " !=");
+		if (fw->arp.arhln_mask != 255)
+			xt_xlate_add(xl, "& %d ", fw->arp.arhln_mask);
+		xt_xlate_add(xl, "%d ", fw->arp.arhln);
+	}
+
+	/* added implicitly by arptables-nft */
+	xt_xlate_add(xl, "arp plen %d", 4);
+
+	if (fw->arp.arpop_mask != 65535 ||
+	    fw->arp.arpop != 0 ||
+	    fw->arp.invflags & IPT_INV_ARPOP)
+		nft_arp_xlate16(fw->arp.arpop, fw->arp.arpop_mask,
+				"operation", false,
+				fw->arp.invflags & IPT_INV_ARPOP, xl);
+
+	if (fw->arp.arpro_mask != 65535 ||
+	    fw->arp.invflags & IPT_INV_PROTO ||
+	    fw->arp.arpro)
+		nft_arp_xlate16(fw->arp.arpro, fw->arp.arpro_mask,
+				"ptype", true,
+				fw->arp.invflags & IPT_INV_PROTO, xl);
+
+	if (fw->arp.smsk.s_addr != 0L)
+		nft_arp_xlate_ipv4_addr("saddr", &fw->arp.src, &fw->arp.smsk,
+					fw->arp.invflags & IPT_INV_SRCIP, xl);
+
+	if (fw->arp.tmsk.s_addr != 0L)
+		nft_arp_xlate_ipv4_addr("daddr", &fw->arp.tgt, &fw->arp.tmsk,
+					fw->arp.invflags & IPT_INV_DSTIP, xl);
+
+	nft_arp_xlate_mac_and_mask(&fw->arp.src_devaddr, "saddr",
+				   fw->arp.invflags & IPT_INV_SRCDEVADDR, xl);
+	nft_arp_xlate_mac_and_mask(&fw->arp.tgt_devaddr, "daddr",
+				   fw->arp.invflags & IPT_INV_TGTDEVADDR, xl);
+
+	ret = xlate_matches(cs, xl);
+	if (!ret)
+		return ret;
+
+	/* Always add counters per rule, as in iptables */
+	xt_xlate_add(xl, "counter");
+	return xlate_action(cs, false, xl);
+}
+
 struct nft_family_ops nft_family_ops_arp = {
 	.add			= nft_arp_add,
 	.is_same		= nft_arp_is_same,
@@ -678,6 +830,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.init_cs		= nft_arp_init_cs,
 	.clear_cs		= xtables_clear_iptables_command_state,
+	.xlate			= nft_arp_xlate,
 	.add_entry		= nft_arp_add_entry,
 	.delete_entry		= nft_arp_delete_entry,
 	.check_entry		= nft_arp_check_entry,
diff --git a/iptables/xtables-multi.h b/iptables/xtables-multi.h
index 833c11a2ac91..760d3e4f2b6e 100644
--- a/iptables/xtables-multi.h
+++ b/iptables/xtables-multi.h
@@ -9,6 +9,7 @@ extern int xtables_ip4_restore_main(int, char **);
 extern int xtables_ip6_main(int, char **);
 extern int xtables_ip6_save_main(int, char **);
 extern int xtables_ip6_restore_main(int, char **);
+extern int xtables_arp_xlate_main(int, char **);
 extern int xtables_ip4_xlate_main(int, char **);
 extern int xtables_ip6_xlate_main(int, char **);
 extern int xtables_eb_xlate_main(int, char **);
diff --git a/iptables/xtables-nft-multi.c b/iptables/xtables-nft-multi.c
index e2b7c641f85d..48265d8e0afa 100644
--- a/iptables/xtables-nft-multi.c
+++ b/iptables/xtables-nft-multi.c
@@ -30,6 +30,7 @@ static const struct subcommand multi_subcommands[] = {
 	{"ip6tables-translate",		xtables_ip6_xlate_main},
 	{"iptables-restore-translate",	xtables_ip4_xlate_restore_main},
 	{"ip6tables-restore-translate",	xtables_ip6_xlate_restore_main},
+	{"arptables-translate",		xtables_arp_xlate_main},
 	{"arptables",			xtables_arp_main},
 	{"arptables-nft",		xtables_arp_main},
 	{"arptables-restore",		xtables_arp_restore_main},
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 88e0a6b63949..ea9dce204dfc 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -140,6 +140,7 @@ bool xlate_find_match(const struct iptables_command_state *cs, const char *p_nam
 }
 
 const char *family2str[] = {
+	[NFPROTO_ARP]	= "arp",
 	[NFPROTO_IPV4]	= "ip",
 	[NFPROTO_IPV6]	= "ip6",
 };
@@ -196,6 +197,15 @@ static int xlate(struct nft_handle *h, struct xt_cmd_parse *p,
 
 	for (i = 0; i < args->s.naddrs; i++) {
 		switch (h->family) {
+		case NFPROTO_ARP:
+			cs->arp.arp.src.s_addr = args->s.addr.v4[i].s_addr;
+			cs->arp.arp.smsk.s_addr = args->s.mask.v4[i].s_addr;
+			for (j = 0; j < args->d.naddrs; j++) {
+				cs->arp.arp.tgt.s_addr = args->d.addr.v4[j].s_addr;
+				cs->arp.arp.tmsk.s_addr = args->d.mask.v4[j].s_addr;
+				ret = cb(h, p, cs, append);
+			}
+			break;
 		case AF_INET:
 			cs->fw.ip.src.s_addr = args->s.addr.v4[i].s_addr;
 			cs->fw.ip.smsk.s_addr = args->s.mask.v4[i].s_addr;
@@ -475,7 +485,24 @@ static int xtables_xlate_main_common(struct nft_handle *h,
 
 	xtables_globals.program_name = progname;
 	xtables_globals.compat_rev = dummy_compat_rev;
-	ret = xtables_init_all(&xtables_globals, family);
+
+	switch (family) {
+	case NFPROTO_IPV4:
+		ret = xtables_init_all(&xtables_globals, family);
+		break;
+	case NFPROTO_IPV6:
+		ret = xtables_init_all(&xtables_globals, family);
+		break;
+	case NFPROTO_ARP:
+		arptables_globals.program_name = progname;
+		arptables_globals.compat_rev = dummy_compat_rev;
+		ret = xtables_init_all(&arptables_globals, family);
+		break;
+	default:
+		ret = -1;
+		break;
+	}
+
 	if (ret < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
 			xtables_globals.program_name,
@@ -590,6 +617,12 @@ static int xtables_restore_xlate_main(int family, const char *progname,
 	exit(0);
 }
 
+int xtables_arp_xlate_main(int argc, char *argv[])
+{
+	return xtables_xlate_main(NFPROTO_ARP, "arptables-translate",
+				  argc, argv);
+}
+
 int xtables_ip4_xlate_main(int argc, char *argv[])
 {
 	return xtables_xlate_main(NFPROTO_IPV4, "iptables-translate",
-- 
2.41.0

