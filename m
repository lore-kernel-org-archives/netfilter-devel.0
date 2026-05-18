Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F193914FF
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 19:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133711; cv=none; b=nqMkaVeKyKA309JUiE7f3AB+DXSqLXDqZ0tJyVEkwHa2ld+Izevmpfo/xavHqNyFGbL4D/qKaS+HfgIGwNev/ONqYWXlN5kIB2HydMYTcznvb5zuGsfAPC22l1WSzd4h4/p3zndxSDtHWS1KvdCAftt+A9tgbyd5ijj+qlzfcEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133711; c=relaxed/simple;
	bh=O8lAD11pJsD9MeG1lp6i2WEYl/W++nu+k3K4DKlcc1s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jPIyDg8+KztAR66wlZtO5Dejcfg2aXisIOiAccznwRZtj8ifZUhPXsEMuIxiAc9Z6enLg1kjz+85ePpF64azH0cdJWxMDPmfMr4hWVhZ5Foni6Loq2abDansedyubEUiUl6JCFWZGvVTl+Q1wApC+HDds8vfjFEqSnVQ7TyyjPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tOwzheCX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tOwzheCX"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BA26A6019D
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 21:48:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779133707;
	bh=FNn+HzDnFvyHLTodKVsADDA+zanO16ZOCiBvIoA0wko=;
	h=From:To:Subject:Date:From;
	b=tOwzheCX6w7K83XeyDiXAwonMk/Ip/fcde1n5pxJA3O+EGgzmpJ+btZfynaqGE+4g
	 RLUCTJZ579a/obVIy9wjJwNLjgM1vBeSScCG0v1LqCu/bUNn0Ay0U8VIDe2k1/D5Dr
	 dJo4+ahkAxTzuYyA1IGuaZz0O89VWDv5RJk/1qrUhv6b5nj8DMG2J+M6t+aex8da3s
	 qS6kzAB++kGk6zaOrUYJWDIbWA0/fYhtl3q/ncZ722IflxmqwjPtsGpfPmyrh7D+XG
	 bH4k8Dq+Lr5Ju3o7ySmWnOeK/c6SqQ4nLxVGJNBZMy0w43KPuqE8hSi+3BbblifU2r
	 s5ZWmngUupS6A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 4/3 nf,v4] netfilter: nf_conntrack_helper: call .destroy() when helper is unregistered
Date: Mon, 18 May 2026 21:47:52 +0200
Message-ID: <20260518194752.1063189-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the helper is removed, call .destroy to release the pptp binding
with gre conntrack entries, otherwise the gre keymap stays with stale
list entries.

Fixes: f09943fefe6b ("[NETFILTER]: nf_conntrack/nf_nat: add PPTP helper port")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_helper.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 9a10b3449957..b226291a5c7f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -241,9 +241,17 @@ EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
 static int unhelp(struct nf_conn *ct, void *me)
 {
 	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_helper *helper;
+
+	if (!help)
+		return 0;
 
-	if (help && rcu_dereference_raw(help->helper) == me) {
+	helper = rcu_dereference_raw(help->helper);
+	if (helper == me) {
 		nf_conntrack_event(IPCT_HELPER, ct);
+		if (helper->destroy)
+			helper->destroy(ct);
+
 		RCU_INIT_POINTER(help->helper, NULL);
 	}
 
-- 
2.47.3

