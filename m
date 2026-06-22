Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.229.168.213])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89F193A5422
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 10:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.229.168.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782123077; cv=none; b=ZP63nabqq020K8fQIhLByVUGI+L8nulU1DoEdB2iVP+Hce7QHybG3vNff/oiBiqelQxAJXBRXDv9y2E1Kb3cZrYFw7PKBi2oXt1PEI7kRSag0UOwG7rwWjIt72uHIo+buE4EzijZNOWDTgQ1ZR3F72y93qqjPh2SCj9Lq/wKMaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782123077; c=relaxed/simple;
	bh=I+Z1DCHK3fH/16Pv1Abw5JpJMGqZWS0dimlr+j6b1YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwWHbnAj3EG2PAh3HDD+SniJKwMVECQKIkvZxQ15JV1or6PJF4FZhOw2ASmyLGCeXQuQt5f1JAlsEtm6kGf4PERZY0Zi5K+zDfmzDiYEIrSATRbBaE9GemaBIKDkIx88c4k2aCqc2KUXDbwnwsFZPjDsxbDt4Gvs/b++WtsQ2zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=52.229.168.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app3 (Coremail) with SMTP id ywmowAC3xvkkCjlqyIYsAA--.11269S3;
	Mon, 22 Jun 2026 18:10:53 +0800 (CST)
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
Subject: [PATCH nf v3 1/2] netfilter: nf_flow_table: separate tunnel route state from direct xmit
Date: Mon, 22 Jun 2026 18:10:26 +0800
Message-ID: <8c46be2ef0884843963fead783d67661a6f565b1.1782092221.git.chzhengyang2023@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782092221.git.chzhengyang2023@lzu.edu.cn>
References: <cover.1782092221.git.chzhengyang2023@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ywmowAC3xvkkCjlqyIYsAA--.11269S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Ww1kJr4kZryfuw4fWFyrXrb_yoW3XF4kpF
	45K3yktrsxWrnIgr4fZ3yfurn8WrsYkFWa9FyYk3ySyF1UX34kGF95Ka42v3WkGFWDJFyS
	qr1qqr1UCF1DA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEGCWo48FMDugAAsH

From: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>

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
changes in v3:
  - add the nft_flowtable.sh regression coverage in patch2
  - Clarify that the DIRECT+tunnel tuple combination is reachable via
    nft_dev_forward_path() updating xmit_type while filling tunnel
    metadata
  - v2 Link: https://lore.kernel.org/all/7016923271a6bb3e26f9a21757922d3c5b1a7487.1781683535.git.chzhengyang2023@lzu.edu.cn/
changes in v2:
  - Move dst_cache and dst_cookie out of the runtime union instead of
    introducing dedicated tunnel dst fields
  - Reuse the shared dst_cache/dst_cookie storage for DIRECT tunnel
    flows
  - Simplify dst release through the common dst_cache path
  - Update Fixes: to d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw
    acceleration")
  - v1 Link: https://lore.kernel.org/all/3947a39286d335b6136bbee26f8bf44b23471c69.1780580352.git.chzhengyang2023@lzu.edu.cn/
---
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

