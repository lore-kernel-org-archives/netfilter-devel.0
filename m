Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13ED25D1E9
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 11:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774870829; cv=none; b=FihUa/RUCZiFkVC8voiodQ0e06g3U6sKojM27xIN3UrYgxPXE4QyoMrDNFRJ3bnH6Xu7+FGXtLx4R8wmyTMiUNqImYZ02eJkQY8uzmKjsaDdh+joAKtP2cqidH57jNjWuZEzuokIIgLqkdv+opW++EI9oK4FPVO8P+TVe6vO5oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774870829; c=relaxed/simple;
	bh=dhR9teYGV2H5pTkvSJ3KJd+Qe5QjzXBVLmBDnWx4zbk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wvbzsout/97sAptUpRQ5DJ5Ufrz4jVq7Q14Dh1qGsv+HWdj8y6ZF3iboTmSiHadkk9Ccw8Co6aTqcVfBiwcEd13x4GiEC2zlS1SGItMK93didWKmThOw/GuriKZclnBAwuSVEyIyagMgsAMlGegL/i8vxQLRhE41tUlBXcrU3U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OUSk8gTf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OUSk8gTf"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6ADB360299;
	Mon, 30 Mar 2026 13:40:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774870824;
	bh=cJrGhI+xccyUbrCRFOWSZ/UIrqLmqdKS8O6T3R7G1TE=;
	h=From:To:Cc:Subject:Date:From;
	b=OUSk8gTfMYAxD+jxk0i+aGAXmfBlT6+1+gRDol/0XR/uGtDrvo97Cu8q+MRQEJVyM
	 fFpQrfOLm5Mik0JeG9v2ZkdBIHSAHbc7ZqkZc86JloIjYrKpr+baLpqg5dPtVeyLLZ
	 lR0zQewkYRWsy8TZIvMM+MaT0IWPW/GOBW9V0Ce/7gAXPUFIO7RO3pJNYSjZAuF2HN
	 87Z7x/Sl+OzK7eO25DizA3V97vA95lYIy0RrtIrk+v/QpVxTChMeMoPnhTHrCUbSZ1
	 qE9u4U4Qt3c2DnIdZhh57VxQSCERIEzaeB5z/x8vkSfERYeJYuBB+pCK6OnKXJpb/l
	 +JbCelfS0ATsw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: tpluszz77@gmail.com,
	fw@strlen.de,
	ffmancera@suse.de
Subject: [PATCH nf] netfilter: ctnetlink: disallow explicit helper on new expectations
Date: Mon, 30 Mar 2026 13:40:19 +0200
Message-ID: <20260330114019.881348-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the existing master conntrack helper, anything else is not really
supported and it just makes validation more complicated, so just ignore
what helper userspace suggests for this expectation.

This was uncovered when validating CTA_EXPECT_CLASS via different helper
provided by userspace than the existing master conntrack helper:

  BUG: KASAN: slab-out-of-bounds in nf_ct_expect_related_report+0x2479/0x27c0
  Read of size 4 at addr ffff8880043fe408 by task poc/102
  Call Trace:
   nf_ct_expect_related_report+0x2479/0x27c0
   ctnetlink_create_expect+0x22b/0x3b0
   ctnetlink_new_expect+0x4bd/0x5c0
   nfnetlink_rcv_msg+0x67a/0x950
   netlink_rcv_skb+0x120/0x350

Allowing to read kernel memory bytes off the expectation boundary.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Reported-by: Qi Tang <tpluszz77@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 52 +++++-----------------------
 1 file changed, 9 insertions(+), 43 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 35f859b24103..a4826ab8e2ca 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2636,7 +2636,6 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
 
 static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
-		       struct nf_conntrack_helper *helper,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask);
 
@@ -2865,7 +2864,6 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 {
 	struct nlattr *cda[CTA_EXPECT_MAX+1];
 	struct nf_conntrack_tuple tuple, mask;
-	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conntrack_expect *exp;
 	int err;
 
@@ -2879,17 +2877,8 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	if (err < 0)
 		return err;
 
-	if (cda[CTA_EXPECT_HELP_NAME]) {
-		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
-
-		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
-						    nf_ct_protonum(ct));
-		if (helper == NULL)
-			return -EOPNOTSUPP;
-	}
-
 	exp = ctnetlink_alloc_expect((const struct nlattr * const *)cda, ct,
-				     helper, &tuple, &mask);
+				     &tuple, &mask);
 	if (IS_ERR(exp))
 		return PTR_ERR(exp);
 
@@ -3528,11 +3517,11 @@ ctnetlink_parse_expect_nat(const struct nlattr *attr,
 
 static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
-		       struct nf_conntrack_helper *helper,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask)
 {
 	struct net *net = read_pnet(&ct->ct_net);
+	struct nf_conntrack_helper *helper;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn_help *help;
 	u32 class = 0;
@@ -3542,7 +3531,11 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (!help)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	if (cda[CTA_EXPECT_CLASS] && helper) {
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (cda[CTA_EXPECT_CLASS]) {
 		class = ntohl(nla_get_be32(cda[CTA_EXPECT_CLASS]));
 		if (class > helper->expect_class_max)
 			return ERR_PTR(-EINVAL);
@@ -3607,7 +3600,6 @@ ctnetlink_create_expect(struct net *net,
 {
 	struct nf_conntrack_tuple tuple, mask, master_tuple;
 	struct nf_conntrack_tuple_hash *h = NULL;
-	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn *ct;
 	int err;
@@ -3633,33 +3625,7 @@ ctnetlink_create_expect(struct net *net,
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	rcu_read_lock();
-	if (cda[CTA_EXPECT_HELP_NAME]) {
-		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
-
-		helper = __nf_conntrack_helper_find(helpname, u3,
-						    nf_ct_protonum(ct));
-		if (helper == NULL) {
-			rcu_read_unlock();
-#ifdef CONFIG_MODULES
-			if (request_module("nfct-helper-%s", helpname) < 0) {
-				err = -EOPNOTSUPP;
-				goto err_ct;
-			}
-			rcu_read_lock();
-			helper = __nf_conntrack_helper_find(helpname, u3,
-							    nf_ct_protonum(ct));
-			if (helper) {
-				err = -EAGAIN;
-				goto err_rcu;
-			}
-			rcu_read_unlock();
-#endif
-			err = -EOPNOTSUPP;
-			goto err_ct;
-		}
-	}
-
-	exp = ctnetlink_alloc_expect(cda, ct, helper, &tuple, &mask);
+	exp = ctnetlink_alloc_expect(cda, ct, &tuple, &mask);
 	if (IS_ERR(exp)) {
 		err = PTR_ERR(exp);
 		goto err_rcu;
@@ -3669,8 +3635,8 @@ ctnetlink_create_expect(struct net *net,
 	nf_ct_expect_put(exp);
 err_rcu:
 	rcu_read_unlock();
-err_ct:
 	nf_ct_put(ct);
+
 	return err;
 }
 
-- 
2.47.3

