Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCED486623
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 11:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435289; cv=none; b=Vd0WcMx6J7RhVUSF/z1CBh4wUYlT9fA+f+T9vH0CXUNRwHWnej/GTVPuitAuIcA3JbLYK3/0Nv2C6s8tn/zAU0olyZon0JX71MZmCYRo55HxXQXt04HEIcWkhdlM6YTtvp1d3NYxoVAKV3waSs+8VCZLiVKNrbDDqQ0pS2O99io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435289; c=relaxed/simple;
	bh=ismyEqWP6CfrQ5vVpVnh6c0FOmnArAZ2f9mWtE8L3ok=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcxcgqetrJeVWXGfdHY4eGaQjh5z1c5LFw4BZt+13g+D4X9/YTNoQLBYtGIbHQ+NUxU1mEVM6TG0qRVSyfJKRmOoraXXCoRKBEzjFF+YFoFRYZmP9jBDcU/ggh1rIz0rXpNkBKC0K/sKxlthLKs9CgJei7DnOioeVmeKN4pbIoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KkTUpR8E; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KkTUpR8E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788435262;
	bh=1+TOGSQ6D7fuRI94cXsTMmDY/L4a2nzVoPR7bWiKf9o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KkTUpR8ELfuCXSEHDdysWzSbG8uPU4Taih49gY/6/OxaRJA6WXiJq6NCALLUYc72E
	 pr+d8nwgrMLaCykhXtGQ78iz0S4ydJJv3T6VSuoN1fIBf11CxSP9mIIdvRgcs07C2G
	 sR0wR2eLThDHLrpvJ0vdCscBMinkh1d/lCSFLfbie1QkZ9rwyNPldHhGr+Etfy0osh
	 egO+kkRBgkyNI0vCW9/yGzHUfEW5ohUP0IIK1m0mwyjL9OmRnpCCyIgsiGiMsdT0gt
	 5RNbvNG3tMK3OqsMR55lEgsXvtflFSP7WTvRatpflF4R8c6qYwhznV+vcZ8mK2Di/P
	 IoI7Lf/0YGRsw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6748C607EE
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 13:34:22 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 6/8] netfilter: nat: use GFP_KERNEL_ACCOUNT
Date: Thu,  3 Sep 2026 13:34:11 +0200
Message-ID: <20260903113413.1122606-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903113413.1122606-1-pablo@netfilter.org>
References: <20260903113413.1122606-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Allocate the internal nat hook via GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes, address leak reported by sashiko in separated patch,
    this should not cause conflict with nf.git

 net/netfilter/nf_nat_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 8ac326e1eb5b..09cc5b8fd6af 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1204,14 +1204,15 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	if (!nat_proto_net->nat_hook_ops) {
 		WARN_ON(nat_proto_net->users != 0);
 
-		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops), GFP_KERNEL);
+		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops),
+					GFP_KERNEL_ACCOUNT);
 		if (!nat_ops) {
 			mutex_unlock(&nf_nat_proto_mutex);
 			return -ENOMEM;
 		}
 
 		for (i = 0; i < ops_count; i++) {
-			priv = kzalloc_obj(*priv);
+			priv = kzalloc_obj(*priv, GFP_KERNEL_ACCOUNT);
 			if (priv) {
 				nat_ops[i].priv = priv;
 				continue;
-- 
2.47.3

