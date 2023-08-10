Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E31CC001DE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 18:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbjHJSzZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 14:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjHJSzY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 14:55:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067062703
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 11:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NGR50Ju20ZTwhqi7GmiwwUZRRQyeqNfQloTLbj5ikhs=; b=a4cVFkxFXnJN/gJDLhHL9tXevJ
        kJ/BBImduvGQDPtVwyJs9FMS1GomoS7ULYbK4Gnma9eMlBt9PO/xWAVAblF4F69cHSg/pZgw0G8Z9
        YuBKtOa2I7gYH+p8iBgniKNOS0gGqa232f3Pmq810M9nSnoEhgRGW3K3rmIRmUK8C7qoNo4+8Qrfv
        4e0/arFzqlGU3vGTAvofdXPdDY9D/Bl30v8LtrW8OnzAdPrAd2JyXX5vG8rboOtyPZEQvAMF+9s0x
        mqaoKfHtR3icn68WgumkDns+ZlSJbReauhxxRpN3m7ioqbQQ/jGJV3QJOpJ4/VHhgmWIfL2p9C2eW
        6/+aZ2kQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qUAoc-0002Yv-EP
        for netfilter-devel@vger.kernel.org; Thu, 10 Aug 2023 20:55:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 1/4] nft: Pass nft_handle to add_{target,action}()
Date:   Thu, 10 Aug 2023 20:54:49 +0200
Message-Id: <20230810185452.24387-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230810185452.24387-1-phil@nwl.cc>
References: <20230810185452.24387-1-phil@nwl.cc>
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
 iptables/nft.h        | 6 ++++--
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 9868966a03688..14b352cebf9d3 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -151,7 +151,7 @@ static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			ret = add_verdict(r, NFT_RETURN);
 		else
-			ret = add_target(r, cs->target->t);
+			ret = add_target(h, r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* No goto in arptables */
 		ret = add_jumpto(r, cs->jumpto, NFT_JUMP);
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 391a8ab723c1c..616ae5a3a2a3c 100644
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
@@ -221,7 +222,7 @@ static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 			if (nft_bridge_add_match(h, fw, ctx, r, iter->u.match->m))
 				break;
 		} else {
-			if (add_target(r, iter->u.watcher->t))
+			if (add_target(h, r, iter->u.watcher->t))
 				break;
 		}
 	}
@@ -229,7 +230,7 @@ static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return _add_action(r, cs);
+	return _add_action(h, r, cs);
 }
 
 static bool nft_rule_to_ebtables_command_state(struct nft_handle *h,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 2f10220edd509..663052fc57f0a 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -95,7 +95,7 @@ static int nft_ipv4_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return add_action(r, cs, !!(cs->fw.ip.flags & IPT_F_GOTO));
+	return add_action(h, r, cs, !!(cs->fw.ip.flags & IPT_F_GOTO));
 }
 
 static bool nft_ipv4_is_same(const struct iptables_command_state *a,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index d53f87c1d26e3..8bc633df0e93a 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -81,7 +81,7 @@ static int nft_ipv6_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return add_action(r, cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO));
+	return add_action(h, r, cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO));
 }
 
 static bool nft_ipv6_is_same(const struct iptables_command_state *a,
diff --git a/iptables/nft.c b/iptables/nft.c
index 97fd4f49fdb4c..1fc12b0c659c7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1538,7 +1538,8 @@ static int add_meta_nftrace(struct nftnl_rule *r)
 	return 0;
 }
 
-int add_target(struct nftnl_rule *r, struct xt_entry_target *t)
+int add_target(struct nft_handle *h, struct nftnl_rule *r,
+	       struct xt_entry_target *t)
 {
 	struct nftnl_expr *expr;
 	int ret;
@@ -1587,8 +1588,8 @@ int add_verdict(struct nftnl_rule *r, int verdict)
 	return 0;
 }
 
-int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
-	       bool goto_set)
+int add_action(struct nft_handle *h, struct nftnl_rule *r,
+	       struct iptables_command_state *cs, bool goto_set)
 {
 	int ret = 0;
 
@@ -1604,7 +1605,7 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
 		else if (strcmp(cs->jumpto, "NFLOG") == 0)
 			ret = add_log(r, cs);
 		else
-			ret = add_target(r, cs->target->t);
+			ret = add_target(h, r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* Not standard, then it's a go / jump to chain */
 		if (goto_set)
diff --git a/iptables/nft.h b/iptables/nft.h
index 5acbbf82e2c29..a89aff0af68d0 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -192,9 +192,11 @@ int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes);
 int add_verdict(struct nftnl_rule *r, int verdict);
 int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	      struct nftnl_rule *r, struct xt_entry_match *m);
-int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
+int add_target(struct nft_handle *h, struct nftnl_rule *r,
+	       struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
-int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
+int add_action(struct nft_handle *h, struct nftnl_rule *r,
+	       struct iptables_command_state *cs, bool goto_set);
 int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
 char *get_comment(const void *data, uint32_t data_len);
 
-- 
2.40.0

