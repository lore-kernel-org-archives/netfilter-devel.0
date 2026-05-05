Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42072264A9;
	Tue,  5 May 2026 14:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777992602; cv=none; b=jRcG66B1okg5Jm0xW31dMTuRWTXQyOy7EuiPeEBDj3fz5uRHAT7BrcwUFV0I77w0FCbDLhvOo99CFQ6SPjYtP6lvqw5Qq0PaNldd45C1Qy7z5KQleFFYNH3W4T+7/4hJgY9SjhMP822uYKcx37BZj/LeOyMphIoUzRheTwGJgac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777992602; c=relaxed/simple;
	bh=92G/hBpoy+tgBOS2x/I53r2sZ5pAyr7z2fg9vOcfHhA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XQ0qd3VEwd2RZU+t149U9O0jT2EX7ft/xbYKoyhbi9GsatBIckYNWlLrHd1shPtrh7E9Oyp34zUTddfBfv0ewXebM3bTrI3ShPuEV+em8pJIONsHdctvV17ZHIlv9/GcXFMtl+Z9OGILCFXRhaymzPppsmSCcwz4bVZHEqY48so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/H8COlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/H8COlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0062FC2BCF4;
	Tue,  5 May 2026 14:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777992602;
	bh=92G/hBpoy+tgBOS2x/I53r2sZ5pAyr7z2fg9vOcfHhA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=E/H8COlVuRum6H/mSSSp2b5NDHs8p1dq3Kmw00eTRTxcDX03eARk/qKClNqhX0z6s
	 NZZBflhEaKRd9eWxiQKAzO7eFngAppDeSNcJPUh3NIXMXGThZHBXlB/uLnea6bwAyG
	 YMqrzDM8uV0lMHb1+eyVHdutii0ueC9SWFbCPS5AzxqoXtvT110NUPxfzrqA6PECr3
	 4FEeOae2TYBj4zSB0/pO9IS4q/TvrVe6MudyGMu7z7iQ0m2HH2OTxpXuKUAHq6rvQp
	 mlGjDwtnqSIhBoNHfG1jnkd4x+HUNj79hBRMDSvoRQqBxvhhipf7WuWZBCtc5EL74j
	 EbyOaAbsvul6w==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Tue, 05 May 2026 16:49:24 +0200
Subject: [PATCH nf-next 2/4] net: netfilter: Add encap_proto to
 flow_offload_tunnel
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-b4-flowtable-sw-accel-ip6ip-v1-2-9ac39ccc9ea9@kernel.org>
References: <20260505-b4-flowtable-sw-accel-ip6ip-v1-0-9ac39ccc9ea9@kernel.org>
In-Reply-To: <20260505-b4-flowtable-sw-accel-ip6ip-v1-0-9ac39ccc9ea9@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, netdev@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 linux-kselftest@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
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
index 85bd9d46b5a0..02f593397fad 100644
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
index b09c11c048d5..96e8ecf0f530 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -118,6 +118,7 @@ struct flow_offload_tunnel {
 	};
 
 	u8	l3_proto;
+	u8	encap_proto;
 };
 
 struct flow_offload_tuple {
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index ff95b1b9908e..5425af051d5a 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -369,6 +369,7 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->tun.src_v4.s_addr = tiph->saddr;
 	path->tun.dst_v4.s_addr = tiph->daddr;
 	path->tun.l3_proto = IPPROTO_IPIP;
+	path->tun.encap_proto = AF_INET;
 	path->dev = ctx->dev;
 
 	ctx->dev = rt->dst.dev;
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 3d64e672eeee..c99ed41bfc99 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1851,6 +1851,7 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->type = DEV_PATH_TUN;
 		path->tun.src_v6 = t->parms.laddr;
 		path->tun.dst_v6 = t->parms.raddr;
+		path->tun.encap_proto = AF_INET6;
 		if (ctx->ether_type == cpu_to_be16(ETH_P_IP))
 			path->tun.l3_proto = IPPROTO_IPIP;
 		else
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index fd56d663cb5b..9efd76b57847 100644
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
index df4e180ed3c2..5a5774d9b6f5 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -127,6 +127,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->tun.src_v6 = path->tun.src_v6;
 				info->tun.dst_v6 = path->tun.dst_v6;
 				info->tun.l3_proto = path->tun.l3_proto;
+				info->tun.encap_proto = path->tun.encap_proto;
 				info->num_tuns++;
 			} else {
 				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
@@ -270,6 +271,7 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 		route->tuple[!dir].in.tun.src_v6 = info.tun.dst_v6;
 		route->tuple[!dir].in.tun.dst_v6 = info.tun.src_v6;
 		route->tuple[!dir].in.tun.l3_proto = info.tun.l3_proto;
+		route->tuple[!dir].in.tun.encap_proto = info.tun.encap_proto;
 		route->tuple[!dir].in.num_tuns = info.num_tuns;
 	}
 

-- 
2.54.0

