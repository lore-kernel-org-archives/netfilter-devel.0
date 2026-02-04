Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D93A33F384
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 20:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770236833; cv=none; b=Sn6RIq6OAErReQKhK4LnU0oDNVpQmlMA2LgnJp5kZoRut/nFnxAvYcFeFnTDXpQcuQEOKI04PrDPeoi6BTn17Sf2r/3zvghFy6MQ+a71qCVeuoy/Ub4xQjHsUjmH9y0MqR9+V1Bchl/1Wgltzbjq8uhN/dwjMrfwamYHrfwkHqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770236833; c=relaxed/simple;
	bh=PU2/zswLMM2a2kN+7WJFEIhX6qssAixUPA1cbc62SWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdQTxtVDFrFHI3jtYdq/nAPJc/LsKFfIXiTuIFOvzahGmVI37SDXunQCPUpkq49Pli41qw7cH5KroORbhu+hrSj4Qotzw026M24nsUWGV27wxZRUb1CSYHcZ4qIPVp9FqNzwPzjYtX3IWqShTmWU1iwgwkIYNl9k9Ze3S//qZt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=so2NbVPh; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="so2NbVPh"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id C60DD4943;
	Wed,  4 Feb 2026 21:27:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770236831;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lAdoLSjN577YL6vXIxgVtEAj65AkYV9N6iZMxCQPyYo=;
	b=so2NbVPh4lSZ3FnuKyZK7QhR73n4n/hBEOhTC8ZLtTNjktGMd65OtoD213s5OFyl
	0LpzF7rkEZ051JqSTFn+HVZ+76sub9OUaDIZR2UX+oQ+9ZJUIi/EHFj/NlfY3Yypilb
	cs48/56NDCXmHOlr/Af0gSxnOINVPL1yyCCRuN9HKOTspLCl1FiACM/8hG8yw4MrvUw
	Z7/ujf0LLAg4HmeE1D0zepwimpdU3klQ+PESuaFLVjYOIOiF5Tfa8kV+OjNX36ZpTZj
	Kv7Wsqs61HapEjOgQCvQz4Ms4RUI1GpiY46MLtCc+Syvfs3FP7YUsvy5H3omfmGA4d8
	CWlTMxvRJQ==
Received: by smtp.mailfence.com with ESMTPSA ; Wed, 4 Feb 2026 21:27:08 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>
Subject: [PATCH v5 nf-next 2/3] netfilter: nft_counter: serialize reset with spinlock
Date: Wed,  4 Feb 2026 14:26:37 -0600
Message-ID: <20260204202639.497235-3-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260204202639.497235-1-brianwitte@mailfence.com>
References: <20260204202639.497235-1-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

Add a global static spinlock to serialize counter fetch+reset
operations, preventing concurrent dump-and-reset from underrunning
values.

The lock is taken before fetching the total so that two parallel
resets cannot both read the same counter values and then both
subtract them.

A global lock is used for simplicity since resets are infrequent.
If this becomes a bottleneck, it can be replaced with a per-net
lock later.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
---
 net/netfilter/nft_counter.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 0d70325280cc..169ae93688bc 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -32,6 +32,9 @@ struct nft_counter_percpu_priv {
 
 static DEFINE_PER_CPU(struct u64_stats_sync, nft_counter_sync);
 
+/* control plane only: sync fetch+reset */
+static DEFINE_SPINLOCK(nft_counter_lock);
+
 static inline void nft_counter_do_eval(struct nft_counter_percpu_priv *priv,
 				       struct nft_regs *regs,
 				       const struct nft_pktinfo *pkt)
@@ -148,13 +151,25 @@ static void nft_counter_fetch(struct nft_counter_percpu_priv *priv,
 	}
 }
 
+static void nft_counter_fetch_and_reset(struct nft_counter_percpu_priv *priv,
+					struct nft_counter_tot *total)
+{
+	spin_lock(&nft_counter_lock);
+	nft_counter_fetch(priv, total);
+	nft_counter_reset(priv, total);
+	spin_unlock(&nft_counter_lock);
+}
+
 static int nft_counter_do_dump(struct sk_buff *skb,
 			       struct nft_counter_percpu_priv *priv,
 			       bool reset)
 {
 	struct nft_counter_tot total;
 
-	nft_counter_fetch(priv, &total);
+	if (unlikely(reset))
+		nft_counter_fetch_and_reset(priv, &total);
+	else
+		nft_counter_fetch(priv, &total);
 
 	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(total.bytes),
 			 NFTA_COUNTER_PAD) ||
@@ -162,9 +177,6 @@ static int nft_counter_do_dump(struct sk_buff *skb,
 			 NFTA_COUNTER_PAD))
 		goto nla_put_failure;
 
-	if (reset)
-		nft_counter_reset(priv, &total);
-
 	return 0;
 
 nla_put_failure:
-- 
2.47.3

