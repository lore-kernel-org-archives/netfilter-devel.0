Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB77E2EC09B;
	Tue, 25 Nov 2025 22:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764110009; cv=none; b=E8nIRECrhehn6H7xFcZAo/0ikh+yioG2BdBDN9j/AQqgfEttAvvk7KF9choEQECNmGlQYmSecSVydxmGR2B+/Hi/oXE+bUYY39vZzfR+kq10IHnkfPi0B0HB3qZpacerJf17i2C2K3BEHZv4RVFZWeU1g4TqStu4Stl0ZEuCex0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764110009; c=relaxed/simple;
	bh=QES8e7HGUZkxIHZTMopV8pVGBKSOeFsMo8lOwa/VGcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvBnzP59h4i3EvnBWYDVUNzGQRE8XL6GfZWC7JHmAjdOz0L0L9rQ+OOJmEbBHP7DWHbjmSxD4yE8jTCJKBwVlCDBZjBo6mA5f/16hqE91kXlT9xWwXTDC7suHz7BxVvhVZSMa7uRiPezRledA0d5YACcOUOpREKyMjkcT6wo+BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UwzapezK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UwzapezK"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EEF0260279;
	Tue, 25 Nov 2025 23:33:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764110003;
	bh=DW+UEv8/ZpE0xklYkdZPUjjoeWeQEo+eiUtdlID+Fnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwzapezKncfdnNA9RMdMVWuEzoaH5H5d1mO+EAlHDvhSnauim9xLf2uhY9dqAIsNf
	 zgHOR+MGxlrihUtmZafwtCCXz7i+4e9UeU+NB1LDbktrd4dwLuMn262cJ4lRX6Umj+
	 iWJnkG3k4J90F4w72Mu7A8BE75eZCbW/9sMOP5HmtagwUAeRdIPhnv0m1H/j5DOrSJ
	 bQGaouy7o6Eh6xk9DCJL/mz6graU4QpRZ5fbP62tjbeMcdMLLEMVEWoYt7Syyq+deG
	 BErP31WlCt8AtxH5b6Aa1aM7FcTsdnVI9JI2SoAblIBjlnRvp5BIKzzupU834k6AhC
	 IYwiVN5BXinmQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 03/16] netfilter: flowtable: inline vlan encapsulation in xmit path
Date: Tue, 25 Nov 2025 22:32:59 +0000
Message-ID: <20251125223312.1246891-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125223312.1246891-1-pablo@netfilter.org>
References: <20251125223312.1246891-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Push the vlan header from the flowtable xmit path, instead of passing
the packet to the vlan device.

This is based on a patch originally written by wenxu.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c   | 25 +++++++++++++++++++++++++
 net/netfilter/nf_flow_table_path.c |  7 ++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8b74fb34998e..a4229fb65444 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -413,6 +413,25 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	return 1;
 }
 
+static int nf_flow_encap_push(struct sk_buff *skb,
+			      struct flow_offload_tuple *tuple)
+{
+	int i;
+
+	for (i = 0; i < tuple->encap_num; i++) {
+		switch (tuple->encap[i].proto) {
+		case htons(ETH_P_8021Q):
+		case htons(ETH_P_8021AD):
+			if (skb_vlan_push(skb, tuple->encap[i].proto,
+					  tuple->encap[i].id) < 0)
+				return -1;
+			break;
+		}
+	}
+
+	return 0;
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -450,6 +469,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (nf_flow_encap_push(skb, &flow->tuplehash[!dir].tuple) < 0)
+		return NF_DROP;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
@@ -754,6 +776,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (nf_flow_encap_push(skb, &flow->tuplehash[!dir].tuple) < 0)
+		return NF_DROP;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 15c042cab9fb..1cb04c3e6dde 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -119,13 +119,14 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->indev = NULL;
 				break;
 			}
-			if (!info->outdev)
-				info->outdev = path->dev;
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
-			if (path->type == DEV_PATH_PPPOE)
+			if (path->type == DEV_PATH_PPPOE) {
+				if (!info->outdev)
+					info->outdev = path->dev;
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
+			}
 			break;
 		case DEV_PATH_BRIDGE:
 			if (is_zero_ether_addr(info->h_source))
-- 
2.47.3

