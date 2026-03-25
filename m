Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D399F38B7C5;
	Wed, 25 Mar 2026 22:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477604; cv=none; b=kdCR4byACnFhV2l8P+ElirDWFOPbIWdX0uzOtpLmbYxfQHkR0VbpkB5AHHS/uEYd1nM+xp+S1X+UgSn533/K/Ah61Q2F69X18Z25JxGJrqw9pSxEnTQIEM/L6Fm4mvGhBFzm9gOTO02sl397cJn9FUJClcCAk1KmEyzBwS1rqLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477604; c=relaxed/simple;
	bh=eB8DTUiEqN019xW+jY9w7FKR/cIYRdOq6iFJK2njVgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d67Snw40CGTQkb/LHdRDsZPSWHHraW8PlO5LjBAbT3tta2b6TV2Z1NMCSs3PJSgA245x5ew270w+m4jLSsyDun/h6BmXRzIeOM3gKoQ4VtnKUK3hiP/msNxDRDK6w4dWawWQX9yC0QuumJP33RP+DdkeKjKC4t9E+H6ak6BurDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mMk+4KOC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mMk+4KOC"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 719956017A;
	Wed, 25 Mar 2026 23:26:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774477599;
	bh=pyZO6aL0NnAibtHpLWCfdpXmz5R7zaZw855RoS7dQpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMk+4KOC+CUvDSE9OaBxkOFPSsh/y4QX6IOBiZ1XPVY8BSZj2rEQ2khKS+g4SjKMG
	 Pu1XnkzaKVCub0NB7trzk457MtNFOxisxdacXYPq1SKiFYc5kiT741NvOK8NZ2UhLf
	 uChrk7UlNU8IBXUUFhDs5xexBW35Naqff/2XXRkDpThES+Mc2ZX4N3P4Djtxz2cx3O
	 VcS2Ax4xQLWN0QtUfkVJJq6yes8pTf7slejgYKbzZPl53dUsB+oLiAMHJIW/kzISKS
	 ehsT5s15RFt9HJwin7G7tvH9ImHPPTxJ6IHo6pgAduLvjsxhy4J1tuOmp755O6yphE
	 GsPdH2BuRknqA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 12/14] netfilter: nf_conntrack_expect: skip expectations in other netns via proc
Date: Wed, 25 Mar 2026 23:26:13 +0100
Message-ID: <20260325222615.637793-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325222615.637793-1-pablo@netfilter.org>
References: <20260325222615.637793-1-pablo@netfilter.org>
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

Fixes: 5a1fb391d881 ("netfilter: netns nf_conntrack: add ->ct_net -- pointer from conntrack to netns")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 29b9d984a990..78270253cca9 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -650,11 +650,15 @@ static int exp_seq_show(struct seq_file *s, void *v)
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

