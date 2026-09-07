Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3244071F3
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 07:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766457; cv=none; b=tiNFAfj/vNzzaMF5bNne0q9nn7RlU6poShYlIO60oVD0kaXGLvyUNprQtJ/mxEJ9nDf4QNbnRyxoAikst6Xw5rI6hrJTNs16QZ2cOm2wfkQNyU9ee/eaPVcxgZiDTO4qV2hVMBOjyZiTuSucEqSU43sLqQw72H8ndKFvbG1yMKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766457; c=relaxed/simple;
	bh=heg60N7YYlggEVkJ3E13NDQsqfVr8dYU9bp7pifaMfs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RmyCtWAQnyjYrCWfS+MsDYTm2l1qRUoduXvx3+hWdUnPb4wZHk8WJPwC4ZKq3nICsrrsLiQeno8EyYPXJS5ecku7nxxRqBx8osFuqN07i6fptSLkGwPOyxn1aGtoC6gZothg0U2PYPMoeNSu/tzo91Ib4g7NDuJQ7Fy2dDSQyII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=drgUz3Gt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Qd+IWJTf; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="drgUz3Gt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Qd+IWJTf"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68777XDH2668285
	for <netfilter-devel@vger.kernel.org>; Mon, 7 Sep 2026 07:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RLpedcZhZDsyKBGVCsCCJ50Ygn6ZAg7z+aYYIAJfKWU=; b=drgUz3GtjcNCaxdq
	fjchKEc+hmxGysQ7d7o44Jg45fuLfuWK+4AH43SoLdzO9/5ZGN839P1kdGnX0HC/
	CDIVgBZRyAg+LtbfoFc0+g8kEAJLNcY1AO1xNkKR4ol7H37w8ylxbSYclrctUVuP
	NshSA3TI0f5oI6m9JaJCd98jxfvSmh7AI0vh+ybsHCoqomDLGRc6sAP1kuijoRta
	tO/uxe9tDCOgJRsKgarDW7dv23RutBtiT0sF/J2oH+m5V/d88A9/qhRS/j1G31/d
	RBjZ8OUfclPvVNmWciG9l1/mtKXwfpLb0hJVtu+JzrJF4Z1IbA+gilZzZRZWm1Sz
	Ewys8Q==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ggcca5h8x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 07:34:15 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e4f946461so616528885a.2
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 00:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788766454; x=1789371254; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RLpedcZhZDsyKBGVCsCCJ50Ygn6ZAg7z+aYYIAJfKWU=;
        b=Qd+IWJTfdj464N4hrZF1HaE6Dkcvr0GnFfyXa7T0224Z6CDMOTUtWXeP5M8hqgcUaY
         DkVGa/sABs4r1Xh8b7QEQ/p5Zc5uo/Q2lWbbcfTkVl23Fkx5pGvnq32dMncs9WXThOgw
         8U9eABfVKg8qbAgm/Fmyj1n9rVtuBqIFzDzzRB0spGbB1TbDT1HF2fcDUOevSN516Ku7
         A3gNlQwQXsUEYX6H1Z5jTyOYpQBkSwIaqEH5+S9n8+S946u/m/tYIabL51VF5lCBu2dq
         Lrv9tpLMKarS6ToN0lMwbzHQJLu1Ty7vWPNObcfpOMRkv6+hUwYk9l2PpCDFCriqatTJ
         +GnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788766454; x=1789371254;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RLpedcZhZDsyKBGVCsCCJ50Ygn6ZAg7z+aYYIAJfKWU=;
        b=Xl3y7u26gHFoQ2BEPggl38fYzuwPc/j3lto76GqMRimFhXtUnC/FO4/pFPVMdc8T2p
         JejrjNgr+/dZv2bROV+Bt1FzUAmBm9qeot/taoRcGii9YoB2yq8DmYKt+xkR3QRlZPLN
         9e+VGQvYjY0CJa74mG59oF3saDS8+Crf4MavT8Z8hAiA44+NhpM9l8XWXzvB8IueuuIF
         mqWnwTHw1aiXdLNWiuztljHVHHsSWIbP8RMzzZKIAY+nAFswWgyc8iASvRAKUHwV+hBc
         tvz+Je3rpiX3MPmvwamyum0BLbm6yLVBpQR5nhPt63EToosTnWAZBz/F+7fVzyKHdc3f
         CNnQ==
X-Gm-Message-State: AFuF++llYFbjIfZHulnBdRrCAOyk8NTWtgokmYcZ0KASfdWxExBhH3om
	gzwUIGEoHxEDXQ+/I6gDtn0ih5BONTwV7Jr9eMLH+7KSS8kQtU62gk56ndkuH4x9YwwW53uBLZ+
	if3pHmRr9rVkTPiUOnJq8ZHH6+KQQctH6Lk1CfgC6/NU2+R9/eR5Eks+wxw1ll4Sn6876Brs=
X-Gm-Gg: AYBFou0E0esfNoeCCoIVZrvSeKVc1eoJKtcZhTRefTUhvydNgD9ERQRYth8DAbpeZyR
	NymaBDbZN7AyV0aFSt1FvLOAv/pVfbWtQXrlQbFRKQb7ayoAB4QujqFS++hDtc2qV04H7blt9N/
	f8p9B2mOlOmnxv9vQzoQ7gs2v9Nk9cXa5f7sDj7p90wogh4xcUvoibV5Or5C7z/KleDOi8gXc0h
	e50Z88kFOYo/TToaThzcESpWGtFkeo1xuR6RdU4CT+hUKfSDeafCHUX++rrVVCzheDawJMeOh7Q
	RUfncouZv9UUvJ/Z1LvV0RksCnkMSVcKke3tPOgTveKTXWvZ1nVQ2aLvIE7eUoRgu3kjuS8Ohmn
	9gw8BKvLPE5/jyA==
X-Received: by 2002:a05:620a:aa0c:b0:937:2e9f:70a8 with SMTP id af79cd13be357-939804af824mr2326254885a.39.1788766454113;
        Mon, 07 Sep 2026 00:34:14 -0700 (PDT)
X-Received: by 2002:a05:620a:aa0c:b0:937:2e9f:70a8 with SMTP id af79cd13be357-939804af824mr2326242685a.39.1788766452676;
        Mon, 07 Sep 2026 00:34:12 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf7736132sm284363575e9.12.2026.09.07.00.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 00:34:11 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Mon, 07 Sep 2026 09:33:39 +0200
Subject: [PATCH nf-next v2 4/6] net: netfilter: add encap_proto to
 flow_offload_tunnel
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-4-7c6ac1750725@oss.qualcomm.com>
References: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
In-Reply-To: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: OsppIkfIFJt7ns_vLR_o46nGtWY-n8mm
X-Authority-Analysis: v=2.4 cv=EJo2FVZC c=1 sm=1 tr=0 ts=6a9e68f7 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=EiAgCLLKtgnx6EotJx8A:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: OsppIkfIFJt7ns_vLR_o46nGtWY-n8mm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA4MCBTYWx0ZWRfXwOxuz/lilUVv
 AzUelY0EGL+KDLzMFP7ApPJ9hNKM/Ju1m+Tbovo3AezZHPj9B8jGToWTWfIAjUqL8nD5eN/t0SV
 is/CJGvhSR3R/P4aPhsvWSSkfbWljwbEQd45RaRxCbfUqboN8xvCOgy04Pr5yoNtrs9qp8b0Uk+
 HoQqJMO0cd+db7R7NfOz++JcKiN8Jq5FIljc96AxRVLe/6HYnHU6nNPfj+HH6CTr3wyCmGzG5b+
 VcRZbuv2KbEXJz9QmuzOBhABmetNCrwXq0DFPzkYHu7Lkmyz+bVrCtC/FmiQ3jU8Rj2m+jh2DSh
 /EaaEoNzfnGW2qDWcZqsOzROEr7Az6wTUwrXldmKrUWH99naNQ0VMPeUp6EeVATv1SEf2bNo49s
 5pLs1S48vJvy3Rawzgd+UIsl64LQcwUHVzTbNllm645qc85H1KlA9idornyovEs0/qbOKK0DLWK
 BsuMSfG4nL0mDGKaBvA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA4MCBTYWx0ZWRfX/0b3ghsVjs1x
 ESPwNQp7xtp1XfRef1S75sGienJA/t75vInEJrevjLa7qanXoQbdsxOEvQc63QIwpmWqtKZP3Kx
 vXsTYKcb/JmmPIPcPvCK/Owu6vEtKic=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070080

From: Lorenzo Bianconi <lorenzo@kernel.org>

Add encap_proto (AF_INET or AF_INET6) to struct flow_offload_tunnel
to allow its use as part of the hash table key during flowtable entry
lookup.
This is a preliminary change to support IPv4 over IPv6 tunneling via
the flowtable infrastructure for software acceleration.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 include/linux/netdevice.h             | 1 +
 include/net/netfilter/nf_flow_table.h | 1 +
 net/ipv4/ipip.c                       | 1 +
 net/ipv6/ip6_tunnel.c                 | 1 +
 net/netfilter/nf_flow_table_ip.c      | 2 ++
 net/netfilter/nf_flow_table_path.c    | 2 ++
 6 files changed, 8 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8454646d6a45..4531e4de8416 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -910,6 +910,7 @@ struct net_device_path {
 			};
 
 			u8	inner_proto;
+			u8	encap_proto;
 		} tun;
 		struct {
 			enum {
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..306e7d9ec3ec 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -118,6 +118,7 @@ struct flow_offload_tunnel {
 	};
 
 	u8	inner_proto;
+	u8	encap_proto;
 };
 
 struct flow_offload_tuple {
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index f684baf8e58f..c06ea32ec1df 100644
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
index a53393f8eda0..1b9360d54dfc 100644
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
index 1e55644f2edb..90360406d11e 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -135,6 +135,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 				info->tun.dst_v6 = path->tun.dst_v6;
 				info->tun.inner_proto = path->tun.inner_proto;
 				info->tun_dst = path->tun.dst;
+				info->tun.encap_proto = path->tun.encap_proto;
 				info->num_tuns++;
 			} else {
 				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
@@ -246,6 +247,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 		route->tuple[!dir].in.tun.src_v6 = info.tun.dst_v6;
 		route->tuple[!dir].in.tun.dst_v6 = info.tun.src_v6;
 		route->tuple[!dir].in.tun.inner_proto = info.tun.inner_proto;
+		route->tuple[!dir].in.tun.encap_proto = info.tun.encap_proto;
 		route->tuple[!dir].in.num_tuns = info.num_tuns;
 		dst_release(route->tuple[dir].dst);
 		route->tuple[dir].dst = info.tun_dst;

-- 
2.55.0

