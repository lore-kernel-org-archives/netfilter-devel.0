Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4463F413A
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 18:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788807362; cv=none; b=Z4ylV2z/eHnNBQrPD0VqqYoeoMsyldj4ZQe/fe8mNgSpcjc8HN96jT/NjpjP/Lu9utPabPzSznZj8DFq1jIcRFv0GpMuzkhRV90LCfLiqVeCyeIUgaTDRWuDDZ2jn4Ss4EhEb+KCcQv5aQCkVX8/aO4hdXfhtz14D+ykpeCq0v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788807362; c=relaxed/simple;
	bh=dIRau64DVLDi7aNyPdP+8nkJiYGyoWr8tsAyMyWz1bk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRcURkidfRw4VBrn8o4SQoMs+79pdQquusSqI7k1I+DpRgAVAftDt8qj2DJiWQxHNfoMH+79svV5IGP/+HUIrgpvTcOHahM5BT00KQAykIVKBRbGUWgkYL+NviwmpH2LZipC+enTeElfi0YzGhuvLlLDP+QRZYt6Jkr5TGyB/kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dtaU66eh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dtaU66eh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788807359;
	bh=A4wmM4E1dAHcOTkk5AmSzZFhe7CVJxpjJQLBR4OG610=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dtaU66eh8/m9iwd4k7QkxJMqpwj4zTTnDpzGmP34FIhiCbKxiGEsyviQ8c8D9mbmJ
	 03Z0riezJlS2GZ1QNVhSje/MJoZ645h5VpcoiD1NkOGw9e8YUq0x1F/BhI0Ur10qJG
	 FNK0kAa6/yTO9E1Tori9rw70IsZ65RUwkM3NRGfWzVBsGIz2ihxfGfXeFNsfnf/Xzu
	 4TfO2DETZh4jFZe+liX3zJo8ODUpmdW6TuRRPaiO4zA37rXySLjNncxw/VF3jE4n0n
	 LiFTYdyHdPxfdqxhNWCM/XJQKbxBIQPcWxPZMW5vdCF3p0403f9SejaVmz1uEeg1H/
	 ME8UmhNN179TA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1BFC160795
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 20:55:59 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 3/8] netfilter: nf_tables: use GFP_KERNEL_ACCOUNT
Date: Mon,  7 Sep 2026 20:55:47 +0200
Message-ID: <20260907185552.1422008-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907185552.1422008-1-pablo@netfilter.org>
References: <20260907185552.1422008-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Just a few leftover in nft_ct and the pipapo set backend,
including alloc_percpu() calls.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: use alloc_percpu_gfp() in pipapo.

 net/netfilter/nft_ct.c         | 5 +++--
 net/netfilter/nft_set_pipapo.c | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 9dbf127df9c8..3c4c2faa7398 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -848,7 +848,8 @@ nft_ct_timeout_parse_policy(void *timeouts,
 	struct nlattr **tb;
 	int ret = 0;
 
-	tb = kzalloc_objs(*tb, l4proto->ctnl_timeout.nlattr_max + 1);
+	tb = kzalloc_objs(*tb, l4proto->ctnl_timeout.nlattr_max + 1,
+			  GFP_KERNEL_ACCOUNT);
 
 	if (!tb)
 		return -ENOMEM;
@@ -934,7 +935,7 @@ static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
 	}
 
 	timeout = kzalloc(sizeof(struct nf_ct_timeout) +
-			  l4proto->ctnl_timeout.obj_size, GFP_KERNEL);
+			  l4proto->ctnl_timeout.obj_size, GFP_KERNEL_ACCOUNT);
 	if (timeout == NULL) {
 		ret = -ENOMEM;
 		goto err_proto_put;
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 978bb0c01106..a40f9d952184 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1441,7 +1441,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	new->field_count = old->field_count;
 	new->bsize_max = old->bsize_max;
 
-	new->scratch = alloc_percpu(*new->scratch);
+	new->scratch = alloc_percpu_gfp(*new->scratch, GFP_KERNEL_ACCOUNT);
 	if (!new->scratch)
 		goto out_scratch;
 
@@ -2298,14 +2298,14 @@ static int nft_pipapo_init(const struct nft_set *set,
 	if (field_count > NFT_PIPAPO_MAX_FIELDS)
 		return -EINVAL;
 
-	m = kmalloc_flex(*m, f, field_count);
+	m = kmalloc_flex(*m, f, field_count, GFP_KERNEL_ACCOUNT);
 	if (!m)
 		return -ENOMEM;
 
 	m->field_count = field_count;
 	m->bsize_max = 0;
 
-	m->scratch = alloc_percpu(struct nft_pipapo_scratch *);
+	m->scratch = alloc_percpu_gfp(struct nft_pipapo_scratch *, GFP_KERNEL_ACCOUNT);
 	if (!m->scratch) {
 		err = -ENOMEM;
 		goto out_scratch;
-- 
2.47.3

