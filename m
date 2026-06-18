Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F335F2BB17
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 16:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781800275; cv=none; b=fQcWOMhrRftJUBE5sdsKdQfZI7Rtmm2xhztKtYJMdhpiUPk/QJLxUnb1PsVyjG5tiMqN/AzkV8KZmtDnwrcBcps6f7YBaKSalvpwcSiUY3WervS78PLQTwsc1N71YYOUiiqorBYZV5vZqR+4mEgsSWhsCfGRa6VcLhqlz29GAVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781800275; c=relaxed/simple;
	bh=L92ojSiW0I7r/t4BoNlJlvKJzG4w51gnrsfPwf1bxRk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TR1F2jS8Kwap6GUf8cFcUto0ZiM4GaZGW5jKFtpmVWRpuxz27ACfWKtHtKYt8Xk4vuz4ZM+Z0dmactnZ06SXK1HrX4JpLNQiJf7HzJmSBGplkWnATfnIz9Qeiln+A+BWq2E+C5d1urx310hTcKW2kXlPkWu6R3W/L4nTNNaf4yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TAZHwwNi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TAZHwwNi"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D5FC1601A4
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 18:31:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781800271;
	bh=dNxRiaY1Lb/28MtSiiTknp1U7bqSczjfhV34a2UDeTg=;
	h=From:To:Subject:Date:From;
	b=TAZHwwNihiTxUL4VIhcuhxvrjt5wDyP7KrHCo0rLJBOsxFcg5b285bJ+pqcV3rKzr
	 HvzJAN9OQGI0ctN1c4Qdc+PX7BuDoONo2loI0Yc5HEzFJ7WSljlX6hXe7+4bM72f/u
	 s+D93AClMEYjRgpj3VnH/QKXUdzqK2cAAjQ2ehHRz+0yb9XrAI27dug+8bwayix3Xx
	 lxmdRLVDPipNy4JCyvpqZC6Qqxa5cdQGRon1uoMlO2XLfjg9POnqTGnevL4e7mzcDg
	 oVENXFouMgECHwxe+dsf8pJ3Ci6zv+X75FgdksJPPnK78kOKAv7C/IkgwBEE5N/y8V
	 ouh0ZFbGMycEg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_conntrack_expect: store master_tuple in expectation
Date: Thu, 18 Jun 2026 18:31:07 +0200
Message-ID: <20260618163107.921486-1-pablo@netfilter.org>
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
 include/net/netfilter/nf_conntrack_expect.h | 1 +
 net/netfilter/nf_conntrack_broadcast.c      | 1 +
 net/netfilter/nf_conntrack_expect.c         | 2 ++
 net/netfilter/nf_conntrack_netlink.c        | 9 +++------
 4 files changed, 7 insertions(+), 6 deletions(-)

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
index 4e78d2482989..22efcb8a29c1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3015,7 +3015,6 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
 	__s32 timeout = (__s32)(READ_ONCE(exp->timeout) - nfct_time_stamp) / HZ;
-	struct nf_conn *master = exp->master;
 	struct nf_conntrack_helper *helper;
 #if IS_ENABLED(CONFIG_NF_NAT)
 	struct nlattr *nest_parms;
@@ -3030,9 +3029,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (ctnetlink_exp_dump_mask(skb, &exp->tuple, &exp->mask) < 0)
 		goto nla_put_failure;
-	if (ctnetlink_exp_dump_tuple(skb,
-				 &master->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-				 CTA_EXPECT_MASTER) < 0)
+	if (ctnetlink_exp_dump_tuple(skb, &exp->master_tuple, CTA_EXPECT_MASTER) < 0)
 		goto nla_put_failure;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
@@ -3045,9 +3042,9 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 		if (nla_put_be32(skb, CTA_EXPECT_NAT_DIR, htonl(exp->dir)))
 			goto nla_put_failure;
 
-		nat_tuple.src.l3num = nf_ct_l3num(master);
+		nat_tuple.src.l3num = exp->master_tuple.src.l3num;
 		nat_tuple.src.u3 = exp->saved_addr;
-		nat_tuple.dst.protonum = nf_ct_protonum(master);
+		nat_tuple.dst.protonum = exp->master_tuple.dst.protonum;
 		nat_tuple.src.u = exp->saved_proto;
 
 		if (ctnetlink_exp_dump_tuple(skb, &nat_tuple,
-- 
2.47.3

