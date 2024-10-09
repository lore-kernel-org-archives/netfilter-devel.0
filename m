Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8A41925A0
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 11:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474510; cv=none; b=YmgvNeIlzcIDQtauqvXIWd1Mq9XAq33tEzNcNUog9ZVisBkxdNXDS/HU/swqON5D7XF8o8oiGrtjZxRoORyao79jqAePULRBqs4d2cU+5PCQOOZ0XHp5Jqp8QJTjbr+TYoPa/fi1bYDBiAqOr+I2wsMM+2r3YTK38z4dsFS/rno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474510; c=relaxed/simple;
	bh=3d6MS4wPVQP/SQ9Fsy/IhGqxZqbsk/BtvsQk7Bb7Orw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWmJOkwJ6qHa+O+dVz7eWB9/4YWMxwQGn9MfqTjNOjwvAbp+KqfOKb9q8Lt5ikq3kg5R0z/eqMN8GW+1MqP8vBEjrqv2ESsLyE1tkbogwLxEk7dn5RqaBo9TLiOV1r64QVe0pjLjraCK8ylfivGB2LjfkDElRUfju1EzKOt/IA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KvLtu/a3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KvLtu/a3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3D4wrLy2cAH1Y9N5GeLq4Cjd7AcNsuCrRl45831acGA=; b=KvLtu/a3Pp/kEeoUKfMaSrXW2A
	lmeExe5olIgrMck7tRlrAXroaEZQlm43S1wvAc8+t1NAmAU8mWMaUO85f16/lAhR6WcbeFhu7/7bp
	OHzJqhXdTXm+y1bQ+N9hfJxEzeEMbefyN74uQN4LtaJyZfCpML7pUidn+/8PvXSLK/HlbbZH8PyUY
	NZAiNTcARy8dnRnSXqLkcnoMcsqDdekDL1n5Qmhk+t3/2T70VzEFdZ0sQO8y29fAOADU+wj0NaiJO
	cfQdofUsCrtdsmklQvULnJuyAc8Gvel9O+LrUhxb/cKRuAc43r+Fv/EF0W+8XnVKuwD9qk4RE+Rjj
	GueJwRHg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syVB5-000000008Hw-2YUd;
	Wed, 09 Oct 2024 13:48:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 6/8] nft: Pass nft_handle into add_{action,match}()
Date: Wed,  9 Oct 2024 13:48:17 +0200
Message-ID: <20241009114819.15379-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009114819.15379-1-phil@nwl.cc>
References: <20241009114819.15379-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Creation of compat extensions in rule userdata will depend on a flag in
nft_handle.

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
index 264864c3fb2b2..8837c236bf2a0 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -167,7 +167,7 @@ static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			ret = add_verdict(r, NFT_RETURN);
 		else
-			ret = add_target(r, cs->target->t);
+			ret = add_target(h, r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* No goto in arptables */
 		ret = add_jumpto(r, cs->jumpto, NFT_JUMP);
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 1623acbac0ba6..6a236846702a3 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -88,7 +88,8 @@ static int add_meta_broute(struct nftnl_rule *r)
 	return 0;
 }
 
-static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
+static int _add_action(struct nft_handle *h, struct nftnl_rule *r,
+		       struct iptables_command_state *cs)
 {
 	const char *table = nftnl_rule_get_str(r, NFTNL_RULE_TABLE);
 
@@ -104,7 +105,7 @@ static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
 		}
 	}
 
-	return add_action(r, cs, false);
+	return add_action(h, r, cs, false);
 }
 
 static int
@@ -192,7 +193,7 @@ static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 			if (nft_bridge_add_match(h, fw, ctx, r, iter->u.match->m))
 				break;
 		} else {
-			if (add_target(r, iter->u.watcher->t))
+			if (add_target(h, r, iter->u.watcher->t))
 				break;
 		}
 	}
@@ -200,7 +201,7 @@ static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return _add_action(r, cs);
+	return _add_action(h, r, cs);
 }
 
 static void nft_bridge_init_cs(struct iptables_command_state *cs)
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 740928757b7e2..91369ec47ba2f 100644
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
index b184f8af3e6ed..e68d41e56afef 100644
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
index 2cc654e2dd91d..9888debca16b4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1539,7 +1539,8 @@ static int add_meta_nftrace(struct nftnl_rule *r)
 	return 0;
 }
 
-int add_target(struct nftnl_rule *r, struct xt_entry_target *t)
+int add_target(struct nft_handle *h, struct nftnl_rule *r,
+	       struct xt_entry_target *t)
 {
 	struct nftnl_expr *expr;
 
@@ -1589,8 +1590,8 @@ int add_verdict(struct nftnl_rule *r, int verdict)
 
 static int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
 
-int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
-	       bool goto_set)
+int add_action(struct nft_handle *h, struct nftnl_rule *r,
+	       struct iptables_command_state *cs, bool goto_set)
 {
 	int ret = 0;
 
@@ -1606,7 +1607,7 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
 		else if (strcmp(cs->jumpto, "NFLOG") == 0)
 			ret = add_log(r, cs);
 		else
-			ret = add_target(r, cs->target->t);
+			ret = add_target(h, r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* Not standard, then it's a go / jump to chain */
 		if (goto_set)
diff --git a/iptables/nft.h b/iptables/nft.h
index f1a58b9e52865..e2004ba6e8292 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -196,9 +196,11 @@ void __add_match(struct nftnl_expr *e, const struct xt_entry_match *m);
 int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	      struct nftnl_rule *r, struct xt_entry_match *m);
 void __add_target(struct nftnl_expr *e, const struct xt_entry_target *t);
-int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
+int add_target(struct nft_handle *h, struct nftnl_rule *r,
+	       struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
-int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
+int add_action(struct nft_handle *h, struct nftnl_rule *r,
+	       struct iptables_command_state *cs, bool goto_set);
 char *get_comment(const void *data, uint32_t data_len);
 
 enum nft_rule_print {
-- 
2.43.0

