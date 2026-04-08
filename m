Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8293A1A4D;
	Wed,  8 Apr 2026 16:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775666131; cv=none; b=Egz3sJ1B1Yx117fYvgP5aYoIUOBs8LMmCKykbZZrFXmgbn0nUYhX2w9YQN+ftBefOR+kUhLvHTEalNGDzDIm8o65ssOTfkxSZgFsIYe25O4P7zax0swBuxV3Wu74DxuvlniSsYT/I4yOik1Cl4UL+3g+d8q5Gf5k+b/LPOPJd9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775666131; c=relaxed/simple;
	bh=SjMNDw3SfdzJVLoRRDNS82BHpA3RIY3BkTvJxwqHNiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ks18xNQBdKC6NKyvX525fUK10gkHFvV0OMy2zqawZwSNinW5bMV5g7r3CYA6WqXIsIO+tfYd8Sllt/ncAtOUgdO0ktZE3Y4ZxoIxMesY4cjTgf+NC3gqG3wyPNQqES6PeaZ9BGIqRfxYOBXII9ye1um12/9GTvwZvLhGBYPti8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4BE9360560; Wed, 08 Apr 2026 18:35:28 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 3/7] netfilter: xt_multiport: validate range encoding in checkentry
Date: Wed,  8 Apr 2026 18:35:08 +0200
Message-ID: <20260408163512.30537-4-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260408163512.30537-1-fw@strlen.de>
References: <20260408163512.30537-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ren Wei <n05ec@lzu.edu.cn>

ports_match_v1() treats any non-zero pflags entry as the start of a
port range and unconditionally consumes the next ports[] element as
the range end.

The checkentry path currently validates protocol, flags and count, but
it does not validate the range encoding itself. As a result, malformed
rules can mark the last slot as a range start or place two range starts
back to back, leaving ports_match_v1() to step past the last valid
ports[] element while interpreting the rule.

Reject malformed multiport v1 rules in checkentry by validating that
each range start has a following element and that the following element
is not itself marked as another range start.

Fixes: a89ecb6a2ef7 ("[NETFILTER]: x_tables: unify IPv4/IPv6 multiport match")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yuhang Zheng <z1652074432@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_multiport.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 44a00f5acde8..a1691ff405d3 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -105,6 +105,28 @@ multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
+static bool
+multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
+{
+	unsigned int i;
+
+	for (i = 0; i < multiinfo->count; i++) {
+		if (!multiinfo->pflags[i])
+			continue;
+
+		if (++i >= multiinfo->count)
+			return false;
+
+		if (multiinfo->pflags[i])
+			return false;
+
+		if (multiinfo->ports[i - 1] > multiinfo->ports[i])
+			return false;
+	}
+
+	return true;
+}
+
 static inline bool
 check(u_int16_t proto,
       u_int8_t ip_invflags,
@@ -127,8 +149,10 @@ static int multiport_mt_check(const struct xt_mtchk_param *par)
 	const struct ipt_ip *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count) ? 0 : -EINVAL;
+	if (!check(ip->proto, ip->invflags, multiinfo->flags, multiinfo->count))
+		return -EINVAL;
+
+	return multiport_valid_ranges(multiinfo) ? 0 : -EINVAL;
 }
 
 static int multiport_mt6_check(const struct xt_mtchk_param *par)
@@ -136,8 +160,10 @@ static int multiport_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_ip6 *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count) ? 0 : -EINVAL;
+	if (!check(ip->proto, ip->invflags, multiinfo->flags, multiinfo->count))
+		return -EINVAL;
+
+	return multiport_valid_ranges(multiinfo) ? 0 : -EINVAL;
 }
 
 static struct xt_match multiport_mt_reg[] __read_mostly = {
-- 
2.52.0

