Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347688;
	b=G/ODkrm3mLbLNtsL7YXrqYo3f9vdNCT+foyEfLaNFdbp7sPZQWYoG8/inC9weMUxke8F
	 i9xhrZVKoHbrEa72bh6Z6lffXxDu5Wcc+C2SezA9WhTghgt5ILlAbjacjQOftEkt9bu+/
	 An5yX60wOtySUL5uqXKWeROhfe40SZIbEgGEgxcbUTyQksdCsKB85B8LK1y8nRS8qnAib
	 w6sCp9XkanqKlzOw+mmmQ9cW30uYlL6NvmsnMqH2BCj4YiCcaSgmiXrGqZRSP+9UH9y84
	 8G2RCPyaAn6L5nQ/kJrkhevrOU5xurWTnXwo+uWvDAcGKhoxgrIQjLbOBxxmFd/xeOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347688;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=bsEsQ8V5/tMFK62kC/e8aRxs+yXOmdAhNLe9dV73e+0=;
	b=4rkLCRjSxYTDWmaTCqqN+qaSx9V2GcPjRXAq1NJidoW+UEKc2AmPiXz+8oBP7KkatEoa
	 68KWL1M27OfK90wKB+akembiYUPWHQjmai3ePV9HdNmq2RjU17+1mvdxWykJdUzJGQGlf
	 64ASrq8E37Q5azKg7k7ARrVc8gM1whjzip8UwqhoJjJd0q7pqlsyo1U7XIvToNQS3aOQQ
	 W+TJuWMu6OhFuGZWaifCkGjCQfInWE64+VcMK0y+EYzFWdQuurBrC3NmtD9V/sTNZrx7X
	 pdPCde16UaKbdN/hgUZnCIiOXiKCzeYQu7no5rgHSrlXp7PiYUVikt3TZkYg/J3+XMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=CzVzuMyf;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0906606A334
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 21:54:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0906606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=CzVzuMyf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794347686;
	bh=bsEsQ8V5/tMFK62kC/e8aRxs+yXOmdAhNLe9dV73e+0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CzVzuMyfp+xhleDQ7ITGoBZJ/lR7kbRrCG3qJv7tgtQs2CwF/ya1VsUUMzJQxwBtj
	 h2nosCbos+Lmabp0vXmyWXxF+jyvH9cAZz4uexvSlPIByZRuN7PxGcrXafAH9et6FN
	 eh00CpFuBEQIXRANoS4n4Tx4/HPLXvS6kIfpHrqlgGwqV8jVWN/ffy8sL4fJ4VpxX7
	 6/vGKJfIMDvLwPqJ9XvlphhU2ygEbXCpRX62m257JCcIuERFk4IQTrXkVvyJ5K5kho
	 ysoI2xAjwgMqIDvc8rEw1qJKB/8CLhHb7n8/1Z+2+WCDK5rJI0non/d0p4N4g4rh5O
	 80kVuCodjwdQQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 400F360306
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 22:54:46 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 4/7] netfilter: ctnetlink: restrict expectation creation glue to userspace helpers
Date: Tue, 10 Nov 2026 22:54:36 +0100
Message-ID: <20261110215439.1958120-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110215439.1958120-1-pablo@netfilter.org>
References: <20261110215439.1958120-1-pablo@netfilter.org>
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
v6: no changes

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

