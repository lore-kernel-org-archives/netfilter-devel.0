Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5569827B35B
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 23:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783899472; cv=none; b=Rb7PsKHNowpHViw3jCVByP9t8RejBa3FgUMvMW9MSQZ8GfvvciWiITA0DIA0jSxrfJuLH2/sQygYkE4zcMnN1VEcbx+kiQql0PCxT3oOWxGcIhUZpeBdt/zJfng2WQ5d/S3dKBNT8cHCGS6X+olgwrccd6MkaSIHMZsUwm1JM8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783899472; c=relaxed/simple;
	bh=Q7I/0jeT8+WMLWeoEHwyE+8z8MQ1cXTWvSuZjyB+grw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rdIlYYh3yYQJXceZE+FmcIwIg6v6IwSmFAplfX3J5UvEyaVEUaWr8dtFEAwESL8jwskJsjZ5Dsudeq2mrmgbcWpgGe4d6gmBBNfSE9i+FgIVvIBuYyx2AMGKH2mkgApPwlPAHLsPxJfXsXgfpvdOBOAwzSWL1/lK+HIWX0DybEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oOdKYbx5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oOdKYbx5"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3896360193;
	Mon, 13 Jul 2026 01:37:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783899468;
	bh=uGmQUcNChqd5zuR/IL2xSyQrOpt6C0iRtKTM1mlrCc8=;
	h=From:To:Cc:Subject:Date:From;
	b=oOdKYbx5D0zHHaiUgNd+FaCaOh9H5xV1h9KCcA/Zv0v/3laOhY1F2SwUpTKFTu//M
	 qXAM0u+Kd9cU3s63SyyJE8a+66cSKKgxe00eojSBtwpiVJHPN8sRrHzKL/970h7exT
	 PL5XG6bUiCW1iqusPZJ/Oss3XplCKwM/Qu36K1O+/MGn9+aMHzT6HSJDiChwoP1ch4
	 PNw4s3PcNPVppsVBozfLaDErQvczc3xcswrBXyyfwweP1wB6UqT7K+Fr2Il4orw2do
	 id4m+AGURPMQMGX9hLD3wmWVhklYOEktlSP5eXvVcff/O97P0Z1YA79P8bV6PCpVmU
	 Rcmg8HQg7FB7g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	iostreampy@proton.me
Subject: [PATCH nf,v2] netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()
Date: Mon, 13 Jul 2026 01:37:44 +0200
Message-ID: <20260712233744.1585130-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new function to insert a pair of expectations, this is required by
the SIP and H323 NAT helpers. The spinlock is held to check if there is
a slot for both expectations, in such case, insert them.

This removes the need for nf_ct_unexpect_related() inside the loop to
find a pair of consecutive ports, otherwise inserting expectations whose
dead flag is already set on can happen.

Fixes: b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap expectations")
Reported-by: Jaeyeong Lee <iostreampy@proton.me>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: address sashiko comments on maximum number of expectations check
    overflow and the missing safety check for null master_help.

 include/net/netfilter/nf_conntrack_expect.h |  3 ++
 net/ipv4/netfilter/nf_nat_h323.c            | 22 ++++-------
 net/netfilter/nf_conntrack_expect.c         | 41 +++++++++++++++++++--
 net/netfilter/nf_nat_sip.c                  | 20 +++-------
 4 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index c024345c9bd8..26d6babd92fc 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -161,6 +161,9 @@ static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect,
 	return nf_ct_expect_related_report(expect, 0, 0, flags);
 }
 
+int nf_ct_expect_related_pair(struct nf_conntrack_expect *expect[],
+			      unsigned int flag);
+
 struct nf_conn_help;
 void nf_ct_expectation_gc(struct nf_conn_help *master_help);
 
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 183e8a3ff2ba..6bcd6734769b 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -182,6 +182,7 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 			struct nf_conntrack_expect *rtp_exp,
 			struct nf_conntrack_expect *rtcp_exp)
 {
+	struct nf_conntrack_expect *rtp_pair[2] = { rtp_exp, rtcp_exp };
 	struct nf_ct_h323_master *info = nfct_help_data(ct);
 	int dir = CTINFO2DIR(ctinfo);
 	int i;
@@ -227,22 +228,13 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		rtp_exp->tuple.dst.u.udp.port = htons(nated_port);
-		ret = nf_ct_expect_related(rtp_exp, 0);
+		rtcp_exp->tuple.dst.u.udp.port = htons(nated_port + 1);
+		ret = nf_ct_expect_related_pair(rtp_pair, 0);
 		if (ret == 0) {
-			rtcp_exp->tuple.dst.u.udp.port =
-			    htons(nated_port + 1);
-			ret = nf_ct_expect_related(rtcp_exp, 0);
-			if (ret == 0)
-				break;
-			else if (ret == -EBUSY) {
-				nf_ct_unexpect_related(rtp_exp);
-				continue;
-			} else if (ret < 0) {
-				nf_ct_unexpect_related(rtp_exp);
-				nated_port = 0;
-				break;
-			}
-		} else if (ret != -EBUSY) {
+			break;
+		} else if (ret == -EBUSY) {
+			continue;
+		} else if (ret < 0) {
 			nated_port = 0;
 			break;
 		}
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 7ae68d60586a..0ecd8cecd4a2 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -460,13 +460,14 @@ static void evict_oldest_expect(struct nf_conn_help *master_help,
 
 static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 				       struct nf_conn_help *master_help,
-				       unsigned int flags)
+				       unsigned int flags, unsigned int new_expects)
 {
 	const struct nf_conntrack_expect_policy *p;
 	struct nf_conntrack_expect *i;
 	struct nf_conntrack_net *cnet;
 	struct nf_conntrack_helper *helper;
 	struct net *net = nf_ct_exp_net(expect);
+	unsigned int num_expects;
 	struct hlist_node *next;
 	unsigned int h;
 	int ret = 0;
@@ -492,19 +493,22 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 			goto out;
 		}
 	}
+
+	num_expects = master_help->expecting[expect->class];
+
 	/* Will be over limit? */
 	helper = rcu_dereference_protected(master_help->helper,
 					   lockdep_is_held(&nf_conntrack_expect_lock));
 	if (helper) {
 		p = &helper->expect_policy[expect->class];
-		if (master_help->expecting[expect->class] >= p->max_expected)
+		if (num_expects + new_expects >= p->max_expected)
 			evict_oldest_expect(master_help, expect, p);
 	} else {
 		const struct nf_conntrack_expect_policy default_exp_policy = {
 			.max_expected = NF_CT_EXPECT_MAX_CNT,
 		};
 
-		if (master_help->expecting[expect->class] >= default_exp_policy.max_expected)
+		if (num_expects + new_expects >= default_exp_policy.max_expected)
 			evict_oldest_expect(master_help, expect, &default_exp_policy);
 	}
 
@@ -530,7 +534,7 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 		goto out;
 	}
 
-	ret = __nf_ct_expect_check(expect, master_help, flags);
+	ret = __nf_ct_expect_check(expect, master_help, flags, 1);
 	if (ret < 0)
 		goto out;
 
@@ -546,6 +550,35 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related_report);
 
+int nf_ct_expect_related_pair(struct nf_conntrack_expect *expect[],
+			      unsigned int flags)
+{
+	struct nf_conn_help *master_help;
+	int i, ret;
+
+	spin_lock_bh(&nf_conntrack_expect_lock);
+	master_help = nfct_help(expect[0]->master);
+	if (!master_help || master_help != nfct_help(expect[1]->master)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = __nf_ct_expect_check(expect[i], master_help, flags, 2);
+		if (ret < 0)
+			goto out;
+	}
+
+	for (i = 0; i < 2; i++) {
+		nf_ct_expect_insert(expect[i], master_help);
+		nf_ct_expect_event_report(IPEXP_NEW, expect[i], 0, 0);
+	}
+out:
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_expect_related_pair);
+
 void nf_ct_expect_iterate_destroy(bool (*iter)(struct nf_conntrack_expect *e, void *data),
 				  void *data)
 {
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index aea02f6aff09..9e9ff986ece5 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -592,6 +592,7 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 				     unsigned int medialen,
 				     union nf_inet_addr *rtp_addr)
 {
+	struct nf_conntrack_expect *rtp_pair[2] = { rtp_exp, rtcp_exp };
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
@@ -622,24 +623,15 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 		int ret;
 
 		rtp_exp->tuple.dst.u.udp.port = htons(port);
-		ret = nf_ct_expect_related(rtp_exp,
-					   NF_CT_EXP_F_SKIP_MASTER);
-		if (ret == -EBUSY)
-			continue;
-		else if (ret < 0) {
-			port = 0;
-			break;
-		}
 		rtcp_exp->tuple.dst.u.udp.port = htons(port + 1);
-		ret = nf_ct_expect_related(rtcp_exp,
-					   NF_CT_EXP_F_SKIP_MASTER);
+
+		ret = nf_ct_expect_related_pair(rtp_pair,
+						NF_CT_EXP_F_SKIP_MASTER);
 		if (ret == 0)
 			break;
-		else if (ret == -EBUSY) {
-			nf_ct_unexpect_related(rtp_exp);
+		else if (ret == -EBUSY)
 			continue;
-		} else if (ret < 0) {
-			nf_ct_unexpect_related(rtp_exp);
+		else if (ret < 0) {
 			port = 0;
 			break;
 		}
-- 
2.47.3

