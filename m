Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795078208;
	b=n79lu5UL/dylycDYeI5U7AJU+PNDA48qsNd3tiYhcgNfVRA8kDWUiJVqQhP7lwrvRDZp
	 XdERnVpkodUi7TpQa6rYbUx21eQwaDMh6jVVcvaGFCDM7pL3p2iCu81SgZWXC/fEjO03a
	 tNlLL0xk0CivDwBDMucytGZ7awU9rclSeVTId/HLXC6gpITBKSdcZ5hn2cYEsBtJuPIJR
	 Qxd4fLRGsTCWSR8iGms7svPsFcFFKOP2/A2IwvIWkwlQVJ65rcF7t4udHJ06YIhOLdIOY
	 hjv//B7v2lYl6fXly8Ff+Vz3G1a6V7+HAZO0UtlhBPqC7kQClDZrFoJQzG43Sy023MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795078208;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=nTdWLCa4qdnkNyAMOcJ9FLH6b36Hqk3wm5uJfydkA/o=;
	b=GAvuCKJh2/SWTEJs+j5cjmTKM2bXgtv9kXxkUGrHKOLhHZG3qXhvxUAIsHM1zcHW5f5c
	 Nxl0RXvhHW8e8qREGXA6ndabAaCktO1N8kDLX8c1DcG9OYCrmotbcGGwTi3yQpCO8RFy1
	 zIMVv/kvO0TsyAmjvgc456RHdVL12pu4ZAMg4Vua2QPmD0RYuvzlx9GjVHwhnEUQ/jRan
	 3mwP1TVDBxtC2/1ucoUN8Avf2ha9ecdEs7+T0uvcuKW/4v2plI1JYJLBGMj8Xb1Q+stZR
	 zaRCrMAYxZURfp3p73egiA//hwxW1tqLiSJw+ilTtRjkDliiPCb9rO98dSiy8/Gv1Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZiWTkprL;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF82D606A32F
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 08:50:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF82D606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZiWTkprL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795078206;
	bh=nTdWLCa4qdnkNyAMOcJ9FLH6b36Hqk3wm5uJfydkA/o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZiWTkprL47lBXwR+pEt+FzKZx0vpZMN4yDtNNL3JR4miz6Qu2RlJxPcd0X+MpoAB0
	 ta+F7fMb+/YBQb9Cw7ylMriWmNwZS4bgAflFkgHQaZbqUjYd3EhQBi7nZC2jEK1KxU
	 w7k9LE2c4JdWcG9Cx4HKzOKpEBrf09j8xkvqB3GAq35pEShb50jtg9HjqHsyCZEU7X
	 XoBja9GpwPAB9Nz8BPPqrK3b7A1OT6sPSu19eIL6Osb552qfE54DzFPLJ9HSNBviXh
	 AbQUsn0mjGovtyt4/xEL18+mT9JisQ6GLIkNfdyCJYLFoseGBqaM4/buhpg+EKjSng
	 YWJW422Xyg8pA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 09E646057A
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 09:50:05 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 3/3] netfilter: flowtable: unify direct and neigh xmit path
Date: Thu, 19 Nov 2026 09:49:59 +0100
Message-ID: <20261119085000.3330145-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119085000.3330145-1-pablo@netfilter.org>
References: <20261119085000.3330145-1-pablo@netfilter.org>
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

Since commit ("netfilter: flowtable: cache destination hw address for
XMIT_NEIGH type"), it is possible to possible to consolidate xmit path
further since the caching of the neighbour entry. To make it happen, do
not attach the cached dst to the skbuff, let's just transmit it via
dev_queue_xmit() without it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: set xmit.source only for DIRECT xmit type.

 net/netfilter/nf_flow_table_ip.c | 60 ++++++++------------------------
 1 file changed, 14 insertions(+), 46 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 354188d9dbf3..2f09bcd4aae8 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -863,31 +863,15 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 				tuplehash->tuple.dst_cache, &ip_addr) < 0)
 		return NF_DROP;
 
-	switch (tuplehash->tuple.xmit_type) {
-	case FLOW_OFFLOAD_XMIT_NEIGH:
-		rt = dst_rtable(tuplehash->tuple.dst_cache);
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
-		if (!xmit.outdev) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		xmit.dest = tuplehash->tuple.out.h_dest;
-		skb_dst_drop(skb);
-		skb_dst_set_noref(skb, &rt->dst);
-		break;
-	case FLOW_OFFLOAD_XMIT_DIRECT:
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
-		if (!xmit.outdev) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		xmit.dest = tuplehash->tuple.out.h_dest;
-		xmit.source = tuplehash->tuple.out.h_source;
-		break;
-	default:
-		WARN_ON_ONCE(1);
+	xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
+	if (!xmit.outdev) {
+		flow_offload_teardown(flow);
 		return NF_DROP;
 	}
+	xmit.dest = tuplehash->tuple.out.h_dest;
+	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		xmit.source = tuplehash->tuple.out.h_source;
+
 	xmit.tuple = other_tuple;
 	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
 
@@ -1186,31 +1170,15 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 				tuplehash->tuple.dst_cache, &ip_addr) < 0)
 		return NF_DROP;
 
-	switch (tuplehash->tuple.xmit_type) {
-	case FLOW_OFFLOAD_XMIT_NEIGH:
-		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
-		if (!xmit.outdev) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		xmit.dest = tuplehash->tuple.out.h_dest;
-		skb_dst_drop(skb);
-		skb_dst_set_noref(skb, &rt->dst);
-		break;
-	case FLOW_OFFLOAD_XMIT_DIRECT:
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
-		if (!xmit.outdev) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		xmit.dest = tuplehash->tuple.out.h_dest;
-		xmit.source = tuplehash->tuple.out.h_source;
-		break;
-	default:
-		WARN_ON_ONCE(1);
+	xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
+	if (!xmit.outdev) {
+		flow_offload_teardown(flow);
 		return NF_DROP;
 	}
+	xmit.dest = tuplehash->tuple.out.h_dest;
+	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		xmit.source = tuplehash->tuple.out.h_source;
+
 	xmit.tuple = other_tuple;
 	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
 
-- 
2.47.3

