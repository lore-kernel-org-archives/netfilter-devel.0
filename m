Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B32288C0E
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 23:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763596288; cv=none; b=e416tBY22rYhtw4F1a9Dw74EPGYvmtv/A9AUzdytYX6yqH0cC2m483japoU6EAwBwQjto3JS/yUZL33wfxlylt6/pQgw61fxD9pHGDbjDm3P+QouHLxfifmdEo46oxgzAZTVal5CmVFk8YjfZdkWABOfXWVv1bVM08XS5galvlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763596288; c=relaxed/simple;
	bh=sCZENRXlDmCtBuDhhTlIrmQudHkPc7e/SM8TK5ZT2J8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=V5Otx10nuyVTVajsa0j4aEOXcKOK0ayUMdidrJu822xny3BJUHC1qK2661+vyHb8dD2KdDbqBNP/eKAYRhvqUCNLZtoK4H+dcPlZCjegwQTZepB1g1Rs/IQgw71WJMv+Pszffs9OAYS86yEHnGLsa75PSa6IThhSbxi2B5r5Piw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mFOZ1W7+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mFOZ1W7+"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 85F5E60253
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2025 00:51:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763596277;
	bh=4dxF32hNU47968ivGd4TB1vELq9iNpbCJpTsZTuh/7c=;
	h=From:To:Subject:Date:From;
	b=mFOZ1W7+lKQXY8uNrIb3i6CshyI97gfsbtoYfOiLMxpox4excitRhoxZAc/YFsPE/
	 kbqNDdi2PGHBSjplo7SF94pxI5tIY2V6GQIjvpGIHxpaAD+yDubwDVx7goK5s/Dm1J
	 KbQ1hyapEXFKhiIvvfUkTZk74NptoQ3n2m4DcRdyf8l95+Jb4XcWNAsVYq/hJicYsC
	 W6EGmfxrYMPQmES+9TjJyEbPnfON1DM10QJidys1+PhlcQ1JVFWRoS7WpnLoQOmru/
	 sm1eqAeG1hNLE79MYVN6edpc2gM58jdkbTcUcLjSKq0eoUfbbMhU6rrz6GvEstjDPH
	 yKbTcYb6PgR2Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] rule: skip CMD_OBJ_SETELEMS with no elements after set flush
Date: Thu, 20 Nov 2025 00:51:13 +0100
Message-Id: <20251119235113.211657-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set declaration + set flush results in a crash because CMD_OBJ_SETELEMS
does not expect no elements. This internal command only shows up if set
contains elements, however, evaluation flushes set content after the set
expansion. Skip this command CMD_OBJ_SETELEMS if set is empty.

Fixes: d3c8051cb767 ("rule: rework CMD_OBJ_SETELEMS logic")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 05b570cda279..bede68fa1549 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1504,6 +1504,9 @@ static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
 {
 	struct set *set = cmd->set;
 
+	if (!set->init)
+		return 0;
+
 	return __do_add_elements(ctx, cmd, set, set->init, flags);
 }
 
-- 
2.30.2

