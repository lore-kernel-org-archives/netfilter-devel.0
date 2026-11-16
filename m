Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789464;
	b=eFVmRLynDjqS5SOqFjaZa0PRWNVqvuEAJncL2ye6eXK0mdHWP0PEenAxhMnuyuWA7sd9
	 651vkEsYH7GixtuXBc8lT90MOh1fz0ZiQXSEuiPK0hBkf5B77QW+RiVWu0kqZ/E093PhZ
	 vyOL7KRJiEc/0Gy66Tbw/ivVBPrxYjYG7mogYpnZeY6kOxoWym+HPrmwpcitg+YuN9Hx5
	 mX9OaC0QH72pOnAHqxCE1EwFnQr7GD/kaUSy8k9VSFL/6C/9wbjRO2WGBAW8/uhe31EJH
	 DqXomYwwotPdYGOLWkaAATC4VjdxA4gO079eFEuvK8OWku5BO9mXvETgOMzec54GdPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789464;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=Of3zstyeAM29jz0SKhqLyIi/X901ogqissAaR5Y+0eA=;
	b=4PrLTg8bzpqO7fS8+1Lp7iZAO28XAPKd37LkVsXITkUoaOgqJ1LQo49DkmOPE0Q5vdMd
	 Zcfu+CqopsPb7MhY1wPuitjEXe3fAsYX9A2fZ4d4rdmibVFyFX5nApOUn7qkCnAJCn6AF
	 QkPp7vzhvgC0nL0XUXoaaB6cRT07jL6Hx/9HJZZz57JhaqUK4In617v3HxgdC6TngPTWe
	 UKTY5DQpH/rLdPMkgOZHqw3zMHu7rTbHwK2ypS31AL2topH0rS/1CFJM/B2uJy30ULvj/
	 RLz31IV1VFEpKAiEGplePizvOU85qkmd9IP3EJKFUnqtfkXEDBzRhT7TZPmhvmNgRbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=k5waPX8l;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B41606A331
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:37:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2B41606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=k5waPX8l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789462;
	bh=Of3zstyeAM29jz0SKhqLyIi/X901ogqissAaR5Y+0eA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=k5waPX8lqilwqsj2hsCTlSeZynpYL78G80Ib8LIYIOHmI2XxdlkhdUyPVYI9yrb6r
	 1uQkK3nArJjFPhqYVeQRopmG/QVnxhzrY5QdIV1pE5Ip1VFLDStM+p7Iyka76RPYFr
	 cBLBSl+PeGcKCMZAT2Zrgt6OfdQj1CcZ9O+ahWM0betatIi5oIBs+3S0tzoi06868y
	 X5qkO+lENxaPIBZUl9sk+9YUwo22p3y0G6PXE6R4mETb6tzycyHXZUm0fUir+2T6oY
	 In0gFX7o4j1x54HBAXo7sSMwGR9Hrdfzstt5aUBRw9EEprOB2HYU5ZYfxQiwfdJM4i
	 09UB52YZg/mCw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0D2D660077
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 01:37:42 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v8 4/7] netfilter: ctnetlink: restrict expectation creation glue to userspace helpers
Date: Mon, 16 Nov 2026 01:37:30 +0100
Message-ID: <20261116003733.2820132-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116003733.2820132-1-pablo@netfilter.org>
References: <20261116003733.2820132-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The integration between ctnetlink and nfnetlink_queue that allows to
create expectations is targeted at the userspace conntrack helpers.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v8: no changes

 net/netfilter/nf_conntrack_netlink.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1f8d94a05240..fa9024bc6dc3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2644,7 +2644,8 @@ static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
 		       const struct nf_conntrack_helper *assign_helper,
 		       struct nf_conntrack_tuple *tuple,
-		       struct nf_conntrack_tuple *mask);
+		       struct nf_conntrack_tuple *mask,
+		       bool userspace);
 
 #ifdef CONFIG_NETFILTER_NETLINK_GLUE_CT
 static size_t
@@ -2899,7 +2900,7 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	}
 
 	exp = ctnetlink_alloc_expect((const struct nlattr * const *)cda, ct,
-				     assign_helper, &tuple, &mask);
+				     assign_helper, &tuple, &mask, true);
 	if (IS_ERR(exp))
 		return PTR_ERR(exp);
 
@@ -3534,14 +3535,14 @@ static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 		       const struct nf_conntrack_helper *assign_helper,
 		       struct nf_conntrack_tuple *tuple,
-		       struct nf_conntrack_tuple *mask)
+		       struct nf_conntrack_tuple *mask, bool userspace)
 {
 	struct net *net = read_pnet(&ct->ct_net);
 	struct nf_conntrack_helper *helper;
 	struct nf_conntrack_ecache *ecache;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn_help *help;
-	u32 class = 0;
+	u32 class = 0, flags;
 	int err;
 
 	help = nfct_help(ct);
@@ -3552,6 +3553,12 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (!helper)
 		return ERR_PTR(-EOPNOTSUPP);
 
+	if (userspace) {
+		flags = READ_ONCE(helper->flags);
+		if (!(flags & NF_CT_HELPER_F_USERSPACE))
+			return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	if (cda[CTA_EXPECT_CLASS]) {
 		class = ntohl(nla_get_be32(cda[CTA_EXPECT_CLASS]));
 		if (class > helper->expect_class_max)
@@ -3639,7 +3646,7 @@ ctnetlink_create_expect(struct net *net,
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	rcu_read_lock();
-	exp = ctnetlink_alloc_expect(cda, ct, NULL, &tuple, &mask);
+	exp = ctnetlink_alloc_expect(cda, ct, NULL, &tuple, &mask, false);
 	if (IS_ERR(exp)) {
 		err = PTR_ERR(exp);
 		goto err_rcu;
-- 
2.47.3

