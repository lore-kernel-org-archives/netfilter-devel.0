Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0E23A7842
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 23:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773791354; cv=none; b=muMqFEPIKRiRMGKH1iLjy9boIQN9ySRh9Hv+weiUA98RhQqF/f8ZVoGPOdP3Jr5MEgnCbPnAg96mzZ1EurOh7lTKScL/aOLp1P5+qKyCoPskPFsB6FWfBXjThpPV6Lw+ChHR2l79YFOw8HevHisFUmalTw2u2e3RvXdD1g01EdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773791354; c=relaxed/simple;
	bh=yesOupGQGJjiAyz5bU3hkmYxkD+A/WGg/zBYa/oIWSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhG41nGSQ1DmoyAGf9f8IzO8FLFY1OVFbahR96N+Myfvdczg6H46nEIcCM7B3+qA1H86nyT8cLY9/4t25aQiWTPLH0GmHAfT91lJ3n9PcdPF/4XHbLFfYFWeoOxMOQAopR1Yvpo6T+YMmG93PzPFWt/5uMhmF4pczb2JQk9qU0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IjHjti1j; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjHjti1j"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439c6fc2910so4759834f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 16:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773791350; x=1774396150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O6ipd6tpbNPeuOXXVzcYM56hqSLKchpu1vcH6GiMAY4=;
        b=IjHjti1jZuIp9oaCvRhmkXv8JQwLemZ8CtK44/I7Pw84xOVR/RRsinGzeofDtgJY1q
         kfKpboIuV0NK3TouvCnwywWmVuejEXo6rl8TeG/8X7xPaGiFME6Mj+4/Qo/T9Dg4mHoa
         37dHUeWJLs0n3m+UGbVk1BTRKBaRiyx+P3iK+bSNh0bJK2+wk1ofny6d9iMyO7Dbt6zY
         /wocxcdmQ5EpxP/4dvgSZz644qWGeZRZ4SZX84d9Bljp+kMKO6iDzzUtmsqeCVkJFfvK
         lgc5Z573yJynya/O0OUkst3Ek1F/vTSOoVoXbxet3LwqelOrFqZfY/wdodh/F5x7aj4P
         er0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773791350; x=1774396150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O6ipd6tpbNPeuOXXVzcYM56hqSLKchpu1vcH6GiMAY4=;
        b=QtvsCCH/pwkudPPYPpUlhAclvRQdSXEPLwVxBBV+pgpwfY7eUGMve83OlX0gbmWCKb
         vrFRnTWtJWAcZLM2cqqv9pdEcHyBLNJKx4g2i2lctT3bySRh78dVh4a6eyZjJSBTm9/7
         5Vw8A3a6q4J1QYNQeUBdljbBoW8ejdqv0+KUgPGg9oR3MXUqdiPRY2nZf/SLwAUhkrc7
         gPJwEd5U6U3b/sA9YZS9Z5n54OulMl8gC6DfGuKzQNG/bMbLCCgnWAu1ajD0c38dCqrX
         UG9UZ2OItPjwZE0RhIU2Vy8Y155omfHzA8Xb6POfffJzmRcpMBnqKb7QRyI3/u2Qo1so
         RiYg==
X-Gm-Message-State: AOJu0YwcVj2GQ08dT5p3Y0DSIdN91QggqjZlFZu444TEZ/rwyU0LZOak
	YAQOGcmCwv3tJnI5C4QqLc2/ywrq59Eva9f8RqnPl9FProtjXJ+o8DlqKPk6f8aRtmUmxg==
X-Gm-Gg: ATEYQzzzrrwyAJyroOpDM/wx5w7nANhCzWbPyaoxMMZ7Ft2hVZzON287L2y916JlK6G
	tmNn9ZUUd7lDtgNBZ+8oOLXGnY2KrqNVH0+7cfAPGorMrB4Zb/v7y0o7qsaiq3ZPcOFH9b0K5fC
	+U4ebENeXvBzU/g7TQfI+2wMRVUIijfKcnD4YVhw6IEfFvru9v/7xGAdJYxpk2QSnFQmgVJPSij
	Kuofq1xHEqhZuUZ/l1M/jtmr3mclcqro9o2WRLEhXYufdtoYjDiZeviwzL0Xd/KBaPtAgjZym76
	5y82BopTzqGJLYq2mW2igPGkyRD3fP2lzgWy1xnkWxt+oU1FASzuRpG8m7gA7ZBBLaGSvbBdYGx
	/68JWAqLcIuAPBoP429U1kwoL2UtdtJF8moR/vpQpcEr38K4ARo0EQyuXNAdb9JWd3DcrKMls8I
	kph1wSmn5jq25PgTWmn0X1yJlo7zMH4mI=
X-Received: by 2002:a05:6000:3103:b0:439:bce5:6508 with SMTP id ffacd0b85a97d-43b527a8f11mr1979880f8f.14.1773791350067;
        Tue, 17 Mar 2026 16:49:10 -0700 (PDT)
Received: from azaki-desk1.. ([41.234.201.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b518a3d78sm3279810f8f.34.2026.03.17.16.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 16:49:08 -0700 (PDT)
From: Ahmed Zaki <anzaki@gmail.com>
To: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de
Cc: coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next 1/2] net: treewide: pass number of pkts to dev_sw_netstats_rx_add()
Date: Tue, 17 Mar 2026 17:48:50 -0600
Message-ID: <20260317234851.234466-2-anzaki@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317234851.234466-1-anzaki@gmail.com>
References: <20260317234851.234466-1-anzaki@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow callers of dev_sw_netstats_rx_add() to update the netdev stats
with multiple packets.

Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
---
 drivers/infiniband/hw/hfi1/driver.c                      | 2 +-
 drivers/net/amt.c                                        | 6 +++---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c        | 2 +-
 drivers/net/ethernet/litex/litex_liteeth.c               | 2 +-
 drivers/net/ethernet/realtek/r8169_main.c                | 2 +-
 drivers/net/ethernet/realtek/rtase/rtase_main.c          | 2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                 | 6 +++---
 drivers/net/ethernet/ti/icssg/icssg_common.c             | 4 ++--
 drivers/net/gtp.c                                        | 2 +-
 drivers/net/macsec.c                                     | 2 +-
 drivers/net/netkit.c                                     | 2 +-
 drivers/net/ppp/ppp_generic.c                            | 2 +-
 drivers/net/tun.c                                        | 8 ++++----
 drivers/net/usb/qmi_wwan.c                               | 2 +-
 drivers/net/wireguard/receive.c                          | 2 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c | 2 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c | 2 +-
 include/linux/netdevice.h                                | 6 ++++--
 net/bridge/br_input.c                                    | 2 +-
 net/core/filter.c                                        | 2 +-
 net/dsa/tag.c                                            | 2 +-
 net/ipv4/ip_tunnel.c                                     | 2 +-
 net/ipv4/ip_vti.c                                        | 2 +-
 net/ipv6/ip6_tunnel.c                                    | 2 +-
 net/ipv6/ip6_vti.c                                       | 2 +-
 net/ipv6/sit.c                                           | 2 +-
 net/mac80211/rx.c                                        | 8 ++++----
 net/openvswitch/vport-internal_dev.c                     | 2 +-
 net/xfrm/xfrm_interface_core.c                           | 2 +-
 29 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 06487e20f723..a5e91ae7619e 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1689,7 +1689,7 @@ static void hfi1_ipoib_ib_rcv(struct hfi1_packet *packet)
 	if (unlikely(!skb))
 		goto drop;
 
-	dev_sw_netstats_rx_add(netdev, skb->len);
+	dev_sw_netstats_rx_add(netdev, 1, skb->len);
 
 	skb->dev = netdev;
 	skb->pkt_type = PACKET_HOST;
diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index f2f3139e38a5..11b4d0ffc8a1 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2340,7 +2340,7 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	len = skb->len;
 	err = gro_cells_receive(&amt->gro_cells, skb);
 	if (likely(err == NET_RX_SUCCESS))
-		dev_sw_netstats_rx_add(amt->dev, len);
+		dev_sw_netstats_rx_add(amt->dev, 1, len);
 	else
 		amt->dev->stats.rx_dropped++;
 
@@ -2439,7 +2439,7 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	local_bh_disable();
 	if (__netif_rx(skb) == NET_RX_SUCCESS) {
 		amt_update_gw_status(amt, AMT_STATUS_RECEIVED_QUERY, true);
-		dev_sw_netstats_rx_add(amt->dev, len);
+		dev_sw_netstats_rx_add(amt->dev, 1, len);
 	} else {
 		amt->dev->stats.rx_dropped++;
 	}
@@ -2541,7 +2541,7 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 	if (__netif_rx(skb) == NET_RX_SUCCESS) {
 		amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_UPDATE,
 					true);
-		dev_sw_netstats_rx_add(amt->dev, len);
+		dev_sw_netstats_rx_add(amt->dev, 1, len);
 	} else {
 		amt->dev->stats.rx_dropped++;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c
index a4ea92c31c2f..bc1104b9f27d 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c
@@ -516,7 +516,7 @@ static int hbg_napi_rx_poll(struct napi_struct *napi, int budget)
 		skb_put(buffer->skb, pkt_len);
 		buffer->skb->protocol = eth_type_trans(buffer->skb,
 						       priv->netdev);
-		dev_sw_netstats_rx_add(priv->netdev, pkt_len);
+		dev_sw_netstats_rx_add(priv->netdev, 1, pkt_len);
 		napi_gro_receive(napi, buffer->skb);
 		buffer->skb = NULL;
 		buffer->page = NULL;
diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
index 108d0a0db206..375a049fb3ad 100644
--- a/drivers/net/ethernet/litex/litex_liteeth.c
+++ b/drivers/net/ethernet/litex/litex_liteeth.c
@@ -78,7 +78,7 @@ static int liteeth_rx(struct net_device *netdev)
 	memcpy_fromio(data, priv->rx_base + rx_slot * priv->slot_size, len);
 	skb->protocol = eth_type_trans(skb, netdev);
 
-	dev_sw_netstats_rx_add(netdev, len);
+	dev_sw_netstats_rx_add(netdev, 1, len);
 
 	return netif_rx(skb);
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 791277e750ba..0cbeaa1b7d4e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4846,7 +4846,7 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
 
 		napi_gro_receive(&tp->napi, skb);
 
-		dev_sw_netstats_rx_add(dev, pkt_size);
+		dev_sw_netstats_rx_add(dev, 1, pkt_size);
 release_descriptor:
 		rtl8169_mark_to_asic(desc);
 	}
diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index ef13109c49cf..40186d6a926a 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -568,7 +568,7 @@ static int rx_handler(struct rtase_ring *ring, int budget)
 		rtase_rx_vlan_skb(desc, skb);
 		rtase_rx_skb(ring, skb);
 
-		dev_sw_netstats_rx_add(dev, pkt_size);
+		dev_sw_netstats_rx_add(dev, 1, pkt_size);
 
 skip_process_pkt:
 		workdone++;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index a38bf7f4f434..1d92c3d27946 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1210,13 +1210,13 @@ static int am65_cpsw_run_xdp(struct am65_cpsw_rx_flow *flow,
 		if (err)
 			goto drop;
 
-		dev_sw_netstats_rx_add(ndev, pkt_len);
+		dev_sw_netstats_rx_add(ndev, 1, pkt_len);
 		return AM65_CPSW_XDP_TX;
 	case XDP_REDIRECT:
 		if (unlikely(xdp_do_redirect(ndev, xdp, prog)))
 			goto drop;
 
-		dev_sw_netstats_rx_add(ndev, pkt_len);
+		dev_sw_netstats_rx_add(ndev, 1, pkt_len);
 		return AM65_CPSW_XDP_REDIRECT;
 	default:
 		bpf_warn_invalid_xdp_action(ndev, prog, act);
@@ -1358,7 +1358,7 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_rx_flow *flow,
 	am65_cpsw_nuss_rx_csum(skb, csum_info);
 	napi_gro_receive(&flow->napi_rx, skb);
 
-	dev_sw_netstats_rx_add(ndev, pkt_len);
+	dev_sw_netstats_rx_add(ndev, 1, pkt_len);
 
 allocate:
 	new_page = page_pool_dev_alloc_pages(flow->page_pool);
diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index 0cf9dfe0fa36..60cac4d0a936 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -811,14 +811,14 @@ static u32 emac_run_xdp(struct prueth_emac *emac, struct xdp_buff *xdp, u32 *len
 			goto drop;
 		}
 
-		dev_sw_netstats_rx_add(ndev, xdpf->len);
+		dev_sw_netstats_rx_add(ndev, 1, xdpf->len);
 		return result;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(emac->ndev, xdp, xdp_prog);
 		if (err)
 			goto drop;
 
-		dev_sw_netstats_rx_add(ndev, pkt_len);
+		dev_sw_netstats_rx_add(ndev, 1, pkt_len);
 		return ICSSG_XDP_REDIR;
 	default:
 		bpf_warn_invalid_xdp_action(emac->ndev, xdp_prog, act);
diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index e8949f556209..be1f884de218 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -335,7 +335,7 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 
 	skb->dev = pctx->dev;
 
-	dev_sw_netstats_rx_add(pctx->dev, skb->len);
+	dev_sw_netstats_rx_add(pctx->dev, 1, skb->len);
 
 	__netif_rx(skb);
 	return 0;
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f6cad0746a02..807939aa8c64 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -836,7 +836,7 @@ static void macsec_finalize_skb(struct sk_buff *skb, u8 icv_len, u8 hdr_len)
 
 static void count_rx(struct net_device *dev, int len)
 {
-	dev_sw_netstats_rx_add(dev, len);
+	dev_sw_netstats_rx_add(dev, 1, len);
 }
 
 static void macsec_decrypt_done(void *data, int err)
diff --git a/drivers/net/netkit.c b/drivers/net/netkit.c
index 5c0e01396e06..993ea62336a3 100644
--- a/drivers/net/netkit.c
+++ b/drivers/net/netkit.c
@@ -107,7 +107,7 @@ static netdev_tx_t netkit_xmit(struct sk_buff *skb, struct net_device *dev)
 		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
 		if (likely(__netif_rx(skb) == NET_RX_SUCCESS)) {
 			dev_sw_netstats_tx_add(dev, 1, len);
-			dev_sw_netstats_rx_add(peer, len);
+			dev_sw_netstats_rx_add(peer, 1, len);
 		} else {
 			goto drop_stats;
 		}
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 6344c5eb0f98..c9f33b588fab 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -2507,7 +2507,7 @@ ppp_receive_nonmp_frame(struct ppp *ppp, struct sk_buff *skb)
 		break;
 	}
 
-	dev_sw_netstats_rx_add(ppp->dev, skb->len - PPP_PROTO_LEN);
+	dev_sw_netstats_rx_add(ppp->dev, 1, skb->len - PPP_PROTO_LEN);
 
 	npi = proto_to_npindex(proto);
 	if (npi < 0) {
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index c492fda6fc15..2d6547d0453d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1567,7 +1567,7 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 			dev_core_stats_rx_dropped_inc(tun->dev);
 			return err;
 		}
-		dev_sw_netstats_rx_add(tun->dev, xdp->data_end - xdp->data);
+		dev_sw_netstats_rx_add(tun->dev, 1, xdp->data_end - xdp->data);
 		break;
 	case XDP_TX:
 		err = tun_xdp_tx(tun->dev, xdp);
@@ -1575,7 +1575,7 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 			dev_core_stats_rx_dropped_inc(tun->dev);
 			return err;
 		}
-		dev_sw_netstats_rx_add(tun->dev, xdp->data_end - xdp->data);
+		dev_sw_netstats_rx_add(tun->dev, 1, xdp->data_end - xdp->data);
 		break;
 	case XDP_PASS:
 		break;
@@ -1957,7 +1957,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	rcu_read_unlock();
 
 	preempt_disable();
-	dev_sw_netstats_rx_add(tun->dev, len);
+	dev_sw_netstats_rx_add(tun->dev, 1, len);
 	preempt_enable();
 
 	if (rxhash)
@@ -2497,7 +2497,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	/* No need to disable preemption here since this function is
 	 * always called with bh disabled
 	 */
-	dev_sw_netstats_rx_add(tun->dev, datasize);
+	dev_sw_netstats_rx_add(tun->dev, 1, datasize);
 
 	if (rxhash)
 		tun_flow_update(tun, rxhash, tfile);
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 3a4985b582cb..bf3979a048a7 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -217,7 +217,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			net->stats.rx_errors++;
 			return 0;
 		} else {
-			dev_sw_netstats_rx_add(net, pkt_len);
+			dev_sw_netstats_rx_add(net, 1, pkt_len);
 		}
 
 skip:
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index eb8851113654..61486b57b6ce 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -19,7 +19,7 @@
 /* Must be called with bh disabled. */
 static void update_rx_stats(struct wg_peer *peer, size_t len)
 {
-	dev_sw_netstats_rx_add(peer->device->dev, len);
+	dev_sw_netstats_rx_add(peer->device->dev, 1, len);
 	peer->rx_bytes += len;
 }
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index c1a53e1ba3be..01ff00f7a447 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -756,7 +756,7 @@ static int qtnf_pcie_pearl_rx_poll(struct napi_struct *napi, int budget)
 			skb_put(skb, psize);
 			ndev = qtnf_classify_skb(bus, skb);
 			if (likely(ndev)) {
-				dev_sw_netstats_rx_add(ndev, skb->len);
+				dev_sw_netstats_rx_add(ndev, 1, skb->len);
 				skb->protocol = eth_type_trans(skb, ndev);
 				napi_gro_receive(napi, skb);
 			} else {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index ef5c069542d4..81367451e096 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -662,7 +662,7 @@ static int qtnf_topaz_rx_poll(struct napi_struct *napi, int budget)
 			skb_put(skb, psize);
 			ndev = qtnf_classify_skb(bus, skb);
 			if (likely(ndev)) {
-				dev_sw_netstats_rx_add(ndev, skb->len);
+				dev_sw_netstats_rx_add(ndev, 1, skb->len);
 				skb->protocol = eth_type_trans(skb, ndev);
 				netif_receive_skb(skb);
 			} else {
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 67e25f6d15a4..351d8c4950e5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2992,13 +2992,15 @@ struct pcpu_lstats {
 
 void dev_lstats_read(struct net_device *dev, u64 *packets, u64 *bytes);
 
-static inline void dev_sw_netstats_rx_add(struct net_device *dev, unsigned int len)
+static inline void dev_sw_netstats_rx_add(struct net_device *dev,
+					  unsigned int packets,
+					  unsigned int len)
 {
 	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
 
 	u64_stats_update_begin(&tstats->syncp);
 	u64_stats_add(&tstats->rx_bytes, len);
-	u64_stats_inc(&tstats->rx_packets);
+	u64_stats_add(&tstats->rx_packets, packets);
 	u64_stats_update_end(&tstats->syncp);
 }
 
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 2cbae0f9ae1f..adfb1861a8dc 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -36,7 +36,7 @@ static int br_pass_frame_up(struct sk_buff *skb, bool promisc)
 	struct net_bridge *br = netdev_priv(brdev);
 	struct net_bridge_vlan_group *vg;
 
-	dev_sw_netstats_rx_add(brdev, skb->len);
+	dev_sw_netstats_rx_add(brdev, 1, skb->len);
 
 	vg = br_vlan_group_rcu(br);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index a77d23fe2359..c3b99c19a22d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2526,7 +2526,7 @@ int skb_do_redirect(struct sk_buff *skb)
 			     net_eq(net, dev_net(dev))))
 			goto out_drop;
 		skb->dev = dev;
-		dev_sw_netstats_rx_add(dev, skb->len);
+		dev_sw_netstats_rx_add(dev, 1, skb->len);
 		skb_scrub_packet(skb, false);
 		return -EAGAIN;
 	}
diff --git a/net/dsa/tag.c b/net/dsa/tag.c
index 79ad105902d9..92455cb848ca 100644
--- a/net/dsa/tag.c
+++ b/net/dsa/tag.c
@@ -115,7 +115,7 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 		skb = nskb;
 	}
 
-	dev_sw_netstats_rx_add(skb->dev, skb->len + ETH_HLEN);
+	dev_sw_netstats_rx_add(skb->dev, 1, skb->len + ETH_HLEN);
 
 	if (dsa_skb_defer_rx_timestamp(p, skb))
 		return 0;
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 50d0f5fe4e4c..88ac5e5fd68c 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -432,7 +432,7 @@ int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 		}
 	}
 
-	dev_sw_netstats_rx_add(tunnel->dev, skb->len);
+	dev_sw_netstats_rx_add(tunnel->dev, 1, skb->len);
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(tunnel->dev)));
 
 	if (tunnel->dev->type == ARPHRD_ETHER) {
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 95b6bb78fcd2..54a789ec201f 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -140,7 +140,7 @@ static int vti_rcv_cb(struct sk_buff *skb, int err)
 
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(skb->dev)));
 	skb->dev = dev;
-	dev_sw_netstats_rx_add(dev, skb->len);
+	dev_sw_netstats_rx_add(dev, 1, skb->len);
 
 	return 0;
 }
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 4c29aa94e86e..90cb0e769a06 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -870,7 +870,7 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 		}
 	}
 
-	dev_sw_netstats_rx_add(tunnel->dev, skb->len);
+	dev_sw_netstats_rx_add(tunnel->dev, 1, skb->len);
 
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(tunnel->dev)));
 
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index ad5290be4dd6..adfe05c16c5b 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -384,7 +384,7 @@ static int vti6_rcv_cb(struct sk_buff *skb, int err)
 
 	skb_scrub_packet(skb, !net_eq(t->net, dev_net(skb->dev)));
 	skb->dev = dev;
-	dev_sw_netstats_rx_add(dev, skb->len);
+	dev_sw_netstats_rx_add(dev, 1, skb->len);
 
 	return 0;
 }
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index ef2e5111fb3a..aaec43451b20 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -724,7 +724,7 @@ static int ipip6_rcv(struct sk_buff *skb)
 			}
 		}
 
-		dev_sw_netstats_rx_add(tunnel->dev, skb->len);
+		dev_sw_netstats_rx_add(tunnel->dev, 1, skb->len);
 
 		netif_rx(skb);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6c4b549444c6..424a1d393753 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -956,7 +956,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 			continue;
 
 		skb->dev = prev_sdata->dev;
-		dev_sw_netstats_rx_add(skb->dev, skb->len);
+		dev_sw_netstats_rx_add(skb->dev, 1, skb->len);
 		netif_receive_skb(skb);
 		prev_sdata = sdata;
 	}
@@ -970,7 +970,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 							 only_monitor);
 		if (skb) {
 			skb->dev = prev_sdata->dev;
-			dev_sw_netstats_rx_add(skb->dev, skb->len);
+			dev_sw_netstats_rx_add(skb->dev, 1, skb->len);
 			netif_receive_skb(skb);
 		}
 	}
@@ -2776,7 +2776,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	skb = rx->skb;
 	xmit_skb = NULL;
 
-	dev_sw_netstats_rx_add(dev, skb->len);
+	dev_sw_netstats_rx_add(dev, 1, skb->len);
 
 	if (rx->sta) {
 		/* The seqno index has the same property as needed
@@ -4878,7 +4878,7 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 
 	skb->dev = fast_rx->dev;
 
-	dev_sw_netstats_rx_add(fast_rx->dev, skb->len);
+	dev_sw_netstats_rx_add(fast_rx->dev, 1, skb->len);
 
 	/* The seqno index has the same property as needed
 	 * for the rx_msdu field, i.e. it is IEEE80211_NUM_TIDS
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 125d310871e9..f1c4ed1bad33 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -199,7 +199,7 @@ static int internal_dev_recv(struct sk_buff *skb)
 	skb->pkt_type = PACKET_HOST;
 	skb->protocol = eth_type_trans(skb, netdev);
 	skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
-	dev_sw_netstats_rx_add(netdev, skb->len);
+	dev_sw_netstats_rx_add(netdev, 1, skb->len);
 
 	netif_rx(skb);
 	return NETDEV_TX_OK;
diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 330a05286a56..f700adbe26a9 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -415,7 +415,7 @@ static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 		md_dst->u.xfrm_info.link = link;
 		skb_dst_set(skb, (struct dst_entry *)md_dst);
 	}
-	dev_sw_netstats_rx_add(dev, skb->len);
+	dev_sw_netstats_rx_add(dev, 1, skb->len);
 
 	return 0;
 }
-- 
2.43.0

