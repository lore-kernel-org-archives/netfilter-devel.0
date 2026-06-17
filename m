Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A7C4A3411
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 17:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.21.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781716013; cv=none; b=GiS0Q0OfUO+cHuHArP6tS863Ah5EZxcKgwgqZ8rhd9utfXemimure6nKePSUSnBMKC0By9Md5lWmWmg4e+LOx+6LIvmOoJvvitNHv0vk5c9FA1OfGsoUW1po4W4XpkPJtFuFfuvzTUO/qjFfq+a6hC7TIkguzM1b1Uxjo7cAiJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781716013; c=relaxed/simple;
	bh=9ReRfwUHP6qw9yH+mA8AANDZ4SRrxMPOorpqpNJSiq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H35d5kNC4vz/CTSU6WfNhxt5I8N7nzeL4yT/SGVj1O4SmJikUByxgJLmEKB/z8bRqQnXIBFdNnjTXKnzW66j4QJyyy7z/Nft3IL3OwaBBJgKXimA0iOHZTRGLNp8uCKAuWFr7X7ztAVuns8zSHk/DJMrlaz9yCOb/aVWlKWr74w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=206.189.21.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app2 (Coremail) with SMTP id zQmowABX9AsV1DJq3GItAA--.61475S2;
	Thu, 18 Jun 2026 01:06:29 +0800 (CST)
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
Subject: [PATCH nf v2 1/1] netfilter: nf_flow_table: separate tunnel route state from direct xmit
Date: Thu, 18 Jun 2026 01:06:21 +0800
Message-ID: <7016923271a6bb3e26f9a21757922d3c5b1a7487.1781683535.git.chzhengyang2023@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQmowABX9AsV1DJq3GItAA--.61475S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Ww1fWr15Cw1xZFWfWw43Awb_yoWxKF4rpF
	45K3yrtrsxWrnIgw4Svw4furn8WrsYkFWa9FyYk3ySyF1UX34kGF95Ka42v3WkGFWDJFyS
	qryqvr1UCF1DJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsACWoxB1IG2wAIsY

From: Zhengyang Chen<chzhengyang2023@lzu.edu.cn>

When a flow tuple carries tunnel metadata and uses
FLOW_OFFLOAD_XMIT_DIRECT, the transmit path may still need route state
for tunnel push. However, the current tuple layout stores direct xmit
L2 state and route state in overlapping runtime storage.

As a result, a tuple may keep tun_num set while the tunnel push path
later reads tuple->dst_cache, even though a direct xmit tuple only has
out.ifidx/out.h_source/out.h_dest stored in that area. This leads to
invalid dst usage and can trigger a crash in the tunnel transmit path.

Fix this by moving dst_cache and dst_cookie out of the runtime union so
that they can be shared by neighbour, xfrm, and direct tunnel flows.
For FLOW_OFFLOAD_XMIT_DIRECT tuples carrying tunnel metadata, preserve
route state in these shared fields and release it through the common
dst release path.

Keep dst validation on the forwarding tuple before the packet is
modified, and validate the tunnel consumer tuple from the same early
control point. This preserves protection for current NEIGH/XFRM users
of tuplehash->tuple.dst_cache while avoiding the late-check fallback
after decap, NAT, and TTL updates.

Hardware offload rule construction still assumes that direct xmit flows
do not carry tunnel route state, so reject that combination there for
now to avoid undefined offload behaviour.

Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
changes in v2:
  - Move dst_cache and dst_cookie out of the runtime union instead of
    introducing dedicated tunnel dst fields
  - Reuse the shared dst_cache/dst_cookie storage for DIRECT tunnel
    flows
  - Simplify dst release through the common dst_cache path
  - Update Fixes: to d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw
    acceleration")
  - v1 Link: https://lore.kernel.org/all/3947a39286d335b6136bbee26f8bf44b23471c69.1780580352.git.chzhengyang2023@lzu.edu.cn/

 include/net/netfilter/nf_flow_table.h |  4 ++--
 net/netfilter/nf_flow_table_core.c    | 12 ++++++++----
 net/netfilter/nf_flow_table_ip.c      | 19 +++++++++++++++++++
 net/netfilter/nf_flow_table_offload.c |  3 +++
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 7b23b245a5a8..369f6a717811 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -155,11 +155,11 @@ struct flow_offload_tuple {
 					tun_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
+	struct dst_entry		*dst_cache;
+	u32				dst_cookie;
 	union {
 		struct {
-			struct dst_entry *dst_cache;
 			u32		ifidx;
-			u32		dst_cookie;
 		};
 		struct {
 			u32		ifidx;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 785d8c244a77..252b081319a7 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,12 +127,18 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
+		if (flow_tuple->tun_num) {
+			flow_tuple->dst_cache = dst;
+			flow_tuple->dst_cookie =
+				flow_offload_dst_cookie(flow_tuple);
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
@@ -152,9 +158,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 static void nft_flow_dst_release(struct flow_offload *flow,
 				 enum flow_offload_tuple_dir dir)
 {
-	if (flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
-	    flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)
-		dst_release(flow->tuplehash[dir].tuple.dst_cache);
+	dst_release(flow->tuplehash[dir].tuple.dst_cache);
 }
 
 void flow_offload_route_init(struct flow_offload *flow,
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9c05a50d6013..b125868ab1fb 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -299,6 +299,11 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 
 static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
 {
+	if (tuple->tun_num &&
+	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
+	    !dst_check(tuple->dst_cache, tuple->dst_cookie))
+		return false;
+
 	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
 	    tuple->xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
 		return true;
@@ -482,6 +487,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 				   struct flow_offload_tuple_rhash *tuplehash,
 				   struct sk_buff *skb)
 {
+	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
 	unsigned int thoff, mtu;
@@ -507,6 +513,12 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 		return 0;
 	}
 
+	other_tuple = &flow->tuplehash[!dir].tuple;
+	if (other_tuple->tun_num && !nf_flow_dst_check(other_tuple)) {
+		flow_offload_teardown(flow);
+		return 0;
+	}
+
 	if (skb_ensure_writable(skb, thoff + ctx->hdrsize))
 		return -1;
 
@@ -1091,6 +1103,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 					struct flow_offload_tuple_rhash *tuplehash,
 					struct sk_buff *skb, int encap_limit)
 {
+	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
 	unsigned int thoff, mtu;
@@ -1119,6 +1132,12 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 		return 0;
 	}
 
+	other_tuple = &flow->tuplehash[!dir].tuple;
+	if (other_tuple->tun_num && !nf_flow_dst_check(other_tuple)) {
+		flow_offload_teardown(flow);
+		return 0;
+	}
+
 	if (skb_ensure_writable(skb, thoff + ctx->hdrsize))
 		return -1;
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 002ec15d988b..e3ace6435074 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -820,6 +820,9 @@ nf_flow_offload_rule_alloc(struct net *net,
 
 	tuple = &flow->tuplehash[dir].tuple;
 	other_tuple = &flow->tuplehash[!dir].tuple;
+	if (other_tuple->tun_num &&
+	    other_tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
+		goto err_flow_match;
 	if (other_tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH)
 		other_dst = other_tuple->dst_cache;
 
-- 
2.43.0

