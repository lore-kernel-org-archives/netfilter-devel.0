Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C6C3C9EE7
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134173; cv=none; b=MYHIpEu1laySdQskeck+9x13gVlzNnHzTwrMGHhW0s2HDgdQhQos61Ll52lBynBp6L7lld5wSHWUllmS3KdJdblXRlT4DGqomhoKeYZxaQGY8tn3sp7mAjRvaXwJbyKhk2LnHe17EzM5kNqTqunO9isxc0NXVlVS3XIsS6udiYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134173; c=relaxed/simple;
	bh=jF4Qob/CIZ+aOsz95GGtYHR+FbVNyRZVv2203Vcjdm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGEhmQsYBN9ygckZV3eGLyCyuKAjMxKfjfnb+ZpMlPouFPPdZdXPkTlzLyytg/gKTjY0i8HBNKD+kGzrLMvohWMaq3R/DtHbPIanp6jdGtFq1AbgFPbRcuWLKlSEKDesEop0gA+M6gczJl1dG2muZKQdweaKvybIDdxQGeqMCnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=OFtXu5EO; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="OFtXu5EO"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2e36c3478aso152525666b.0
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134169; x=1791738969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T2jpf56bQMb7dbhx7mwCnMjIEjtvkT40nE2gW2IJYhI=;
        b=OFtXu5EOfahH4E9FtbGM4+rQOKnXrHVvNiNVPAf+qKJ2OF5yu+2PBb/oDxmoICRCdy
         pLLd5PX62vw22rSmpHPbR2ZrXFeGyEcDkhMVs15y7ZRrI3ZePgwGy8DgeoeZW+HTE1ad
         kuEkqy2kxQOWmgcM3RUwvsil0PQhNLOTnLD+0i21cH1GQCBVJejKZL2WZL5odrX0CBte
         eqsggS5BH/ZIUVbuXPt4huVNC1AdyHHzb6j9TrRMBib8JJuwnWUPG8mMzQitmi462PQB
         shMdhxIH07XQbJUxEPuHL4yRwHiQxpQEkgyhn3ryjicF7jAhE0MWfUuRH8oHkM+JPa8j
         Abyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134169; x=1791738969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T2jpf56bQMb7dbhx7mwCnMjIEjtvkT40nE2gW2IJYhI=;
        b=IwXL+cx/Z39FmZ8Viqr/+rq6duLrXpgANH5tNU9C3d9bse/za9X03b8MTIkEh53jfI
         r8i6UBhr/XNIkJCKWb7GIpu0uVKvAaux0n21CGhLjfQ2DFnh5sK3NoDEHh/D9XWN8fiq
         tzMaMCAwCHO938H//v0jHrMhjM5be7Vm60xeHf9hV0qW+aKXm9hIxMA7iiStJvd8iZ/C
         hroC3T64DtYHyYYkhIQSK8bvncx3+/Knk10bfhdgrd2eKAgXB8zmsEgS/lqkrtieZZeg
         cIRSp0f9+EiGP3RRMxo2o7dlurtWEj9QOjHuqC+v1l/qr9rjWTmfd3eo5s3nW+YMsq/n
         5vow==
X-Gm-Message-State: AFuF++mNyXp2meFmUybVSXBtx+uh+UWZibsk1DFUYTH9lFLfMuTlJvWO
	4FjlPin2QZAWZapMsToXxKUmazES+WrPymAdXwfr1PZvwqt82cWcVnpDvZ44NIr+bQ9Nh/7PgC3
	xOk4Lwg==
X-Gm-Gg: AYBFou3W04M8bnHFHbTSTZSV55KG9UmAtvEUN9arBKlMFm8pOrnTbgtlDj2/pWxDN2D
	XyNMTS4Re8to7xDt42Kn3ksP7ozN+GLMDVFp6UZgqMWWb57UjTwvcSF2FMHpzla6d4n1mu8r4W3
	M/nFZfP0he23yuU/HVOR3FKnTIjTEvRkYyrBcD5IJj+sAsCIHmWu1416kmNarhIyyvad72b+u5N
	hrMDBdD/wh0qc4SeBLTsYqkRDy5i80LHKVOEDSpzrI48h+Ro81RJwpDhXEQX8haJq+wBSy3XhJ+
	94ldGDo5Fm5g1vHJ1Iv74+gN4yzPFfDtMhsy0xJvgZ6AS7wSLnWqVpSOY4FmW0MAuKSyTk8kVvW
	EEk0gr6L2MGa7Jv98YTSMBYAyeR0ZQZ6d4hOTw4yuiHOGtyAfhfOSWojxnUEz9kJwWQ95kvZlbE
	Xz8Qq0T0ggGbdtgc8GERUXDWh6gHDkgcZEic+Ks39wkg9DT9/R2SBFx6Brisn9hCOVKn83lyh10
	4W7g7eCKTJn7OHRQDe/N/tlXMp1nNFmFqeeluchgw4liUtYZNugILSQXBpTBXN87/46p5m5qmYY
	MiMRJJFNm/6WqVhW54a+wp1JQQ124CsUokSB3Yy4P4VT/PTwnZd24ORRofy3o0C1yphkyDagX0z
	Gi97cL9PynkqTLeadf4dStq3W4hk0ySELpCT4HQ1MFUqtpRllFoXE0VhzXJZ0BXS4Ews12Ep0s3
	UnpfWj+7Xao8O6Yc9jBTtpYhGgwv0qBqvBQQ==
X-Received: by 2002:a17:906:794e:b0:c2e:4292:d27f with SMTP id a640c23a62f3a-c2e6ed44749mr408428166b.18.1791134168755;
        Sun, 04 Oct 2026 10:16:08 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e878b0e05sm82284366b.5.2026.10.04.10.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:07 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	phil@nwl.cc,
	horms@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	razor@blackwall.org,
	ericwouds@gmail.com,
	dqfext@gmail.com,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v6 1/2] netfilter: flowtable: tear down direct xmit flows when the fdb entry moves
Date: Sun,  4 Oct 2026 19:16:04 +0200
Message-ID: <20261004171605.3544792-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171605.3544792-1-julius@bairaktaris.de>
References: <20261004171605.3544792-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A direct xmit flow stores the bridge port the fdb resolved when the flow
was created. When the host moves to another port of the bridge, the flow
keeps sending to the old port, and packets from the other side keep it
from timing out. A hardware offloaded flow behaves the same.

Look the forward path up again in the gc and tear the flow down when the
bridge now resolves the destination to another port. An aged out fdb
entry leaves the flow alone, because offloaded packets do not refresh
it. The tuple stores the route's output device, where the lookup starts,
and the bridge port, which differs from out.ifidx when the port is a
vlan device.

The check adds about 1.4 us per bridged flow and gc run (1800 flows,
x86 guest with lockdep, 3 runs: 2.2 -> 4.7 ms).

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 include/net/netfilter/nf_flow_table.h |  4 +++
 net/netfilter/nf_flow_table_core.c    | 44 +++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_path.c    |  7 +++++
 3 files changed, 55 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..ba0739247d86 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -164,6 +164,8 @@ struct flow_offload_tuple {
 		};
 		struct {
 			u32		ifidx;
+			u32		path_ifidx;
+			u32		bridge_ifidx;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
@@ -232,6 +234,8 @@ struct nf_flow_route {
 		struct {
 			u32			ifindex;
 			u32			hw_ifindex;
+			u32			path_ifindex;
+			u32			bridge_ifindex;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
 			u8			needs_gso_segment:1;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 03241d4bfd5e..0ed379addd41 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/netfilter.h>
 #include <linux/rhashtable.h>
+#include <linux/etherdevice.h>
 #include <linux/netdevice.h>
 #include <net/ip.h>
 #include <net/ip6_route.h>
@@ -139,6 +140,9 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->out.path_ifidx = route->tuple[dir].out.path_ifindex;
+		flow_tuple->out.bridge_ifidx =
+			route->tuple[dir].out.bridge_ifindex;
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
@@ -565,15 +569,55 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 	nf_ct_put(ct);
 }
 
+/* A direct xmit flow through a bridge is stale once the bridge resolves
+ * its destination to another port. An fdb entry that aged out is not a
+ * move: offloaded packets do not pass the bridge to refresh it.
+ */
+static bool nf_flow_bridge_port_stale(struct net *net,
+				      const struct flow_offload_tuple *tuple)
+{
+	struct net_device_path_ctx ctx = {
+		.ether_type = tuple->l3proto == NFPROTO_IPV4 ?
+			      htons(ETH_P_IP) : htons(ETH_P_IPV6),
+	};
+	struct net_device_path_stack stack;
+	bool stale = false;
+	int i, port = 0;
+
+	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_DIRECT ||
+	    !tuple->out.bridge_ifidx)
+		return false;
+
+	ether_addr_copy(ctx.daddr, tuple->out.h_dest);
+
+	rcu_read_lock();
+	ctx.dev = dev_get_by_index_rcu(net, tuple->out.path_ifidx);
+	if (ctx.dev && !dev_fill_forward_path(&ctx, &stack)) {
+		/* The last bridge, as in nft_dev_path_info() */
+		for (i = 0; i < stack.num_paths - 1; i++) {
+			if (stack.path[i].type == DEV_PATH_BRIDGE)
+				port = stack.path[i + 1].dev->ifindex;
+		}
+		stale = port && port != tuple->out.bridge_ifidx;
+		dev_fill_forward_path_release(&stack);
+	}
+	rcu_read_unlock();
+
+	return stale;
+}
+
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
+	struct net *net = read_pnet(&flow_table->net);
 	bool teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
 	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
 	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple) ||
+	    nf_flow_bridge_port_stale(net, &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
+	    nf_flow_bridge_port_stale(net, &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple) ||
 	    nf_flow_custom_gc(flow_table, flow)) {
 		flow_offload_teardown(flow);
 		teardown = true;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 1e55644f2edb..386d41e6c713 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -88,6 +88,7 @@ struct nft_forward_info {
 		__be16	proto;
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
 	u8 num_encaps;
+	u32 bridge_ifidx;
 	struct flow_offload_tunnel tun;
 	struct dst_entry *tun_dst;
 	u8 num_tuns;
@@ -180,6 +181,10 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
 			}
+			/* dev_fill_forward_path() adds the bridge port after
+			 * the bridge.
+			 */
+			info->bridge_ifidx = stack->path[i + 1].dev->ifindex;
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
@@ -257,6 +262,8 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.path_ifindex = dst->dev->ifindex;
+		route->tuple[dir].out.bridge_ifindex = info.bridge_ifidx;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
-- 
2.53.0

