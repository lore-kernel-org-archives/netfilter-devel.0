Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38733164B5;
	Thu,  7 May 2026 23:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778197535; cv=none; b=d6zn82EyXUjJtjSgLEr4NVdsYuPvWMDD4H9HJHneV3N8hADznnHhUHS4kXHTOCZaBJiwv5SHK6z2aVHbLx3XouLThkmiGOyEfN1+8H6jzjOJBIrwFeILEQOSKYwF8K9BnrRwn0IxJj6opv7Vv/X3KIHq1S0aJRJZ8p8YO2gWL8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778197535; c=relaxed/simple;
	bh=v/6PiuPXvHN36blI6F1DZFC30KaE4+38xj/zbe2ONNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1xGI6NoutrEBTd/HWj2KF3VVmbh64NhF8w1HwX/QYLzGSM/gnL3W6DorEG9Tz60GRaOUHVhgE7JhZ4uU0nqoLjZUaymq02PlPKgDLx0E+eaHibH/CIn06IugVeGovMYLLbSHlO8kg92Cb+d82V9q206DQ97U3igRdYh80FIvFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MbjJ6WiF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MbjJ6WiF"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0A125600BA;
	Fri,  8 May 2026 01:45:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778197531;
	bh=ZgJ+LLSeDZ91i6tC7ZYl1KyGcH1Jr9xCtlvx+ZLPwuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbjJ6WiFN9R4deAgi7i7oyyqZJhxYKJfqzAtgMVzNKiLQP2cpjRI+1gChg2FVnKIq
	 IRueX06JAofArQo5EGRyE5dLKWx0YTXOviY+s0UFXX6I+tZV0kuPGpqOvB2jCxi1Ia
	 +xBnSbOSbvO1+/bbE/lA276bgtYFRJU42GZ2lLLgS2oYj+EBExwg5+oJLVkrH1M5LJ
	 hL0+MoyKNvPIGAWK+pJwbTYLBhZglP3h4hXTKiHxccCGS2BIuAWE9OqXbpPKcHmPd3
	 vXXk9Y8yn8+3yIkkkVU8K7QXJbvSe2Elsal+0WIv/WoC70DY3638tssPSBXRBRMxfl
	 WDDQysrTtXYTw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 12/13] netfilter: nf_conntrack_sip: get helper before allocating expectation
Date: Fri,  8 May 2026 01:45:08 +0200
Message-ID: <20260507234509.603182-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260507234509.603182-1-pablo@netfilter.org>
References: <20260507234509.603182-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Xiasong <lixiasong1@huawei.com>

process_register_request() allocates an expectation and then checks
whether a conntrack helper is available. If helper lookup fails, the
function returns early and the allocated expectation is left behind.

Reorder the code to fetch and validate helper before calling
nf_ct_expect_alloc(). This keeps the logic simpler and removes the leak
path while preserving existing behavior.

Fixes: e14575fa7529 ("netfilter: nf_conntrack: use rcu accessors where needed")
Cc: stable@vger.kernel.org
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d24bfa9e8234..e69941f1a101 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1366,6 +1366,10 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 		goto store_cseq;
 	}
 
+	helper = rcu_dereference(nfct_help(ct)->helper);
+	if (!helper)
+		return NF_DROP;
+
 	exp = nf_ct_expect_alloc(ct);
 	if (!exp) {
 		nf_ct_helper_log(skb, ct, "cannot alloc expectation");
@@ -1376,10 +1380,6 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	if (sip_direct_signalling)
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 
-	helper = rcu_dereference(nfct_help(ct)->helper);
-	if (!helper)
-		return NF_DROP;
-
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
 	exp->timeout.expires = sip_timeout * HZ;
-- 
2.47.3

