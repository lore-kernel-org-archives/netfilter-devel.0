Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 893CB15BF;
	Thu, 22 Feb 2024 00:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560533; cv=none; b=FeBThRDdPSCCnQ89G4n09tM/hWV2LRpTjFqsp/K16f8EAkt9nhow5tKoFvtmz6RZT5SF1nta56ScmFMS5L0Rn0fTdJvFHhczbD/1JOXHaxzeaCu6oOSn87e/5n1FdYtUYni5iQnD9LU3SW9rAzq3evXGacFZ7gR4NXId0BlO0D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560533; c=relaxed/simple;
	bh=fZYI1Wm9etnD2oj49LBXnVNWbYUn3Tis4ha0K+VZ/Gk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xg6ccZj/Z+crfokdzYx5VKn1Jn7hYcMyMbBCpdnV/BqV/rJHZlbQ2SdlV6V+eYDiRoVrVKm3nzzTAINrbZcT0IB264v/JZ5rCBjNfrNr2IXb2rdW23QfmparGz4bGA6R+rbVWKozqSkfKfQqSMXM0cAzx+osqLNyEzlOanQ+HzU=
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
	fw@strlen.de
Subject: [PATCH net 2/5] netfilter: nft_flow_offload: reset dst in route object after setting up flow
Date: Thu, 22 Feb 2024 01:08:40 +0100
Message-Id: <20240222000843.146665-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240222000843.146665-1-pablo@netfilter.org>
References: <20240222000843.146665-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dst is transferred to the flow object, route object does not own it
anymore.  Reset dst in route object, otherwise if flow_offload_add()
fails, error path releases dst twice, leading to a refcount underflow.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  2 +-
 net/netfilter/nf_flow_table_core.c    | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 956c752ceb31..a763dd327c6e 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -276,7 +276,7 @@ nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 }
 
 void flow_offload_route_init(struct flow_offload *flow,
-			     const struct nf_flow_route *route);
+			     struct nf_flow_route *route);
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 920a5a29ae1d..7502d6d73a60 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -87,12 +87,22 @@ static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple)
 	return 0;
 }
 
+static struct dst_entry *nft_route_dst_fetch(struct nf_flow_route *route,
+					     enum flow_offload_tuple_dir dir)
+{
+	struct dst_entry *dst = route->tuple[dir].dst;
+
+	route->tuple[dir].dst = NULL;
+
+	return dst;
+}
+
 static int flow_offload_fill_route(struct flow_offload *flow,
-				   const struct nf_flow_route *route,
+				   struct nf_flow_route *route,
 				   enum flow_offload_tuple_dir dir)
 {
 	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
-	struct dst_entry *dst = route->tuple[dir].dst;
+	struct dst_entry *dst = nft_route_dst_fetch(route, dir);
 	int i, j = 0;
 
 	switch (flow_tuple->l3proto) {
@@ -146,7 +156,7 @@ static void nft_flow_dst_release(struct flow_offload *flow,
 }
 
 void flow_offload_route_init(struct flow_offload *flow,
-			    const struct nf_flow_route *route)
+			     struct nf_flow_route *route)
 {
 	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_REPLY);
-- 
2.30.2

