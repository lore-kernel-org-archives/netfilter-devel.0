Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE74429CE6;
	Fri, 24 Jul 2026 10:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890192; cv=none; b=NoMn+yBwq38rKdUagTeiORVgrbApn/SbQF+K/dlGl2WDqZ0eopPOsbLdMciagMx+LS5VCPvdGCTQUVOTMzkfhXJgC/NYlxLB4rexl8lkccLFsblfyDLh3AxZ6voyyF8XNoU3HmpoESV/9DrTbKr1qfM0QNqyo8E3PCDatA7H95U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890192; c=relaxed/simple;
	bh=kJiqKQz8EY6xe6vcHEZ5zo5eUVrOjCI/Vk/4Tz07wTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQrv7FCA+5gtzUHFi51NdcH6TU/zzRWxuAgVF7z7k1lQD0lEtVxd4Ff88etutnauEM6hR0kSfqx8cIIwvCp0rhyPoXE3wVI5ysJwoJ6Is0DO+Jtv8pUxOyw7OVEN6oKIJuZ7usWe6hGgMc0ffF/HFORtJrjPX274AdOUv9ZVNqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CJbB17/9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CJbB17/9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BD6BA601A5;
	Fri, 24 Jul 2026 12:49:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784890189;
	bh=BeQGsFz0+dpimRHBgs/mUC+fxVu3XYl0SEUrMXioSLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJbB17/9YLJLV5cRtdpbV3HXWo6lB1buyiiaineViLfSCUBXjWKdr7hhIHp7ID8wl
	 Wh7PpZOqX41DSHjfaO6/QfZsLjnL4iEvB2Aq0xmC1aO5WGijm3WScq6DCQzvpRvA23
	 2PKti8AAQFhfHsta3qDCaiNSK0MMThuV1wMLqcV1Xav92TVGZuQuLhkFA1zSNtR03P
	 So8m949xMfxzisheRvdWk2VMLVWbR+aXzwNI8otWlAW9U4V1iAAvDF0W2OstFAn7fy
	 regBequVKdqwJ1NXQ/qJ7Im0h8I1ldPNq1CaDUmuZi1U5mdFEvXXx/wO3X+uayyuyA
	 eOOD+rfD42qHw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 6/7] netfilter: nf_conntrack_expect: store event cache in expectation
Date: Fri, 24 Jul 2026 12:49:31 +0200
Message-ID: <20260724104932.437729-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724104932.437729-1-pablo@netfilter.org>
References: <20260724104932.437729-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Store the event cache in the expectation instead of accessing the
exp->master cache, as a step forward towards turning the exp->master
into a cookie.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_expect.h | 3 +++
 net/netfilter/nf_conntrack_broadcast.c      | 6 ++++++
 net/netfilter/nf_conntrack_ecache.c         | 7 +------
 net/netfilter/nf_conntrack_expect.c         | 5 +++++
 net/netfilter/nf_conntrack_netlink.c        | 5 +++++
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index c024345c9bd8..5d0f5b2f12a7 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -42,6 +42,9 @@ struct nf_conntrack_expect {
 	/* Expectation class */
 	unsigned int class;
 
+	/* Event filter mask */
+	u16 event_mask;
+
 	/* Function to call after setup and insertion */
 	void (*expectfn)(struct nf_conn *new,
 			 struct nf_conntrack_expect *this);
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 6ff954f1bfb8..0922e30b6ab0 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -14,6 +14,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 int nf_conntrack_broadcast_help(struct sk_buff *skb,
 				struct nf_conn *ct,
@@ -27,6 +28,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	struct rtable *rt = skb_rtable(skb);
 	struct in_device *in_dev;
 	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_ecache *ecache;
 	__be32 mask = 0;
 
 	if (!help)
@@ -79,6 +81,10 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	exp->zone = ct->zone;
 #endif
+	ecache = nf_ct_ecache_find(ct);
+	if (ecache)
+		exp->event_mask = ecache->expmask;
+
 	nf_ct_expect_related(exp, 0);
 	nf_ct_expect_put(exp);
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index cc8d8e85169f..fb731ee235d8 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -245,7 +245,6 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 {
 	struct net *net = nf_ct_exp_net(exp);
 	struct nf_ct_event_notifier *notify;
-	struct nf_conntrack_ecache *e;
 
 	lockdep_nfct_expect_lock_held();
 
@@ -254,11 +253,7 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 	if (!notify)
 		goto out_unlock;
 
-	e = nf_ct_ecache_find(exp->master);
-	if (!e)
-		goto out_unlock;
-
-	if (e->expmask & (1 << event)) {
+	if (exp->event_mask & (1 << event)) {
 		struct nf_exp_event item = {
 			.exp	= exp,
 			.portid	= portid,
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 7ae68d60586a..cd9af3620af5 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -330,6 +330,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conn *ct = exp->master;
 	struct net *net = read_pnet(&ct->ct_net);
+	struct nf_conntrack_ecache *ecache;
 	struct nf_conn_help *help;
 	int len;
 
@@ -342,6 +343,10 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 	exp->class = class;
 	exp->expectfn = NULL;
 
+	ecache = nf_ct_ecache_find(ct);
+	if (ecache)
+		exp->event_mask = ecache->expmask;
+
 	help = nfct_help(ct);
 	if (help)
 		helper = rcu_dereference(help->helper);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 31cbb1b55b9e..fc3f60099af3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3524,6 +3524,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 {
 	struct net *net = read_pnet(&ct->ct_net);
 	struct nf_conntrack_helper *helper;
+	struct nf_conntrack_ecache *ecache;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn_help *help;
 	u32 class = 0;
@@ -3575,6 +3576,10 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	exp->mask.src.u3 = mask->src.u3;
 	exp->mask.src.u.all = mask->src.u.all;
 
+	ecache = nf_ct_ecache_find(ct);
+	if (ecache)
+		exp->event_mask = ecache->expmask;
+
 	if (cda[CTA_EXPECT_NAT]) {
 		err = ctnetlink_parse_expect_nat(cda[CTA_EXPECT_NAT],
 						 exp, nf_ct_l3num(ct));
-- 
2.47.3

