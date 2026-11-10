Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271159;
	b=5NbGhud7Ond75YQh/FJMuRbKC6u7mZXBhtMqJAoogzLVOR4SeOtoafitvfBdXpkV6a4g
	 roxnZhWHz1px1c1ybtKrj1bSareOirZEvuW9C+iGY4Q/K4tcvVB74el2N0xjVsejlIEHk
	 kV7p7vF35VNYb3YvSsHotPm0FZ1qI73oo84ueDD0fyHOIEH4bKXkNBgZ9cuLzbRumAkR0
	 MvXn9jTk2C4vhxUtBEzrzZEOrmXU1c5qD/uOotJmzLscztsrnBIbFnhmPm0gb7Y5tiM+i
	 fWFz+nCU9qi2tOmCCFtHc/4u/ElpaQLxYwIUml+vCb98Jxs0bJgW1TM/DxNZlz64mWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271159;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=dl5N38gQaRt2SIblVWUQ5RhrtI6Cef2bcki+TajoirQ=;
	b=prQVji6v+Ff+qQXUeGviMUujfS7QRK44slfLn/GW9KpgqO+A824MXpMPv9OKlJJrqcxy
	 ZcGwzd5n2YQMjASHmmOCH2ja8KiY69OdI0CzrBCKYz/8DCEZcd7rBabP9PEeIPaxjlMp6
	 uiMnYV3NDoZdYOF+DH/bfytZ8n30mzYVj7izdoWwpZXS+BMeV7eFAIaCVsy6hj50ruOMa
	 /sdgkXbS8q5uRS8FHACCGUOhL2S/1ejsIRe5PWoTNlAPe04Klt/mpgxP3M52rLJIRWwQS
	 UBcuCM53p5/1O8tcRhIh4AHBuDTxIODIpr8Vl0G3lV55WLJGy89XLhDDPP1I10WC0bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=cTRxMGKs;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9ED606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 00:39:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E9ED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=cTRxMGKs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794271156;
	bh=dl5N38gQaRt2SIblVWUQ5RhrtI6Cef2bcki+TajoirQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cTRxMGKsIS019q/FOEFNOm3EnTy1L09ceZcncbH1jviERiPk4NSMS3awaFw8KKZ8I
	 kAwHgfdd8SAVgSEl82w7R4YEBelVUD8blRh9Mm8XGmvBUHy6Zmp07I+10SVc2XspY4
	 C3IKPbWX0IaXrozSEgy9ThWWcCsNr3AdGD9wPu3vXTwPGlheNQO5YcQWNlnjEz7yIO
	 EuyuLf6hObKSS8YkQCyUUE6L8vHZJckbdQ8YZO0OadB3SThGGQGW/sdBYqv6uqSghf
	 JsHgIvwbS6im0Cy8UodEBUP3VENcw2sznktRhOqcbl/5Yc9A1/Iko0PMv7WbSQpIGy
	 y0vVEp9ULftFg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9AAED6005D
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 01:39:16 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 4/4] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
Date: Tue, 10 Nov 2026 01:39:09 +0100
Message-ID: <20261110003909.1740094-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110003909.1740094-1-pablo@netfilter.org>
References: <20261110003909.1740094-1-pablo@netfilter.org>
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
v4: use ops->hook_ops_type == NF_HOOK_OP_CONNTRACK check to identify if
    this is a conntrack hook.

 net/netfilter/nfnetlink_queue.c | 39 +++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 09af8faf8675..25a0c55899ca 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1800,6 +1800,18 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
 	return 0;
 }
 
+static bool nfqnl_hook_exp_support(struct nf_hook_ops *ops)
+{
+	return (ops->hook_ops_type == NF_HOOK_OP_CONNTRACK &&
+		(((ops->pf == NFPROTO_IPV4 ||
+		   ops->pf == NFPROTO_IPV6) &&
+		  (ops->hooknum == NF_INET_LOCAL_IN ||
+		   ops->hooknum == NF_INET_POST_ROUTING)) ||
+		 (ops->pf == NFPROTO_BRIDGE &&
+		  (ops->hooknum == NF_BR_LOCAL_IN ||
+		   ops->hooknum == NF_BR_POST_ROUTING))));
+}
+
 static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nfqa[],
@@ -1816,10 +1828,29 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
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

