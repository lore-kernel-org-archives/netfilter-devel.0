Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D593E1C9EB1;
	Fri, 28 Jun 2024 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590728; cv=none; b=U3lzEQMfIFUB+GcmKyHNW6/WE42z6wXmgiPk8hqPr6K1ub1AXZQ1te0ugApR/0C1zak6V0J/c1JTPxzokFm6wiGvJSRvob4M+AMON4rcEFkSmrrtkn8XxTyj96pHRncP2aqhRIfLAduK8Btrf+SNeT9KveA6rfMxKwff8mm7siA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590728; c=relaxed/simple;
	bh=KD8knpXBOYQbSVlqs+ARIVBd61NDg66wZcUOPYafw8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VVX5WHU22hNj9azv/9N4qL+KzmV2GdGs32JuBiZqBdFniCBzIdJDLsGO5oLsFYJJurYUbzVQdWCqdbqlU4c7Vkgr4K64Q2gVceP0prc49aQNn417tHsGlpmAP7o+Yc+bvWPpYKUSqm4x0IbrjMExt47Shs3fYG04bMtt7uISpFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 14/17] netfilter: cttimeout: remove 'l3num' attr check
Date: Fri, 28 Jun 2024 18:05:02 +0200
Message-Id: <20240628160505.161283-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240628160505.161283-1-pablo@netfilter.org>
References: <20240628160505.161283-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

After commit dd2934a95701 ("netfilter: conntrack: remove l3->l4 mapping
information"), the attribute of type `CTA_TIMEOUT_L3PROTO` is not used
any more in function cttimeout_default_set.

However, the previous commit ea9cf2a55a7b ("netfilter: cttimeout: remove
set but not used variable 'l3num'") forgot to remove the attribute
present check when removing the related variable.

This commit removes that check to ensure consistency.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index f466af4f8531..eab4f476b47f 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -366,8 +366,7 @@ static int cttimeout_default_set(struct sk_buff *skb,
 	__u8 l4num;
 	int ret;
 
-	if (!cda[CTA_TIMEOUT_L3PROTO] ||
-	    !cda[CTA_TIMEOUT_L4PROTO] ||
+	if (!cda[CTA_TIMEOUT_L4PROTO] ||
 	    !cda[CTA_TIMEOUT_DATA])
 		return -EINVAL;
 
-- 
2.30.2

