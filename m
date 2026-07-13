Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067D51F099C
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 14:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783952404; cv=none; b=KG5Cgt7fl2ta9XFkp7luB5kn04GWxa2dPRWiuDZsji6VQoWSupuyk6X4aOtikOi/YFPSpRuB5evFOsLTAn8Y+ji/TVwc7RXI8jcy5bVjl6huxVVCaOIqk9DUGuluWOPUy21lOlMvsg6cayCCy/0TsxCaTtG08k6ectmpnjqdk5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783952404; c=relaxed/simple;
	bh=2C/vblAWPw1+0wzIlwmcKkN0ra9pC8sm1oPIDgXwzHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B2F2MNGMN6HjcKclapjbtFvnoc0FPKPg6p0V8rfGlIETzl3ti4un0LOiQrQ7BLPtMoAhACs/X6r1BQe6vfQhGWDYHS5j6xHCAWYHuIVSejVyX7u0EiRBfhFu354DL11dmFpEP9P4H5v2a38oZyJ0Ju5cupiFuMIOAO6c/o/2cxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vJgfctHv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vJgfctHv"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D78F760578;
	Mon, 13 Jul 2026 16:19:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783952400;
	bh=dsGhARgoya9cOq9BxhOhpUXIncrI2/YG4RqflLQSIUA=;
	h=From:To:Cc:Subject:Date:From;
	b=vJgfctHvMbh2u5vgLIlfLUDXAX9RLFa/bcG3//nhFg6l1tHK5R+7mYKYijxJfuxAA
	 jnQMMrGVPRCiziOG0XSTcX7aLH1aQJF0JNIA+i/nDXDEA4Mz7+E60Mo2zuZL75KjPe
	 DyZZ/gzyVMrNtVM0645IyE348nHGsWrHFFazat9vsKplWuIvjwHm/AzprLcKkXXyeF
	 A8gYodOfuonFYrfZ7z9ru8b+vP5em/xTcNttn5hJqlYgSWf+50K1lBNug1TTdg4VYn
	 gkZuV7pqhxiG1WB9RV8Ioyu+IoBZrYQyU9o2S4w0wckfWnN2c1W7u/6cPrDjYL9Krd
	 8kKBw1IHr9dhg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: iostreampy@proton.me
Subject: [PATCH nf,v3] netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()
Date: Mon, 13 Jul 2026 16:19:56 +0200
Message-ID: <20260713141956.1675856-1-pablo@netfilter.org>
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

Bump master_help->expecting for the expectation class after checking if
the expectation fits in the master expectation list, which is needed for
this new _pair() function variant to run the eviction routine including
the preallocated slot for the first expectation in the pair.

Fixes: b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap expectations")
Reported-by: Jaeyeong Lee <iostreampy@proton.me>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: change direction: preallocate the expectation slot in the _check()
    loop in the new nf_ct_expect_related_pair().

 include/net/netfilter/nf_conntrack_expect.h |  3 ++
 net/ipv4/netfilter/nf_nat_h323.c            | 22 +++++--------
 net/netfilter/nf_conntrack_expect.c         | 35 ++++++++++++++++++++-
 net/netfilter/nf_nat_sip.c                  | 20 ++++--------
 4 files changed, 50 insertions(+), 30 deletions(-)

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
index 7ae68d60586a..8a3b9e33e94f 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -427,7 +427,6 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp,
 		exp->timeout += helper->expect_policy[exp->class].timeout * HZ;
 
 	hlist_add_head_rcu(&exp->lnode, &master_help->expectations);
-	master_help->expecting[exp->class]++;
 
 	hlist_add_head_rcu(&exp->hnode, &nf_ct_expect_hash[h]);
 	cnet = nf_ct_pernet(net);
@@ -534,6 +533,7 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 	if (ret < 0)
 		goto out;
 
+	master_help->expecting[expect->class]++;
 	nf_ct_expect_insert(expect, master_help);
 
 	nf_ct_expect_event_report(IPEXP_NEW, expect, portid, report);
@@ -546,6 +546,39 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
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
+		ret = __nf_ct_expect_check(expect[i], master_help, flags);
+		if (ret < 0) {
+			if (i == 1)
+				master_help->expecting[expect[0]->class]--;
+			goto out;
+		}
+		master_help->expecting[expect[i]->class]++;
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

