Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EAA4398ED;
	Mon, 10 Aug 2026 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388811; cv=none; b=Surr2HnPjiyIWr5zU8zR8JTTaC0lXaa2hBrXo1rSTL1Adt7n/mJYgcGmAhoFxAzjkyMZkvigp3RMmxBMTBplXcO4ihY3+N4RaEMuerKU9S3QERw4MdpVLaj57OP/tgi9hHuibPickH3i7pJANJBA+VJICK7xULb5vK5r+1ZpTm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388811; c=relaxed/simple;
	bh=It4zNg+yEZG5oQGX8ot/c/jijGbLPUuypmWD9AIhRf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jCh3magRbBJi0f+a32Sjhq5I3ANlkLxJM1mlUtPLlmwxoFqlWYqbr0zxjrl9IWawuhWrNyV2NxgdY8sO9EM/qXsO3t96Q9BZlAQMVCi2Ezajcpcg6VstKVpZO57MtIZHFxzvC8bKn0eUu7phSdbGN73jHnRJRagO9O8xNt35d4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VLqCVNvy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VLqCVNvy"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 61A506028E;
	Mon, 10 Aug 2026 21:06:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388808;
	bh=v988Iog1h9uF2SxdgCbWCzeRIXa98D8MWl7kjSVnZig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLqCVNvy5ty+49QVrlQRuCtFMIyhhxjKOLlTsTD2uAyry+SUL9Igmb5XTu+rg4f3L
	 9u9LcvbcJrSvGpTYQcVHeKNmf6xOUdb+YplOjWJ7/oPLdG+C/mSb0yTGvxmAY7VhA4
	 Nt1/0iFpSldvgLx4hulS6ZUEz/NRm4na89bpDduJ47Js94srg6R2oGUwetK8JWjtGq
	 84ENZm7kQDTKG7hfp3wPtC/p2mNiPyx44CdrcxyzPW00RvtjwXDnd6jTFWtv5fgQ6c
	 CfHO/99APsjV4PVzZOCDC8StIiudEZ4mg9+o6LgcrBlQOAjSJTquV4YQBref3/1i6k
	 7aIJ1DE1KVBIw==
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
Subject: [PATCH net 11/13] netfilter: flowtable: publish GC-visible tuple last
Date: Mon, 10 Aug 2026 21:06:19 +0200
Message-ID: <20260810190621.894119-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810190621.894119-1-pablo@netfilter.org>
References: <20260810190621.894119-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

nf_flow_table_iterate() only treats original-direction tuple nodes as
owning entries. Publishing the original node first lets GC observe and
free a flow while flow_offload_add() is still inserting the reply node.
Publish the reply node first and the original node last so GC never
sees a partially installed flow.

KASAN can trigger slab-use-after-free read and write reports in the
flowtable/rhashtable path (rht_deferred_worker, jhash, flow_offload_del,
flow_offload_lookup, etc.).

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Assisted-by: Codex:gpt-5
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b66e65439341..8b1165f2b5a4 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -332,17 +332,18 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
 
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
-				     &flow->tuplehash[0].node,
+				     &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 				     nf_flow_offload_rhash_params);
 	if (err < 0)
 		return err;
 
+	/* GC only iterates original-direction entries; publish original last. */
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
-				     &flow->tuplehash[1].node,
+				     &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
 				     nf_flow_offload_rhash_params);
 	if (err < 0) {
 		rhashtable_remove_fast(&flow_table->rhashtable,
-				       &flow->tuplehash[0].node,
+				       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 				       nf_flow_offload_rhash_params);
 		return err;
 	}
-- 
2.47.3

