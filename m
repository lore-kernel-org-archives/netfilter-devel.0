Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C207FC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A433261101
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhKFVBG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVBF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:01:05 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43E2C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:58:22 -0700 (PDT)
Received: from localhost ([::1]:58764 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSlZ-00046i-8u; Sat, 06 Nov 2021 21:58:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 08/10] xshared: Share print_header() with legacy iptables
Date:   Sat,  6 Nov 2021 21:57:54 +0100
Message-Id: <20211106205756.14529-9-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106205756.14529-1-phil@nwl.cc>
References: <20211106205756.14529-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Legacy iptables fetches the relevant data via libiptc before calling the
shared routine which merely prints data as requested.

Drop the 'basechain' parameter, instead make sure a policy name is
passed only with base chains. Since the function is not shared with
ebtables (which uses a very rudimental header instead), this is safe.

In order to support legacy iptables' checking of iptc_get_references()
return code (printing an error message instead of the reference count),
make refs parameter signed and print the error message if it's negative.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c  | 64 ++++++++-----------------------------------
 iptables/iptables.c   | 64 ++++++++-----------------------------------
 iptables/nft-arp.c    |  7 ++---
 iptables/nft-bridge.c |  2 +-
 iptables/nft-shared.c | 44 -----------------------------
 iptables/nft-shared.h |  7 ++---
 iptables/nft.c        |  6 ++--
 iptables/xshared.c    | 46 +++++++++++++++++++++++++++++++
 iptables/xshared.h    |  3 ++
 9 files changed, 82 insertions(+), 161 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 3d304d441c10a..5a64566eecd2a 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -233,56 +233,6 @@ static int is_exthdr(uint16_t proto)
 		proto == IPPROTO_DSTOPTS);
 }
 
-static void
-print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
-{
-	struct xt_counters counters;
-	const char *pol = ip6tc_get_policy(chain, &counters, handle);
-	printf("Chain %s", chain);
-	if (pol) {
-		printf(" (policy %s", pol);
-		if (!(format & FMT_NOCOUNTS)) {
-			fputc(' ', stdout);
-			xtables_print_num(counters.pcnt, (format|FMT_NOTABLE));
-			fputs("packets, ", stdout);
-			xtables_print_num(counters.bcnt, (format|FMT_NOTABLE));
-			fputs("bytes", stdout);
-		}
-		printf(")\n");
-	} else {
-		unsigned int refs;
-		if (!ip6tc_get_references(&refs, chain, handle))
-			printf(" (ERROR obtaining refs)\n");
-		else
-			printf(" (%u references)\n", refs);
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
-
 static int
 print_match(const struct xt_entry_match *m,
 	    const struct ip6t_ip6 *ip,
@@ -662,8 +612,18 @@ list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 
 		if (found) printf("\n");
 
-		if (!rulenum)
-		    print_header(format, this, handle);
+		if (!rulenum) {
+			struct xt_counters counters;
+			unsigned int urefs;
+			const char *pol;
+			int refs = - 1;
+
+			pol = ip6tc_get_policy(this, &counters, handle);
+			if (!pol && ip6tc_get_references(&urefs, this, handle))
+				refs = urefs;
+
+			print_header(format, this, pol, &counters, refs, 0);
+		}
 		i = ip6tc_first_rule(this, handle);
 
 		num = 0;
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 12a5423ec271d..ac51c612d92f2 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -224,56 +224,6 @@ iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 
 
-static void
-print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
-{
-	struct xt_counters counters;
-	const char *pol = iptc_get_policy(chain, &counters, handle);
-	printf("Chain %s", chain);
-	if (pol) {
-		printf(" (policy %s", pol);
-		if (!(format & FMT_NOCOUNTS)) {
-			fputc(' ', stdout);
-			xtables_print_num(counters.pcnt, (format|FMT_NOTABLE));
-			fputs("packets, ", stdout);
-			xtables_print_num(counters.bcnt, (format|FMT_NOTABLE));
-			fputs("bytes", stdout);
-		}
-		printf(")\n");
-	} else {
-		unsigned int refs;
-		if (!iptc_get_references(&refs, chain, handle))
-			printf(" (ERROR obtaining refs)\n");
-		else
-			printf(" (%u references)\n", refs);
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
-
 static int
 print_match(const struct xt_entry_match *m,
 	    const struct ipt_ip *ip,
@@ -652,8 +602,18 @@ list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 
 		if (found) printf("\n");
 
-		if (!rulenum)
-			print_header(format, this, handle);
+		if (!rulenum) {
+			struct xt_counters counters;
+			unsigned int urefs;
+			const char *pol;
+			int refs = -1;
+
+			pol = iptc_get_policy(this, &counters, handle);
+			if (!pol && iptc_get_references(&urefs, this, handle))
+				refs = urefs;
+
+			print_header(format, this, pol, &counters, refs, 0);
+		}
 		i = iptc_first_rule(this, handle);
 
 		num = 0;
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index b7536e61a255f..b211a30937db3 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -308,11 +308,10 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 static void nft_arp_print_header(unsigned int format, const char *chain,
 				 const char *pol,
 				 const struct xt_counters *counters,
-				 bool basechain, uint32_t refs,
-				 uint32_t entries)
+				 int refs, uint32_t entries)
 {
 	printf("Chain %s", chain);
-	if (basechain && pol) {
+	if (pol) {
 		printf(" (policy %s", pol);
 		if (!(format & FMT_NOCOUNTS)) {
 			fputc(' ', stdout);
@@ -323,7 +322,7 @@ static void nft_arp_print_header(unsigned int format, const char *chain,
 		}
 		printf(")\n");
 	} else {
-		printf(" (%u references)\n", refs);
+		printf(" (%d references)\n", refs);
 	}
 }
 
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index cc2a48dbf7741..5cde302c4f189 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -534,7 +534,7 @@ static void nft_bridge_print_table_header(const char *tablename)
 static void nft_bridge_print_header(unsigned int format, const char *chain,
 				    const char *pol,
 				    const struct xt_counters *counters,
-				    bool basechain, uint32_t refs, uint32_t entries)
+				    int refs, uint32_t entries)
 {
 	printf("Bridge chain: %s, entries: %u, policy: %s\n",
 	       chain, entries, pol ?: "RETURN");
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index eb0070075d9eb..a6a79c8cda084 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -714,50 +714,6 @@ void nft_clear_iptables_command_state(struct iptables_command_state *cs)
 	}
 }
 
-void print_header(unsigned int format, const char *chain, const char *pol,
-		  const struct xt_counters *counters, bool basechain,
-		  uint32_t refs, uint32_t entries)
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
 void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy)
 {
 	const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index e18df20d9fc38..de684374ef9e0 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -94,8 +94,8 @@ struct nft_family_ops {
 	void (*print_table_header)(const char *tablename);
 	void (*print_header)(unsigned int format, const char *chain,
 			     const char *pol,
-			     const struct xt_counters *counters, bool basechain,
-			     uint32_t refs, uint32_t entries);
+			     const struct xt_counters *counters,
+			     int refs, uint32_t entries);
 	void (*print_rule)(struct nft_handle *h, struct nftnl_rule *r,
 			   unsigned int num, unsigned int format);
 	void (*save_rule)(const void *data, unsigned int format);
@@ -164,9 +164,6 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
 					struct iptables_command_state *cs);
 void nft_clear_iptables_command_state(struct iptables_command_state *cs);
-void print_header(unsigned int format, const char *chain, const char *pol,
-		  const struct xt_counters *counters, bool basechain,
-		  uint32_t refs, uint32_t entries);
 void print_matches_and_target(struct iptables_command_state *cs,
 			      unsigned int format);
 void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy);
diff --git a/iptables/nft.c b/iptables/nft.c
index 282d417f3bc85..887c735b3f6e6 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2398,7 +2398,6 @@ static void __nft_print_header(struct nft_handle *h,
 {
 	struct nftnl_chain *c = nc->nftnl;
 	const char *chain_name = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
-	bool basechain = !!nftnl_chain_get(c, NFTNL_CHAIN_HOOKNUM);
 	uint32_t refs = nftnl_chain_get_u32(c, NFTNL_CHAIN_USE);
 	uint32_t entries = nft_rule_count(h, c);
 	struct xt_counters ctrs = {
@@ -2407,11 +2406,12 @@ static void __nft_print_header(struct nft_handle *h,
 	};
 	const char *pname = NULL;
 
-	if (nftnl_chain_is_set(c, NFTNL_CHAIN_POLICY))
+	if (nftnl_chain_get(c, NFTNL_CHAIN_HOOKNUM) &&
+	    nftnl_chain_is_set(c, NFTNL_CHAIN_POLICY))
 		pname = policy_name[nftnl_chain_get_u32(c, NFTNL_CHAIN_POLICY)];
 
 	h->ops->print_header(format, chain_name, pname,
-			&ctrs, basechain, refs - entries, entries);
+			     &ctrs, refs - entries, entries);
 }
 
 struct nft_rule_list_cb_data {
diff --git a/iptables/xshared.c b/iptables/xshared.c
index e8c8939cf8e3e..37ea71068b69c 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -547,6 +547,52 @@ void debug_print_argv(struct argv_store *store)
 }
 #endif
 
+void print_header(unsigned int format, const char *chain, const char *pol,
+		  const struct xt_counters *counters,
+		  int refs, uint32_t entries)
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
+	} else if (refs < 0) {
+		printf(" (ERROR obtaining refs)\n");
+	} else {
+		printf(" (%d references)\n", refs);
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
 const char *ipv4_addr_to_string(const struct in_addr *addr,
 				const struct in_addr *mask,
 				unsigned int format)
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 48f314cac8f45..757940090dd69 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -220,6 +220,9 @@ void debug_print_argv(struct argv_store *store);
 const char *ipv4_addr_to_string(const struct in_addr *addr,
 				const struct in_addr *mask,
 				unsigned int format);
+void print_header(unsigned int format, const char *chain, const char *pol,
+		  const struct xt_counters *counters,
+		  int refs, uint32_t entries);
 void print_ipv4_addresses(const struct ipt_entry *fw, unsigned int format);
 void save_ipv4_addr(char letter, const struct in_addr *addr,
 		    const struct in_addr *mask, int invert);
-- 
2.33.0

