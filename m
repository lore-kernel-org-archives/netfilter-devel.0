Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F519C77B7D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 18:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbjEESfI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 14:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjEESfF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 14:35:05 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFE715EDD
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 11:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=h6W3uUWBkPzxJeATGlK5T/Ina/j4z2Q7Kcg1Hi76h1k=; b=iDCiAb6ugJm5FswtpSuo8iYigy
        puMXJ8rQro4y8wHm6LFWYdoN/SenSNglgh6dIlL3EONX6x+Y00RL6UiQEURf+fw/E0lRA2n8pMwY2
        0Lbhbfgb9NDmx/fKQ2uHD+WNrcpPkYRYhxCa6/cNzh6DJ96P5iPAMqHps6VHDovaDeJ9T9eUu8VvJ
        Ieh2vQsBCQ5gMmlbzH3E+IvvtMvP8w3IdwVH9Z02xb7ydC3297wAfMIypATYemqO6JR4fXmxxUQh9
        HIunCliYb8fk1FqwbUZaETnJdZpz+D9x/ry2mXP68pSTkvAVwha/UumFADOYuCOPUQdqsiXI6Jsva
        5Q/xF4tA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pv0Gd-0004OW-2j; Fri, 05 May 2023 20:34:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Garver <e@erig.me>, danw@redhat.com, aauren@gmail.com
Subject: [iptables PATCH 1/4] nft: Pass nft_handle to add_{target,action}()
Date:   Fri,  5 May 2023 20:34:43 +0200
Message-Id: <20230505183446.28822-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230505183446.28822-1-phil@nwl.cc>
References: <20230505183446.28822-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prepare for varying rule content based on a global flag.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    | 2 +-
 iptables/nft-bridge.c | 9 +++++----
 iptables/nft-ipv4.c   | 2 +-
 iptables/nft-ipv6.c   | 2 +-
 iptables/nft.c        | 9 +++++----
 iptables/nft.h        | 4 ++--
 6 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 265de5f88cea0..192819276b692 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -151,7 +151,7 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			ret = add_verdict(r, NFT_RETURN);
 		else
-			ret = add_target(r, cs->target->t);
+			ret = add_target(h, r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* No goto in arptables */
 		ret = add_jumpto(r, cs->jumpto, NFT_JUMP);
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index f3dfa488c6202..f5b376c0dfe6b 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -117,7 +117,8 @@ static int add_meta_broute(struct nftnl_rule *r)
 	return 0;
 }
 
-static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
+static int _add_action(struct nft_handle *h, struct nftnl_rule *r,
+		       struct iptables_command_state *cs)
 {
 	const char *table = nftnl_rule_get_str(r, NFTNL_RULE_TABLE);
 
@@ -133,7 +134,7 @@ static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
 		}
 	}
 
-	return add_action(r, cs, false);
+	return add_action(h, r, cs, false);
 }
 
 static int
@@ -220,7 +221,7 @@ static int nft_bridge_add(struct nft_handle *h,
 			if (nft_bridge_add_match(h, fw, r, iter->u.match->m))
 				break;
 		} else {
-			if (add_target(r, iter->u.watcher->t))
+			if (add_target(h, r, iter->u.watcher->t))
 				break;
 		}
 	}
@@ -228,7 +229,7 @@ static int nft_bridge_add(struct nft_handle *h,
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return _add_action(r, cs);
+	return _add_action(h, r, cs);
 }
 
 static bool nft_rule_to_ebtables_command_state(struct nft_handle *h,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 6df4e46bc3773..92fe263769695 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -92,7 +92,7 @@ static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r,
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return add_action(r, cs, !!(cs->fw.ip.flags & IPT_F_GOTO));
+	return add_action(h, r, cs, !!(cs->fw.ip.flags & IPT_F_GOTO));
 }
 
 static bool nft_ipv4_is_same(const struct iptables_command_state *a,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 693a1c87b997d..cfada13ce5ee8 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -79,7 +79,7 @@ static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r,
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return add_action(r, cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO));
+	return add_action(h, r, cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO));
 }
 
 static bool nft_ipv6_is_same(const struct iptables_command_state *a,
diff --git a/iptables/nft.c b/iptables/nft.c
index 1cb104e75ccc5..55f98c164846e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1526,7 +1526,8 @@ static int add_meta_nftrace(struct nftnl_rule *r)
 	return 0;
 }
 
-int add_target(struct nftnl_rule *r, struct xt_entry_target *t)
+int add_target(struct nft_handle *h, struct nftnl_rule *r,
+	       struct xt_entry_target *t)
 {
 	struct nftnl_expr *expr;
 	int ret;
@@ -1575,8 +1576,8 @@ int add_verdict(struct nftnl_rule *r, int verdict)
 	return 0;
 }
 
-int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
-	       bool goto_set)
+int add_action(struct nft_handle *h, struct nftnl_rule *r,
+	       struct iptables_command_state *cs, bool goto_set)
 {
 	int ret = 0;
 
@@ -1592,7 +1593,7 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
 		else if (strcmp(cs->jumpto, "NFLOG") == 0)
 			ret = add_log(r, cs);
 		else
-			ret = add_target(r, cs->target->t);
+			ret = add_target(h, r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* Not standard, then it's a go / jump to chain */
 		if (goto_set)
diff --git a/iptables/nft.h b/iptables/nft.h
index 1d18982dc8cf7..c8d5bfdc50871 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -189,9 +189,9 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain, const char *
 int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes);
 int add_verdict(struct nftnl_rule *r, int verdict);
 int add_match(struct nft_handle *h, struct nftnl_rule *r, struct xt_entry_match *m);
-int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
+int add_target(struct nft_handle *h, struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
-int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
+int add_action(struct nft_handle *h, struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
 int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
 char *get_comment(const void *data, uint32_t data_len);
 
-- 
2.40.0

