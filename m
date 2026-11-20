Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795215163;
	b=ZPbHgmZFKehcLT6nsM/w8iydPI89LC6UfbqHUj2HyQpiWwZwTvm4pqs8emojwgLm6Nl1
	 n6m2swnhavMFHOuIOP/g0KFvdGunIDefjuF9WCoQ3OxDj61BRhkKW/bWAym6D/EBiSbmd
	 g4DND49HPB7Ojo1UgOCwUvqbCo/rBhbxuukZGqwzCzQ2Im/NPkGWXidJiTq1qbmYVqxMo
	 r2uYNMgKw7jVLE0/wHGm3xU+uaaucTm7iPsCLcRUap/QwdZ+3za2PG+vE0WeBv2WkRoqg
	 DoJ4YXoG7MBtRTqF/I4DG2wQLpwqZrbYPjvFkHsscI/oe82/ENXcMWpY4ZSzU5NPdiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795215163;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=7bOogpDVgkETL/PHndFneONJEa0PXveDb0KR7stqI3E=;
	b=FBnOgtAy4PV4sdEeUOJsnLtLsWpwN74Jg1xYhgiJctpnGIMf2MWZtlPScdwqagJE76f9
	 cDlPPbwOvh7O6E2HKAwqeBkL1YjR0CqFzQTPpU9ioufuYBaQ7LOiIVyiRdkDKSKCOX3aY
	 GPGgahgQGGwiR0WDaoji1tP2a5GPW8rNd4QeWDZZuZ057L7xTk47mVsC2FrFWvu27YKcn
	 0SE/VCKini9eUB5XfZ7aMJsBAwCkdzjS7X8xi7A7Hej2OOu3n8Wxy6EiSNM8HjghHCQJV
	 AYDUI/+Dpbxei1y7IQcHQ9+Q9I5Jvf6STofDPRd3iwh0/0smsLZtB8XZ0HnrMJhxIuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Dhx31fwI;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F453606A68F
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 22:52:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F453606A68F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Dhx31fwI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795215150;
	bh=7bOogpDVgkETL/PHndFneONJEa0PXveDb0KR7stqI3E=;
	h=From:To:Subject:Date:From;
	b=Dhx31fwIsCncKAHE8/tSKWREz/K+fOe6UFuiMvPYk4oq3FmQxdrWEQCuNBwJRBwLh
	 olCWXKcP+4+McxobGB3nyyvtXWR2Rw1oQ4F5JVaoxWXPQlRzA1IFrH0EC3y49eAej/
	 ImtoUZDDu7CSTiz9KpY7rUtWqPVmhz8Z4IyIr05cjAzsUOsqfT3LKZ+Y7bS0ebGIUy
	 bS71vP4Tmmb3LJPFPn4qPdoOIa2yLawkJM0Qxw1kRn50vbA5KN8lOG6Etb2ZgKGpv/
	 YTQgSKYoJBUv14A9N/sNFVoclYqodXI1fwfyr56r/r7c+ySnadthtPAnXFrKBp55n7
	 SIWwhorx9Ks3Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CA99E60058
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 23:52:30 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 1/3] netfilter: flowtable: remove redundant ifidx field in tuple output union
Date: Fri, 20 Nov 2026 23:52:25 +0100
Message-ID: <20261120225227.3565643-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

The XMIT_NEIGH and XMIT_DIRECT types use an output ifidx field to
determine the destination netdevice. Remove the redundant ifidx field in
the flow_offload_tuple union that represents the output path, use the
existing struct.

No functional change, this is just a preparation patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: no changes

 include/net/netfilter/nf_flow_table.h | 3 ---
 net/netfilter/nf_flow_table_core.c    | 2 +-
 net/netfilter/nf_flow_table_ip.c      | 4 ++--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5b22d31cb140..61ac43b17dc9 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -160,9 +160,6 @@ struct flow_offload_tuple {
 	struct dst_entry		*dst_cache;
 
 	union {
-		struct {
-			u32		ifidx;
-		};
 		struct {
 			u32		ifidx;
 			u8		h_source[ETH_ALEN];
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2aa2647ed9df..a7b4fc5766a9 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -142,7 +142,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
-		flow_tuple->ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->dst_cache = dst;
 		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
 		break;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19cafae748ab..115c54ad4633 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -867,7 +867,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
 		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
@@ -1196,7 +1196,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
 		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
-- 
2.47.3

