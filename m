From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables v2 2/2] xtables-translate-restore: do not escape quotes
Date: Mon, 22 Aug 2016 12:56:15 +0200
Message-ID: <20160822105615.32483-2-pablombg@gmail.com>
References: <20160822105615.32483-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33681 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754685AbcHVK4u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 06:56:50 -0400
Received: by mail-wm0-f67.google.com with SMTP id o80so12885202wme.0
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 03:56:50 -0700 (PDT)
In-Reply-To: <20160822105615.32483-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If quotes are escaped, nft -f is unable to parse and load the translated
ruleset.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---

Changes in v2:
  - Do not use strcmp against 'program_name' global, propagate 'bool restore'
    argument instead.

 iptables/nft-ipv4.c          |  6 +++---
 iptables/nft-ipv6.c          |  7 ++++---
 iptables/nft-shared.h        |  2 +-
 iptables/nft.h               |  5 +++--
 iptables/xtables-translate.c | 28 ++++++++++++++++++----------
 5 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 295dd42..362036c 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -438,7 +438,7 @@ static void nft_ipv4_save_counters(const void *data)
 	save_counters(cs->counters.pcnt, cs->counters.bcnt);
 }
 
-static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
+static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl, bool restore)
 {
 	const struct iptables_command_state *cs = data;
 	const char *comment;
@@ -481,7 +481,7 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 			   inet_ntoa(cs->fw.ip.dst));
 	}
 
-	ret = xlate_matches(cs, xl);
+	ret = xlate_matches(cs, xl, restore);
 	if (!ret)
 		return ret;
 
@@ -492,7 +492,7 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 	if (comment)
 		xt_xlate_add(xl, "comment %s", comment);
 
-	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), xl);
+	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), xl, restore);
 
 	return ret;
 }
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 8bebf6b..e24149e 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -398,7 +398,7 @@ static void xlate_ipv6_addr(const char *selector, const struct in6_addr *addr,
 	xt_xlate_add(xl, "%s %s%s ", selector, invert ? "!= " : "", addr_str);
 }
 
-static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
+static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl, bool restore)
 {
 	const struct iptables_command_state *cs = data;
 	const char *comment;
@@ -430,7 +430,7 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 	xlate_ipv6_addr("ip6 daddr", &cs->fw6.ipv6.dst,
 			cs->fw6.ipv6.invflags & IP6T_INV_DSTIP, xl);
 
-	ret = xlate_matches(cs, xl);
+	ret = xlate_matches(cs, xl, restore);
 	if (!ret)
 		return ret;
 
@@ -441,7 +441,8 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 	if (comment)
 		xt_xlate_add(xl, "comment %s", comment);
 
-	ret = xlate_action(cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO), xl);
+	ret = xlate_action(cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO), xl,
+				  restore);
 
 	return ret;
 }
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index c0948fd..489bad7 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -102,7 +102,7 @@ struct nft_family_ops {
 	void (*parse_target)(struct xtables_target *t, void *data);
 	bool (*rule_find)(struct nft_family_ops *ops, struct nftnl_rule *r,
 			  void *data);
-	int (*xlate)(const void *data, struct xt_xlate *xl);
+	int (*xlate)(const void *data, struct xt_xlate *xl, bool restore);
 };
 
 void add_meta(struct nftnl_rule *r, uint32_t key);
diff --git a/iptables/nft.h b/iptables/nft.h
index 52f2136..641e347 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -163,9 +163,10 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename, uint32_t
 struct xt_buf;
 
 bool xlate_find_match(const struct iptables_command_state *cs, const char *p_name);
-int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl);
+int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl,
+		  bool restore);
 int xlate_action(const struct iptables_command_state *cs, bool goto_set,
-		 struct xt_xlate *xl);
+		 struct xt_xlate *xl, bool restore);
 void xlate_ifname(struct xt_xlate *xl, const char *nftmeta, const char *ifname,
 		  bool invert);
 
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 3c577ed..94aebda 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -52,7 +52,7 @@ void xlate_ifname(struct xt_xlate *xl, const char *nftmeta, const char *ifname,
 }
 
 int xlate_action(const struct iptables_command_state *cs, bool goto_set,
-		 struct xt_xlate *xl)
+		 struct xt_xlate *xl, bool restore)
 {
 	int ret = 1, numeric = cs->options & OPT_NUMERIC;
 
@@ -72,6 +72,8 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 				.numeric	= numeric,
 				.escape_quotes	= true,
 			};
+			if (restore)
+				params.escape_quotes = false;
 			ret = cs->target->xlate(xl, &params);
 		}
 		else
@@ -87,7 +89,8 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 	return ret;
 }
 
-int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
+int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl,
+		  bool restore)
 {
 	struct xtables_rule_match *matchp;
 	int ret = 1, numeric = cs->options & OPT_NUMERIC;
@@ -100,6 +103,9 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 			.escape_quotes	= true,
 		};
 
+		if (restore)
+			params.escape_quotes = false;
+
 		if (!matchp->match->xlate)
 			return 0;
 
@@ -134,7 +140,7 @@ const char *family2str[] = {
 static int nft_rule_xlate_add(struct nft_handle *h,
 			      const struct nft_xt_cmd_parse *p,
 			      const struct iptables_command_state *cs,
-			      bool append)
+			      bool append, bool restore)
 {
 	struct xt_xlate *xl = xt_xlate_alloc(10240);
 	int ret;
@@ -147,7 +153,7 @@ static int nft_rule_xlate_add(struct nft_handle *h,
 			   family2str[h->family], p->table, p->chain);
 	}
 
-	ret = h->ops->xlate(cs, xl);
+	ret = h->ops->xlate(cs, xl, restore);
 	if (ret)
 		printf("%s\n", xt_xlate_get(xl));
 
@@ -157,11 +163,11 @@ static int nft_rule_xlate_add(struct nft_handle *h,
 
 static int xlate(struct nft_handle *h, struct nft_xt_cmd_parse *p,
 		 struct iptables_command_state *cs,
-		 struct xtables_args *args, bool append,
+		 struct xtables_args *args, bool append, bool restore,
 		 int (*cb)(struct nft_handle *h,
 			   const struct nft_xt_cmd_parse *p,
 			   const struct iptables_command_state *cs,
-			   bool append))
+			   bool append, bool restore))
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -176,7 +182,7 @@ static int xlate(struct nft_handle *h, struct nft_xt_cmd_parse *p,
 					args->d.addr.v4[j].s_addr;
 				cs->fw.ip.dmsk.s_addr =
 					args->d.mask.v4[j].s_addr;
-				ret = cb(h, p, cs, append);
+				ret = cb(h, p, cs, append, restore);
 			}
 			break;
 		case AF_INET6:
@@ -191,7 +197,7 @@ static int xlate(struct nft_handle *h, struct nft_xt_cmd_parse *p,
 				memcpy(&cs->fw6.ipv6.dmsk,
 				       &args->d.mask.v6[j],
 				       sizeof(struct in6_addr));
-				ret = cb(h, p, cs, append);
+				ret = cb(h, p, cs, append, restore);
 			}
 			break;
 		}
@@ -232,7 +238,8 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 	switch (p.command) {
 	case CMD_APPEND:
 		ret = 1;
-		if (!xlate(h, &p, &cs, &args, true, nft_rule_xlate_add)) {
+		if (!xlate(h, &p, &cs, &args, true, restore,
+		    nft_rule_xlate_add)) {
 			print_ipt_cmd(argc, argv);
 		}
 		break;
@@ -246,7 +253,8 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		break;
 	case CMD_INSERT:
 		ret = 1;
-		if (!xlate(h, &p, &cs, &args, false, nft_rule_xlate_add)) {
+		if (!xlate(h, &p, &cs, &args, false, restore,
+		    nft_rule_xlate_add)) {
 			print_ipt_cmd(argc, argv);
 		}
 		break;
-- 
2.9.3

