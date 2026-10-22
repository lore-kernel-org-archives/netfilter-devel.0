Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684301;
	b=LFUhFPh0NoeCVIh43INpA2xtNmTK9dzJuHcVK8YszU/B8VRPtWJ0P3fwN3SWneI0e6PY
	 9MpilkaPkVZHtq6AAOBcxoY9NXDxDRP+B2rySMl1zKjYCBX3iMSwDTeoDFVdvYL//bylh
	 nIHoHA3cD9Ve1uj0tybIxqgnYxI5ftXfKA3/rSA3xRitoO+6JIc61Hi27ffTFSUKUL0aR
	 ggJhO5kyOJyxaGdxyC0aLZt1J1ImX50h3zV2BWdgurxjyw3vSsB/1H9FcaX6+ptS46gAJ
	 M6IZY3OS3jY31jmPlmKff1nS/x+pgWF5HfduEpfeXbktpQ0amNCZZITx8RpcjJiFMOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684301;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=2MqA69+DwFEexOgzjDpfPNJhslqyY29gu9/Mh3BDT9c=;
	b=P0Aooka97EPtlReJ8oeAjL2YltvR4uhocKJ5rpkghDloQXwlK0HCsUdNeJYpDj89Gy/V
	 kw/UCORK+NG/GTYclo9lTP6wgZBxRL8xnxuhbmt+wh9LeUM8mEjFqg5is9N9CxKE8eUcj
	 isy+BeVtUL1pkaMFzeJfdrxCEZVMrEYuKzuPYOqXimDRnbWEzooolX/YaSthPw8itABdD
	 wSVgnaxn0VjVcwSTHYqtEciy+Vva/neEm9wZnenAr7mp+qv47jpfqVl7aYDW8zVHOANOe
	 4/BGhHD37WPDPp3g0v/flbC+/BEFrl0aT2xPeNJfJqE9CLg/XFiGyGFTuus/+hozyqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=jZK99vwU;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B71606A319
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 15:51:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52B71606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=jZK99vwU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792684293;
	bh=2MqA69+DwFEexOgzjDpfPNJhslqyY29gu9/Mh3BDT9c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jZK99vwUGd8j7wDPYcIYWQv0Vohdq6b+8z9RRRwAltqzgnn0it8ZoqBGBrSGJWxnL
	 IzVTsdAi83SbTTlAx91fFv5I346MerXtqnfIxYPEJz43SJqMzyNIRLXpihp7/aRNJQ
	 xOp4YlSky+UFWZEdKPacuKPFO3nWpYcYR+aMQiKL/X5rKHln4vuOArpgEkRmRYNxQ3
	 qet0tlWpncRL62Zk9mI2+H2RselNj0h3Q8I4RqgRP64KDgX15gRjJvOOW0j74KNdP9
	 bgp8Xh1TIBEFgtQuvQfJwr201w84fBoLkzoxVBrVhYUdEusTa8X1G8nMLO1C1F0UN8
	 YW+iPDwByC0FA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9B7C460074
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:51:33 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 2/3] netfilter: ctnetlink: restrict expectation creation glue to userspace helpers
Date: Thu, 22 Oct 2026 17:51:28 +0200
Message-ID: <20261022155129.2003363-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022155129.2003363-1-pablo@netfilter.org>
References: <20261022155129.2003363-1-pablo@netfilter.org>
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
v3: new in this series.

 net/netfilter/nf_conntrack_netlink.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4b6abe36028e..3b61659e031e 100644
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

