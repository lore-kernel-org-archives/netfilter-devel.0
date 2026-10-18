Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8A62F616B;
	Sun, 18 Oct 2026 00:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285028; cv=none; b=rpwtrCgaQISDmgsXIGtSbN7/2APhEXp+jTtrz5Ju6g08NDL81832N6Q7BR2uxXHwZf08atRVzTfRPEmBzBUIg2nz2bpckTytbbyfLzj1pSPJx6jYU04ZhnFcq8WqfQFewEx+WEEqdQVVKaOkTxN81gpMBCDAuvNuqA30a8fOV+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285028; c=relaxed/simple;
	bh=BI7vM6etFsbbM5NQ7o0MpNZXEi5KvAKJrw6I/lrcGpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4slraG2T9DQ5pw397uukl64BDIidDWHzm3/cthsX9txdQpopKOpX1Lpk/1xRHQ1UVQaf9ffeHmiQN/VW1zcVJ86KMKaqCedzL4JuMLjh+Lw22JQ/feAWLjpp1OHcyFSfvEMO0YySOucdn7KCl9ZyYS6Wkg6t0nrqrIobjtokag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Pq4qk7vG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Pq4qk7vG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285025;
	bh=gPGyhYQKqXJqFu5cwcQV3Vsg2yC4WSYQGlyq1fpZYrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pq4qk7vGY3NsRxkdFd6FYc4d4RuT56jtZQ7PwJGzmPanztbExd5VFR0FNSDqZdVb0
	 gxMSqADTnBcUUdHz22W2pCqTic5F0dz63f4vH6ETTKV0UiAd41QsaE+7HZhDkk8cr+
	 1+Vvs2+XGAA+AYWoeWh0I7uPGkxHpYuayT4GxBKrdeNeazWMJY2N92dvqUMmS+g30W
	 J5hYoeybpSA+F0VHj3gqTKNcCt6YTj/ekyNiWbAz6ih/+L7uE34s+Aow1Ob3o8MIn1
	 ZYCJRwuhXTFFiUn4rxxGFrE87CvX9tZ3PBAaT+BsWm02Qmqvq6u/UjSndTMwun9eYa
	 vYjbuql41UWuQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0D2B760088;
	Sun, 18 Oct 2026 02:57:05 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 14/15] netfilter: flowtable: add encap_proto to flow_offload_tunnel
Date: Sun, 18 Oct 2026 02:56:37 +0200
Message-ID: <20261018005638.1776148-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018005638.1776148-1-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Add encap_proto (AF_INET or AF_INET6) to struct flow_offload_tunnel
to allow its use as part of the hash table key during flowtable entry
lookup.
This is a preliminary change to support IPv4 over IPv6 tunneling via
the flowtable infrastructure for software acceleration.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h             | 1 +
 include/net/netfilter/nf_flow_table.h | 1 +
 net/ipv4/ipip.c                       | 1 +
 net/ipv6/ip6_tunnel.c                 | 1 +
 net/netfilter/nf_flow_table_ip.c      | 2 ++
 net/netfilter/nf_flow_table_path.c    | 2 ++
 6 files changed, 8 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f61c97231309..fee3728ad666 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -911,6 +911,7 @@ struct net_device_path {
 			};
 
 			u8	inner_proto;
+			u8	encap_proto;
 		} tun;
 		struct {
 			enum {
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5b611efaa3cd..5b22d31cb140 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -118,6 +118,7 @@ struct flow_offload_tunnel {
 	};
 
 	u8	inner_proto;
+	u8	encap_proto;
 };
 
 struct flow_offload_tuple {
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 2ffe64e736e0..15189e1fa068 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -379,6 +379,7 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->tun.src_v4.s_addr = tiph->saddr;
 	path->tun.dst_v4.s_addr = tiph->daddr;
 	path->tun.inner_proto = IPPROTO_IPIP;
+	path->tun.encap_proto = AF_INET;
 	path->tun.dst = &rt->dst;
 	path->dev = ctx->dev;
 
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index d5ff50a2ac01..64a184bca467 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1868,6 +1868,7 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->tun.src_v6 = fl6.saddr;
 		path->tun.dst_v6 = fl6.daddr;
 		path->tun.inner_proto = IPPROTO_IPV6;
+		path->tun.encap_proto = AF_INET6;
 		path->tun.dst = dst;
 		path->dev = ctx->dev;
 		ctx->dev = dst->dev;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8379b45b2dad..29a769736dbf 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -199,12 +199,14 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		tuple->tun.dst_v4.s_addr = iph->daddr;
 		tuple->tun.src_v4.s_addr = iph->saddr;
 		tuple->tun.inner_proto = ctx->tun.inner_proto;
+		tuple->tun.encap_proto = AF_INET;
 		break;
 	case htons(ETH_P_IPV6):
 		ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 		tuple->tun.dst_v6 = ip6h->daddr;
 		tuple->tun.src_v6 = ip6h->saddr;
 		tuple->tun.inner_proto = ctx->tun.inner_proto;
+		tuple->tun.encap_proto = AF_INET6;
 		break;
 	default:
 		break;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index d90013685bf1..841f099434d9 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -138,6 +138,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 				info->tun.dst_v6 = path->tun.dst_v6;
 				info->tun.inner_proto = path->tun.inner_proto;
 				info->tun_dst = path->tun.dst;
+				info->tun.encap_proto = path->tun.encap_proto;
 				info->num_tuns++;
 			} else {
 				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
@@ -249,6 +250,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 		route->tuple[!dir].in.tun.src_v6 = info.tun.dst_v6;
 		route->tuple[!dir].in.tun.dst_v6 = info.tun.src_v6;
 		route->tuple[!dir].in.tun.inner_proto = info.tun.inner_proto;
+		route->tuple[!dir].in.tun.encap_proto = info.tun.encap_proto;
 		route->tuple[!dir].in.num_tuns = info.num_tuns;
 		dst_release(route->tuple[dir].dst);
 		route->tuple[dir].dst = info.tun_dst;
-- 
2.47.3

