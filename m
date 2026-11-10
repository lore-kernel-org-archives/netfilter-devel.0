Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271158;
	b=r+r6sK9f03HExvj5Bogr0QRj1l0L9P6cWMlk/8KGDuRHhl/86hijVu5wo6jVYIYCUAwL
	 nBb9plE6u8H4LnTqalX4+w8U0pc08FI5pwOUHodCWzjuKh/gPCx8knM+ZRRpltFGfiz3C
	 DfZcun7QEMxtGGsP1VXiy5wm56vnXgvHWGl+vs+aUWSLODYSCwPzy5c2vbyeqPgV53mGb
	 ym0iaGONKC/uOQL4fBzkUbxeDSSj5Vjkke1wrOmeRiC84I5ks4cQJuMRWf1JV6MjHv42U
	 8zjzwTUdmy+LxzFnTN7AzYyrXnC6sN8Iwx69yVCJjVzeVgwUHfL2z4QcMcVVfZLFqpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271158;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=sij+//fAkKkYWDv7ybQ/BQZIcVfScalfWR1KQZzEyvA=;
	b=LLth0Dxt4U0jkM4CtLjoqBzTx0rpt9PIe5ln03mPt+dvdyU9ctOkQHNCWpWiThd7wGbg
	 zviloNho1zg+/uh0HxB2wDoaHwj4Ovl0AAtr6HlEPjbjsrdGte/Aikrt+UokDdrM4OLF/
	 Z/CXF9KRC32QTimpcBEIkVpbL95dyohj6hNldkleotD6Djs6UXYpwyXuQqmKahKeryW3r
	 VoNCKbgPjB44CDcMTsAarz1cOBIyMC9S6m4EnvKleqwA3untd25f5KxIDimZRjYIlsIS2
	 j7yW+4QmYrM7cT64+k7pz6+yEL6FxP/S37t8iNH+2VmNnCbSzccu+Bv6cdWFQUBVvCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=wCrAaIVg;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8F6606A331
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 00:39:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE8F6606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=wCrAaIVg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794271155;
	bh=sij+//fAkKkYWDv7ybQ/BQZIcVfScalfWR1KQZzEyvA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=wCrAaIVgPEsKlx8lDCDNJvWjC35L/NIS2xyGiu/tZhE5eG2360wxVA2XkNKEMEjLh
	 Vn1HZtPoO+KZxrxvEkWQlrC0Tn/ljM3az49zuuGRb4sXfNsaqyzdIeb7MPod+pSKLa
	 J5omZbeTocD7kdx8ifK9F/A1f/5SpDpik8tb7iPJZTt89NOfXSGwYEOsoJaVvuXVRq
	 +z5Aj4mRo+K7j7XvjS4nHkArT2diWBxZeahFC149ivA3xPD7SXYKo8NFUrSoTm65IC
	 R7I8eYoSsU5zL3MzeaoMRK/MTspnoImKZCKCUMyRgb6rkZ3N0GkOJsbS8k93oJNald
	 6+T712rV4mvOw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9D4106005C
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 01:39:15 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 3/4] netfilter: ctnetlink: restrict expectation creation glue to userspace helpers
Date: Tue, 10 Nov 2026 01:39:08 +0100
Message-ID: <20261110003909.1740094-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110003909.1740094-1-pablo@netfilter.org>
References: <20261110003909.1740094-1-pablo@netfilter.org>
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
v4: no changes

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

