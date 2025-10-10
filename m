Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668072253A1
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 11:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760095128; cv=none; b=tGP+PYFVi/Pv7hlkWW/wbxheGE5wSC9kSlb2sdoYsyLDcjxuISKBC4d0Br84LyfwT2x163lAcgYK1MyImBAZ3/PtUPU/XZYfcJwapbaI7WzkOF+BmPzFw2+VNyKWBJDZUooksxd4MFkMTShYHfxtDyh+tqDU8YE5C209fCqE9D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760095128; c=relaxed/simple;
	bh=o0rElA5r2V8SzVV5erTKU2I5cDy9U7I1Rvk8uHSVUlQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T62EDxRu6V4s3mfkSG7zJY3/k1+95Zcfn43UaJd6fl1g38+idKQVwycgijRyhjWvNOzUwyr6oiQ2cjMwzuWdHq4n8PY03+uFO20DkOpmwF93AstmIaOSnBuEEOAnyKVSND7phYzGF1uilGRBdIrkerSuvv63CuD3UA6HAqilnpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BpsbAjVQ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RNRfwyXb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BpsbAjVQ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RNRfwyXb"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 50D0D602AE; Fri, 10 Oct 2025 13:18:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760095119;
	bh=ZN5Ia3qw3tKehdVObPShnrApB/BoRXUQC6UcMdkkAOE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BpsbAjVQjoBXJzvCXxhgVCrHyguO85In9o1XwZFPwUwcmB6rjpMsUtoZkmysyVTJf
	 m4Al03J+lpdf3rHfZAmIMyRCrtMLpPXKmK2P2dnWey6mTSp4Ro0keC9sOju70bkN9T
	 /89ootTsdkrQS3BvcLE0241adYoBYcM1kD9Nr1Rjzyx7f5PI8WSAkhehgQ81ZjdHws
	 fLzZB05pVswzTMGRLX/fqFtE5mo0pqS5g4qRynG+0wk0n2AM+9HR+UoYmASnaeh0iP
	 owSdPl4ljqNTEXOxd8Hwb/zC8/5rlJfZM9EGOZGZA5b+/2JcJ7teR8gBkUEr2plDb9
	 EvGizOQaWZogw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B0E04602A9
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 13:18:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760095118;
	bh=ZN5Ia3qw3tKehdVObPShnrApB/BoRXUQC6UcMdkkAOE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RNRfwyXbCmmdT9xyIIwd8FWzz+cyVWrfQEG+zL3suerbu0OqhZOI+dH5rzGt8IoX8
	 0NSxXgwuHd4GvEsbrKup/E4axcn837G/+upHm4dfDB1w/+wtGUz7C4aJX2m7lkNMXK
	 CgKIHokoFb7wo7wbZ/mc5aCrRNLn3ew9eHvYMvn/dIDKFIh+wgjdPCP+1+LNfwdN16
	 bdbzA9luZJOGKCaDfuFl9J8wWWi91bqCCj+r6Jlmg5xz8RvqYe9m0ULFk0eiS7pe3I
	 QH3aa+jHlGgtexFmCZuE8E3ON1894HSxE5Ll8bNX5DqLL6Pu93HcduTndFn8WdH0IC
	 NwrmQrwW981Kg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/5] netfilter: flowtable: inline vlan encapsulation in xmit path
Date: Fri, 10 Oct 2025 13:18:23 +0200
Message-Id: <20251010111825.6723-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251010111825.6723-1-pablo@netfilter.org>
References: <20251010111825.6723-1-pablo@netfilter.org>
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
 net/netfilter/nf_flow_table_ip.c   | 20 ++++++++++++++++++++
 net/netfilter/nf_flow_table_path.c |  7 ++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8b74fb34998e..2d11c46a925c 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -413,6 +413,23 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	return 1;
 }
 
+static int nf_flow_encap_push(struct sk_buff *skb, struct flow_offload_tuple *tuple)
+{
+	int i;
+
+	for (i = 0; i < tuple->encap_num; i++) {
+		switch (tuple->encap[i].proto) {
+		case htons(ETH_P_8021Q):
+		case htons(ETH_P_8021AD):
+			if (skb_vlan_push(skb, tuple->encap[i].proto, tuple->encap[i].id) < 0)
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
@@ -450,6 +467,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (nf_flow_encap_push(skb, &flow->tuplehash[!dir].tuple) < 0)
+		return NF_DROP;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
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
2.30.2

