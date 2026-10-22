Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684012;
	b=BoT59r7eaS9WVBG1EDN1n09Z7XRv+tirvnMZaldSKc20pFFL7ksrQ4Z+7s3LDvY2YqeB
	 6+fZJoGMvNq+Y3T9r53eWggIGUBk68lknAo3aFj6zIUMsDbYf52Pf+YhXulbrvLE7sMh2
	 dzsV/GaCfnl8HDtuoQizYGK+FaNxjJTGQ9r0Vp2YlAVh1slUjQxRKCHlVXrYQe4UzI7L6
	 tfKme72vLs7q2txMyC+ysP0OFobnhPdDhpEF64IeCemh7SoHgkzOSqb5XHrSdPqVK+6Hy
	 vORQmNlWoDirmE8ctb8mAJebYE04Zr01RQ5Uahttygml/qrC7A0UudKgcVTjS24QTIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684012;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=74+QKOW3aWRjMWuH1YMHR6l60FP/DPyZ8hr3VWtayAo=;
	b=ZA5JTriBfkz6ryRquNXjR++vLS3TxC2e562VbS01683Kz/pujB3U6zV9V3hMg/qiS3ut
	 OqARoKuLrg66NsHS0bU6bLKPH4zrjRs8c32VVPCSsSULz0LSBY96fP2rr/t2trwvRqC0d
	 TauBhvk1299hHdZHDIRqIGQhc3IsUMr/X8+ksPtI6f78DPVNWuzcumR5WOkuxZNlH2VZn
	 gSSC96fYqIvDCmjP/yZGQXpzJicfSftnU/3ElQ0hvXk9GJbNLsCs69BaJJEQNtHjhuYAL
	 HQctqC/aV4PIdKPGpdA7nGGJQHiUED1Pliiczx0Ii3JJIxQYKVbmKMvWW/9lg5NBTIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=I4bFsIvA;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A4E606A319
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 15:46:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83A4E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=I4bFsIvA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792684007;
	bh=74+QKOW3aWRjMWuH1YMHR6l60FP/DPyZ8hr3VWtayAo=;
	h=From:To:Subject:Date:From;
	b=I4bFsIvAjnWYfjuMmJyLvNi1blJlC4wRGdEHHt2lWBBIuwTQpgfiROa6leu92HLzV
	 +YUdWpfl7lHK+C2wvgneZJnA5n58vemY0YZuoYGip9OJPX6VOpRJHrsWA7CWvDoDCd
	 Bi8fAANTkM9Otx8WmEEDjdwRsdX/2NUWG1dpfvAA1ITg3WiC5D1r2WpYFwAoafMEsh
	 ijHs0f/nU7SAPeeKpq7AvCsUIxU9g/rc2VhInHvySKCLEikfbPLA2n+pQ1vSlF/WZt
	 Hd+iwuQ8xcgsdaKi6voW/GI0mteh1EKlEph3aBlsIfdnzVH1HRBD8LyMzm06wWuGhy
	 ZwjA878WWzyIw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 69EC860056
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:46:47 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
Date: Thu, 22 Oct 2026 17:46:44 +0200
Message-ID: <20261022154644.2002766-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

Adding expectations to unconfirmed conntracks are problematic because of
reallocations of the ct extension area can happen while expectations are
placed in the ct extension expectation list.

NFQA_EXP was added with the purpose of supporting userspace conntrack
helpers, which create expectations in confirmation hook.

On packet reinjection, hook updates could result in a stale hook_index
that point to different hooks, but this is not an issue because, in such
rare case, expectation will not be created, else it could be created on
the confirmation hook, which is the only hook where userspace helpers
are possible.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: - add check for bridge
    - expand commit description to try to calm down LLM, stale hook_index
      is not an issue in this case.

 net/netfilter/nfnetlink_queue.c | 43 ++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 6ebf2bb8bbbd..677ec191df06 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1786,6 +1786,22 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
 	return 0;
 }
 
+static bool nfqnl_hook_exp_support(struct nf_hook_ops *ops)
+{
+	return (ops->pf == NFPROTO_IPV4 &&
+		(ops->hooknum == NF_INET_POST_ROUTING ||
+		 ops->hooknum == NF_INET_LOCAL_IN) &&
+		ops->priority == NF_IP_PRI_CONNTRACK_CONFIRM) ||
+	       (ops->pf == NFPROTO_IPV6 &&
+		((ops->hooknum == NF_INET_POST_ROUTING &&
+		 ops->priority == NF_IP6_PRI_LAST) ||
+		 (ops->hooknum == NF_INET_LOCAL_IN &&
+		  ops->priority == NF_IP6_PRI_LAST - 1))) ||
+	       (ops->pf == NFPROTO_BRIDGE &&
+		(ops->hooknum == NF_BR_POST_ROUTING ||
+		 ops->priority == NF_IP_PRI_CONNTRACK_CONFIRM));
+}
+
 static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nfqa[],
@@ -1802,10 +1818,29 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 	if (nfnl_ct->parse(nfqa[NFQA_CT], ct) < 0)
 		return NULL;
 
-	if (nfqa[NFQA_EXP])
-		nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
-				      NETLINK_CB(entry->skb).portid,
-				      nlmsg_report(nlh));
+	if (nfqa[NFQA_EXP]) {
+		const struct nf_hook_entries *hooks;
+		struct nf_hook_ops **ops;
+		unsigned int i;
+
+		hooks = nf_queue_hook_entries(entry);
+		if (!hooks)
+			return NULL;
+
+		ops = nf_hook_entries_get_hook_ops(hooks);
+		if (!ops)
+			return NULL;
+
+		i = entry->hook_index;
+		if (i >= hooks->num_hook_entries)
+			return NULL;
+
+		if (nfqnl_hook_exp_support(ops[i])) {
+			nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
+					       NETLINK_CB(entry->skb).portid,
+					       nlmsg_report(nlh));
+		}
+	}
 	return ct;
 #else
 	return NULL;
-- 
2.47.3

