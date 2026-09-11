Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9A046982A;
	Fri, 11 Sep 2026 08:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116295; cv=none; b=K2kAVsfbSOJcegJNxydVhvhiZ8mG4jSYcktG3owH7pm3WXxkYb7BaT7wY1e0WHqVtJEt65/Sluw7R0kATEUZc4QWuTJPJIK7u4IRoJC35CVEg/zwRO4uCK4Y5qp+hgoqUIxi5FAalhfanqWoNHWlOnzt3lVbTJcFsGqoMvFdmnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116295; c=relaxed/simple;
	bh=JYMJRenYSW/rmZ3KxLqDHtGMIPeLzDg4yBfxUSOHp/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0IUJ07wrqr2/QVFcRsOJAIk9qkmyYZfDTuC4nSk1aeFoYgPnqF67SG5p0xlfiD+38hMfnYnWZPfehAoIie0CkID3t6X0hel0hU1OFSZc66ajzj3Jf9WS+qXn9pqHhLGsS1fzcR6f+kpdeylPXuI+30J6PmMZPKmt8Q1Jqxxojw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DDYNBoV7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DDYNBoV7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789116290;
	bh=33hr1Phbv+UpsWm3mdMMxy5it3l/FCRuHgmxfoCkbck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDYNBoV7mS4BFA+WdYgiv3IG6L6hdY/d8OwyfbQP9DB/zTm8oMTHuYpeijwDc8xpO
	 yWetDiyQ4k5Z/YvouIfesK1loZZSsnWbgaTtuUBK9yDD+ekjKgNHrc3QZYkJJSKXyf
	 Wbar5NfZr+8CBpnUPZtGcjpf1fgLFlzTi3udhFqeFm8xpendOrcQk1urVaWoP/ES+v
	 o12uC7+4fHwkAfZNi2ndghBgUNFT9bJQVWThEfDLEc84/qsFNeCI9RfMTIxibB0t3a
	 WJHFW2LC461hQ0Miax+ckoESqAHLD4wKTdSje7TSmuoEMHDPk+R0JV9/C8h3tib4oY
	 FrofJtVoGue0A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 99173603E1;
	Fri, 11 Sep 2026 10:44:49 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 4/8] netfilter: nf_tables: use GFP_KERNEL_ACCOUNT
Date: Fri, 11 Sep 2026 10:44:33 +0200
Message-ID: <20260911084437.1838161-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911084437.1838161-1-pablo@netfilter.org>
References: <20260911084437.1838161-1-pablo@netfilter.org>
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

