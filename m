Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521483;
	b=K9oURy/muPwQBkHHv3sJcRTfvewtuJrTJpiiZTBnliK02ljnZaosQJq7VX3p8xpUfk3A
	 pxxyIRzXT/jQ6SlBsCO87Jz6/Mqs0szfe02h2cE8n54lr+U72sQzLA+J8CW6cgGq3Ugqf
	 NqjKd5p1KC+EC2FKmT5vfBP6h+wJRrZNQRVY7H7LEnCsL1xHn5H4amZCdNOjtc8hdj1dM
	 qb8dPAhiabxLP0Naz0ZHqTtwvL7TepX2kLErZSAegpN52QJHeTgpltjMqQ869EL9n21vZ
	 pluul7UKs18MBiEvJ0UJg8DjNc0tn9Dnf00RwR5dq884WDOifZFt96MJ2KsaJmPVH0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521483;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=ZH0UvnB9LVoT+8gp4SOngt4+90mV4RDEL7Cp6u2on+w=;
	b=c8X1iYKgL3yDJGHal5jywr/IlOkafKJiLPaGUGPITENDhm5sOQgJoner8+ZZROPUo8lE
	 v5HnEXjmGFzPQGrAJBp8Z3jl6P5Zxv15fdOOY+vW4xKXlJzkZ5BLVMq8Ur7CZIPELnJIt
	 GlR0XR2kTBu3/Nx+EvvGc+gzAECGwfx5B+Y48sEPILDP1jR1TLswMCCT973EikRMSpqIr
	 W9MpAIPH/ghhBJratqdqCNCI2DJyq+akeMWNkb2uEsbrc5FAHAPWD5kRRIV9U9eMCQoO6
	 SXrHZ81sj64oVFD/S53CggMpGGA7BST0wZb5a8mbYQS2kLJ8g5D5WvFsKUG2c/1+CNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="tWkM0/T6";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14E9606A321
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 22:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F14E9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=tWkM0/T6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794521475;
	bh=ZH0UvnB9LVoT+8gp4SOngt4+90mV4RDEL7Cp6u2on+w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=tWkM0/T6+/Dj/GpoBhF6wuOMAOAQViN37lrGu/S3e/qLzbkbAe4mEOkYlW/b+1txi
	 nyctE7IQyIB1OVeOI79rYxr3/nm5UpoqVPcx8PcYC49DxAteTH+mnOdlvhbnUIoJOQ
	 hAz1KCDfN7aw4PKnczIsss08UZIwNI1YVhTGaHpaRkX1qlxIphVi6Bf0s1/WQsD8MO
	 YQddW6+rnmXD+vaaql8oMcpsPMBzCc6ddRr1vCZg229KjoKLKY/MhhJAbtO+rBlPTG
	 BvmmsXCMTs2SLWrOeRJyYQNbGDIlR3jT2eoEGoqBu6jbARAlWaWOVyR5Zrdh0OFDPA
	 C0Zi3QAaXR/eg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6CA536007A
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 23:11:15 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 3/6] netfilter: ctnetlink: restrict expectation creation glue to userspace helpers
Date: Thu, 12 Nov 2026 23:11:03 +0100
Message-ID: <20261112221106.2278789-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112221106.2278789-1-pablo@netfilter.org>
References: <20261112221106.2278789-1-pablo@netfilter.org>
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
v7: no changes

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

