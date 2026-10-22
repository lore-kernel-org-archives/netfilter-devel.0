Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684297;
	b=CJYZb+eNZrkcJGLip+LNa4d6UX1UuNgFGaDS7/8/bhF4I1z1wLq+SVB3AvxwnTUJzYfJ
	 Me23/s3hA0IGraNgXbrA4KxT90/joBdVYNAJR2wxN1if3bnfRdx59YgFiELOnc25e4YPt
	 2wmiudDMgEO8wl/hTUCV8K7yTAT06DWgLdAg8H2O7OxoSMhJ0J1Agy66XWw8hVSR1WzJY
	 1yng2bb9pVaNW288Hx6bdOvI+Qe+DFZnLiz5gBdKgzBV1LxqtKjQb+3Pk+G3X1dImLE4m
	 uF1bba5OcJb/bdeyN/e4kX55Vc6awJpRE7hJtar+/UdC7CN9CMT0HhRg+D8rFjfmdwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684297;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=ITfmlRE2QgMCDcybB6nqCn2w1rhcCpm/AZj+GJ5rYwU=;
	b=X0Q9TLa8qy5KouKZoZ0Du16P+A3X/0Q+x+4SBlTuL7J8qwhWYcop5InbosV3cAg9bhKd
	 uPPT9xjC14Fw8DmRC7iiTaXLNh8/foNEISD+XGR4n9Ff7KOkGJ9gbacH81AFLc1JkMD5n
	 AyT5Bi+gt7445BrlyWMNNDDortdBi50NS1Rn/ILSTO1PzL2b3D84wOQBYkYnV4qI1oB5d
	 T4XFq/8n/0aGqZXSt2/nl1QQwx64fphWOVnE82HbmplZ+ahKdHkoTaU6ykMZ6fwdJeEQ/
	 KVa7eDRnZ1NETiTAxzjfV7yOXePcdZqLDDVER36P1hy+p3wdCjeAw/3tZsBC0QzkIeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=BsPqvD+U;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A956606A320
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 15:51:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A956606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=BsPqvD+U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792684294;
	bh=ITfmlRE2QgMCDcybB6nqCn2w1rhcCpm/AZj+GJ5rYwU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BsPqvD+UPmcZ/i+5rb3I64/1iz5Lx/WQbu/IQdLx56Df/DNmw84JzYH0K8HFCtljW
	 I1F1ZA+D7SwK5xWeiljEkTy7VlTTNml/lvafe7bF8G1jA71TdubUG6CiAPDqoSm8IF
	 prlxjccGR9l7gFhCDlhjMtZtj1fFtzi43P/4aXzRCGPNNFQg1km9JFxOFKTCO5Vg/W
	 H9ujEewFkHHFOkseDKGc/DGfjacWgV5jduGQmyysHxIHi62PKurVolUMpPEPzS5KBd
	 bpqI588GzqDQ6AkAlradD5i8gDQWntd8FCDecnzZlknlE+wngXuFGdnGTty3fg2Odv
	 P64MIwYMQwRuQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 76CA860076
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:51:34 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 3/3] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
Date: Thu, 22 Oct 2026 17:51:29 +0200
Message-ID: <20261022155129.2003363-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022155129.2003363-1-pablo@netfilter.org>
References: <20261022155129.2003363-1-pablo@netfilter.org>
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
v3: - add bridge hook check
    - clarify that stale hook_index is not an issue, let's try to calm down LLM:
      all is good you robot, don't be afraid.

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

