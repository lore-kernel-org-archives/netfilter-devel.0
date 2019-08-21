Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9A1C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8571A22D6D
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfHUJ0Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 05:26:25 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43754 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfHUJ0Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 05:26:25 -0400
Received: from localhost ([::1]:56844 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i0Mso-00054K-Be; Wed, 21 Aug 2019 11:26:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/14] nft: family_ops: Pass nft_handle to 'rule_to_cs' callback
Date:   Wed, 21 Aug 2019 11:25:58 +0200
Message-Id: <20190821092602.16292-11-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190821092602.16292-1-phil@nwl.cc>
References: <20190821092602.16292-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the actual callback used to parse nftables rules. Pass
nft_handle to it so it can access the cache (and possible sets therein).

Having to pass nft_handle to nft_rule_print_save() allows to simplify it
a bit since no family ops lookup has to be done anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c         |  4 ++--
 iptables/nft-bridge.c      |  9 +++++----
 iptables/nft-ipv4.c        |  2 +-
 iptables/nft-ipv6.c        |  2 +-
 iptables/nft-shared.c      |  5 +++--
 iptables/nft-shared.h      |  5 +++--
 iptables/nft.c             | 29 +++++++++++++----------------
 iptables/nft.h             |  4 ++--
 iptables/xtables-monitor.c | 17 +++++++++++++++--
 iptables/xtables-save.c    |  3 +++
 10 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 2956469be6340..c31d80eedfd60 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -612,7 +612,7 @@ static void nft_arp_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	if (format & FMT_LINENUMBERS)
 		printf("%u ", num);
 
-	nft_rule_to_iptables_command_state(r, &cs);
+	nft_rule_to_iptables_command_state(h, r, &cs);
 
 	nft_arp_print_rule_details(&cs, format);
 	print_matches_and_target(&cs, format);
@@ -663,7 +663,7 @@ static bool nft_arp_rule_find(struct nft_handle *h, struct nftnl_rule *r,
 	bool ret = false;
 
 	/* Delete by matching rule case */
-	nft_rule_to_iptables_command_state(r, &this);
+	nft_rule_to_iptables_command_state(h, r, &this);
 
 	if (!nft_arp_is_same(&cs->arp, &this.arp))
 		goto out;
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index b0c6c5a4db3cd..20ce92a6d5242 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -333,11 +333,12 @@ static void nft_bridge_parse_target(struct xtables_target *t, void *data)
 	cs->target = t;
 }
 
-static void nft_rule_to_ebtables_command_state(const struct nftnl_rule *r,
+static void nft_rule_to_ebtables_command_state(struct nft_handle *h,
+					       const struct nftnl_rule *r,
 					       struct iptables_command_state *cs)
 {
 	cs->eb.bitmask = EBT_NOPROTO;
-	nft_rule_to_iptables_command_state(r, cs);
+	nft_rule_to_iptables_command_state(h, r, cs);
 }
 
 static void print_iface(const char *option, const char *name, bool invert)
@@ -480,7 +481,7 @@ static void nft_bridge_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	if (format & FMT_LINENUMBERS)
 		printf("%d ", num);
 
-	nft_rule_to_ebtables_command_state(r, &cs);
+	nft_rule_to_ebtables_command_state(h, r, &cs);
 	nft_bridge_save_rule(&cs, format);
 	ebt_cs_clean(&cs);
 }
@@ -544,7 +545,7 @@ static bool nft_bridge_rule_find(struct nft_handle *h, struct nftnl_rule *r,
 	struct iptables_command_state this = {};
 	bool ret = false;
 
-	nft_rule_to_ebtables_command_state(r, &this);
+	nft_rule_to_ebtables_command_state(h, r, &this);
 
 	DEBUGP("comparing with... ");
 
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 98d7f966e3694..70634f8fad84d 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -266,7 +266,7 @@ static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 {
 	struct iptables_command_state cs = {};
 
-	nft_rule_to_iptables_command_state(r, &cs);
+	nft_rule_to_iptables_command_state(h, r, &cs);
 
 	print_rule_details(&cs, cs.jumpto, cs.fw.ip.flags,
 			   cs.fw.ip.invflags, cs.fw.ip.proto, num, format);
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 56236bff03c2b..d01491bfdb689 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -192,7 +192,7 @@ static void nft_ipv6_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 {
 	struct iptables_command_state cs = {};
 
-	nft_rule_to_iptables_command_state(r, &cs);
+	nft_rule_to_iptables_command_state(h, r, &cs);
 
 	print_rule_details(&cs, cs.jumpto, cs.fw6.ipv6.flags,
 			   cs.fw6.ipv6.invflags, cs.fw6.ipv6.proto,
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 0f5ca3b4eab23..d5984d0577ed1 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -580,7 +580,8 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		ctx->h->ops->parse_match(match, ctx->cs);
 }
 
-void nft_rule_to_iptables_command_state(const struct nftnl_rule *r,
+void nft_rule_to_iptables_command_state(struct nft_handle *h,
+					const struct nftnl_rule *r,
 					struct iptables_command_state *cs)
 {
 	struct nftnl_expr_iter *iter;
@@ -975,7 +976,7 @@ bool nft_ipv46_rule_find(struct nft_handle *h, struct nftnl_rule *r, void *data)
 	struct iptables_command_state *cs = data, this = {};
 	bool ret = false;
 
-	nft_rule_to_iptables_command_state(r, &this);
+	nft_rule_to_iptables_command_state(h, r, &this);
 
 	DEBUGP("comparing with... ");
 #ifdef DEBUG_DEL
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 38e5fd5387c10..ff3beef1af0de 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -101,7 +101,7 @@ struct nft_family_ops {
 			   struct xtables_args *args);
 	void (*parse_match)(struct xtables_match *m, void *data);
 	void (*parse_target)(struct xtables_target *t, void *data);
-	void (*rule_to_cs)(const struct nftnl_rule *r,
+	void (*rule_to_cs)(struct nft_handle *h, const struct nftnl_rule *r,
 			   struct iptables_command_state *cs);
 	void (*clear_cs)(struct iptables_command_state *cs);
 	bool (*rule_find)(struct nft_handle *h, struct nftnl_rule *r,
@@ -138,7 +138,8 @@ int parse_meta(struct nftnl_expr *e, uint8_t key, char *iniface,
 		unsigned char *outiface_mask, uint8_t *invflags);
 void print_proto(uint16_t proto, int invert);
 void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv);
-void nft_rule_to_iptables_command_state(const struct nftnl_rule *r,
+void nft_rule_to_iptables_command_state(struct nft_handle *h,
+					const struct nftnl_rule *r,
 					struct iptables_command_state *cs);
 void nft_clear_iptables_command_state(struct iptables_command_state *cs);
 void print_header(unsigned int format, const char *chain, const char *pol,
diff --git a/iptables/nft.c b/iptables/nft.c
index 1acc97702bcce..821afa8f5e78c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -389,7 +389,7 @@ static int mnl_append_error(const struct nft_handle *h,
 			 nftnl_rule_get_str(o->rule, NFTNL_RULE_CHAIN));
 #if 0
 		{
-			nft_rule_print_save(o->rule, NFT_RULE_APPEND, FMT_NOCOUNTS);
+			nft_rule_print_save(h, o->rule, NFT_RULE_APPEND, FMT_NOCOUNTS);
 		}
 #endif
 		break;
@@ -1339,19 +1339,16 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 }
 
 void
-nft_rule_print_save(const struct nftnl_rule *r, enum nft_rule_print type,
-		    unsigned int format)
+nft_rule_print_save(struct nft_handle *h, const struct nftnl_rule *r,
+		    enum nft_rule_print type, unsigned int format)
 {
 	const char *chain = nftnl_rule_get_str(r, NFTNL_RULE_CHAIN);
-	int family = nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY);
 	struct iptables_command_state cs = {};
-	struct nft_family_ops *ops;
 
-	ops = nft_family_ops_lookup(family);
-	ops->rule_to_cs(r, &cs);
+	h->ops->rule_to_cs(h, r, &cs);
 
-	if (!(format & (FMT_NOCOUNTS | FMT_C_COUNTS)) && ops->save_counters)
-		ops->save_counters(&cs);
+	if (!(format & (FMT_NOCOUNTS | FMT_C_COUNTS)) && h->ops->save_counters)
+		h->ops->save_counters(&cs);
 
 	/* print chain name */
 	switch(type) {
@@ -1363,11 +1360,11 @@ nft_rule_print_save(const struct nftnl_rule *r, enum nft_rule_print type,
 		break;
 	}
 
-	if (ops->save_rule)
-		ops->save_rule(&cs, format);
+	if (h->ops->save_rule)
+		h->ops->save_rule(&cs, format);
 
-	if (ops->clear_cs)
-		ops->clear_cs(&cs);
+	if (h->ops->clear_cs)
+		h->ops->clear_cs(&cs);
 }
 
 static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
@@ -1836,7 +1833,7 @@ static int nft_chain_save_rules(struct nft_handle *h,
 
 	r = nftnl_rule_iter_next(iter);
 	while (r != NULL) {
-		nft_rule_print_save(r, NFT_RULE_APPEND, format);
+		nft_rule_print_save(h, r, NFT_RULE_APPEND, format);
 		r = nftnl_rule_iter_next(iter);
 	}
 
@@ -2681,7 +2678,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 static void list_save(struct nft_handle *h, struct nftnl_rule *r,
 		      unsigned int num, unsigned int format)
 {
-	nft_rule_print_save(r, NFT_RULE_APPEND, format);
+	nft_rule_print_save(h, r, NFT_RULE_APPEND, format);
 }
 
 static int __nftnl_rule_list_chain_save(struct nftnl_chain *c, void *data)
@@ -2797,7 +2794,7 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 		goto error;
 	}
 
-	nft_rule_to_iptables_command_state(r, &cs);
+	nft_rule_to_iptables_command_state(h, r, &cs);
 
 	cs.counters.pcnt = cs.counters.bcnt = 0;
 
diff --git a/iptables/nft.h b/iptables/nft.h
index ff57976abbd64..09604692d66d0 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -145,8 +145,8 @@ enum nft_rule_print {
 	NFT_RULE_DEL,
 };
 
-void nft_rule_print_save(const struct nftnl_rule *r, enum nft_rule_print type,
-			 unsigned int format);
+void nft_rule_print_save(struct nft_handle *h, const struct nftnl_rule *r,
+			 enum nft_rule_print type, unsigned int format);
 
 uint32_t nft_invflags2cmp(uint32_t invflags, uint32_t flag);
 
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index eb80bac81c645..a5245d1422af9 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -11,6 +11,7 @@
 
 #define _GNU_SOURCE
 #include "config.h"
+#include <errno.h>
 #include <stdlib.h>
 #include <time.h>
 #include <string.h>
@@ -41,6 +42,7 @@
 struct cb_arg {
 	uint32_t nfproto;
 	bool is_event;
+	struct nft_handle *h;
 };
 
 static int table_cb(const struct nlmsghdr *nlh, void *data)
@@ -106,7 +108,7 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 	}
 
 	printf("-t %s ", nftnl_rule_get_str(r, NFTNL_RULE_TABLE));
-	nft_rule_print_save(r, type == NFT_MSG_NEWRULE ? NFT_RULE_APPEND :
+	nft_rule_print_save(arg->h, r, type == NFT_MSG_NEWRULE ? NFT_RULE_APPEND :
 							   NFT_RULE_DEL,
 			    counters ? 0 : FMT_NOCOUNTS);
 err_free:
@@ -593,7 +595,10 @@ int xtables_monitor_main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint32_t nfgroup = 0;
-	struct cb_arg cb_arg = {};
+	struct nft_handle h = {};
+	struct cb_arg cb_arg = {
+		.h = &h,
+	};
 	int ret, c;
 
 	xtables_globals.program_name = "xtables-monitor";
@@ -610,6 +615,14 @@ int xtables_monitor_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
+	if (nft_init(&h, xtables_ipv4)) {
+		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
+			xtables_globals.program_name,
+			xtables_globals.program_version,
+			strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
 	opterr = 0;
 	while ((c = getopt_long(argc, argv, "ceht46V", options, NULL)) != -1) {
 		switch (c) {
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 77b13f7ffbcdd..88f974a55f15b 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -248,6 +248,9 @@ xtables_save_main(int family, int argc, char *argv[],
 				strerror(errno));
 		exit(EXIT_FAILURE);
 	}
+	h.ops = nft_family_ops_lookup(h.family);
+	if (!h.ops)
+		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
 	ret = do_output(&h, tablename, &d);
 	nft_fini(&h);
-- 
2.22.0

