Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E5847AF45;
	Tue, 20 Jan 2026 19:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768936725; cv=none; b=iacAL4xKfNJuFYjqXxDt7zBZ6fH55KWkQutGljO5mOt03adM7gmjiOw9cS6c9DvaDbG5uzAgT/HJwuMF/8aaZw2V3trgjXm8RKzd5eK2QnAfXYQxI/tXxFZnRTx6VGTp24m9IWX+2m4ygr0PgXpxtL6ElMQSobVejbr4AbeIABo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768936725; c=relaxed/simple;
	bh=fh3ylUracZE3S3+kd/fT7fdkgKwSmLFGvfxPyzGPiho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdaOCLgYrrS56I16KFhfr4jIMIY89w7/3iNRNQ1jpmh2vnJGQawnTDtbAokYmkvQFMobZnCC5zNmnzDIbKdgYtUyAD5DZ3c/hETL5dbT5hNX51eyAlLv6/I6gGmPfTtagGkZXaW4Ms0Y9vk13qufeRwy1a0MespTqHmkK2U9nao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E718A60854; Tue, 20 Jan 2026 20:18:41 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 08/10] netfilter: nft_compat: add more restrictions on netlink attributes
Date: Tue, 20 Jan 2026 20:18:01 +0100
Message-ID: <20260120191803.22208-9-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120191803.22208-1-fw@strlen.de>
References: <20260120191803.22208-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As far as I can see nothing bad can happen when NFTA_TARGET/MATCH_NAME
are too large because this calls x_tables helpers which check for the
length, but it seems better to already reject it during netlink parsing.

Rest of the changes avoid silent u8/u16 truncations.

For _TYPE, its expected to be only 1 or 0. In x_tables world, this
variable is set by kernel, for IPT_SO_GET_REVISION_TARGET its 1, for
all others its set to 0.

As older versions of nf_tables permitted any value except 1 to mean 'match',
keep this as-is but sanitize the value for consistency.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_compat.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 72711d62fddf..08f620311b03 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -134,7 +134,8 @@ static void nft_target_eval_bridge(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_target_policy[NFTA_TARGET_MAX + 1] = {
-	[NFTA_TARGET_NAME]	= { .type = NLA_NUL_STRING },
+	[NFTA_TARGET_NAME]	= { .type = NLA_NUL_STRING,
+				    .len = XT_EXTENSION_MAXNAMELEN, },
 	[NFTA_TARGET_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_TARGET_INFO]	= { .type = NLA_BINARY },
 };
@@ -434,7 +435,8 @@ static void nft_match_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_match_policy[NFTA_MATCH_MAX + 1] = {
-	[NFTA_MATCH_NAME]	= { .type = NLA_NUL_STRING },
+	[NFTA_MATCH_NAME]	= { .type = NLA_NUL_STRING,
+				    .len = XT_EXTENSION_MAXNAMELEN },
 	[NFTA_MATCH_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_MATCH_INFO]	= { .type = NLA_BINARY },
 };
@@ -693,7 +695,12 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 
 	name = nla_data(tb[NFTA_COMPAT_NAME]);
 	rev = ntohl(nla_get_be32(tb[NFTA_COMPAT_REV]));
-	target = ntohl(nla_get_be32(tb[NFTA_COMPAT_TYPE]));
+	/* x_tables api checks for 'target == 1' to mean target,
+	 * everything else means 'match'.
+	 * In x_tables world, the number is set by kernel, not
+	 * userspace.
+	 */
+	target = nla_get_be32(tb[NFTA_COMPAT_TYPE]) == htonl(1);
 
 	switch(family) {
 	case AF_INET:
-- 
2.52.0

