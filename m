Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21EB40E8E5;
	Mon, 13 Jul 2026 12:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783946810; cv=none; b=kh/40HnS9Om0vWB/fyy0URvwwctMw3SLMN4or0siogaa28tUpYDKFCyET0WqTJVLURcvIIIQTTnqMbqmQOEzPg6xr5XU92JpQnjjHYGDpbNjQ+pJLiweCrWjGQcXFCQTCkNOTvqNyKhtoLi0PhB9hzE/Z0lt6wMfaT88GZJCDnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783946810; c=relaxed/simple;
	bh=v4AwIbVBNMt9xdoi5ovKxaeZUpxBg11lDXd7q3C7o5I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F/aCGcNUf2vBIDOHvRSdPW4cQE55HxkxqHXD8UmVbMLRXfG4yAlHjqEB6kp7MfUEovlhVweQrGoSOi2ZPrsZ0rQe2ANgkGnHyrBUbtPR5oefNC0xXjds0Uj63TIAweWhuC0V0pZFP21ITFyfBdB3aDsPpG5kMzZEf/6zEvzkl40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbKx0JVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbKx0JVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8850C1F000E9;
	Mon, 13 Jul 2026 12:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783946807;
	bh=dApmkL6jAWucItRGk3h8VIr3mPNdySBBR32tJWZcyFM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bbKx0JVbkoTmCzkn0VmDSfDw5W2AXByg7KL4YL31Hewap+9eDdn2QcDwyQfWQy/bN
	 fcM0b2TeSOw0JEL/JaItl/uDUAJMCtF1p9JAqw7TPmc+dC1LH1KQmhwYvji6U0QRma
	 +uE7ipUZd6KmkLSoj+/SF9shcI4uAh43blrWqxzheiT5cG3leusdTHzRzmp6xkWUgO
	 lKnNGycZwR4J3Ftkm2E8jUGuWN/s7bo9ySlo6EVhk115HDISGjYDbTyEDl0Q0bAfYP
	 LAAeSndjEEelqPndPxKGr13RBtqSA6iNk3AIXz4QRX7cnqqtz7JeJvzxdbmBT0xkqD
	 1PWZor6sT1wJQ==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 13 Jul 2026 14:46:19 +0200
Subject: [PATCH nf-next v6 2/6] net: netfilter: add encap_proto to
 flow_offload_tunnel
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-b4-flowtable-sw-accel-ip6ip-v6-2-33f0155fc658@kernel.org>
References: <20260713-b4-flowtable-sw-accel-ip6ip-v6-0-33f0155fc658@kernel.org>
In-Reply-To: <20260713-b4-flowtable-sw-accel-ip6ip-v6-0-33f0155fc658@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 Shuah Khan <shuah@kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, netdev@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.14.3

Add encap_proto (AF_INET or AF_INET6) to struct flow_offload_tunnel
to allow its use as part of the hash table key during flowtable entry
lookup.
This is a preliminary change to support IPv4 over IPv6 tunneling via
the flowtable infrastructure for software acceleration.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/netdevice.h             | 1 +
 include/net/netfilter/nf_flow_table.h | 1 +
 net/ipv4/ipip.c                       | 1 +
 net/ipv6/ip6_tunnel.c                 | 1 +
 net/netfilter/nf_flow_table_ip.c      | 2 ++
 net/netfilter/nf_flow_table_path.c    | 2 ++
 6 files changed, 8 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ed53f390606..0630c07e543e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -902,6 +902,7 @@ struct net_device_path {
 			};
 
 			u8	l3_proto;
+			u8	encap_proto;
 		} tun;
 		struct {
 			enum {
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ce414118962f..bae0f55743e9 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -118,6 +118,7 @@ struct flow_offload_tunnel {
 	};
 
 	u8	l3_proto;
+	u8	encap_proto;
 };
 
 struct flow_offload_tuple {
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index d1aa048a6099..4d2195b4ae3e 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -370,6 +370,7 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->tun.src_v4.s_addr = tiph->saddr;
 	path->tun.dst_v4.s_addr = tiph->daddr;
 	path->tun.l3_proto = IPPROTO_IPIP;
+	path->tun.encap_proto = AF_INET;
 	path->dev = ctx->dev;
 
 	ctx->dev = rt->dst.dev;
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 38da07101601..a121f715afd2 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1863,6 +1863,7 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->type = DEV_PATH_TUN;
 		path->tun.src_v6 = t->parms.laddr;
 		path->tun.dst_v6 = t->parms.raddr;
+		path->tun.encap_proto = AF_INET6;
 		if (ctx->ether_type == cpu_to_be16(ETH_P_IP))
 			path->tun.l3_proto = IPPROTO_IPIP;
 		else
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 0b78decce8a9..f29c69c362f5 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -198,6 +198,7 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 			tuple->tun.dst_v4.s_addr = iph->daddr;
 			tuple->tun.src_v4.s_addr = iph->saddr;
 			tuple->tun.l3_proto = IPPROTO_IPIP;
+			tuple->tun.encap_proto = AF_INET;
 		}
 		break;
 	case htons(ETH_P_IPV6):
@@ -206,6 +207,7 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 			tuple->tun.dst_v6 = ip6h->daddr;
 			tuple->tun.src_v6 = ip6h->saddr;
 			tuple->tun.l3_proto = IPPROTO_IPV6;
+			tuple->tun.encap_proto = AF_INET6;
 		}
 		break;
 	default:
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index c8011ec36532..caaf48c5fd2a 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -129,6 +129,7 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->tun.src_v6 = path->tun.src_v6;
 				info->tun.dst_v6 = path->tun.dst_v6;
 				info->tun.l3_proto = path->tun.l3_proto;
+				info->tun.encap_proto = path->tun.encap_proto;
 				info->num_tuns++;
 			} else {
 				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
@@ -278,6 +279,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 		route->tuple[!dir].in.tun.src_v6 = info.tun.dst_v6;
 		route->tuple[!dir].in.tun.dst_v6 = info.tun.src_v6;
 		route->tuple[!dir].in.tun.l3_proto = info.tun.l3_proto;
+		route->tuple[!dir].in.tun.encap_proto = info.tun.encap_proto;
 		route->tuple[!dir].in.num_tuns = info.num_tuns;
 	}
 

-- 
2.55.0

