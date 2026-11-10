Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316013;
	b=urGu52X0qgu4EvwoboUaWqB2FtcAfcBVRlyNF3nYFNQoiaT5bNpRsEHyDpPGuwJeQXgC
	 pLHw9IzAq+JYhev5gGC+3fNVbF0B65Y+ZXPPy1tRK7i2GJx4Kxez+jxB6/VrKwkUBRiNr
	 637g1BDWYmUPNXQVNA3iw8sKe1Hteqpk37t2pLKm0fPN8kzQmPKUVuw/ps9mREzpULkkq
	 P+MSsIwdZnQ3syKQslBrxjGu+mMc/exMvbu7mECKYlzwDYJRYuwe6MEiQ615yNBUaDYHM
	 zWKYxkveqbjfzHtuWJJSKhR2cjjbVVoygw2phNdfR8wMOqacxOzogsEjx9EWUd5no+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316013;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=jjF9aQBcmc1rJnzCZYSz/BgGcTDJ6fMIHq7Lm/ywPdI=;
	b=1yWElJeTkTCY3ezaTejZStBcmpm4/+Vy1zo0pN7BCY9XyP1j1gLWpNBpKTrYIg+L0ZMa
	 OPYUYAU4Ub54FRJUo2izbJQ/29H8Q4ewo1Gg0bd/hTS9gp+oKkrW8MPURo1wUp7E4+uiX
	 GmE0R1ZnVe2cN8cWORbIXKW7d8bOrvGX3hvSInbSeNKLuFEqUtdIFB6ZUa1aOPD789SnY
	 sdkJAd5zSiImOvmayz+KfGgvCB8gpEZXxOvRv5Qlyvffmz8EkcBfrKd9psQ1bp5SLmZkc
	 oOF2ii5TizNOZ678qNExdWNjCVq7GOLYKLF+vItwdHNjaQGT8jwZODUYLhik36pivPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=G+wFxcQI;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A82606BFD0
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:06:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2A82606BFD0
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=G+wFxcQI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794316004;
	bh=jjF9aQBcmc1rJnzCZYSz/BgGcTDJ6fMIHq7Lm/ywPdI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=G+wFxcQIKotNcZ06Alb9IZ1+FOhPBKnHeQ/A+B37iwg4tEXuku+PwIWvaddI4pmU5
	 ArfdxtTK+H6znxJjmxJoY6xS0LRsercNgdPLXWo5KkS6Mp2CmXpuzh4fXuEVnkjVma
	 /qLHTGzOJFIAbmKvU3O+SqbmnuawRM8Ud6+U47Pq8J603ti1HT9YJMO0UgQJJVDdMm
	 ooEPpgvqxnMXe5lP+08VX9owJCHTENgzTvfClXm9iHWDUcdbsdt0pJnsz8golX5hGK
	 6H0zmDm9kx/JmdUeggLHP4ECyb+H+/noYQDd1Jw2PUpG5QALbeGUOatuJGsINpM1e2
	 A7LLnXFnE+FSw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B83CE605D2
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 14:06:44 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v5 4/5] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
Date: Tue, 10 Nov 2026 14:06:36 +0100
Message-ID: <20261110130637.1832292-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110130637.1832292-1-pablo@netfilter.org>
References: <20261110130637.1832292-1-pablo@netfilter.org>
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

Use NF_HOOK_OP_CONNTRACK to check this is a conntrack hook, where the
expectation creation for userspace helpers is allowed.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: remove bridge/input.

 net/netfilter/nfnetlink_queue.c | 40 +++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 09af8faf8675..36667a803426 100644
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
 static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
@@ -1816,10 +1829,29 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
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

