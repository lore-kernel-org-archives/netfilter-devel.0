Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B2E6BFA7;
	Thu,  8 Feb 2024 11:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707391723; cv=none; b=bjGjiY4R85vcTydUrN33RzcJUENK/wpJ0R7Gx+Zb2ewh+j5LF2V6C+i6bw0EtPOPXZ7JmEi2GcM2YM7WxDU8SISRnvTUeC7yE5ZOdsLbHDudzaBAA7YklghPJu6NHvnBkCOInt5Xdqwz8FMfb5FkF0uOeJPN96qeAmVzv3pvyR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707391723; c=relaxed/simple;
	bh=dA3bahxcGvS1L3trOq3bDjnN17P1qV1m4b4l7mV4cvE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qis5/jcPjADIylRueBkO4o2quazwxPn2zFqYXG7NCQ7CxG+z7Qp8RP4fsY3l7rlis18V/+I6uEXwRnz34gV9SJRICC1hioiAIj3EmE9dsonLeer2dy2IHPBV7Aho/EK3cZCdZjnfzrQjV4U2Q5j/lXDMFSPK/hSmyF329WlUe2E=
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
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net 03/13] netfilter: nft_compat: restrict match/target protocol to u16
Date: Thu,  8 Feb 2024 12:28:24 +0100
Message-Id: <20240208112834.1433-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240208112834.1433-1-pablo@netfilter.org>
References: <20240208112834.1433-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xt_check_{match,target} expects u16, but NFTA_RULE_COMPAT_PROTO is u32.

NLA_POLICY_MAX(NLA_BE32, 65535) cannot be used because .max in
nla_policy is s16, see 3e48be05f3c7 ("netlink: add attribute range
validation to policy").

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index ed71d5ecbe0a..1f9474fefe84 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -200,6 +200,7 @@ static const struct nla_policy nft_rule_compat_policy[NFTA_RULE_COMPAT_MAX + 1]
 static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 {
 	struct nlattr *tb[NFTA_RULE_COMPAT_MAX+1];
+	u32 l4proto;
 	u32 flags;
 	int err;
 
@@ -218,7 +219,12 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 	if (flags & NFT_RULE_COMPAT_F_INV)
 		*inv = true;
 
-	*proto = ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_PROTO]));
+	l4proto = ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_PROTO]));
+	if (l4proto > U16_MAX)
+		return -EINVAL;
+
+	*proto = l4proto;
+
 	return 0;
 }
 
-- 
2.30.2

