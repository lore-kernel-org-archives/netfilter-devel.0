Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795306306;
	b=E28oS88Omdq2ICZxzmwKDB80Pnc25XZSPJtvwx+K0zr36JPWS5fQ3XZK3gNPSL7wyxE9
	 xkhP4HSNhe31zWL7M9LKptoSERvRkr/8X05nTRSwTmiLw9SdCm4BA8zljoy7Nnu43R9yP
	 pvScq3ZWNgLHKJos7iVgM3A7b7tQH2ejxtKVnpO11T98N0wfVPqCzyvWs0U/FhPZJ6yPE
	 sQTiOnCanSxS87eiuVPiC2Y2oyO/AyFR0B6vuaWXxXloAlQunOYKt3srxj7XZxzx2NoFy
	 5XL2aEjAXtl20YRkMa5kujvKQwqFeTjS7HwdBLtuM3trnaez7ANc+69koNmg4DOm9+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795306306;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=VabwxPJd9liZ7uvdy44HYqkLnD7jazk1jf2nq9C0Fzc=;
	b=lzeCNFWxiGE+HyJgW1mpRekkb+q+ByaS4bIVzyr0ErpVEma6LesgMh767DJXpbTSel8I
	 zEGT2qlS0iXw1Jcs7ozFyv/b4G5A70/l4RYCblpuySesX+GRCSkCZ1uyTDU6G95L4UpZp
	 GVSGZ5xKOQduN2skVmlAOY6yizE8A7vIwCIvexN4ndFJZC34/JL0PrYFTj8qcw4xvrlp6
	 6Gy3Sn1FD4E2QMVR3zt1GGVfc9cSWLjf1K4oetMHukzfYuYTAzxvl6NegrjJCEJAVgRIA
	 btG0LDXq09gxWSs+eoSLwFhEbPYjV1Y4hROdTnrKNOKHs14Rreqo7tCC+2eU7dPOWTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=efX1TDUv;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1DF606A320
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 00:11:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C1DF606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=efX1TDUv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795306303;
	bh=VabwxPJd9liZ7uvdy44HYqkLnD7jazk1jf2nq9C0Fzc=;
	h=From:To:Subject:Date:From;
	b=efX1TDUvdeZx4GQZlwPITupepoZ+wf1xKsstdyih6Z/iXRBW0sYafi1Mtr+lqQJ2K
	 xfz779spL0I6ylpDZVrOxkgRu/+LN0BImPG6npIMHl43vi8S4Dy1GMkdSsprKbA5Lp
	 Iaw1qSegl6wsog80zbvYO0dj/PFaY2pQV/v2pBZwoCTRcbZTNh5Dxr2pmvDfE7cbOk
	 cotzuNVgz4jr+6gQj01rRHtPZLqBx2A08opk2mOmfP+4bhQVmTfYsJZdVIO9PSLs24
	 Qy2sMtkW8i1JFY6+xfZqlgmJzQ2Do2FWp9ku//ThtqEscyXpTnxdG+AvncX/Pn336I
	 PricSydTzJEmg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5E38C6005B
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 01:11:43 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v9 1/3] netfilter: flowtable: remove redundant ifidx field in tuple output union
Date: Sun, 22 Nov 2026 01:11:38 +0100
Message-ID: <20261122001140.3768172-1-pablo@netfilter.org>
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
v9: no changes

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

