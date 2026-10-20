Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792518368;
	b=QjHEXf0iA+C7Gh9CjICQnkQ6Z6VvnaEC1J0gjglVBFI/LRp+hQGZiRCmk5Pwh2szI/w5
	 RXHsUepyJ8cR7TinkEXxriF8Cua2etsnLexi5UGDcw6qXzEBKwTCaaUzc1TizdiSxGnP8
	 ZWx7kN3AOXI7WWku0h7gPR+7bBxWT2VynJcGWJWwgFhH0XrFEd2VQ2XSeR96zRuodYj0m
	 aVe96uM8d+6i1V7nvtA/W3VUjnu28B07FBbBOmo8lD1bH3laomdKXkj80KmEGOVJjyAK0
	 xs2P1Ysc1Xx7qLFkIc/JxWzLpvsAHjRcuvNYlVhGLT7n01F0zBicM9tT7/BBqQFJOEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792518368;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=YtKOMdcWp8rW1xUUabByq1AVOYlX3gNhKmXaeudAKN0=;
	b=OWY6xEftMk4mxqKxW9EVC5SpzK7/n5cH4qeOLoSdFt2keU+w/6na3ikFzBDHN5xfOdRW
	 emQsLAKlrz+WhNv1m4M/NjqXM2LHxkTagMyUdAS/LC+ZDoVMZnG2qA0O3/HYXspxwKqoo
	 rApqL1q2WrMEmBVLU2lziJOXr3Cm+GKCX5yJJOVwCFs9hZ9aAQAEioL64HDykt6hLAwnM
	 Sj1ptHqinirBMjAe3Wf1q12Miqk2kixQM7Sp3AVhRqr5W2c3qhRnp0zCTgxlxNm3MMDNW
	 wAGTF8lGIEwd+5NKZ4g9ndvnZorl7WUfrF1SNXmJcTILr0QMFDKnqxV1myO80DXMb8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mv3D+O4i;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18228606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 17:46:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18228606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mv3D+O4i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792518365;
	bh=YtKOMdcWp8rW1xUUabByq1AVOYlX3gNhKmXaeudAKN0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mv3D+O4iRdDwIv1H1cRufdynJ3/RN4/zrJAQGKxgk0kHNzDhZxZkufDIUOPnBOU4p
	 6gYkjm1pG4hfbZrNUE6rX8kGIivQfjYVL0dRGufzzN9h6hq80+IB4FVaDTV4OwN3jr
	 rqIUqGw+NLVp6fuzzbK8O8HHYLt/QtSJkSXPaiXWat2zcIaqotpxTTV3XstFbAaAHd
	 TA42ZAMcGuUvZWDoIUqEHIOUy9bmU5haMr/J/4VYqORPGipjYVgmvTREsyEfLI/V7N
	 R4nF62+WaVUd09sb2gX6ONksiKEJ3u6cWO5Lr8uyShvk9fPV7waAVUe7JlS35zPszm
	 p8SV6ul0JMS0A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 418686007B
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 19:46:05 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 2/2] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
Date: Tue, 20 Oct 2026 19:45:58 +0200
Message-ID: <20261020174558.1922531-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261020174558.1922531-1-pablo@netfilter.org>
References: <20261020174558.1922531-1-pablo@netfilter.org>
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
helpers, which create expectations in the postrouting hook with priority
NF_IP_PRI_CONNTRACK_CONFIRM.

Restrict this feature to userspace conntrack helpers.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: refine hook check for ipv4 and ipv6.

 net/netfilter/nfnetlink_queue.c | 35 +++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index bd3567f29752..728b4041890a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1795,10 +1795,37 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
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
+		if ((ops[i]->pf == NFPROTO_IPV4 &&
+		     (ops[i]->hooknum == NF_INET_POST_ROUTING ||
+		      ops[i]->hooknum == NF_INET_LOCAL_IN) &&
+		     ops[i]->priority == NF_IP_PRI_CONNTRACK_CONFIRM) ||
+		    (ops[i]->pf == NFPROTO_IPV6 &&
+		     ((ops[i]->hooknum == NF_INET_POST_ROUTING &&
+		       ops[i]->priority == NF_IP6_PRI_LAST) ||
+		      (ops[i]->hooknum == NF_INET_LOCAL_IN &&
+		       ops[i]->priority == NF_IP6_PRI_LAST - 1)))) {
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

