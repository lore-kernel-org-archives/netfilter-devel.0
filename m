Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9433B4EB2
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 07:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789370750; cv=none; b=ld1c52Sl3CNtTbaZZXAbd+0A6K9HSX87kzALCj56goYbIxCQzx1lfnswC56XdlJDaKbzKTTZblpopyxsgAbI/2FUi5rQX53Q7E9hx8UPpDd1zLlMW6Yf26Vo5ALS9vt1/R+Tvx4NhYbWKKRtIvScSFfo9vHYJeCne5FBPNvdXfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789370750; c=relaxed/simple;
	bh=+4b5tXne8/M8BAgKYGBdEU+kM4v39RRFpGoz6klM5j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoAlO7SwzX2gh/Scb3HP8tdABXtaIJQrgin/P6gbWaISXKdr1rmtLPkn/EaDuSs6sN1CSkLvhsh3ApG48GYYwlq58e0e9u67K7iq9LogqadD/U2tR9ccCHGRYc6hwZPBiHAQKDrPuETzJMFONvirS94EMccFrgzqO8iwpAR71Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=QsFHFdL0; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="QsFHFdL0"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f705536so414207166b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 00:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789370746; x=1789975546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=//laNQ4vdXExCrBm3O2PIIdjOC1SK3rk6Ct5+d+DRUI=;
        b=QsFHFdL0e6A/HmyOibE2ZOFzAbowraDXFCwDy0Vz5xT2GHiXJTrud2PiEF6yNVtTlb
         fOWPCLhSJ6WaFZUGchS75PBblIpA2y/JnXiFl03mpaFugEHdYPVr+2oRECxNQploFg94
         A6mXYmgkKXyOZbMYkHXwG0Rmi+0j0Ownr4h3pvE6QvsmVlIGqx69o2ryaYNZVa60nftn
         RliOHb0T3/SmXz/HS7HjwHIpYcYIe8sBOhWlSNKvPBDZf9ZwXhl1lcB0+u/KlW/C20E+
         xjsA4msh+Nag+Qi9K7DrraGc7DPfQ95GZR/44FLdzX8T6+hjvpWaQlI+zGVIrOUc4E6r
         +9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789370746; x=1789975546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=//laNQ4vdXExCrBm3O2PIIdjOC1SK3rk6Ct5+d+DRUI=;
        b=Bt2d5QHfcFUtvK+GylM1S5vtdylvY4ckn8BNBwuhRbUzFJn7TAtt/XeswJT0VBrLk1
         AJcC25PfL/2jnpEOg4zPq0YX3F+RKCCPE2mElFUdLm+KwokU0NjlDe24rEj33jSj+4SV
         fcP7R1ppRmh87MDLLkDnAbdj27t2+PpkmXOJswS19UzS+mTstIDW9SNOS3W0/G/INpnZ
         ioL0otuWL8pUAd+yZbt+KnAWISydQCFu7l44pvDdx3iVbVbylrX/fpIP7UlKbDp1uhy3
         V48zXMxsvLqCCScVXeX6AuRxlIvqHrw9OsnBEAfL2+62DU0CMrrRcO87W6InWhQReumq
         rvcg==
X-Gm-Message-State: AFuF++lQydq1if9il8NleSc5Nh+Xy1gONwWW0RZeeBZlwm2gMDAvjGMD
	UETNvJKixO2NfV/rrkKFEXRVO6ZIeqzzmadkrTp7qgr8eXT74271XtZjrsUYvtA3XHlw3r5PJYk
	0YRspdwqwtaM95w==
X-Gm-Gg: AYBFou2dmO6QQx2m2wDUPQYqvsknL+7W3UvinkI3uYfjxdiVDk/Eby62ePK73qoslMl
	GCGK6Mb/ePj8dkPs37kKieENhOf0w5cUptk7/hTHZseRCg9U1MhqQhyVmeOYGkozcMbkwihiDdw
	99SN10QSw5/VWTt5/4lz4e6e/YhkcqbtvLh+FpDEGnfKP+WSibSg/q21JqenaBpXopE/Gk7F7q4
	fWVRNtmimL1C6sdTjQ9AkQ+q38OA+xMNKnLexw6isyLH0W7OaPK24Z0lqVM4KLSwl8evJ5bWm7D
	cbJ0gpoEJo1HtZ1vEbfcveIbv06MEWVgRRb/h6TB13Wb2OrmP6JjAB+VfpPEdy2UIWm5dsNt2CA
	zFtbT9DAkunTvcb/P2hvNKLZn0mH1KB/oYN5QrmtAG87WZOCVSJMiJ0GhFLH8QlayrtJKq7O//S
	IvLk8WDV3nwVw+dtSIsuWYwdOp+aoW1U01CcNomj8QbBRBLSqSasLvJ2SwGpcU6KekuNP8R+um0
	8+t67LIxNk/4z8okY4+2xkS8MsSn0rpUC9C8+cEpzUWTJYpfRDkl5g9qTCUeBhPQo72iQHCJ+wA
	vfXMDQXRhC9SM0woSyVev/d/zQaBvAsUPsz7hIuUNV8st192U31TiBmA+j9xOnSQPZiMtS4OVLn
	q5jm3E4qgl0edxoH1cSGSTUo3VAM5A5d4vZTlfWq4PZEgSAen8KnIOSsPVlus2b0LMWx/dvNHLc
	UQ118Lc8qU
X-Received: by 2002:a17:907:94ce:b0:c29:5326:5a67 with SMTP id a640c23a62f3a-c29b86362c4mr73401466b.13.1789370745182;
        Mon, 14 Sep 2026 00:25:45 -0700 (PDT)
Received: from Desktop.fritz.box ([185.152.145.208])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2965c4e8a1sm382835666b.6.2026.09.14.00.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 00:25:44 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	phil@nwl.cc,
	horms@kernel.org,
	davem@davemloft.net,
	razor@blackwall.org,
	ericwouds@gmail.com,
	dqfext@gmail.com,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v5 1/3] netfilter: flow: Add bridge_vid member
Date: Mon, 14 Sep 2026 09:25:39 +0200
Message-ID: <20260914072541.897040-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914072541.897040-1-julius@bairaktaris.de>
References: <20260914072541.897040-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Woudstra <ericwouds@gmail.com>

Store the vid used on the bridge in the flow_offload_tuple, so it can be
used later to identify fdb entries that relate to the tuple.

The bridge_vid member is added to the structures nft_forward_info,
nf_flow_route and flow_offload_tuple. It can now be passed from
net_device_path->bridge.vlan_id to flow_offload_tuple->out.bridge_vid.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Assisted-by: LLM
---
 include/net/netfilter/nf_flow_table.h | 2 ++
 net/netfilter/nf_flow_table_core.c    | 1 +
 net/netfilter/nf_flow_table_path.c    | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..cadd5f82be8e 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -164,6 +164,7 @@ struct flow_offload_tuple {
 		};
 		struct {
 			u32		ifidx;
+			u16		bridge_vid;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
@@ -232,6 +233,7 @@ struct nf_flow_route {
 		struct {
 			u32			ifindex;
 			u32			hw_ifindex;
+			u16			bridge_vid;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
 			u8			needs_gso_segment:1;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 03241d4bfd5e..b308fb627640 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -139,6 +139,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->out.bridge_vid = route->tuple[dir].out.bridge_vid;
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 1e55644f2edb..53629e9b2273 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -88,6 +88,7 @@ struct nft_forward_info {
 		__be16	proto;
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
 	u8 num_encaps;
+	u16 bridge_vid;
 	struct flow_offload_tunnel tun;
 	struct dst_entry *tun_dst;
 	u8 num_tuns;
@@ -180,6 +181,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
 			}
+			info->bridge_vid = path->bridge.vlan_id;
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
@@ -257,6 +259,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.bridge_vid = info.bridge_vid;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
-- 
2.53.0

