Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026CE30DD22
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 12:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773319743; cv=none; b=UItqTdBS1laDcrnknTmghgESH2YI/YaJ3vnqo9FnJSyHWl46y7nbi3bPJwvEEKymqoYMDrdp71INwEzQ5tV7qhmvm7IehSDvaF8pAOP6qwdRP7u0DqGtIRDD0i2e2lWNiy9x33Uf5IPWsvTOWbVrFZCWg/KyXha/fK+rRm6VNUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773319743; c=relaxed/simple;
	bh=y5ncKk6F4dcoykUu/slouAw19yRyMn6VcMSMP2xy6cE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Tt9R0hKN55ydlZAJ2OrQ0UzWFpyW6ZgXkOAnsWmDrgdAaD2Lz683R3XuUwmZs8vRD6IJNSOyPfD9qQ0TPKhtd+DwoCIg/hPw5rli/xZsgBiSTTx/sGlKsiSsl/zi883mHpJrZFK+8HW87MkTjZWuzv4na7HLT+KnelUWo2Z2jd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dPyJ//E6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dPyJ//E6"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9034660566
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 13:48:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773319731;
	bh=y95zGEE2l9V8iUKKBNYViTlnqyfI0u+RYJX+6Jn1rgA=;
	h=From:To:Subject:Date:From;
	b=dPyJ//E6la7CepMrVHZy+mIDE5++bpkWx/SWqjXVNlvLoMc0E6wvxw2M2ysTR3K09
	 dtr3+JIH2FWsTvyATJy10xEA2tljiZnGhfH79u9UPzLbhyXw3oRzIlKbsxrh1oIX7G
	 RTEx0OaxWfgC7k2HMnhFho+LbXSf7ESxVQeihf+bFFnMIpobH0SsbEFwsMu5KxoemG
	 iYDzN1lZF6arxQEXZcZfWtrzndSllEIr9WLGRTlu2ynN+bQynSXRLOhnINni1a5oWT
	 JWVFc+kqrgYXKdgnwAMOp2K08uktWQpibeRw/ABkhzPa5mWleIKjks4gQVP3Ll+wiY
	 LHQX22AF5HbZA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nft_ct: drop pending enqueued packets on removal
Date: Thu, 12 Mar 2026 13:48:47 +0100
Message-ID: <20260312124848.3532943-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Packets sitting in nfqueue might hold a reference to:

- templates that specify the conntrack zone, because a percpu area is
  used and module removal is possible.
- conntrack timeout policies and helper, where object removal leave
  a stale reference.

Since these objects can just go away, drop enqueued packets to avoid
stale reference to them.

If there is a need for finer grain removal, this logic can be revisited
to make selective packet drop upon dependencies.

Fixes: 7e0b2b57f01d ("netfilter: nft_ct: add ct timeout support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I don't remember what email reported this.

Compile-tested only.

 net/netfilter/nft_ct.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 6f2ae7cad731..db1bf69f8775 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -23,6 +23,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
+#include "nf_internals.h"
 
 struct nft_ct_helper_obj  {
 	struct nf_conntrack_helper *helper4;
@@ -543,6 +544,7 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
+		nf_queue_nf_hook_drop(ctx->net);
 		mutex_lock(&nft_ct_pcpu_mutex);
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();
@@ -1016,6 +1018,7 @@ static void nft_ct_timeout_obj_destroy(const struct nft_ctx *ctx,
 	struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
 	struct nf_ct_timeout *timeout = priv->timeout;
 
+	nf_queue_nf_hook_drop(ctx->net);
 	nf_ct_untimeout(ctx->net, timeout);
 	nf_ct_netns_put(ctx->net, ctx->family);
 	kfree(priv->timeout);
@@ -1148,6 +1151,7 @@ static void nft_ct_helper_obj_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_ct_helper_obj *priv = nft_obj_data(obj);
 
+	nf_queue_nf_hook_drop(ctx->net);
 	if (priv->helper4)
 		nf_conntrack_helper_put(priv->helper4);
 	if (priv->helper6)
-- 
2.47.3

