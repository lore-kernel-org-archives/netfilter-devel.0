Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7110125A357;
	Thu, 26 Mar 2026 12:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774529536; cv=none; b=QTlXSh5cqxWT9eiL2J5v5ZuabL84VT2T0e+8lyeudsWrAFPmD+A0eI0y2KHuxiI5xsB1cfUAX2e+8I/ojXAnx/mQG9K3150Yr9EvDoWa4mskoR0l47fQ6hSoLUm0h7rtsgoKz2VG/2BP0qk9tkWhMHpEfTEbSbizFbVg1ZRm5Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774529536; c=relaxed/simple;
	bh=m36HQ+19ZssWkfaGsMyZothAnBVP41gw6eqpJzjoGZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9lm3WCu4n8s6+9T9Fc+MrnEMqW/uEV49K4/OyC+kJGg3Sw+W3cViMAohtCdLJKtjUA1kLdEXw+8RURSMUm9ChsUySkoDYn10tMyrnbLe9RrjeIPnETWBXW01Apc3HGYzO/l0Hsc92no5RMJKP2T9kvw8GVPNyqzFfuvBy2M7Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AuS2kxKW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AuS2kxKW"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6F0DF600B9;
	Thu, 26 Mar 2026 13:52:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774529529;
	bh=mXgMC5zMq/Jg0azTBih3uHFHbM9VtWyIjy7qNUxWoeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuS2kxKWHTnOttWOTcKQMsVEAKNL3T23JiCiQSueuX2hkqPGuoBkpcyLX+LH9TB6q
	 Ez7/OHuTutAD63T8vVqKDfwgpRZ7q80b1NDPCjsBDxvDYONF/oyRadgiZwnr+0n+my
	 UIWTejmL+36s5B/7Fd34P98T1UhzONrs1dUyT2FMF9d0qAhiqJpFZlmhxKko3FMqPk
	 We9oaiAyCGpQ3ylXE+D4xIEjgPG7rMDQZKrwv8YFDmN95KqRMYkjW+D8BNaOPYgX4q
	 vEoWszRJwyWD7njk/s0GoiSREDfZV4bgfnpvwrRZhiYGvqzXEOY/aotYn1SpBMeMJj
	 y9JIynMp69zug==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 10/12] netfilter: nf_conntrack_expect: skip expectations in other netns via proc
Date: Thu, 26 Mar 2026 13:51:51 +0100
Message-ID: <20260326125153.685915-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326125153.685915-1-pablo@netfilter.org>
References: <20260326125153.685915-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip expectations that do not reside in this netns.

Similar to e77e6ff502ea ("netfilter: conntrack: do not dump other netns's
conntrack entries via proc").

Fixes: 9b03f38d0487 ("netfilter: netns nf_conntrack: per-netns expectations")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index db28801b1688..24d0576d84b7 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -652,11 +652,15 @@ static int exp_seq_show(struct seq_file *s, void *v)
 {
 	struct nf_conntrack_expect *expect;
 	struct nf_conntrack_helper *helper;
+	struct net *net = seq_file_net(s);
 	struct hlist_node *n = v;
 	char *delim = "";
 
 	expect = hlist_entry(n, struct nf_conntrack_expect, hnode);
 
+	if (!net_eq(nf_ct_exp_net(expect), net))
+		return 0;
+
 	if (expect->timeout.function)
 		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
 			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
-- 
2.47.3

