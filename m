Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E028D39B481;
	Fri, 10 Jul 2026 14:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694277; cv=none; b=GtyeOLaNLDcG06tyTzD4+Xp4qZyRDDcgkCmsPKnLdCdYnaf3zv03Ysfo2QZdr5ZkDP6D0ek0MbQpY7pzUPQjj+Fxbykp7w85f64dJ7YYx/7wZ1uzM1Og6vlzVArMtD5VSW8Z+iSGga9K8OZqKcdQFMQMMQs1iEHRH5f/Xo4cow4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694277; c=relaxed/simple;
	bh=W1Pk5SCMaV9uZyG5tOuXChx3zlQVoIfOF0K2QTSdwok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wab6ZKoCVfnBLvKqWcK7reC1fT5tIaI7cnfiBtpg7uzkWEUJCwDCQ5V4bKr4O+B+ozpcKQ3Z/cW2Bo3KxW52e86/D/2UlOHpBh4OXTqKvCorQDDAdu7b6HiH1c+qxj6YixwSfNkFCDtGhXLhZ//071D49VkhoAXhoOwrZlICOeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 11E6C60503; Fri, 10 Jul 2026 16:37:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 1/9] netfilter: xt_nat: reject unsupported target families
Date: Fri, 10 Jul 2026 16:37:25 +0200
Message-ID: <20260710143733.29741-2-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710143733.29741-1-fw@strlen.de>
References: <20260710143733.29741-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wyatt Feng <bronzed_45_vested@icloud.com>

xt_nat SNAT and DNAT target handlers assume IP-family conntrack state
is present and can dereference a NULL pointer when instantiated from an
unsupported family through nft_compat. A bridge-family compat rule can
therefore trigger a NULL-dereference in nf_nat_setup_info().

Reject non-IP families in xt_nat_checkentry() so unsupported targets
cannot be installed. Keep NFPROTO_INET allowed for valid inet NAT
compat users and leave the runtime fast path unchanged.

[ The crash was fixed via
  9dbba7e694ec ("netfilter: nft_compat: ebtables emulation must reject non-bridge targets"),
  so this patch is no longer critical.
  Nevertheless, NAT is only relevant for ipv4/ipv6, so this extra
  family check is a good idea in any case. ]

Fixes: c7232c9979cb ("netfilter: add protocol independent NAT core")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_nat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index b4f7bbc3f3ca..51c7f7ce88d9 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -26,6 +26,15 @@ static int xt_nat_checkentry_v0(const struct xt_tgchk_param *par)
 
 static int xt_nat_checkentry(const struct xt_tgchk_param *par)
 {
+	switch (par->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return nf_ct_netns_get(par->net, par->family);
 }
 
-- 
2.54.0

