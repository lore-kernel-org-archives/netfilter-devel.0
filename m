Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E74C6BFD8;
	Thu,  8 Feb 2024 11:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707391722; cv=none; b=ps2YYK69xTOuGlkL/b4vCfdCJDaFoAHArCerrJgBsaq5F6f6pdr/BaJNBivcJZJ+sC6F6Udyd8txg/LxHvFiykk05Q4ZiSOrfm9xBSpyRLVdpQTbA/7OAOSEwAG09CYMue5khRjfD2C4N6SfmI4yciovdY+L/QlobZ80wfH282A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707391722; c=relaxed/simple;
	bh=JGqMyZn5PUS5Jyme6daszsMDNgGgUpdJmxZYXdcblb0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=niRERhtLDzBDdA7hWgq6cseskNBOPqv9EWNVGhW2EEQOjGTypkDL+2KHYCK6N0IiPgoabDqWighpy70GLeyaFkhqIgPWRJI6jLDczfdCr2fJ99h42Mqpr/TnHlSUQxt7miivqYSiSOZFkTMi9LrlgCYK7G3tR40B/Ut0CXBteAM=
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
Subject: [PATCH net 01/13] netfilter: nft_compat: narrow down revision to unsigned 8-bits
Date: Thu,  8 Feb 2024 12:28:22 +0100
Message-Id: <20240208112834.1433-2-pablo@netfilter.org>
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

xt_find_revision() expects u8, restrict it to this datatype.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f0eeda97bfcd..001b6841a4b6 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -135,7 +135,7 @@ static void nft_target_eval_bridge(const struct nft_expr *expr,
 
 static const struct nla_policy nft_target_policy[NFTA_TARGET_MAX + 1] = {
 	[NFTA_TARGET_NAME]	= { .type = NLA_NUL_STRING },
-	[NFTA_TARGET_REV]	= { .type = NLA_U32 },
+	[NFTA_TARGET_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_TARGET_INFO]	= { .type = NLA_BINARY },
 };
 
@@ -419,7 +419,7 @@ static void nft_match_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_match_policy[NFTA_MATCH_MAX + 1] = {
 	[NFTA_MATCH_NAME]	= { .type = NLA_NUL_STRING },
-	[NFTA_MATCH_REV]	= { .type = NLA_U32 },
+	[NFTA_MATCH_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_MATCH_INFO]	= { .type = NLA_BINARY },
 };
 
@@ -724,7 +724,7 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 static const struct nla_policy nfnl_compat_policy_get[NFTA_COMPAT_MAX+1] = {
 	[NFTA_COMPAT_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = NFT_COMPAT_NAME_MAX-1 },
-	[NFTA_COMPAT_REV]	= { .type = NLA_U32 },
+	[NFTA_COMPAT_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_COMPAT_TYPE]	= { .type = NLA_U32 },
 };
 
-- 
2.30.2

