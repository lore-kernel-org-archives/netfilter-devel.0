Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8479C3BB10D
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.175.55.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780593064; cv=none; b=jLyeQwZQFWSyQIZluKneyIBsjQJwk6aKv+v2f4gkOmlLVW2KM9KWgRMOObzlG+4ldpY5bNRHXFs0KDjp/dOur0p2QTGh5TgXkKGT7fxHeCoeaYiKt+l+JfBx4Nd/st4/a6f6/ndp1lrDv0DrlfgZCPC1PUx15cSAhIkeY05iQRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780593064; c=relaxed/simple;
	bh=ISX4ybWdLDBcWSp+5sz76Z0o0RF+VjPotuyCRlQ+f+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilbErwBzbpfHBD9QeEjdUw2+Z1PgCZm+qVEGSmLZT5xULafZjVL46CywpjGOeULvI8GIVBK5GZad1Chk8abVk0wvW6cow4jV5Xf78SA8ypnfjsiwPbh+BrILd7Vu4hGwx98l9pRuiCgNvra2CBOYTJlD8Freky9VDGj+0K5ESso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=52.175.55.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app3 (Coremail) with SMTP id ywmowAB3tv6RsSFqKOUWAA--.32698S3;
	Fri, 05 Jun 2026 01:10:48 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	lorenzo@kernel.org,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	chzhengyang2023@lzu.edu.cn,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: nf_flow_table: separate tunnel route state from direct xmit
Date: Fri,  5 Jun 2026 01:10:35 +0800
Message-ID: <3947a39286d335b6136bbee26f8bf44b23471c69.1780580352.git.chzhengyang2023@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780580352.git.chzhengyang2023@lzu.edu.cn>
References: <cover.1780580352.git.chzhengyang2023@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ywmowAB3tv6RsSFqKOUWAA--.32698S3
X-Coremail-Antispam: 1UD129KBjvJXoW3ArW7GrWkAr4DuFykuw17Wrg_yoWxZr45pF
	4UK3yrtr4fWr9F9ws3Zw4xur15WrsYkaya9FyYk3ySyFn8X34kWFyrKay2vFn7JFWDJrWa
	qr1DKr1UCF1DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEICWohNVALygAAsu

From: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>

When a flow tuple carries tunnel metadata and uses
FLOW_OFFLOAD_XMIT_DIRECT, the transmit path may still need route state
for tunnel push. However, the current tuple layout stores direct xmit
L2 state and route state in overlapping runtime storage.

As a result, a tuple may keep tun_num set while the tunnel push path
later reads tuple->dst_cache, even though a direct xmit tuple only has
out.ifidx/out.h_source/out.h_dest stored in that area. This leads to
invalid dst usage and can trigger a crash in the tunnel transmit path.

Fix this by separating tunnel route state from direct xmit runtime
state. Store dedicated tunnel dst information for direct xmit tunnel
flows, use it from the IPv4/IPv6 tunnel push helpers, and validate and
release it independently from the normal neighbour/xfrm dst state.

Hardware offload rule construction still assumes that direct xmit flows
do not carry tunnel route state, so reject that combination there for
now to avoid undefined offload behaviour.

The issue can be reproduced with the provided namespace + flowtable +
IPIP setup, and after this change the reproducer no longer triggers the
observed GPF/panic.

Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 include/net/netfilter/nf_flow_table.h |  4 ++++
 net/netfilter/nf_flow_table_core.c    | 19 ++++++++++++++++++-
 net/netfilter/nf_flow_table_ip.c      | 13 +++++++++++--
 net/netfilter/nf_flow_table_offload.c |  5 +++++
 4 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 7b23b245a5a8..4fe220f97d75 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -155,6 +155,10 @@ struct flow_offload_tuple {
 					tun_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
+	struct {
+		struct dst_entry	*tun_dst_cache;
+		u32			tun_dst_cookie;
+	};
 	union {
 		struct {
 			struct dst_entry *dst_cache;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 785d8c244a77..5048c0a1ba2e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -84,6 +84,14 @@ static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple)
 	return 0;
 }
 
+static u32 flow_offload_tun_dst_cookie(struct flow_offload_tuple *flow_tuple)
+{
+	if (flow_tuple->tun.l3_proto == IPPROTO_IPV6)
+		return rt6_get_cookie(dst_rt6_info(flow_tuple->tun_dst_cache));
+
+	return 0;
+}
+
 static struct dst_entry *nft_route_dst_fetch(struct nf_flow_route *route,
 					     enum flow_offload_tuple_dir dir)
 {
@@ -127,12 +135,17 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
+		if (flow_tuple->tun_num) {
+			flow_tuple->tun_dst_cache = dst;
+			flow_tuple->tun_dst_cookie = flow_offload_tun_dst_cookie(flow_tuple);
+		}
 		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
 		       ETH_ALEN);
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
-		dst_release(dst);
+		if (!flow_tuple->tun_num)
+			dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
@@ -152,6 +165,10 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 static void nft_flow_dst_release(struct flow_offload *flow,
 				 enum flow_offload_tuple_dir dir)
 {
+	if (flow->tuplehash[dir].tuple.tun_num &&
+	    flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		dst_release(flow->tuplehash[dir].tuple.tun_dst_cache);
+
 	if (flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
 	    flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)
 		dst_release(flow->tuplehash[dir].tuple.dst_cache);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9c05a50d6013..8dbec82a663a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -299,6 +299,11 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 
 static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
 {
+	if (tuple->tun_num &&
+	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
+	    !dst_check(tuple->tun_dst_cache, tuple->tun_dst_cookie))
+		return false;
+
 	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
 	    tuple->xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
 		return true;
@@ -597,7 +602,9 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 				    __be32 *ip_daddr)
 {
 	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
-	struct rtable *rt = dst_rtable(tuple->dst_cache);
+	struct dst_entry *dst = tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT ?
+				tuple->tun_dst_cache : tuple->dst_cache;
+	struct rtable *rt = dst_rtable(dst);
 	u8 tos = iph->tos, ttl = iph->ttl;
 	__be16 frag_off = iph->frag_off;
 	u32 headroom = sizeof(*iph);
@@ -660,7 +667,9 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 {
 	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
 	u8 hop_limit = ip6h->hop_limit, proto = IPPROTO_IPV6;
-	struct rtable *rt = dst_rtable(tuple->dst_cache);
+	struct dst_entry *dst = tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT ?
+				tuple->tun_dst_cache : tuple->dst_cache;
+	struct rtable *rt = dst_rtable(dst);
 	__u8 dsfield = ipv6_get_dsfield(ip6h);
 	struct flowi6 fl6 = {
 		.daddr = tuple->tun.src_v6,
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 002ec15d988b..c739c9db68bd 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -820,6 +820,11 @@ nf_flow_offload_rule_alloc(struct net *net,
 
 	tuple = &flow->tuplehash[dir].tuple;
 	other_tuple = &flow->tuplehash[!dir].tuple;
+
+	if (other_tuple->tun_num &&
+	    other_tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		goto err_flow_match;
+
 	if (other_tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH)
 		other_dst = other_tuple->dst_cache;
 
-- 
2.43.0

