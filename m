Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1453ECBCF;
	Sun, 27 Sep 2026 22:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548493; cv=none; b=dUKIeKPzoJf90GTkwQL4KWhxz1VjUvixK5tq0Aplp3HjkoyO54wBPSrUFyvTO04FadJ5jwm+87+FsPxqhFgmzUna0hJCg3D00RFiDO0NZjOckV9EV26DrsaAuw0IxOgb9fVUYS9GZTqZVV2l1HBJbr13t1QDxwlEanWtqsaNo/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548493; c=relaxed/simple;
	bh=JvN3Mo+FFgKbtsvpL4Q22tqXyjlnOoYcLF+E7yVwxe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLaLV0HZ+UhQwLdoWtgF18ly3JhvfWVT+6qiAfjTLMR0g0c9DACk1j6Oog0jYO+5XooDhGnpUqPukGIehJmABJcfq7Sj3Rrp9HMgsY9WbQ/C+xyGjbZzgNzEaRWx4e9ukE32ecKxGJIye1EiozkHgUiv88vZ1gvH/XB5TWlzGGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SrlPkHGm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SrlPkHGm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790548490;
	bh=ybcY8mDFhtnr6cIiBZkeE0TlliVQHUxT11CHx5EkqfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrlPkHGmWjFckfWUYtuSxvcihZUaEolhG4JnZ14c4aBI/JR96F8g+i7cFULwiUkHb
	 zTrREfbLeY0JY7GssuJtJRgllJ1GlGbvU0vFrzksPuLBzNXQFrCUeBgvLGTUnjCXAK
	 4xMwUIhBZY4jGTq9yjFpknZrSLAyLfKGShkrZXynytNhRVR+AUeRPV4+2QFdXWOlGN
	 +dt+TLAP3TQ8VrZs37yu73v3+mgOf4hAoy2kRRneB55TrYz4HTo9kgFyk+uHZrKOQ7
	 aHNBCZBaZZ5CyaLcm97ejPk0Xir5NQbphF9AwX3mn9vELbtG8ppN+F75j3bg6h+Uus
	 NmDgeB5LTMSVw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C80D960058;
	Mon, 28 Sep 2026 00:34:49 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 08/11] netfilter: flowtable: check namespace before iterating flows
Date: Mon, 28 Sep 2026 00:34:33 +0200
Message-ID: <20260927223436.269024-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927223436.269024-1-pablo@netfilter.org>
References: <20260927223436.269024-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qingfang Deng <qingfang.deng@linux.dev>

nf_flow_table_cleanup() walks every registered flow table, checking the
network namespace for each flow in nf_flow_table_do_cleanup(). As a
result, tables in other namespaces are still iterated and their cleanup
work is flushed.

Compare the flow table's namespace with the device's namespace in
nf_flow_table_cleanup() and skip nonmatching tables. This avoids
unnecessary iteration and work flushing, and leaves the per-flow cleanup
callback to check only the interface index.

Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 934c6151f558..bd8f9cf394ff 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -737,14 +737,9 @@ static void nf_flow_table_do_cleanup(struct nf_flowtable *flow_table,
 {
 	struct net_device *dev = data;
 
-	if (!dev) {
-		flow_offload_teardown(flow);
-		return;
-	}
-
-	if (net_eq(nf_ct_net(flow->ct), dev_net(dev)) &&
-	    (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
-	     flow->tuplehash[1].tuple.iifidx == dev->ifindex))
+	if (!dev ||
+	    flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
+	    flow->tuplehash[1].tuple.iifidx == dev->ifindex)
 		flow_offload_teardown(flow);
 }
 
@@ -761,8 +756,10 @@ void nf_flow_table_cleanup(struct net_device *dev)
 	struct nf_flowtable *flowtable;
 
 	mutex_lock(&flowtable_lock);
-	list_for_each_entry(flowtable, &flowtables, list)
-		nf_flow_table_gc_cleanup(flowtable, dev);
+	list_for_each_entry(flowtable, &flowtables, list) {
+		if (net_eq(read_pnet(&flowtable->net), dev_net(dev)))
+			nf_flow_table_gc_cleanup(flowtable, dev);
+	}
 	mutex_unlock(&flowtable_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
-- 
2.47.3

