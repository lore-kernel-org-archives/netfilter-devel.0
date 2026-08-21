Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DD14C77A7
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 14:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323121; cv=none; b=e8RXLxfHbosk5TfDj7ei/6QxIRHKkp6oYxDhtIVfhHZSMVpMZfTMOjkJJEOJ4krBFxDREJHg1N2b3WQSF+FoYAqqKqCbS7pmDAhjctn7GR80xRNyVtmBSw/n6niuLN9+MFTcpMunQHqlNmhXbNWV7W4LNXfvCfOaJwStRTJbEyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323121; c=relaxed/simple;
	bh=vkIDaX/VnBre4OxtEWbc9T9gN4uHzF9vewFYprwkfI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er/ckYgZat5JxFsdNDTcUTFAjbpJ/rG6RHdpy6HZ+7pdDYPVMKTX4xfWCaXl2rSg2VErHniZy3L1U3o1qJkFz6mkq69Sofv+mojNeS+0um+mWjemBZU+omXb8Tq+X+NnnMhPsVF/SsWFkTchl33a92tzrJI+rJbIkzGwTiJYVbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=md1ag0bE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="md1ag0bE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787323115;
	bh=uF0MRqnBDvlHPfd5GgCFi4AmQ5Uhq5yhWFSVjCIXfuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=md1ag0bEaPPm58TOQey9I8sMHb3mQ4F0W2Sl6OOkbG4CKILLLETaFSshggzXGhuPj
	 azJq24IDOs1yDRh1sxfG65FCIGf+SIfVInKm0k04vXdeFpuTnf8s9uZLMxJk0F7j2e
	 vqhgSWNNkx8m2ADDbY0dfmVddmEi1C6eQhHP6ziUczAVwvegPY44+F4mtdj/4pHB+7
	 H8SF8FwBZNRdiwcmu0AOFB2x9e2cIMJG8+6p/WZIe+QHj94/WvPQ+ocYRRqZqvH7JN
	 3dCE1XnQ64zNY/ZB8xi0yoWbsYwqYG1YJA66F9R0HGv4AirbYbyYuXOV0jMNyMI1dE
	 uwB3xUKjtM9SA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1CCE96008B;
	Fri, 21 Aug 2026 16:38:35 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 03/10] netfilter: nf_tables: use GFP_KERNEL_ACCOUNT
Date: Fri, 21 Aug 2026 16:38:20 +0200
Message-ID: <20260821143827.183963-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821143827.183963-1-pablo@netfilter.org>
References: <20260821143827.183963-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Just a few leftover in nft_ct and the pipapo set backend.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c         | 7 ++++---
 net/netfilter/nft_set_pipapo.c | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 9dbf127df9c8..89760874336c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -365,7 +365,7 @@ static bool nft_ct_tmpl_alloc_pcpu(void)
 		return true;
 
 	for_each_possible_cpu(cpu) {
-		tmp = nf_ct_tmpl_alloc(&init_net, &zone, GFP_KERNEL);
+		tmp = nf_ct_tmpl_alloc(&init_net, &zone, GFP_KERNEL_ACCOUNT);
 		if (!tmp) {
 			nft_ct_tmpl_put_pcpu();
 			return false;
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
index 978bb0c01106..3617bb66094d 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2298,7 +2298,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 	if (field_count > NFT_PIPAPO_MAX_FIELDS)
 		return -EINVAL;
 
-	m = kmalloc_flex(*m, f, field_count);
+	m = kmalloc_flex(*m, f, field_count, GFP_KERNEL_ACCOUNT);
 	if (!m)
 		return -ENOMEM;
 
-- 
2.47.3

