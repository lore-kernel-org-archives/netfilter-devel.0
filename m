Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE5233E375;
	Tue, 25 Nov 2025 22:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764110015; cv=none; b=J775W+lkyykdUF9M5koEhoHzFbVt2zfoqQVQ9eO2hD/ZRM/x1VjXPrfvTu93i2MQrsZnOE/tdgZcq0Uep5iqidQ+PetHbqQZEmJaoTDDIG1MkbxYEW/qv1eD1yczS5P3M6CD06+tF1fq76aZTtA3GtL90j39GQ18iL21UxQostk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764110015; c=relaxed/simple;
	bh=f/nMSGVhSBcLymDcXcjvi1f462+7vd41OW093xRtZHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS7gMnV1yYWbvwBJMJI/aPbj79IidGQY7IUUPzv03BGrbtXLZtcI1uoFRXN55/U9JfJ7RjUeo0ycH75zQuFZFbI5mISqugKyExf7OoQng6tjF/87IHyiGT/ErfcQjzdoJ8OIhlAU4PEAt5yIo69RENYARoYFK9kBqMwqx63s5fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tejFw/Rr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tejFw/Rr"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D5A71602B7;
	Tue, 25 Nov 2025 23:33:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764110012;
	bh=6Jw105fFdZGS8KrL0oHbpuY31pVaj/wCwqCP6OkZadU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tejFw/Rr79wbgiwJbJJXpuDxcc9CCuMQV9bMH7Pulwiv6ymXa36AANG49Ra9Z23z1
	 iBZLrCI8mEfrHT5s/KQfD/02rrBsCu/whAnYkHoDWIFOLQY4eLicAhf911eAcMBcI4
	 lZACihhjrP3QzxQy6jufu/tdopypbuHqIO8uTE+uFqpUwtMXJR6gnm8rxtIDUktwbl
	 osZPAnVEBJ7sCQr1gOzbtS/Vlc8aZqInuYA10+pm4gyC3wiyeH9QvKZMX9XGoWqXE+
	 I2UpC2umMCskLviAkIC5wbLu29nBVwasIoBrnF5w28LUme6bqR6FQgLXHOSniPO9Uj
	 YMISnPEccwbmQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 11/16] netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
Date: Tue, 25 Nov 2025 22:33:07 +0000
Message-ID: <20251125223312.1246891-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125223312.1246891-1-pablo@netfilter.org>
References: <20251125223312.1246891-1-pablo@netfilter.org>
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
index dbaa3051577c..eabce7e141f8 100644
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

