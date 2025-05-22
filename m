Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC8C29B231;
	Thu, 22 May 2025 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932797; cv=none; b=QVYbn4VtKVUJ+m8mVzxbCdqkboTKRKluS39ureWuHaizMiSvwSPdpEKQcbmb7pYlkTX2w3Mjccr7idzzTdpDefYZhWwlEa7HJqmnGxLBqnnw58xJRHjWsWfbmHIFr2Vb4MM/ILKx9+veHl2OZVcfmly0X45iX+P2AJgONyje5HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932797; c=relaxed/simple;
	bh=R6lBbr9j7LlwJiLupFk985xmeRLWeRceIxsmZhXILEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IZDR07SVP120GA5+X2A41yz9x/XG4XPYcGVuaaf6nrxgdsUzDXQKCmett60a9w2wau2GDjUcXDUys000o2FReqiBgF94W1M385IiYwLVL5PA7ZSegw+vf583WsAQzOZX92xwtqGh1wgX6pRkifNzLMpa/7rubyDenG39updRRwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iweT76JI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=duSuC89Z; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iweT76JI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="duSuC89Z"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 40920606E9; Thu, 22 May 2025 18:53:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932794;
	bh=7+8rNsQHuGn78VP8QDzb4tbhD/GtmhyAQzafzrrpBPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iweT76JIiBsWkMjsJ1KRFnww5tT2efHKdWcbRkV2HDRhMoT9cnZrpQWyZ2YoHdHGt
	 T4jot5IhYp1FMB2kkxH1CPTM41mXheXjiR/PrN6BrVMRiRtqudE9Ng0I38kgfw3PRd
	 Be7w/hHZmhEoVDOw85i0DryWC4VXnDVXeFR8dweh6Q1dzrOFOTwEnVBoCkuExsF+oX
	 i6jtWzDO+BzMKOp8p4n0Ruzyr5I9ZhJMtZlUITPP9jdaUAxi4LjDI7p5hmLydombtj
	 odwwcgwetH9qVWIt1M4fdn9JbvM6dTL4A7nlniOJwAOW5Fh1LUFJK/0WVRi+QCcWgf
	 BF6xeNpLm/3/w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A2FA060737;
	Thu, 22 May 2025 18:52:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932775;
	bh=7+8rNsQHuGn78VP8QDzb4tbhD/GtmhyAQzafzrrpBPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duSuC89ZbxzU0v5a7SE22J2NnhJBv3cUpViJu51r/79J0OP4lTfvX4Bzttr+fSmGQ
	 0M4coqaoFsIkmDQHzNbPuzhOTBhcjcAdLpXnBPw/HhNya9RRW5LLFz+vcZJUiNHd1J
	 Qn1adxVGDogXsWuQHk9Kl0unwEYv1ZwMxJBcR6JOiL8AYozFiGmf/w0kRxgQfuPoM4
	 q0d1DySZaebJjxqbOY74Nj8Fa5gWlnMAdTOug6Ob9CBRwvSEM0C3tep1J9804WGsel
	 JTUevhws5QTNZbborwgLQHAObbx67Vuqs9/ADeaUu6MqbVbRIFa2NLCcafUvDeR5M5
	 enf5BJMIC5tYQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 12/26] netfilter: conntrack: make nf_conntrack_id callable without a module dependency
Date: Thu, 22 May 2025 18:52:24 +0200
Message-Id: <20250522165238.378456-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

While nf_conntrack_id() doesn't need any functionaliy from conntrack, it
does reside in nf_conntrack_core.c -- callers add a module
dependency on conntrack.

Followup patch will need to compute the conntrack id from nf_tables_trace.c
to include it in nf_trace messages emitted to userspace via netlink.

I don't want to introduce a module dependency between nf_tables and
conntrack for this.

Since trace is slowpath, the added indirection is ok.

One alternative is to move nf_conntrack_id to the netfilter/core.c,
but I don't see a compelling reason so far.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h         | 1 +
 net/netfilter/nf_conntrack_core.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 892d12823ed4..20947f2c685b 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -470,6 +470,7 @@ struct nf_ct_hook {
 	void (*attach)(struct sk_buff *nskb, const struct sk_buff *skb);
 	void (*set_closing)(struct nf_conntrack *nfct);
 	int (*confirm)(struct sk_buff *skb);
+	u32 (*get_id)(const struct nf_conntrack *nfct);
 };
 extern const struct nf_ct_hook __rcu *nf_ct_hook;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index de8d50af9b5b..201d3c4ec623 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -505,6 +505,11 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_id);
 
+static u32 nf_conntrack_get_id(const struct nf_conntrack *nfct)
+{
+	return nf_ct_get_id(nf_ct_to_nf_conn(nfct));
+}
+
 static void
 clean_from_lists(struct nf_conn *ct)
 {
@@ -2710,6 +2715,7 @@ static const struct nf_ct_hook nf_conntrack_hook = {
 	.attach		= nf_conntrack_attach,
 	.set_closing	= nf_conntrack_set_closing,
 	.confirm	= __nf_conntrack_confirm,
+	.get_id		= nf_conntrack_get_id,
 };
 
 void nf_conntrack_init_end(void)
-- 
2.30.2

