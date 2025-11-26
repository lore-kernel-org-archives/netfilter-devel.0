Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDCB34252E;
	Wed, 26 Nov 2025 20:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190588; cv=none; b=ZyXCBd182IFNlUBMBPf3eOUyjyfeq8CVtYRconEo+42dDy2M4p51U/s9J9Xlv74qipx8YdM/+ZgMVFeWlKn10IcHCgHiQe176a4OHceA74XZISASF7SfRcmakJRJhn9yzE6YlnUPkJi0clo0qd+0LaAjIwD8fMjlX9E9GCC3yAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190588; c=relaxed/simple;
	bh=QES8e7HGUZkxIHZTMopV8pVGBKSOeFsMo8lOwa/VGcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euR1a+z2O7B5CGZaQyslv3VkQDEKg4ggTGnNyI4Mk0HfxgUpEy8ExpLTE2zyCtxhT855UlryaQwetGFRVxLaxyUWas9/RzpgvVA1jK71Au62rdKVk3zawhyvM+2q5FjwRN0+OjKUAeG+mkEv79FDrtiUybM6Thjv4pRkrFOa8i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ujgJJ05v; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ujgJJ05v"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 47DC760275;
	Wed, 26 Nov 2025 21:56:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764190584;
	bh=DW+UEv8/ZpE0xklYkdZPUjjoeWeQEo+eiUtdlID+Fnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujgJJ05v7hiKYtMjQYnbArWd/lnf1+ZGqka2cugPYI+tUrLdPB2STV8fvelwA/ZR1
	 Sgw2ObRoFs0xYka8r7+HstPPKXzl7I8Ar5wfrLC4oyCB1+2Bzd8qT7fnYRbYENiDPI
	 R5bJpIW4uNrB0laAeMwEPzXfY0vNIO2hGURiPtAWRrFyzKSmtykZ0t25hYRyNamNlU
	 ObyQxmuqaCpJlfn5eb7T25brDUzWlSgy+/rpMBJI+ybEPu98/2phTZR3nnfxnPfYwb
	 u/tngw6N3IeyE5eeHUWUxL3yLX6cbzhoyxNS79Pajg7RISJNuQblhK99/cNbg/hN+q
	 srLEcTldp8WCw==
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
Date: Wed, 26 Nov 2025 20:55:58 +0000
Message-ID: <20251126205611.1284486-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126205611.1284486-1-pablo@netfilter.org>
References: <20251126205611.1284486-1-pablo@netfilter.org>
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

