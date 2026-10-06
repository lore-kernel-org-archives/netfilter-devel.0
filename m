Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042D237F337;
	Tue,  6 Oct 2026 09:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277324; cv=none; b=cuZ9WvxZU2vRcK07wln4XvwjeooKvUf5s2U4X4HaUfD6s83BQBbpvAVnKU93vQJGrYEVk7Jnz6NGLh+QzaVwMpR79uykIANRxJCOJesfexrWRMW2PsqmUJgl6WR6G5Z8oXXMgFYZe76p4qGU7mKepZB8QH0hGPtIokosIFGwsd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277324; c=relaxed/simple;
	bh=8MfpeJFSppQamPfCBYTs5Fd1fLWRa6sO3hiJm8ub+10=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DNTnD2tV8XkxLAd/lyqbo39bgEHOWQJuUFsDDjugyxTsrB2ckv2koW8WY/ATlRe54h26ar98d4F716Z1iNAgfFprPba9X4nJq55nZuRpyAasSaAQQKASZnzFXr7cb6sXSczysDjkPYP1h66IwNdyDM4tCPbZktPs/p9W3migVAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=idJuu1mZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="idJuu1mZ"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6967Sdp63537718;
	Tue, 6 Oct 2026 09:01:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=Vf2j2u+/3ZFVhWU7kRS+D/SAyrxMqxWOEyH
	NN4i7jCo=; b=idJuu1mZVFJ1kWVWOdUMaDZRPSY8vaspIdVZHH3dcm7qkleWhSW
	n3ZzAYG187J32DZCsL3bJ456C67VFAx+L5jxg5aQB6JyB/rCfbyzb72jNvvG+zhJ
	mo6CXciyKbKqE+8gsAeUUUoQz6N3ocITy/LgD4xxp84XxP5t8LoT2ezd5aJsIJ09
	OCRRTuXPmnfOEBT6GKleubaHYBMRDyjN26kMkxsJrsuqu7kQjz7evgLImBoDdgqd
	p8pakomhtJnS7FcUV8L/pq3Ryx3ZxvHPxr7z9xZ4Efmom0VOLWgnQmspVHHjC8xz
	5kBVNWaF7noFtpeoTGCfWTkFyLKjAD1ZTLQ==
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4vmrrabd-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 06 Oct 2026 09:01:25 +0000 (GMT)
Received: from pps.filterd (apblrppmta01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.18.1.11/8.18.1.11) with ESMTP id 69690Act079404;
	Tue, 6 Oct 2026 09:00:10 GMT
Received: from hu-devc-blr-u22-a.qualcomm.com (hu-haric-blr.qualcomm.com [10.131.39.39])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 69690Anv079366
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 06 Oct 2026 09:00:10 +0000 (GMT)
Received: by hu-devc-blr-u22-a.qualcomm.com (Postfix, from userid 3844793)
	id 7864A41200; Tue,  6 Oct 2026 14:30:09 +0530 (+0530)
From: Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
To: pablo@netfilter.org, fw@strlen.de
Cc: phil@nwl.cc, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
Subject: [RFC PATCH net-next] netfilter: nf_conntrack: add ct expression support for netdev egress chains
Date: Tue,  6 Oct 2026 14:28:44 +0530
Message-Id: <20261006085844.2694120-1-hari.chandrakanthan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Reinject: loops=2 maxloops=12
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Authority-Analysis: v=2.4 cv=XZ4cX455 c=1 sm=1 tr=0 ts=6ac4b8e5 cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8 a=9ZRjs37vXSK0Xz5s9nIA:9
X-Proofpoint-GUID: zdtoavhFzn70cuIX0hlSgil06VE3J6x_
X-Proofpoint-ORIG-GUID: zdtoavhFzn70cuIX0hlSgil06VE3J6x_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDAzNSBTYWx0ZWRfX8Un9jr8pISRN
 574g4xqoke3at92eQ85UoRxrXQY76FjNq06dRKIDG/D7Siloey9M7MUFWEjP13UcHreTnpb2Cn6
 bfvRfwydU64HtsTJkbKb3BCFOB3G+TWhDjGow1Qi76u2VSN3nMBQ/WzrpiLoutayyWmXFnRHiNf
 wUXKPvuFJgQJ2cTqlUrLte4y+hdfGBvCEZZMWqwvQNbq0XXqbX44NCxp4gQdwHmiyxViCzWVHLm
 gaQW/FXswcGx4vkBReB6Y8ttIgFZzlzNQ1sYS9l0oDymZjqWRAeJ11CSJgGtV2Q7bgsRDE9WqjD
 25F83GT7GPOr2L0gYYuzO1DzNswL/Mvf2YL8uvx7pfXxUvdwDh7bp4UQbKRUtJsmyLLBVMeeRIA
 k5z0t2f/Di9BSRRwx1D0R+jbxt37sKSsaup+fG41UdB/ckAsq2b+55G1+CCX31dMpjOPu8yUmnb
 dNveOanw8RFXglSdBGQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDAzNSBTYWx0ZWRfX4G+GTiOVJovN
 jcgGsltq3tOUmbtLbztF6pl3HLp/Gdu0YwVD1YvC+DT/dHGF/g6HyF5Ev9TjSwR6uPLDb/J/j3t
 GB2mEmuxNJUFOSVG12igWEFV1Sb/rmQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_02,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610060035

Add support for using the ct expression in nftables netdev egress chains.
This enables QoS policy enforcement at the netdev egress hook by
allowing ct operations such as copying connmark to packet mark.

Add an explicit NFPROTO_NETDEV case in nf_ct_netns_get() and
nf_ct_netns_put() that enables conntrack for IPv4, IPv6 and bridge when a
ct expression is added to a netdev chain.

Restrict ct expression use in the netdev family to egress hooks only, as
the connection entry is not yet available at ingress.

Sharing this change as an RFC, to get feedback. The patch has been tested
by configuring nft rules at netdev egress hook to set ct mark and copy
ct mark into skb->mark. Also, the patch is validated at netdev ingress to
ensure the nft rule with ct mark set action is rejected.

Signed-off-by: Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
---
 net/netfilter/nf_conntrack_proto.c | 26 ++++++++++++++++++++++++++
 net/netfilter/nft_ct.c             | 22 ++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 7a40e4e0e33e..b8ee46262901 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -587,11 +587,36 @@ static int nf_ct_netns_inet_get(struct net *net)
 int nf_ct_netns_get(struct net *net, u8 nfproto)
 {
 	int err;
+	bool bridge_acquired = false;
 
 	switch (nfproto) {
 	case NFPROTO_INET:
 		err = nf_ct_netns_inet_get(net);
 		break;
+	case NFPROTO_NETDEV:
+		err = nf_ct_netns_do_get(net, NFPROTO_BRIDGE);
+		if (err < 0) {
+			mutex_lock(&nf_ct_proto_mutex);
+			if (nf_ct_bridge_info) {
+				/* Module present but hook registration failed.*/
+				mutex_unlock(&nf_ct_proto_mutex);
+				return err;
+			}
+			mutex_unlock(&nf_ct_proto_mutex);
+			/* Bridge module absent, netdev egress handles routed
+			 * traffic too, bridge conntrack is only needed for
+			 * bridged frames.
+			 */
+		} else {
+			bridge_acquired = true;
+		}
+		err = nf_ct_netns_inet_get(net);
+		if (err < 0) {
+			if (bridge_acquired)
+				nf_ct_netns_put(net, NFPROTO_BRIDGE);
+			return err;
+		}
+		break;
 	case NFPROTO_BRIDGE:
 		err = nf_ct_netns_do_get(net, NFPROTO_BRIDGE);
 		if (err < 0)
@@ -615,6 +640,7 @@ void nf_ct_netns_put(struct net *net, uint8_t nfproto)
 {
 	switch (nfproto) {
 	case NFPROTO_BRIDGE:
+	case NFPROTO_NETDEV:
 		nf_ct_netns_do_put(net, NFPROTO_BRIDGE);
 		fallthrough;
 	case NFPROTO_INET:
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 3c4c2faa7398..e90e73475b0c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -649,6 +649,15 @@ static void nft_ct_get_destroy(const struct nft_ctx *ctx,
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 
+static int nft_ct_validate(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr)
+{
+	if (ctx->family != NFPROTO_NETDEV)
+		return 0;
+
+	return nft_chain_validate_hooks(ctx->chain, 1 << NF_NETDEV_EGRESS);
+}
+
 static void nft_ct_set_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
@@ -732,6 +741,7 @@ static const struct nft_expr_ops nft_ct_get_ops = {
 	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
+	.validate	= nft_ct_validate,
 };
 
 #ifdef CONFIG_MITIGATION_RETPOLINE
@@ -742,6 +752,7 @@ static const struct nft_expr_ops nft_ct_get_fast_ops = {
 	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
+	.validate	= nft_ct_validate,
 };
 #endif
 
@@ -752,9 +763,19 @@ static const struct nft_expr_ops nft_ct_set_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.validate	= nft_ct_validate,
 };
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
+static int nft_ct_set_zone_validate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	if (ctx->family == NFPROTO_NETDEV)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_ct_set_zone_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
@@ -762,6 +783,7 @@ static const struct nft_expr_ops nft_ct_set_zone_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.validate	= nft_ct_set_zone_validate,
 };
 #endif
 
-- 
2.34.1

