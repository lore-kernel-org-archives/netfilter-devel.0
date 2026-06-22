Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8BD347BD9
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 19:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782157026; cv=none; b=r661LZ6HuYLAZ+Q2ZUiKI38mH9Y6a1tHbYjEPGCMjELhnk1jAQtznU/u8l85jcSJNULbZm46Hf45DrOJsAyn5/3bU/KvjaFrk8Rp+8iHDlDG52LxQrwcwF44+fdnImXhqBbyK8mrvn3BVBorSVvAt1dlJnBHaq8bNNND06DgWMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782157026; c=relaxed/simple;
	bh=Z5VRN2JRtxpRUAM3dZobPdVCHO3ep3XUKyavmw8XuZM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=emZA+EqUa1BI7dXmZlQB1ayiGhu32yzkj/6orIP6nUWZEYGKj2Vs7+slSXhtVGPNZhmYjXxPLFEr1j654wKuSq2BLl4GvbaJqbOFB3w9ijTXqFK1z0X8wj6Pt1kcIyGTIHPW7kszR9F/fHQsEVdcnOeSt8N8zLAgD2NCNfAn3j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WJdgEZl/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WJdgEZl/"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D7A7160196
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 21:37:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782157023;
	bh=M5CTEJPOXsDfRxeKORugO36vFdcyuQ5+lpU4qSmlYRc=;
	h=From:To:Subject:Date:From;
	b=WJdgEZl/AJ2HOToY+6a1sVRTFz9fkTQ8UuzYUH0/SAfUVkSH6c8D9xjWLKhRJOib1
	 nN0v3Uc3mTLjpRKdaz0IpQcEQNoy9ewl4Pqw8OnjZHTS2OrUoy5AA9NyGUVnzerLWa
	 MZZiowBTABnSU1+EoCixzj8iz2ebSfZOZJNM7STQC6gTsiuOXlVlrHpXsLU+QMBqle
	 0rpR5/K1ZUlZMfOnk2YGaQe0SiliM9C7R+c9lnzcg8gzE9zftZQxpvuC/Ca/JwhpQ9
	 8c6gUMxv+kvqUzLVUp/cH74DFRgsTA8J5iXlbyRO0g8Ecrdm8UgC5ypJH2OSAdFHqf
	 UMWdDCX/udxwQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_conntrack_expect: store master_tuple in expectation
Date: Mon, 22 Jun 2026 21:36:59 +0200
Message-ID: <20260622193659.286517-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Store master conntrack tuple in the expectation since exp->master might
refer to a different conntrack when accessed from rcu read side lock
area due to typesafe rcu rules.

Fixes: 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_expect.h |  1 +
 net/netfilter/nf_conntrack_broadcast.c      |  1 +
 net/netfilter/nf_conntrack_expect.c         |  2 ++
 net/netfilter/nf_conntrack_netlink.c        | 10 ++++------
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index be4a120d549e..c024345c9bd8 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -26,6 +26,7 @@ struct nf_conntrack_expect {
 	possible_net_t net;
 
 	/* We expect this tuple, with the following mask */
+	struct nf_conntrack_tuple master_tuple;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_mask mask;
 
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 400119b6320e..bf78828c7549 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -62,6 +62,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	if (exp == NULL)
 		goto out;
 
+	exp->master_tuple	  = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
 	exp->tuple                = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 
 	helper = rcu_dereference(help->helper);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 49e18eda037e..9454913e1b33 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -355,6 +355,8 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
 
+	exp->master_tuple = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+
 	if (saddr) {
 		memcpy(&exp->tuple.src.u3, saddr, len);
 		if (sizeof(exp->tuple.src.u3) > len)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index cb38ef42e9e6..4217715d42dc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3002,7 +3002,6 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
 	__s32 timeout = (__s32)(READ_ONCE(exp->timeout) - nfct_time_stamp) / HZ;
-	struct nf_conn *master = exp->master;
 	struct nf_conntrack_helper *helper;
 #if IS_ENABLED(CONFIG_NF_NAT)
 	struct nlattr *nest_parms;
@@ -3017,9 +3016,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (ctnetlink_exp_dump_mask(skb, &exp->tuple, &exp->mask) < 0)
 		goto nla_put_failure;
-	if (ctnetlink_exp_dump_tuple(skb,
-				 &master->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-				 CTA_EXPECT_MASTER) < 0)
+	if (ctnetlink_exp_dump_tuple(skb, &exp->master_tuple, CTA_EXPECT_MASTER) < 0)
 		goto nla_put_failure;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
@@ -3032,9 +3029,9 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 		if (nla_put_be32(skb, CTA_EXPECT_NAT_DIR, htonl(exp->dir)))
 			goto nla_put_failure;
 
-		nat_tuple.src.l3num = nf_ct_l3num(master);
+		nat_tuple.src.l3num = exp->master_tuple.src.l3num;
 		nat_tuple.src.u3 = exp->saved_addr;
-		nat_tuple.dst.protonum = nf_ct_protonum(master);
+		nat_tuple.dst.protonum = exp->master_tuple.dst.protonum;
 		nat_tuple.src.u = exp->saved_proto;
 
 		if (ctnetlink_exp_dump_tuple(skb, &nat_tuple,
@@ -3576,6 +3573,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 #endif
 	rcu_assign_pointer(exp->helper, helper);
 	rcu_assign_pointer(exp->assign_helper, assign_helper);
+	exp->master_tuple = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
 	exp->mask.src.u.all = mask->src.u.all;
-- 
2.47.3

