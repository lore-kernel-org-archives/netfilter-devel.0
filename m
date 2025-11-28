Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955292139C9;
	Fri, 28 Nov 2025 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289450; cv=none; b=fHp3CuHgIqIQ0iBAOKAVejV5jYLG18Df2n32CyRiSYLPbA1XEKbo9TPq+0znH34GuYyy8Zt8ZB0CIXCE1XpMjRm9arrKvz8QUAg5WwsH7QQ+ULhuZPzDKdxqif6m/UijyhBY9oYL0H6Lf+nSdi0Ye8KmS8lYq8nc9MFpXjuXgFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289450; c=relaxed/simple;
	bh=Y/u2mwTTjCZn1x7AzoxstcUI+eh22L7duqyGqlfyliU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/prRRfsVZiYPQtz0qd5S8WfDqhd8BDEk72FCs9NPj+W77uEo70r+HEgX6qe2/vOx5JN6YUXC2dNLGFcKFqjusXfGMh5m1sMC3uJpAb04UmeWiQ9PF5jCbCAao+5XqK7ZPMVh33sqBReNRgeAmhTX7qM8TE15/1MQt+yrLdIc/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WGODBgYc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WGODBgYc"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2AC7060278;
	Fri, 28 Nov 2025 01:24:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289445;
	bh=fyu4uRHrTtm/iSiWqyhDv4ZWEJJjqxifFtTWvRy1liU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGODBgYcRpeZ9wazsNi1Ygp13wnsuTPBfX79g1iWCpgXtXNY1qsJAaRCxhV+Sy75H
	 bErUPuF70eyPl5nDkX/YWGkjM7B8UlwUhHpPQpI7EGFingFY/dvnlBTUR9TlB1ObNd
	 vMBUIgMM2vDPxFUd12rFkZPBy/mLGtr20jHRqfb1rC/EOXVXbq26c5IuFqq4EkBNkS
	 6bR18QhZQ/AxrSNxQJIIx69c2a3lC/gfVwEeZGmF+a0286a6ogTE2lSG1yXH+K8xhi
	 gmf9XapMcoAzIP3LGFx3Ll72d2dwWU3GFWftTZs3wYh0t/sQJO5Kp7pTUWG0faVdbD
	 nKZ28pBAtJGYQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 12/17] netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
Date: Fri, 28 Nov 2025 00:23:39 +0000
Message-ID: <20251128002345.29378-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

For convenience when performing GC over the connection list, make
nf_conncount_gc_list() to disable BH. This unifies the behavior with
nf_conncount_add() and nf_conncount_count().

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c  | 24 +++++++++++++++++-------
 net/netfilter/nft_connlimit.c |  7 +------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 0ffc5ff78a71..d8893e172444 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -278,8 +278,8 @@ void nf_conncount_list_init(struct nf_conncount_list *list)
 EXPORT_SYMBOL_GPL(nf_conncount_list_init);
 
 /* Return true if the list is empty. Must be called with BH disabled. */
-bool nf_conncount_gc_list(struct net *net,
-			  struct nf_conncount_list *list)
+static bool __nf_conncount_gc_list(struct net *net,
+				   struct nf_conncount_list *list)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn, *conn_n;
@@ -291,10 +291,6 @@ bool nf_conncount_gc_list(struct net *net,
 	if ((u32)jiffies == READ_ONCE(list->last_gc))
 		return false;
 
-	/* don't bother if other cpu is already doing GC */
-	if (!spin_trylock(&list->list_lock))
-		return false;
-
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		found = find_or_evict(net, list, conn);
 		if (IS_ERR(found)) {
@@ -323,7 +319,21 @@ bool nf_conncount_gc_list(struct net *net,
 	if (!list->count)
 		ret = true;
 	list->last_gc = (u32)jiffies;
-	spin_unlock(&list->list_lock);
+
+	return ret;
+}
+
+bool nf_conncount_gc_list(struct net *net,
+			  struct nf_conncount_list *list)
+{
+	bool ret;
+
+	/* don't bother if other cpu is already doing GC */
+	if (!spin_trylock_bh(&list->list_lock))
+		return false;
+
+	ret = __nf_conncount_gc_list(net, list);
+	spin_unlock_bh(&list->list_lock);
 
 	return ret;
 }
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 5df7134131d2..41770bde39d3 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -223,13 +223,8 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
-	bool ret;
 
-	local_bh_disable();
-	ret = nf_conncount_gc_list(net, priv->list);
-	local_bh_enable();
-
-	return ret;
+	return nf_conncount_gc_list(net, priv->list);
 }
 
 static struct nft_expr_type nft_connlimit_type;
-- 
2.47.3

