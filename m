From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH xtables-compat] arptables-compat: get output in sync with arptables -L -n --line-numbers
Date: Thu,  9 Oct 2014 12:48:33 +0200
Message-ID: <1412851713-9829-1-git-send-email-pablo@netfilter.org>
Cc: giuseppelng@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57634 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbaJIKrZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:47:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # arptables-compat -L -n --line-numbers
 Chain INPUT (policy ACCEPT)
 num  target     prot opt source               destination <--

This header is not shown by arptables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-arp.c    |   22 ++++++++++++++++++++++
 iptables/nft-ipv4.c   |    9 +++++++++
 iptables/nft-ipv6.c   |    9 +++++++++
 iptables/nft-shared.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-shared.h |    8 ++++++++
 iptables/nft.c        |   48 ++----------------------------------------------
 6 files changed, 94 insertions(+), 46 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 541feeb..dbfbded 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -414,6 +414,27 @@ void nft_rule_to_arptables_command_state(struct nft_rule *r,
 		cs->jumpto = "";
 }
 
+static void nft_arp_print_header(unsigned int format, const char *chain,
+				 const char *pol,
+				 const struct xt_counters *counters,
+				 bool basechain, uint32_t refs)
+{
+	printf("Chain %s", chain);
+	if (pol) {
+		printf(" (policy %s", pol);
+		if (!(format & FMT_NOCOUNTS)) {
+			fputc(' ', stdout);
+			xtables_print_num(counters->pcnt, (format|FMT_NOTABLE));
+			fputs("packets, ", stdout);
+			xtables_print_num(counters->bcnt, (format|FMT_NOTABLE));
+			fputs("bytes", stdout);
+		}
+		printf(")\n");
+	} else {
+		printf(" (%u references)\n", refs);
+	}
+}
+
 static void print_fw_details(struct arpt_entry *fw, unsigned int format)
 {
 	char buf[BUFSIZ];
@@ -665,6 +686,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.parse_meta		= nft_arp_parse_meta,
 	.parse_payload		= nft_arp_parse_payload,
 	.parse_immediate	= nft_arp_parse_immediate,
+	.print_header		= nft_arp_print_header,
 	.print_firewall		= nft_arp_print_firewall,
 	.save_firewall		= nft_arp_save_firewall,
 	.save_counters		= nft_arp_save_counters,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index cb1d45b..eedcb50 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -221,6 +221,14 @@ static void nft_ipv4_parse_immediate(const char *jumpto, bool nft_goto,
 		cs->fw.ip.flags |= IPT_F_GOTO;
 }
 
+static void nft_ipv4_print_header(unsigned int format, const char *chain,
+				  const char *pol,
+				  const struct xt_counters *counters,
+				  bool basechain, uint32_t refs)
+{
+	print_header(format, chain, pol, counters, basechain, refs);
+}
+
 static void print_ipv4_addr(const struct iptables_command_state *cs,
 			    unsigned int format)
 {
@@ -415,6 +423,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.parse_meta		= nft_ipv4_parse_meta,
 	.parse_payload		= nft_ipv4_parse_payload,
 	.parse_immediate	= nft_ipv4_parse_immediate,
+	.print_header		= nft_ipv4_print_header,
 	.print_firewall		= nft_ipv4_print_firewall,
 	.save_firewall		= nft_ipv4_save_firewall,
 	.save_counters		= nft_ipv4_save_counters,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index a70afcc..2e50627 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -158,6 +158,14 @@ static void nft_ipv6_parse_immediate(const char *jumpto, bool nft_goto,
 		cs->fw6.ipv6.flags |= IP6T_F_GOTO;
 }
 
+static void nft_ipv6_print_header(unsigned int format, const char *chain,
+				  const char *pol,
+				  const struct xt_counters *counters,
+				  bool basechain, uint32_t refs)
+{
+	print_header(format, chain, pol, counters, basechain, refs);
+}
+
 static void print_ipv6_addr(const struct iptables_command_state *cs,
 			    unsigned int format)
 {
@@ -360,6 +368,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.parse_meta		= nft_ipv6_parse_meta,
 	.parse_payload		= nft_ipv6_parse_payload,
 	.parse_immediate	= nft_ipv6_parse_immediate,
+	.print_header		= nft_ipv6_print_header,
 	.print_firewall		= nft_ipv6_print_firewall,
 	.save_firewall		= nft_ipv6_save_firewall,
 	.save_counters		= nft_ipv6_save_counters,
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 86b7ac9..70a28c8 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -532,6 +532,50 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 		cs->jumpto = "";
 }
 
+void print_header(unsigned int format, const char *chain, const char *pol,
+		  const struct xt_counters *counters, bool basechain,
+		  uint32_t refs)
+{
+	printf("Chain %s", chain);
+	if (basechain) {
+		printf(" (policy %s", pol);
+		if (!(format & FMT_NOCOUNTS)) {
+			fputc(' ', stdout);
+			xtables_print_num(counters->pcnt, (format|FMT_NOTABLE));
+			fputs("packets, ", stdout);
+			xtables_print_num(counters->bcnt, (format|FMT_NOTABLE));
+			fputs("bytes", stdout);
+		}
+		printf(")\n");
+	} else {
+		printf(" (%u references)\n", refs);
+	}
+
+	if (format & FMT_LINENUMBERS)
+		printf(FMT("%-4s ", "%s "), "num");
+	if (!(format & FMT_NOCOUNTS)) {
+		if (format & FMT_KILOMEGAGIGA) {
+			printf(FMT("%5s ","%s "), "pkts");
+			printf(FMT("%5s ","%s "), "bytes");
+		} else {
+			printf(FMT("%8s ","%s "), "pkts");
+			printf(FMT("%10s ","%s "), "bytes");
+		}
+	}
+	if (!(format & FMT_NOTARGET))
+		printf(FMT("%-9s ","%s "), "target");
+	fputs(" prot ", stdout);
+	if (format & FMT_OPTIONS)
+		fputs("opt", stdout);
+	if (format & FMT_VIA) {
+		printf(FMT(" %-6s ","%s "), "in");
+		printf(FMT("%-6s ","%s "), "out");
+	}
+	printf(FMT(" %-19s ","%s "), "source");
+	printf(FMT(" %-19s "," %s "), "destination");
+	printf("\n");
+}
+
 void print_firewall_details(const struct iptables_command_state *cs,
 			    const char *targname, uint8_t flags,
 			    uint8_t invflags, uint8_t proto,
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index aa97b84..468da5c 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -82,6 +82,11 @@ struct nft_family_ops {
 	void (*parse_cmp)(struct nft_xt_ctx *ctx, struct nft_rule_expr *e,
 			  void *data);
 	void (*parse_immediate)(const char *jumpto, bool nft_goto, void *data);
+
+	void (*print_header)(unsigned int format, const char *chain,
+			     const char *pol,
+			     const struct xt_counters *counters, bool basechain,
+			     uint32_t refs);
 	void (*print_firewall)(struct nft_rule *r, unsigned int num,
 			       unsigned int format);
 	void (*save_firewall)(const void *data, unsigned int format);
@@ -131,6 +136,9 @@ void nft_parse_counter(struct nft_rule_expr *e, struct xt_counters *counters);
 void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_rule_to_iptables_command_state(struct nft_rule *r,
 					struct iptables_command_state *cs);
+void print_header(unsigned int format, const char *chain, const char *pol,
+		  const struct xt_counters *counters, bool basechain,
+		  uint32_t refs);
 void print_firewall_details(const struct iptables_command_state *cs,
 			    const char *targname, uint8_t flags,
 			    uint8_t invflags, uint8_t proto,
diff --git a/iptables/nft.c b/iptables/nft.c
index 6686a9b..ca199cd 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1871,50 +1871,6 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 	return ret;
 }
 
-static void
-print_header(unsigned int format, const char *chain, const char *pol,
-	     const struct xt_counters *counters, bool basechain, uint32_t refs)
-{
-	printf("Chain %s", chain);
-	if (basechain) {
-		printf(" (policy %s", pol);
-		if (!(format & FMT_NOCOUNTS)) {
-			fputc(' ', stdout);
-			xtables_print_num(counters->pcnt, (format|FMT_NOTABLE));
-			fputs("packets, ", stdout);
-			xtables_print_num(counters->bcnt, (format|FMT_NOTABLE));
-			fputs("bytes", stdout);
-		}
-		printf(")\n");
-	} else {
-		printf(" (%u references)\n", refs);
-	}
-
-	if (format & FMT_LINENUMBERS)
-		printf(FMT("%-4s ", "%s "), "num");
-	if (!(format & FMT_NOCOUNTS)) {
-		if (format & FMT_KILOMEGAGIGA) {
-			printf(FMT("%5s ","%s "), "pkts");
-			printf(FMT("%5s ","%s "), "bytes");
-		} else {
-			printf(FMT("%8s ","%s "), "pkts");
-			printf(FMT("%10s ","%s "), "bytes");
-		}
-	}
-	if (!(format & FMT_NOTARGET))
-		printf(FMT("%-9s ","%s "), "target");
-	fputs(" prot ", stdout);
-	if (format & FMT_OPTIONS)
-		fputs("opt", stdout);
-	if (format & FMT_VIA) {
-		printf(FMT(" %-6s ","%s "), "in");
-		printf(FMT("%-6s ","%s "), "out");
-	}
-	printf(FMT(" %-19s ","%s "), "source");
-	printf(FMT(" %-19s "," %s "), "destination");
-	printf("\n");
-}
-
 static int
 __nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		int rulenum, unsigned int format,
@@ -2026,8 +1982,8 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		if (found)
 			printf("\n");
 
-		print_header(format, chain_name, policy_name[policy],
-				     &ctrs, basechain, refs);
+		ops->print_header(format, chain_name, policy_name[policy],
+				  &ctrs, basechain, refs);
 
 		__nft_rule_list(h, chain_name, table,
 				rulenum, format, ops->print_firewall);
-- 
1.7.10.4

