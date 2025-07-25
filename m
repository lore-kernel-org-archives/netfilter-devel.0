Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249CE2EF9B8;
	Fri, 25 Jul 2025 17:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463055; cv=none; b=htFalmUdyYbVeUdiMD5XWi0FW8AZWoGki5bg7GPgpRphUGyKoHVqzt6KOgnzIF9V+eYrkiU81jIOMXFlZRtVQ0oegYpDBvY/qGd+aJmKLXvQ1/vgQKdcbuCMGvk2vQrbwcP2Ce6hBaPzS+aTfvlJRW9sWbvMUyR5dXG8CqEb+rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463055; c=relaxed/simple;
	bh=jr625M2Q0V8kN4yc+sP4NHyBWmTCJS5BSoKsIKVVKx8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oSKa4FUWR1MTuRPNQ3zoXo5HQe+11jX7BZe+vrMMohdLj7538K70VCF76hIiIfNGKXAwVmk6tMnk/A/pgNw1VTo85EfptyatPRgJAOJUJ/CHN820i2M+Y/y+goI6VOXlqSpe+up9KulW2f7naecGpvLmjaS1MxXp+KXiPPkwTM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AwjMG9Mh; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n5mwoZyA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AwjMG9Mh";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n5mwoZyA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C04EE60281; Fri, 25 Jul 2025 19:04:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463052;
	bh=MXH2xRi9JHnlb8QW9IiYDdu+wOAkB91a1Th8fkI7WJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwjMG9MhRYs+xKzG+DJKMwKqm70cWnTQQbA7LZsodv+9S9jDV7NTvqALmNgb04/Om
	 yt7UAHve1ap6NcbChQ+IwuwQcoh1JjZJ2Ahu/7QDtRt6QNcNODMR4oxlNIwym7meNT
	 RA/+p6XhK22Kh8t7YJUWhvuhCjdqHT6TjrPlhqc8o8Akb1cmDNhMbXUqEGqsLnLQml
	 0vzhNIWZVkmRVp7FioKSGqG/ysUHkcKjYKO9TAG3umh65oXY7skapxiUexQRXL4HET
	 TM1PH+I2yMFm/P4+Oy2UhPNbEjDeWlmeBKt+Lcm2LeFbz/gcs7NcT8VOsmq+VZvCBb
	 ie6hSYkDvPr7g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 56F516026F;
	Fri, 25 Jul 2025 19:04:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463049;
	bh=MXH2xRi9JHnlb8QW9IiYDdu+wOAkB91a1Th8fkI7WJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5mwoZyAu9+Tkl87ph+z4r6WWrERjsT/vw9IGTXrQWopcNvvXg7N3YsEzq70lVt47
	 P5qj+Y7FhnJ9NOxvQegHmm/Os8/mHPs6tVrqI7qgnhlFBgc8lqbFVpfLgg1RUepx32
	 xX6iCMaaPstUFC9gBpXRx7ZhR22pMTAowkZXDvw6Us1t3Vux4MO3VH0o2/Vsigl9OX
	 AoanzqserpkkHI5yl9C14s98j2Ia6Zsers5o30QXzgG/v48b/XifkjwrsYuL7E8UWK
	 43/PjJuuwaGXGhCCLGG+b2NtfMus7+EgRM7W5bKltJhDDIBwbtLWncI7epkKHuNmB5
	 lyWQes9QDrHag==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 12/19] netfilter: nft_set_pipapo: remove unused arguments
Date: Fri, 25 Jul 2025 19:03:33 +0200
Message-Id: <20250725170340.21327-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

They are not used anymore, so remove them.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c5855069bdab..08fb6720673f 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -502,8 +502,6 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 
 /**
  * pipapo_get() - Get matching element reference given key data
- * @net:	Network namespace
- * @set:	nftables API set representation
  * @m:		storage containing active/existing elements
  * @data:	Key data to be matched against existing elements
  * @genmask:	If set, check that element is active in given genmask
@@ -516,9 +514,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
  *
  * Return: pointer to &struct nft_pipapo_elem on match, error pointer otherwise.
  */
-static struct nft_pipapo_elem *pipapo_get(const struct net *net,
-					  const struct nft_set *set,
-					  const struct nft_pipapo_match *m,
+static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
 					  const u8 *data, u8 genmask,
 					  u64 tstamp, gfp_t gfp)
 {
@@ -615,7 +611,7 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_match *m = rcu_dereference(priv->match);
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
+	e = pipapo_get(m, (const u8 *)elem->key.val.data,
 		       nft_genmask_cur(net), get_jiffies_64(),
 		       GFP_ATOMIC);
 	if (IS_ERR(e))
@@ -1345,7 +1341,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	else
 		end = start;
 
-	dup = pipapo_get(net, set, m, start, genmask, tstamp, GFP_KERNEL);
+	dup = pipapo_get(m, start, genmask, tstamp, GFP_KERNEL);
 	if (!IS_ERR(dup)) {
 		/* Check if we already have the same exact entry */
 		const struct nft_data *dup_key, *dup_end;
@@ -1367,7 +1363,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 
 	if (PTR_ERR(dup) == -ENOENT) {
 		/* Look for partially overlapping entries */
-		dup = pipapo_get(net, set, m, end, nft_genmask_next(net), tstamp,
+		dup = pipapo_get(m, end, nft_genmask_next(net), tstamp,
 				 GFP_KERNEL);
 	}
 
@@ -1914,7 +1910,7 @@ nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
 	if (!m)
 		return NULL;
 
-	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
+	e = pipapo_get(m, (const u8 *)elem->key.val.data,
 		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
 		return NULL;
-- 
2.30.2

