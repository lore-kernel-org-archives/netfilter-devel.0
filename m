Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795079264;
	b=vsZVnTUwSxWjL3wL+SJht9t2/ELIL+yKU7rOlsvHxpnUmGixsUDdariWyMN86XYUAQCi
	 B7gJENdM7Xr8K9GAnTvV6wif/XFqPjGQYQegoOPYSYzlFx20ekQRrMHPLIAqRGD+cjutM
	 dbivcfb7CJmy3+mlZF9SeBLt+8vlrdmwM9z2lZpnSfxMzg1ZM/SaZ6xaR+R+xCcYYnak7
	 rjMCZrM4ssye75WaeCUrSeeOnzOJZeuytSCwhx5rFqxc1Tz1Pr2HrBctG9ALlVFNP9uks
	 hZ3IAj3mHQqoc5xkgd34dIvUszKRJu9tm/tbfdmisp5b6Z8aFehsHqpEro4cq0jwapw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795079264;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=pKSxhGWxDvRsO3f89ykU9w/pJYhbFuAazOx2QiMQJQY=;
	b=Hjle4r+yScdvxz+KaCD1yu9tWA+Dp5457s4aAMhd5o46Adqv+WsXbWrTSe6tvs3WFsc9
	 x/6JIU+oqltIdnxNdRLM3Hi6mNcV7O709zUVJtq2P+ZJOR5moabpwv/MsJAz67njWxNTl
	 c9tjaMKhqLLHdbtcdwLkxAxYkzEcy1xvLpGmXvm+qmP+u5p3Ox6uyosX7JCwTaBs5+sUW
	 vZAaKXdZo/Hocjkdj4l5+xABbXxcRmi//2Sgvlp6aEnkwtkjGN+G5sVJ2gZdBEgeH/V4e
	 PZN71LjlC7/oBy7w6QezAvXFqxLQXmR1GNu7N7laZN1GKOMdvT5A/M/QwllHBLh0qyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TI7dgkwH;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8EF606A320
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 09:07:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B8EF606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TI7dgkwH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795079261;
	bh=pKSxhGWxDvRsO3f89ykU9w/pJYhbFuAazOx2QiMQJQY=;
	h=From:To:Subject:Date:From;
	b=TI7dgkwHvyywVywoceFZhlh9NFpQnnrU8Eu/mdx9ki41WaDPHCKMlyt42kM5Un+f7
	 +T7fg7azX7vLxnd6BPLZWilX1btEMsOXk9hvVuX9yfx6viSmlBkqsk9YUiA+Qfa5Bk
	 Wr+o7zAAttDNVlvG1aigJeCMivd4xpKZnJh6TxlUBXvipLMWHCijHbJwMxapJ1oaR6
	 OC/1O50BAT/vGnZ8NqPHbbv36eh7RttBVP7g8letzJExHXmrZukUwWrbgxvWE8D0kS
	 E4AvC91zM9XDTk2awa6Ryfh6qbR8LdcSw8vhBHMOXOhk5Dh0wVQ5/zrZKe7aJXKgiZ
	 ygDLiUAbuMufQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AF11160056
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 10:07:41 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 1/3] netfilter: flowtable: remove redundant ifidx field in tuple output union
Date: Thu, 19 Nov 2026 10:07:34 +0100
Message-ID: <20261119090736.3342541-1-pablo@netfilter.org>
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
v4: no changes

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

