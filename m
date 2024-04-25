Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E49312BF22
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 12:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046961; cv=none; b=XrCTcx0DYGQsTQWHGsgT2m7Gq0d4Ia0v/FamLwryyuPQb5Hj6isIoBDUsz8r/RCzikYMIIhVWZjTDjmYvEXXte21zJjWw3ZfT7aMxCQiMq5A/Vr+Vr8munYW+MdLNuX+yCmjRPA8u0bRCmkNQkBRLbQrC3PyTJ/uHHQLCT9hvuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046961; c=relaxed/simple;
	bh=E5QqVxcAEAWwrNYDVnMKZUkdIJjaTPhUaAbYcTARaYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAMZtxV8F86rHdFyyUGhfLWTNdzZhwBshKqc5lIWS+Z2WrE2WEWoEVO4tvulM2rNX/A5YUDWzZRDAk5mIEY3P64+TMalogBfn5A28dJmv82UshFaUV+isNT+m6hmWSzikg4DENTEAZKMKuNkjbyiYwUUHwZUzK7jTCf4V6Cz/D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzxuf-0007ps-Us; Thu, 25 Apr 2024 14:09:17 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 5/8] netfilter: nft_set_pipapo: merge deactivate helper into caller
Date: Thu, 25 Apr 2024 14:06:44 +0200
Message-ID: <20240425120651.16326-6-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240425120651.16326-1-fw@strlen.de>
References: <20240425120651.16326-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its the only remaining call site so there is no need for this to
be separated anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo.c | 39 ++++++++--------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 3e1d44a2b1c1..a922d39f7f25 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1851,52 +1851,31 @@ static void nft_pipapo_activate(const struct net *net,
 }
 
 /**
- * pipapo_deactivate() - Check that element is in set, mark as inactive
+ * nft_pipapo_deactivate() - Search for element and make it inactive
  * @net:	Network namespace
  * @set:	nftables API set representation
- * @data:	Input key data
- * @ext:	nftables API extension pointer, used to check for end element
- *
- * This is a convenience function that can be called from both
- * nft_pipapo_deactivate() and nft_pipapo_flush(), as they are in fact the same
- * operation.
+ * @elem:	nftables API element representation containing key data
  *
  * Return: deactivated element if found, NULL otherwise.
  */
-static void *pipapo_deactivate(const struct net *net, const struct nft_set *set,
-			       const u8 *data, const struct nft_set_ext *ext)
+static struct nft_elem_priv *
+nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
+		      const struct nft_set_elem *elem)
 {
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, data, nft_genmask_next(net),
-		       nft_net_tstamp(net), GFP_KERNEL);
+	e = pipapo_get(net, set, (const u8 *)elem->key.val.data,
+		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
 		return NULL;
 
 	nft_set_elem_change_active(net, set, &e->ext);
 
-	return e;
-}
-
-/**
- * nft_pipapo_deactivate() - Call pipapo_deactivate() to make element inactive
- * @net:	Network namespace
- * @set:	nftables API set representation
- * @elem:	nftables API element representation containing key data
- *
- * Return: deactivated element if found, NULL otherwise.
- */
-static struct nft_elem_priv *
-nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
-		      const struct nft_set_elem *elem)
-{
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
-
-	return pipapo_deactivate(net, set, (const u8 *)elem->key.val.data, ext);
+	return &e->priv;
 }
 
 /**
- * nft_pipapo_flush() - Call pipapo_deactivate() to make element inactive
+ * nft_pipapo_flush() - make element inactive
  * @net:	Network namespace
  * @set:	nftables API set representation
  * @elem_priv:	nftables API element representation containing key data
-- 
2.43.2

