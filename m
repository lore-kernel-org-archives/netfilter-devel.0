Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323734399F7;
	Wed, 22 Jul 2026 21:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754880; cv=none; b=gZUXXBDdOfpQnX+KBbVnHM93nMuRSpC4RpTWgzsrKGEvsH18XmYRBdb/aMd+oRYpzyzq/5QuhX6oXuBqkKVSixDN91dDtj/OKI7u3v2VwNCNoVwQ6xskkQsDDW0eu4Q/xS+PItv6hN941IoHcMUXyJQE98nAecaDpRjzUUT/ktM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754880; c=relaxed/simple;
	bh=GMeAOvoErUYTW4lcOzPpNw0VCD5jdvgE6inCfTNurZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYsdueCq9oVz6GW+q0SSWVg6LOTJY0e8z1ETvnWAfB91o3D54Io5TFtRbuSUn+xNI+VGB8wu6wKJ8Rm41I5JG7JFyu57aXIZx97lCrjvte7XzELdBeSVcVfNRijnwVYT16ymAw38xfVuxo0juV0JN45R0+z6Jk8nT8HOZ2rGZgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vEIurwG4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vEIurwG4"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 544E96019E;
	Wed, 22 Jul 2026 23:14:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784754871;
	bh=Dfej/kXpz0EHt4KV6jp8ELzokq+ndIxpYDiP8JHHEqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEIurwG4HvDz+PUpT2e36uv1bZHU3oVrNKj/GEfyAmmesFgXxvQyF8zM1kSw4p3t9
	 pjlKWuaeL667Q2CJihbXE6W015UtIJoVOhX2bqCi2N9VJzRpZYH8e0FDKhEyOuK/AX
	 qFwjlx0TwZNf6TgRV6rHT05u6JjPyUDD6IoPKQ/9umfUpxmZDNRVl/+tfpG93i3JfD
	 XJpqVEyFiMIFrVd4BXquNBgFjRUk6GSTeKAY+HwpynON4aA47IYpbNTPVn98HqufdX
	 rujpcGe7iq/m1EMZw7Oh5YddcZKX8Iy0I1EIESozuCJuUxT/ZkwTH5MSr+/4OCClcB
	 nYPnW0ViDFeOg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 03/13] netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()
Date: Wed, 22 Jul 2026 23:14:10 +0200
Message-ID: <20260722211420.153933-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722211420.153933-1-pablo@netfilter.org>
References: <20260722211420.153933-1-pablo@netfilter.org>
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
Link: https://patch.msgid.link/178377968720.33756.12204817361601593230@proton.me/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
index a93eaf0f7d30..133bd713fe0c 100644
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

