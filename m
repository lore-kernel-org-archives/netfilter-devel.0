Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347691;
	b=Mks3GAdADFSeruzeFcKORHwRV0ZSOa4HSxQCpikVueriN5ezTLLz3fjbs4a0grDjGA/A
	 SIy/16qLQqFiwLgIy3iIkj6vZX3FUPybp7wT7wl1hFY5SU7VkfRDHB4bSQaSXgc3MvI8g
	 /1JXVHmZUSh+4duAn+y8NGLMjILZjLKtVnVVgjqPkCP9YZZaQZbvLjgztpU1EG3iZanwk
	 j83aFbTsFOH/FowtLmcXsZfdLqGpKanWtjqAPZKVlGxi1FFcjmgh9UFLidun1LboPeM+b
	 ImXU9NMR83GR7fKPiO6pR1/KvJt84Kjq4rCiXDnYG1VB1rV99f+1V6Dgh2umOrGIrcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347691;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=KiRigMNQ0DrDgdfmhQM9ts/ZMAJgzFL9sf2m8k/9r2M=;
	b=kZ7vEmXroTtfydo0nx7w7LMoHZC4a6IUfOTnz1o3h1wSMbfuNn4q2K67jwvOVImjIfeD
	 5tI66Gm/T2R82y6E2owsg9l7Dx4q8g2lgBbZtNFHrj/M9tSHzU8W6Xg9EXZIIt2miQS1S
	 YXuNmmdCQIQC+kTn9+T0AvSGI4odryYpmLrbDif5HloccIcu830Ca5so4pk8bCo3FDdwB
	 1K0Z68rCNb4qxF6PuI3Fiv+OQKj5TX6eKuSpuM5Jaqi6zgLpi17oruTqsoCW0coxyelvV
	 8Kqb72WYuNDT7oANbfl0fVppMyqWazFWD8rcdS5niW91Ie1IVyGppmyaXaqy7soQnsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="ZyQwwz/s";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87233606A321
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 21:54:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87233606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZyQwwz/s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794347687;
	bh=KiRigMNQ0DrDgdfmhQM9ts/ZMAJgzFL9sf2m8k/9r2M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZyQwwz/sguRQ39t1TQvY/DXnzznOJdNc5hjBJhq7yS7Y+t5Soh+jHecbEObBu1JE7
	 qvrvaErELd22MjR/PbbRyGKf6ZVynekkvRW3azByQu3/dHxMM44L5qyxnEQ+sxiEc/
	 BOxRs4KSS9C1WvkrPDEqEIvDJNtPOqkbUWjr930Q11gjKjoWQpqf+iNbazaBKOM3xU
	 wDPqZnmq12hcp/8b+05qKZSUk+xQJLeFvTn3WgZXRnWfesGvwK44FTM3vh+Wtnoxb/
	 Bts2Ur/aTHiD80nMhRg4GXbRFpAAclCHjvLajZFlSuihbTDKyOgxtSGmB9ABNsKGi5
	 Is9cPJBDRvWiA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 16DFD602D4
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 22:54:47 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 5/7] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
Date: Tue, 10 Nov 2026 22:54:37 +0100
Message-ID: <20261110215439.1958120-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110215439.1958120-1-pablo@netfilter.org>
References: <20261110215439.1958120-1-pablo@netfilter.org>
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

Adding expectations to unconfirmed conntracks from any hook is
problematic because of reallocations of the ct extension area can happen
while expectations are placed in the ct extension expectation list.

Note that NFQA_EXP was added with the purpose of supporting userspace
conntrack helpers, which create expectations in confirmation hook.

This patch restricts expectation creation to userspace ct helpers to the
conntrack confirmation hook (ie. NF_HOOK_OP_CONNTRACK), where the
expectation creation for userspace helpers is allowed.

On packet reinjection, hook updates could result in a stale hook_index
that point to different hooks, but this is not an issue because the hook
type is validated.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: rebase

 net/netfilter/nfnetlink_queue.c | 36 ++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7fb6b6b82a24..c6ea584d5e9d 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -381,6 +381,19 @@ nf_queue_hook_entry(const struct nf_hook_entries *hooks,
 	return &hooks->hooks[i];
 }
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+static bool nfqnl_hook_exp_support(struct nf_hook_ops *ops)
+{
+	return (ops->hook_ops_type == NF_HOOK_OP_CONNTRACK &&
+		(((ops->pf == NFPROTO_IPV4 ||
+		   ops->pf == NFPROTO_IPV6) &&
+		  (ops->hooknum == NF_INET_LOCAL_IN ||
+		   ops->hooknum == NF_INET_POST_ROUTING)) ||
+		 (ops->pf == NFPROTO_BRIDGE &&
+		  ops->hooknum == NF_BR_POST_ROUTING)));
+}
+#endif
+
 /* caller must hold rcu read-side lock */
 static void nf_reinject(struct nf_queue_entry *entry,
 			const struct nf_hook_entries *hooks,
@@ -1813,6 +1826,7 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nfqa[],
 				      struct nf_queue_entry *entry,
+				      const struct nf_hook_entries *hooks,
 				      enum ip_conntrack_info *ctinfo)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -1825,10 +1839,22 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 	if (nfnl_ct->parse(nfqa[NFQA_CT], ct) < 0)
 		return NULL;
 
-	if (nfqa[NFQA_EXP])
-		nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
-				      NETLINK_CB(entry->skb).portid,
-				      nlmsg_report(nlh));
+	if (nfqa[NFQA_EXP]) {
+		struct nf_hook_ops **ops;
+		unsigned int i;
+
+		ops = nf_hook_entries_get_hook_ops(hooks);
+
+		i = entry->hook_index;
+		if (i >= hooks->num_hook_entries)
+			return ct;
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
@@ -1913,7 +1939,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	if (nfqa[NFQA_CT]) {
 		if (nfnl_ct != NULL)
 			ct = nfqnl_ct_parse(nfnl_ct, info->nlh, nfqa, entry,
-					    &ctinfo);
+					    hooks, &ctinfo);
 	}
 
 	if (entry->state.pf == PF_BRIDGE) {
-- 
2.47.3

