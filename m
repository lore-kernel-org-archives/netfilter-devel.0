Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63C9493D35;
	Wed,  9 Sep 2026 22:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992351; cv=none; b=ZgZNdTb/JQ5fvDovYbKMZutTQsJLbHHy431vfLsSPlsaTanyXoDz0mqbCPSJKNYojqkvRPBLb4luXv/QhywUcHluZLplV2P/Tpy57ClTcSjFHmkPLmpdLJU6+LqjbqnTyCbZTAeqP8gB9XGoT5wv1+VzHuBe6765JHHiptcFYG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992351; c=relaxed/simple;
	bh=3IIYPdwmcth8l5tcNbFybsOMotg7dFDmnfMe+EEsGg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=At+j9v3Jx2AiV8c+NDImrF71MOvyRG6u7m93WtB8BlJ6Zk58gaMj5Nu12+CW8IXzjra11igNOoQFiQgBNn55fmKahhNxblVjxyUGfur4Esx63S8ZbVeF8Ft6ObqhkYS2woc0LeZzbUMvMzKffW6xSiP4Cuv7L9tTiMni94QiUTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W3kbKjCy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W3kbKjCy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788992338;
	bh=3aHUdJCKJcMEyuP+fFCs/7MfU46x4lzn+N6U8/PHk2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3kbKjCy1jKTWWmboptYHVzahRIFxnapyQUGaZEZznOuOQtrmw7pejwE7/iyVqNRU
	 gqO+xnOWM8+Kat0kx5IPjCknt6YbfRk6s/1+j6PIGiWXMcT4VADNO615/ah0NnM/Zk
	 gNs3vpAhKA2cBzQbjXRt0gXew3n5x+8qdyE5HUqU3uupUWPhJmG3mFV7bos0RroXDe
	 lZl2wBnLuzB5rznXqdCmbp1at9pqQaNboULwruQSmTndkIXU6WzmUoCvlZxN4iS9HP
	 IQRAoeWDx/pyL3nW19Uj+osXpDWC6ArsyczmsBLKtG10L47G+jN9vjfH11Qk1UI88Y
	 rZRy8lbs56d/g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0E6E3607C3;
	Thu, 10 Sep 2026 00:18:58 +0200 (CEST)
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
Subject: [PATCH net 5/7] netfilter: flowtable: hold reference on ct until flow is released
Date: Thu, 10 Sep 2026 00:18:42 +0200
Message-ID: <20260909221844.1650275-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909221844.1650275-1-pablo@netfilter.org>
References: <20260909221844.1650275-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_ct_put() releases the ct->ext area inmediately, the rcu typesafe
semantics also allow to refer to the wrong conntrack from the flowtable
datapath. Hold reference on ct until flow is released after rcu grace
period.

Fixes: 0ff90b6c2034 ("netfilter: nf_flow_offload: fix use-after-free and a resource leak")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 03241d4bfd5e..141502081784 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -258,6 +258,14 @@ static void flow_offload_route_release(struct flow_offload *flow)
 	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_REPLY);
 }
 
+static void flow_offload_free_rcu(struct rcu_head *rcu_head)
+{
+	struct flow_offload *flow = container_of(rcu_head, struct flow_offload, rcu_head);
+
+	nf_ct_put(flow->ct);
+	kfree(flow);
+}
+
 void flow_offload_free(struct flow_offload *flow)
 {
 	switch (flow->type) {
@@ -267,8 +275,7 @@ void flow_offload_free(struct flow_offload *flow)
 	default:
 		break;
 	}
-	nf_ct_put(flow->ct);
-	kfree_rcu(flow, rcu_head);
+	call_rcu(&flow->rcu_head, flow_offload_free_rcu);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
-- 
2.47.3

