Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5281191F9E
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 11:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474509; cv=none; b=IPjiaAlULo6fBKPy7ZqF1FCKYllfzb/lJj+WLwWFMlgMS45ybpRZC4R9SbUMzhSBhSM+S6RECIre13aNWrsJw98JmuNEVH+Tcah12Ee1qyQX3P1Q5EquJlCnTTao8MvuZSk/QRjP13Ww+EEwaa4jEhgUce2X1UvLa4FDEF1aqqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474509; c=relaxed/simple;
	bh=BLqLjN5U1OGu+C+3y9jEWTR1FQtE+1CspoG9PbhHp8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfkZfyyYuceCrTgf9CAc4I9P0TLmtaElmTAsxNjpZxCbzZQjDEP6tJFiRoLtuN4V+Zs2eSa1PwMxJzkWxnc/JHwgWzKuPydgkILFEg0s6hu5uDV40uchjoAm3te2gIo9oJqT5oWWxzchOjz7qIjBGC0/hjlX4U7k3qRx3DJNbAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZLX7xzWN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZLX7xzWN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tuRlSKD18RaACt+5swaRpWpnPVVpa7mil9R4BP9cc44=; b=ZLX7xzWNb1ZSsBn8BRwQztrCEu
	EdxnQCvMXyM0rDp5kjpYsNmGn1gX1XoR2m+F32wSHb2pDwo3/eY/xPjg7mXLjKdc95tvL4lDufYn9
	giIYrj5jv2NrzM3pP4e/Zlais9GvBypGuuE9XNzLGhB7YMCWVDdH0IYQzKiSL5xNlrxWYGjLvNktF
	5iQLtFq/nUPXih9iAk9fkXNXdWF4deIzvOndn4Zllzhk73hv25Jnl7GRidNp2er04O/S5KkCm2Sjo
	I2KIACfW2bYJNoQnJff1R7iuW1UbeXY7hUSOIESvYK7YgNajud7SrT8/izoFcNHHBgVV/sZ7g4qdl
	0HlB3iWw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syVB2-000000008HN-2wB6;
	Wed, 09 Oct 2024 13:48:24 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 1/8] nft: Make add_log() static
Date: Wed,  9 Oct 2024 13:48:12 +0200
Message-ID: <20241009114819.15379-2-phil@nwl.cc>
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

It is not used outside of nft.c, though in the wrong position so keep
the declaration but right above its caller.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 4 +++-
 iptables/nft.h | 1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 88be5ede5171d..2ed21bb14c253 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1595,6 +1595,8 @@ int add_verdict(struct nftnl_rule *r, int verdict)
 	return 0;
 }
 
+static int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
+
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
 	       bool goto_set)
 {
@@ -1623,7 +1625,7 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
 	return ret;
 }
 
-int add_log(struct nftnl_rule *r, struct iptables_command_state *cs)
+static int add_log(struct nftnl_rule *r, struct iptables_command_state *cs)
 {
 	struct nftnl_expr *expr;
 	struct xt_nflog_info *info = (struct xt_nflog_info *)cs->target->t->data;
diff --git a/iptables/nft.h b/iptables/nft.h
index 8f17f3100a190..09b4341f92f8e 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -197,7 +197,6 @@ int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
-int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
 char *get_comment(const void *data, uint32_t data_len);
 
 enum nft_rule_print {
-- 
2.43.0

