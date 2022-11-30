Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB8EC4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiK3TOR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3TOQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 14:14:16 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011C762E8C
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 11:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t1z2kGghzgtSeyENJQ3L/mLTDt8JL0/4Uy5vRFSqROE=; b=CBsRkFZ2lBILGoSwVUq/QI26X/
        WEzYB4ZQWY1ByVGpGwNUzuQSbyzZO/jy0x2W3IMvciCpn0MqHhSkh60UlEBfOF+zNTR5DrPziP2mG
        9OTZTyDZmRRBsMT0XPUmpPje7oDKD06+Y2xAO5q85WUgQi4l5bbji5W4Q5nbsBdlOg+LTSRtucpBB
        ulWFviDtq6WUrNHI4Vn2ehqsDom7tJ1SRAqgpz4+k/e7JLTEYmcvrt6XGk3TQ8uGwrrSmeOBjGFEb
        2vpQBNJ+whWFzWcoHVOxy4rssJPYo3DO77rE/hkGphxWCmda4V1KBbTLqo96F5oB4IpfCTEnH/756
        h4wqjDsA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0SX8-0001Ab-9q
        for netfilter-devel@vger.kernel.org; Wed, 30 Nov 2022 20:14:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 6/9] xtables: Introduce xtables_clear_iptables_command_state()
Date:   Wed, 30 Nov 2022 20:13:42 +0100
Message-Id: <20221130191345.14543-7-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130191345.14543-1-phil@nwl.cc>
References: <20221130191345.14543-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is nft_clear_iptables_command_state() but in a location reachable
by legacy iptables, too.

Changes callers in non-family-specific code to use clear_cs callback
instead of directly calling it - ebtables still has a custom variant.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c           |  4 ++--
 iptables/nft-ipv4.c          |  4 ++--
 iptables/nft-ipv6.c          |  4 ++--
 iptables/nft-shared.c        | 14 --------------
 iptables/nft-shared.h        |  1 -
 iptables/xshared.c           | 17 +++++++++++++++++
 iptables/xshared.h           |  2 ++
 iptables/xtables-translate.c |  2 +-
 iptables/xtables.c           |  2 +-
 9 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 59f100af2a6b9..d670cbe629fe4 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -490,7 +490,7 @@ nft_arp_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
 
-	nft_clear_iptables_command_state(&cs);
+	xtables_clear_iptables_command_state(&cs);
 }
 
 static bool nft_arp_is_same(const struct iptables_command_state *cs_a,
@@ -787,7 +787,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.init_cs		= nft_arp_init_cs,
-	.clear_cs		= nft_clear_iptables_command_state,
+	.clear_cs		= xtables_clear_iptables_command_state,
 	.parse_target		= nft_ipv46_parse_target,
 	.add_entry		= nft_arp_add_entry,
 	.delete_entry		= nft_arp_delete_entry,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 6c62dd46dddac..42167351710e6 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -247,7 +247,7 @@ static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
 
-	nft_clear_iptables_command_state(&cs);
+	xtables_clear_iptables_command_state(&cs);
 }
 
 static void nft_ipv4_save_rule(const struct iptables_command_state *cs,
@@ -454,7 +454,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	},
 	.parse_target		= nft_ipv46_parse_target,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
-	.clear_cs		= nft_clear_iptables_command_state,
+	.clear_cs		= xtables_clear_iptables_command_state,
 	.xlate			= nft_ipv4_xlate,
 	.add_entry		= nft_ipv4_add_entry,
 	.delete_entry		= nft_ipv4_delete_entry,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 98c35afa67ad9..3a373b7eb2cfe 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -211,7 +211,7 @@ static void nft_ipv6_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
 
-	nft_clear_iptables_command_state(&cs);
+	xtables_clear_iptables_command_state(&cs);
 }
 
 static void nft_ipv6_save_rule(const struct iptables_command_state *cs,
@@ -423,7 +423,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	},
 	.parse_target		= nft_ipv46_parse_target,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
-	.clear_cs		= nft_clear_iptables_command_state,
+	.clear_cs		= xtables_clear_iptables_command_state,
 	.xlate			= nft_ipv6_xlate,
 	.add_entry		= nft_ipv6_add_entry,
 	.delete_entry		= nft_ipv6_delete_entry,
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 63d251986f65b..f1503b6ce0cbc 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -1293,20 +1293,6 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 	return ret;
 }
 
-void nft_clear_iptables_command_state(struct iptables_command_state *cs)
-{
-	xtables_rule_matches_free(&cs->matches);
-	if (cs->target) {
-		free(cs->target->t);
-		cs->target->t = NULL;
-
-		if (cs->target == cs->target->next) {
-			free(cs->target);
-			cs->target = NULL;
-		}
-	}
-}
-
 void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy)
 {
 	const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index e2c3ac7b0cc5c..07d39131cb0d6 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -216,7 +216,6 @@ void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv);
 bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
 					struct iptables_command_state *cs);
-void nft_clear_iptables_command_state(struct iptables_command_state *cs);
 void print_matches_and_target(struct iptables_command_state *cs,
 			      unsigned int format);
 void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy);
diff --git a/iptables/xshared.c b/iptables/xshared.c
index d400dc595ea99..2a894c19a011d 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1356,6 +1356,23 @@ static const char *optstring_lookup(int family)
 	return "";
 }
 
+void xtables_clear_iptables_command_state(struct iptables_command_state *cs)
+{
+	xtables_rule_matches_free(&cs->matches);
+	if (cs->target) {
+		free(cs->target->t);
+		cs->target->t = NULL;
+
+		free(cs->target->udata);
+		cs->target->udata = NULL;
+
+		if (cs->target == cs->target->next) {
+			free(cs->target);
+			cs->target = NULL;
+		}
+	}
+}
+
 void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args)
diff --git a/iptables/xshared.h b/iptables/xshared.h
index bfae4b4e1b5d3..0ed9f3c29c600 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -130,6 +130,8 @@ struct iptables_command_state {
 	bool restore;
 };
 
+void xtables_clear_iptables_command_state(struct iptables_command_state *cs);
+
 typedef int (*mainfunc_t)(int, char **);
 
 struct subcommand {
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 4e8db4bedff88..e8d251b3162d9 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -336,7 +336,7 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		exit(1);
 	}
 
-	nft_clear_iptables_command_state(&cs);
+	h->ops->clear_cs(&cs);
 
 	if (h->family == AF_INET) {
 		free(args.s.addr.v4);
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 70924176df8c1..22d6ea58376fc 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -262,7 +262,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 
 	*table = p.table;
 
-	nft_clear_iptables_command_state(&cs);
+	h->ops->clear_cs(&cs);
 
 	free(args.s.addr.ptr);
 	free(args.s.mask.ptr);
-- 
2.38.0

