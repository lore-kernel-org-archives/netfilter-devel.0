Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15513E49F7
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 08:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785920050; cv=none; b=nHDrGnYLdZUYIBESBPUF/lwAg4lO4Qmyw1aM/mk3bcGhxx8VnKo9fkPXwWV007nQaMBRnOh2vYEtrTEGDSqQKCONTR5WCaKLTY05W73y6IIcZCvfFR9BDKBhIArWz2g9H/DAKD0bJ+E4OGcAuIpLNMY86MQjUN4OLKkgBcRSOPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785920050; c=relaxed/simple;
	bh=ZiWXWyoC7YBFxPqrh92AacqSzsXXBSu88/60x3OFoOU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=f9KKbZisC8l1+AbQTmg11QMjdIwMFgemAHurxHJxGgW4GrUftgszzpcFmMah061lVBxm7P+eDE4oBWRTR6YtOxaJCBVjxCUqj/0MoVUIEvWY79tmP+ZGkIpSLQKysy7bbcsqKjQodCdAVB5dyWQb2OS2ckG1ChhL9TCfWeXPnbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DGYpQORb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=i7jW+75S; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DGYpQORb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="i7jW+75S"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6758dCR62132431
	for <netfilter-devel@vger.kernel.org>; Wed, 5 Aug 2026 08:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Su6pUumKgpP8taWCBv6778
	NBns5sO908kIeSqx2hTLE=; b=DGYpQORbLV3qXFfNsqspPQqIkAFOt00/0xAP9d
	agsIb914lZk1Hj3166ybKWN/ikTZKrM1bX9SyuiKA5OXwMsBhyrRvHyv3RTMmzFM
	ejSfW+jnxJ7gGv/atQabfzZEzF9J6CB7QTcuTYypGbEYGWPcCGCFD+kWyhoYkNNj
	mJax7/F2D6eXfSUKB+yRcX0CRzO7IYNFDgidL/82IHT+r+Ysfx//AbWCUam6mPIj
	1pOlPsYzOu26mx4kpvQ3R5AZ3GbuyIya2+aB2dzqtO9Zzec5K1zjjhG00c/j6+X/
	Al2RIwMwc2Dyv8WRuEnKLWkbwSRWVcYUIk4IcposEvs9joNA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fum56bnek-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Wed, 05 Aug 2026 08:54:07 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c1eb52e1fso12324751cf.0
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Aug 2026 01:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785920047; x=1786524847; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Su6pUumKgpP8taWCBv6778NBns5sO908kIeSqx2hTLE=;
        b=i7jW+75SC1RZ9+yE5rmizjtwgelFekxj/PGWKm0urs2wBldtnFoFAg33Voo6fCaBFB
         rq1mIkI3KC84UKSwkYNiMDUVcpCnKHEQjaOIi6M1xTh8+PdvZdBu0dBQWIcjhphznfzk
         oxAE2428CvQNvzsoPi+cusaRcRkiWThKZDPz1rUWI/iwv3wXJEVItXPg5g7DSGeybjs2
         RJzoiuT/4BpTqcjo+G3purxleDFVhy1PjBcXISqv2DWyDwnZigq2Eo0j6mrNAHQe7guF
         spJucUkJc//Gy0GRJJTjmyFpctjfFE7HOiDczHZVK1lQHyXMhENNao5nPxsR/KEAk8+W
         NyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785920047; x=1786524847;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Su6pUumKgpP8taWCBv6778NBns5sO908kIeSqx2hTLE=;
        b=VFZHX2Zx2PotLZGH6bGK48u0mu8HMWfB31dubjdwvpGSFsa49XE3yEE1c7qtqZ97Z8
         gErOYHBTT9BrWBoKCazIRcGIRsC8tHk7sKVl0dSwqa3M32N8GENlUcrA7iGsZQCLBO1K
         CKFqVfbPgM0QoRQOy9FPBbxm3rOER+eJCKKZNwH5DIOVeCucWpSdewNGKxHw6PBbilHv
         6MCxBn4RX/iKdB5KvwrndLNpDKQBuHYpzJWht9VXlEck6aTiCejB1+4hzHkFJjWq0wuH
         Vx2NGIlMbCxjugDHniVM5n3i++gDqYPkuBH5jiRA3H75kDLdbTpvOgsUDRgtf9Ake85a
         9KPQ==
X-Forwarded-Encrypted: i=1; AHgh+RqC9kCNseii/mHjHmvmKamILcXH+FcVSZlO4Srx9Bd5LOwSKQ+kdmXfWDk96pfRlmIAxFsj1rDxxhOwaM92tmY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWssbK8/4ArOqyyn023xPQHLcaQZ8WO1kx07MqQDVTE9hD04t5
	juJCEBnbpEEuRq8cW9m6UCo3tbeBwQjPn63+DHbr39WwF5f055uA+Lm4FZTPHez6W4kDAxcXPyn
	CaJeoGoKu+SQN71kUE2JmOf1gDEAnAYAu8mkykunzTFtyiH1J7/5HFJUdrupP49tQbF+rA4I=
X-Gm-Gg: AR+sD11oAVBr0vL853me8m/B6p45MP0EoHaY7TXYX74bnRAV0t8KmfInUXkjsYVB4UA
	bktfWjQPxjhjZK1nXDFNMAYx23Bw6n9rjHGsDvnImBS2adcd/+RJ1cb8rCiXQhdxqlfLbT0vSC7
	TNjxU53EuDmJrCg4F2aNM5TXqwtVr/gsQ+WgDTW5Pmmnrv9AIvIl1WoE7v/Vs5CEmxk7Xb4criy
	kYHCQ/iKFj2s0aQsGEtJOCXPUDrS1ctnPuy+LlItBXXfzk32ebyxGiwflf09JgbUmrmbGtc6YH8
	PV+op8uF2vb7vMJFy3oX6ssNM2SrRySFvCKXi+o+j/boL92EoAEzaQ+A/zKd3JDCoWpJOGy38yq
	JjhpZ0UwLG7N6nIw=
X-Received: by 2002:a05:622a:5c07:b0:51c:1a46:9148 with SMTP id d75a77b69052e-52ce61934eamr55890431cf.34.1785920046807;
        Wed, 05 Aug 2026 01:54:06 -0700 (PDT)
X-Received: by 2002:a05:622a:5c07:b0:51c:1a46:9148 with SMTP id d75a77b69052e-52ce61934eamr55890001cf.34.1785920046322;
        Wed, 05 Aug 2026 01:54:06 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994dfda556sm82948865e9.5.2026.08.05.01.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 01:54:05 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Wed, 05 Aug 2026 10:53:09 +0200
Subject: [PATCH nf-next] net: pass net_device_path_ctx to
 dev_fill_forward_path()
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260805-dev_fill_forward_path-ctx-arg-v1-1-f2873d941755@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqDMBAAwK/InruQGk2lXykSotnogkTZBBsQ/
 97Q41zmgkTClODdXCB0cuI9VjwfDcyriwsh+2poVWvUoHr0dNrA22bDLl8n3h4urzjngk4WfGl
 tjO560tMA9TiEApf//4EYMFLJMN73D1GnxCN4AAAA
X-Change-ID: 20260805-dev_fill_forward_path-ctx-arg-73366345e3b8
To: Lorenzo Bianconi <lorenzo@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Simon Horman <horms@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Cc: linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA2OSBTYWx0ZWRfX+JfKwQtubIUF
 WI0j/0aOR4cAGBirFQbR76kaHCySj6oVfY+PEvlKlhDvNwwRW7ZmzsJOPa/ioNxc/IF/b/wjJK9
 tYFqcINhGyXproo27jr1vNEfjF534FWZMBnlLEaHUmdEVizHMBfLawDsM8HVGjJzFEODBtzMW6z
 qx8L9+tpd9uLgSmJTxjNfofqiiHnuf0+738OfLIoKrcHduF8jtayEp1RqVZ6eoWiknZgsp5laPO
 6EzuWiE8dXffEnkbACYiBbyz9as2eB7i7yz8hR/Ou1pIXqek3O85i9J+GL/ZBYnMuTv73QZEYP4
 KkCjjhcTWF0hAEjK6c7LmJR+d5ggCPwFz49ykMiT7NmtKYFXRPKI4uhzxJjDyU3vU1otFFBRC4H
 rkPb66LDToAWKQhNjOUxn6lqw+G9USm5g/BxhwqULc/c8A+aszXRKxXqVudJsg9UmJGqMnhWaGX
 pMfGHQlMv0l1cDZ/Q7A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA2OSBTYWx0ZWRfX1kVwdciPC8ZT
 3V4FnmcvRcREusIyof7RfUHO+VORnyaxWtkP1u6vuVNZCqykX+COrZtVe6NyCAE6C7xct8IsJCl
 gE8qSTYnNgKYJYRlvdnhK80UxhiRJGg=
X-Proofpoint-GUID: 2SxiwKVerlwKv6swdddZdlmEtLdD2ViW
X-Proofpoint-ORIG-GUID: 2SxiwKVerlwKv6swdddZdlmEtLdD2ViW
X-Authority-Analysis: v=2.4 cv=GL441ONK c=1 sm=1 tr=0 ts=6a72fa2f cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=xc6HxeBLMKpXFN7qBEQA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_03,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 clxscore=1011 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050069

Refactor dev_fill_forward_path() to take a struct net_device_path_ctx
pointer instead of a (dev, daddr) pair, so the caller can build and
populate the context up front and keep it after the forward path walk.

This allows additional fields (e.g. vlan and ether_type) to be carried
in the context and shared with ndo_fill_forward_path implementations,
instead of being reconstructed on the stack inside the core helper.

Update the mtk_ppe_offload, airoha_ppe and nf_flow_table_path callers to
allocate and fill the context before invoking dev_fill_forward_path().
The network topology resolution behaviour is unchanged.

This is a preliminary patch to enable HW flowtable offload for IPv4
over IPv6 tunnels.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/ethernet/airoha/airoha_ppe.c        |  7 ++++++-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c |  7 ++++++-
 include/linux/netdevice.h                       |  2 +-
 net/core/dev.c                                  | 18 +++++++-----------
 net/netfilter/nf_flow_table_path.c              |  7 ++++++-
 5 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 33ddf0d07855..53183a132100 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -283,14 +283,19 @@ static int airoha_ppe_get_wdma_info(struct net_device *dev, const u8 *addr,
 				    struct airoha_wdma_info *info)
 {
 	struct net_device_path_stack stack;
+	struct net_device_path_ctx ctx = {
+		.dev = dev,
+	};
 	struct net_device_path *path;
 	int err;
 
 	if (!dev)
 		return -ENODEV;
 
+	ether_addr_copy(ctx.daddr, addr);
+
 	rcu_read_lock();
-	err = dev_fill_forward_path(dev, addr, &stack);
+	err = dev_fill_forward_path(&ctx, &stack);
 	rcu_read_unlock();
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index cc8c4ef8038f..1ec46784f018 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -92,6 +92,9 @@ static int
 mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_info *info)
 {
 	struct net_device_path_stack stack;
+	struct net_device_path_ctx ctx = {
+		.dev = dev,
+	};
 	struct net_device_path *path;
 	int err;
 
@@ -101,8 +104,10 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 	if (!IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED))
 		return -1;
 
+	ether_addr_copy(ctx.daddr, addr);
+
 	rcu_read_lock();
-	err = dev_fill_forward_path(dev, addr, &stack);
+	err = dev_fill_forward_path(&ctx, &stack);
 	rcu_read_unlock();
 	if (err)
 		return err;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8db25b79573e..d2f545016f7f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3425,7 +3425,7 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
-int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 			  struct net_device_path_stack *stack);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index c1c1be1a6962..e2c9fe3f7a7b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -750,41 +750,37 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 	return &stack->path[k];
 }
 
-int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 			  struct net_device_path_stack *stack)
 {
 	const struct net_device *last_dev;
-	struct net_device_path_ctx ctx = {
-		.dev	= dev,
-	};
 	struct net_device_path *path;
 	int ret = 0;
 
-	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
 	stack->num_paths = 0;
-	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
-		last_dev = ctx.dev;
+	while (ctx->dev && ctx->dev->netdev_ops->ndo_fill_forward_path) {
+		last_dev = ctx->dev;
 		path = dev_fwd_path(stack);
 		if (!path)
 			return -1;
 
 		memset(path, 0, sizeof(struct net_device_path));
-		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
+		ret = ctx->dev->netdev_ops->ndo_fill_forward_path(ctx, path);
 		if (ret < 0)
 			return -1;
 
-		if (WARN_ON_ONCE(last_dev == ctx.dev))
+		if (WARN_ON_ONCE(last_dev == ctx->dev))
 			return -1;
 	}
 
-	if (!ctx.dev)
+	if (!ctx->dev)
 		return ret;
 
 	path = dev_fwd_path(stack);
 	if (!path)
 		return -1;
 	path->type = DEV_PATH_ETHERNET;
-	path->dev = ctx.dev;
+	path->dev = ctx->dev;
 
 	return ret;
 }
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 98c03b487f52..b9df7453f762 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -50,6 +50,9 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 {
 	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
 	struct net_device *dev = dst_cache->dev;
+	struct net_device_path_ctx ctx = {
+		.dev = dev,
+	};
 	struct neighbour *n;
 	u8 nud_state;
 
@@ -72,7 +75,9 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 		return -1;
 
 out:
-	return dev_fill_forward_path(dev, ha, stack);
+	ether_addr_copy(ctx.daddr, ha);
+
+	return dev_fill_forward_path(&ctx, stack);
 }
 
 struct nft_forward_info {

---
base-commit: a23b36233d4103def55dc8cf65698106d0bd1e62
change-id: 20260805-dev_fill_forward_path-ctx-arg-73366345e3b8

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

