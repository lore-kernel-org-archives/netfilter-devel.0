Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1A8421A15;
	Sun, 27 Sep 2026 22:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548490; cv=none; b=ruvIm/3nfkZD5vFIEw3MDV0K/ONXO7Gkd8OoFUWe/j1MmyoodK5zT1WsTxfbxhhg4kXQNEAfoFMCEhO0KthJ2LNrhnkHLJGlA+TV0Wcsjr7yDi7Jv+KDTTr/gVnxy+5jNi9AVTtQLMGUn+UJN8YY9wTjQhR5CwDUoRfIzI4eYVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548490; c=relaxed/simple;
	bh=62JL4b+HPAeJVW1MsD3UgzZHXDBH/4bdO3JOgZG/2ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jar+xOSWMzfbvHVCk3s0Yt/r/b987D8T5+D+mrqA2zBfAKcblUqxGvsEvpuQ/Ks9exMxXkZRZHZod3dYaQS6GyXr9goab34xBsTidcyKxXiH3JksLT045yrU7Oe7w2+SAexo5uVRrBg8Ow4kDGhujhpn5XSAKS+J8TJjbuQnFbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CIxu/rsD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CIxu/rsD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790548486;
	bh=JTg+FejhooZPZLjKd9sSGjAM6rZpOW/XuMYpgbZTbOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIxu/rsDlOQxZLVrVPNIqKpfCNPCYJv3t0ZcXox7DAhot/9Zq5r8cXxiDSxTT6i9A
	 csHlQpHVPCiwXsNrqPrrUE3g4V67xuOuBFcOKLBzfK6R+/eS+trvXsL0uu69lcb5wG
	 23D5w33mXXfNG3NHJtaXeZGDOlztIkUYVcUvWgRv1HRaUSgtvYNmtb5QLeoekDs6ui
	 SDgh6zb6iwzhzUiAb2KT5Mg+jbagwRY1s5KjvQcf6kXruHZAqPlS/iCMThfInsBIdS
	 VXMDeUW4B/gxNAE9G2XT4bmkqkmWd4liVAYp41dk4BiT37kkMd87U9qAGk6aT8yW2j
	 98S8nZw2+W1dA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4AB8A60081;
	Mon, 28 Sep 2026 00:34:46 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 05/11] netfilter: conntrack: Untangle insert_failed counter from others
Date: Mon, 28 Sep 2026 00:34:30 +0200
Message-ID: <20260927223436.269024-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927223436.269024-1-pablo@netfilter.org>
References: <20260927223436.269024-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

There is not much sense in incrementing multiple conntrack counters for
the same situation. Defining insert_failed as a situation where a valid
packet's conntrack can't be confirmed due to unresolvable clash sets it
apart from 'drop' (ENOMEM situation) and 'chaintoolong'.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d0d9e5ea84a0..53401e21ad99 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1169,7 +1169,6 @@ nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h,
 		return ret;
 
 drop:
-	NF_CT_STAT_INC(net, drop);
 	NF_CT_STAT_INC(net, insert_failed);
 	return NF_DROP;
 }
@@ -1259,7 +1258,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		if (chainlen++ > max_chainlen) {
 chaintoolong:
 			NF_CT_STAT_INC(net, chaintoolong);
-			NF_CT_STAT_INC(net, insert_failed);
 			ret = NF_DROP;
 			goto dying;
 		}
-- 
2.47.3

