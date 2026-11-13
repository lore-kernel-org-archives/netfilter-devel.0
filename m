Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539590;
	b=KFcozFKONHjUeKP9MbNBbUr/4/3uemaKtPOdrQEFgmgDTELw1mCEFib7bNENs0n6Hu2s
	 utYVkkeAcpPbiXJ6aBXpR8pJAiVZsRycwjYkIghyrCt93I5IIhHW/+CfrF3EjmsOE/lN1
	 6hSNecl+fW4bOMJG2vEo85AVWfQ4ExfaV4OhnNfr6G7fnzLtHBALzlwAqSJcQ/jgJW5HG
	 ank5eNnuM7uxMIK1eAfcdYZluKHR8C0s5Z4lec9PH/dsHVzuEzpBZSc8qfi1QhcFHgtW7
	 Qk6rYPednHMARoZS6iydLeGGX0xSTeSv7jVdr1bP/68u0KzUXuIhC1/r2Js/bw+qFJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539590;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=2X/ESR4oJ+B1WlY0s0sl7YqeheiQBxd5Aklrg4+e/XA=;
	b=NC2ign21alyusAbz+hxx7YvkT7gf3ot9AJVxl+HgJBGditnv6YnLlyjaKydxGaSnXV00
	 4MppT5d95hNux2BEvo/Krr+7xHqrPHepD0vNsspI2z/C+9pHmKFjojNe9X6+S/R/o0zIS
	 S3DsP6gqInVWyM6jvvAj+pYUd4rIvkPr3/RiTF3IFo5JI4UBcRknWzNhqsc0S255FX78d
	 lt/HcMEKlX63mmX9+x/2nNZeBp946qrw1ZL54ejwFH2X4HkBUOaEJu0MuYRdBP+w5uWoa
	 RcJbs2qHPXSzLhzqE6XP4Whpzso2XrJAo/JCI3pcVG70R86F2Q9B2yWWNmBEXuEeNvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=oSyRk01Z;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F2260A261D;
	Fri, 13 Nov 2026 03:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28F2260A261D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=oSyRk01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539588;
	bh=2X/ESR4oJ+B1WlY0s0sl7YqeheiQBxd5Aklrg4+e/XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSyRk01Z1/Z47dBPRzIdgQKEczAKF3OcAJ3EClM/dugPFo9Ip5GubhUz7uCwUrJNr
	 J0Pozrw8pUuK/kv9ZqyOVGRKAa6J/5eT+8lixAyiXL8alemeUtPwppqOc8ahqgt2dA
	 ln74LRPFWvU0Ieg06AsAqgcQlIMGz1pf32R4PFi8Q2KZdMitftjLaVmG1PZAE6d27P
	 zOjOEjDnSeLXhjqV0bXg/SVRNxbGHNKQdPOn2CFUBrrpK893UR88vGzTUVksE2XNr0
	 9ct+g7IExT98FlcYlciz8DhS5NXEn4DufKTj/oe/tMxbcbvoNlKWh3JpTgJtNO99Bi
	 oA0gqCYr0BHxQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E5A0E60058;
	Fri, 13 Nov 2026 04:13:07 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 09/15] netfilter: flowtable: purge entries immediately when destroying the flowtable
Date: Fri, 13 Nov 2026 04:12:45 +0100
Message-ID: <20261113031251.2437074-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not use hardware offload workqueue to purge the remaining flow
entries when the flowtable is being destroyed. Instead, iterate over the
flowtable to purge the remaining flow offload entries. Work memory
allocations can fail, leaving us with either waiting indefinitely until
work can be allocated or leaving entries in the hardware.

Given it is possible to encounter either the original or reply direction
when walking down the rhashtable in the destroy path, use the
NF_FLOW_PENDING bit to indicate that the first tuplehash has been
already visited, so this flow can be safely released.

Fixes: c921ffe85333 ("netfilter: flowtable: Fix flushing of offloaded flows on free")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  3 ++-
 net/netfilter/nf_flow_table_core.c    | 29 +++++++++++++++++++++++----
 net/netfilter/nf_flow_table_offload.c | 23 +++++++++++++--------
 3 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5b22d31cb140..9bb46457c192 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -375,7 +375,8 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow);
 
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
-void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
+void nf_flow_table_offload_purge(struct nf_flowtable *flowtable,
+				 struct flow_offload *flow);
 
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2aa2647ed9df..733107180d56 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -770,6 +770,29 @@ void nf_flow_table_cleanup(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
+static void nf_flow_table_do_purge(void *ptr, void *arg)
+{
+	struct flow_offload_tuple_rhash *tuplehash = ptr;
+	struct nf_flowtable *flow_table = arg;
+	struct flow_offload *flow;
+	int dir;
+
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+
+	/* Let the second tuplehash that is seen release the flow. */
+	if (!test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
+		return;
+
+	flow_offload_teardown(flow);
+
+	if (nf_flowtable_hw_offload(flow_table) &&
+	    !test_bit(NF_FLOW_HW_DEAD, &flow->flags))
+		nf_flow_table_offload_purge(flow_table, flow);
+
+	flow_offload_free(flow);
+}
+
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
 	mutex_lock(&flowtable_lock);
@@ -779,10 +802,8 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_offload_flush(flow_table);
 	/* ... no more pending work after this stage ... */
-	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_table_gc_run(flow_table);
-	nf_flow_table_offload_flush_cleanup(flow_table);
-	rhashtable_destroy(&flow_table->rhashtable);
+	rhashtable_free_and_destroy(&flow_table->rhashtable,
+				    nf_flow_table_do_purge, flow_table);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c302051489f2..11434cfb105b 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1181,14 +1181,6 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	flow_offload_queue_work(offload);
 }
 
-void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable)
-{
-	if (nf_flowtable_hw_offload(flowtable)) {
-		flush_workqueue(nf_flow_offload_del_wq);
-		nf_flow_table_gc_run(flowtable);
-	}
-}
-
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 {
 	if (nf_flowtable_hw_offload(flowtable)) {
@@ -1198,6 +1190,21 @@ void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 	}
 }
 
+void nf_flow_table_offload_purge(struct nf_flowtable *flowtable,
+				 struct flow_offload *flow)
+{
+	struct flow_offload_work offload = {
+		.cmd		= FLOW_CLS_DESTROY,
+		.flowtable	= flowtable,
+		.flow		= flow,
+	};
+
+	if (nf_flow_offload_unsupported(flow))
+		return;
+
+	flow_offload_work_del(&offload);
+}
+
 static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 				     struct flow_block_offload *bo,
 				     enum flow_block_command cmd)
-- 
2.47.3

