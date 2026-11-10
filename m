Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316012;
	b=WXkWvvRES5U9NSBqo7WDRSjfjZ9NAHieAb3aqC3P4snj22xVj5FllVZYbLzjOhE0Afq3
	 WhpJmZ+fCrZ3mmqQOwGLUn9hxalveKE44uinKPmDxmZ71wNphNhgvaO0CyVmnUudFJsju
	 3TJwSM7RBPuq4UpNRKergzhyqz96JCNSzLuQRjVUbThf9iIh/hRYmNsa5tHuW0iiVu3+i
	 OMMOPD3chS674cuY7nvqij7PtAYew1He9R3rCumIo7Zyg1zNRb9dhdMUAOvXB2Ef7EXKs
	 pzz/KJJV5/bu8/KnmuJTofJkQCRiDyVUOcEosV6SPVXsA3SEX7OPKLmmY+UwmDdNAfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316012;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=E8ZfndGvEqMhTM5zzIcDeua53hNmN+XVAneg/GKYZEo=;
	b=xUkscebcNCdsijDVWtqVvvdxbtCDUcvrE5lorcNpmZHe63sh+2cqYt2iwFhibg2UuiDL
	 NJhfJxLs6TNX9LkwpJlk+OolGM/YHAXDKQXKWzTAgwVm4elinwF9TU+tC101TqfoN+ycb
	 nJgaPNmBEbcr/c7kBW9ZGDnbDT/8XbBUYwHBrv+AHce2sUAfT+I4HLtXN/LsJWG2VtSR8
	 t3M7/8weLiiWG/7RMHV2CryAqTUH7KK6YooUep5NmedIXCDOiebMCPFSph0YO069YMEku
	 ZTaYB8ccqSGZNPvsevZiSYBNrPJLJiyCqtXfugbYp1OIkTw8U1qh8m5ZoxIEMtnqE+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VG60cG+3;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E44606A325
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:06:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7E44606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VG60cG+3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794316003;
	bh=E8ZfndGvEqMhTM5zzIcDeua53hNmN+XVAneg/GKYZEo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VG60cG+3l1ircpuNI43T+zooL+AT1lV4iiPDn0VpjgOZn+DPvgRxHITWYeJw/Yha9
	 bbsIFe4M3GfD86E/KXK45MouOLg/3g49Y+eEoZqfeBkX9A+nK2s4YkCc09x+gS/sCT
	 YaGJD2c3S3FfRjKTpww3xgSAbXq6nTLtUgeR5GkK14RAmF94sw2WnnUBEnIM9G8WP7
	 6OwcexY6HmwG7D7y3taK8iKDpz952DDtQzR5QemyZvsTd7zWHRawT4x2/L5GJso+xs
	 VrejSyZul6bfMRAr3peVGtYyq3Hb0ABe+aRAVrAFl2pfgLnSP0b1KT0UqVVF6jBLSx
	 0RXtWf29EhRtQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D409B605D1
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 14:06:43 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v5 3/5] netfilter: ctnetlink: restrict expectation creation glue to userspace helpers
Date: Tue, 10 Nov 2026 14:06:35 +0100
Message-ID: <20261110130637.1832292-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110130637.1832292-1-pablo@netfilter.org>
References: <20261110130637.1832292-1-pablo@netfilter.org>
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
v5: no changes

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

