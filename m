Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714542;
	b=xCPbE6eHvmjpXDWMbrzmdP4gAP6UVulOQuNyGmG+K7wsJIkieFobAVukwvsMELzKMZ6a
	 ACwS6GOd1122AlcW0FJ6oW2ltxfKX6/QkoLQqhCRpL1Bt8WqPMed1gQ6JMCPeYSFS+5xx
	 oA//PkcVE7yCB9xx1X5sckGGjZAC2oRnXJCd9CEj7BlIgQmmZEbpuIRY6EeRtQC6NyJeV
	 BFFo1i3jSnwg2aFXPxNy91n3gz0jY5dAWEwRl9pGqwvt1ovmG79ad0npCbqkbPXVu8qlT
	 wueshxiV7VdKOWZYr925cXaHQ16zAY0PDv0caLbw4O4U0ZNT6VgJjLu4/89XCQdkqDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714542;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=;
	b=2GET8J4ARLlQUsNGdjMJ3Y8u319zUXXmongG/3FdEvUUYwacptRuptj3wjbKu2/sH+U+
	 +Ct5rdFzDOb8CZgsYU49/Mj5El665G9W/58UNrOtm1hfclHFIp+g72KBYMkDYJ++GBLvc
	 J6uzTmg8ripDYTP2oSSqKqulUUhXyqqD3QWLPT0vKgl3X4fjQDCTwcdmI5lhQ8VW2f+7r
	 YI/AeMb3rPDWeHQRdqnrqSLm2ZacknGiUTUa9HgXutttqCYjgPOkOxOfVww5B3WptOf6o
	 N46gEIV9Sni6FD78OOYoqSQvJzfTyG0VZBfgSPxnY6Py5RwK+fcLOjnk6KEV3F+uVjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jSaVoowX;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=h2FBaa9a;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DC9606A329
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 14:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3DC9606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jSaVoowX;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=h2FBaa9a
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3DZBts3581414
	for <netfilter-devel@vger.kernel.org>; Tue, 3 Nov 2026 14:02:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=; b=jSaVoowXxs9DoOm4
	+Nk7j53T/b/1qZSTZnDZiHyopZfm33nSdPEIfR2uiXoT0ajmtzZRsWyXFM8p7MMx
	JBq96hMQjZY3304YncA1fH4Ax2DKmmzkDHZBPOsXfFjIx8A1SFpx+u+v5Yg63JFv
	3VDLXQGsPYMMYQ1qqcoC72hCsM1L019JYU405zv1t2j+qbRmqQVpmCQh1Hxo2YUV
	ynD2af9y4Ds9LWLMLEWdPQc4lBL/MgJmO/gqKGWyqcJLsxobCrtlyuZ00Vkt8uOG
	d/M5+Y9ds4bHFflBVTcII24euNGwfTk4o2X4EIt+bdq+rZWy9e4nhVwnQbsM+5Np
	ylwc0w==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq94ct1k5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:02:20 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5eab0467c89so5026327e0c.2
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 06:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793714540; x=1794319340; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=;
        b=h2FBaa9akSmsEb2r6PEtetLlKd7WvDL8JANu61hBcNsTjvmM7dxLdbQoCQ7d8ejd+h
         /jhTkQtE1lezX+Hbzgi+Wu9dyhXxK5hjfyGC11+6BfZjb4hESGXEVLgs/Wfch2WqNn2X
         7xtRgEBx7LWkb/huhoeJxsMRCpbT5TRGsQWACQxcN+8SVDjpUmWRT/Yn6S8wQaA4pvZ7
         EdVlsV0Vy+WT8q15Oa8DLT8spXP4v2UggpbPcZvMfPndwroHFSHlslfCFwGfapnZWfbi
         jxDg8E0qmrzOsAFzmOeRgD6e0TyaGEQ1dGn2p7Lne4SEkm0ISNnGMKiPNcB+ZaqevgOv
         dsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714540; x=1794319340;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ET+B6ryXZSjsDmJogt9NhGamDLd5Mr29EJGHgALtRKA=;
        b=YwPf1Muv2WTqIbSxzGImm7ISdyD6u4x/C3Hq68pHCFEUFBCMNzTSQsOb997UqhgT6J
         JPzo1MFoOoGGxNtR9c+nCsFxQHINpygGfOfTyaqMofK7GKrwJj/cd6QCF/1h/i3KzJs3
         tHu6u5f+N4OxGrodV2bRZFeBNfcTX2OSOIcdyMO+e+GiX3ZZ4PUMIw+nzQyAu9ejk9Vq
         T+BVVrFHeAu52jQ9CM8VfAdXkH2NvD8YJnTbiRaPWLh/vxBVjt1C8mEcJxlVuoI6V8E9
         VNvjWEq7UEeqaRXszxApDpFqa3nB64KLwvJCR2RZsJFLJjtbYS4SkHqCtPOgV5qFNYTT
         xYXw==
X-Gm-Message-State: APuU4Z9IpYj9TrT1YqbHkDUnR8tqfvEju+KivEVDPXvUotj6xjSMAUAw
	PPWPHkqBV8c2Y6itaqsz6N1bhD354jgcbi+CFWm5YSU3awf9pSPAgGO3oes5jV+AdXZEmFF5JpW
	QsM2REjasW206Ix5tPUwNSslVSu5drrx895BaEZld5HYiNHoLElnkjjTPdvje3v0vqGq8d/E=
X-Gm-Gg: AYBFou17AP7iAU6vHux9A2dJkNiiTjK+kaUgluqHk1mDw/O5Lcgr8JxOwlIZSg6OMuk
	yUYfHRHRjYUfY8nRkZli1TmZkCbYRF4C7mnSHRvQnACaBds4xa/cyPC814sFgxaoWqYvMfX5oyq
	JD1UyFXyRVKucCKu40JQG9UP29ekb0SjFfVpRvpfwJwOSViJFtCPFaodFeSWcokpwJ/l7WgqEwX
	IT2Q6TKjOrOkb1pgq66YjfT8X9dvGx3klHBOLZkkX3b5sAhJQZQPUv+Juxhl6v9i049G5zdFI9p
	tSeBOANj7vWKPz82PlSWKwpWYBWOuB1ahxIIxhcTNSrOBipy5sTvTrme6UiFZoyrZahUDo+vSnv
	zviDHcM4UgQSj8IVgLSGFq9Saruad6DN97Igks9BE/9oB6ZGYBcQ6SZ/Ah1gvTZw=
X-Received: by 2002:a05:6122:4892:b0:5c9:a7af:8178 with SMTP id 71dfb90a1353d-5ec6851cd6cmr5730262e0c.2.1793714527897;
        Tue, 03 Nov 2026 06:02:07 -0800 (PST)
X-Received: by 2002:a05:6122:4892:b0:5c9:a7af:8178 with SMTP id 71dfb90a1353d-5ec6851cd6cmr5724949e0c.2.1793714478743;
        Tue, 03 Nov 2026 06:01:18 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b81c74sm25057443f8f.36.2026.11.03.06.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:01:17 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 15:00:45 +0100
Subject: [PATCH nf-next v3 4/8] net: netfilter: nf_flow_table: use tunnel
 encap proto for route lookup
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-flowtable-sw-accel-ip6ip-sit-v3-4-60b5f063f1df@oss.qualcomm.com>
References: <20261103-flowtable-sw-accel-ip6ip-sit-v3-0-60b5f063f1df@oss.qualcomm.com>
In-Reply-To: <20261103-flowtable-sw-accel-ip6ip-sit-v3-0-60b5f063f1df@oss.qualcomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=O+KsLx9W c=1 sm=1 tr=0 ts=6ae9e96c cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=BwFUO5JFP4DfzLIXruUA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-ORIG-GUID: XNpsBUKInKy3Jl3FE7q5Sg3ckViDT7yR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX6Oxinprgl0U5
 pKR3RXvkVezq9uH3DbOd9o/06NWTUuOSLBvBK57BwQUrN3WLCt008KBkiE+MH8mWv+ttQax/Dt0
 RTaUl6ZxpnrlFp3z5gfeE9J+QU+aNuxXE/19XgKRJekQRNiPaCeMQmX4zAAZjsmhsW/hAaWxlSi
 IteNhegbwA9P/0x6BGcHHMXztrNW6SvaPJIHWHqADPZj2AlyFRmG213HvgFaRxJtbqeeKXhz2Qt
 VouPplWX1vCW6iyTzg27ebFho8Fl7S4w7I5D9XCORi/umcVvxhmpdvDhFBFW4t1j7URNiiSffZa
 FNDnFBq0gAjZ1bsiffLwVzv3umhqP4DLiGFp6twuR+lJu2nd2EZYwVV2etxiJ14FhoYPxYE6dWY
 wKixgTgGTIpS0HKWA9LA/dNlORNm1gpc6AD+VXwoXF0B9C/PNmnRAlO9lz6c9uV79UfSp3gj97B
 9+AKza3YKpE0g1a+DoA==
X-Proofpoint-GUID: XNpsBUKInKy3Jl3FE7q5Sg3ckViDT7yR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX9ZBxYr6uHOQg
 kXDA5szPMM5cmM12xGRHtJzvwKY4p6VGyYggKGFi0cuH16AeCMJrWqky9ApbkGsMqhijGVopOrJ
 p+bZW9AsS5rDt2FnGrQal5eEK+t4ko4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611030055

For IP tunnels, resolve the MTU and the dst cookie against the tunnel's
inner IP protocol (tun.encap_proto) instead of the flow's l3proto, so
the correct header size and route cookie are used when the flow is
carried over a tunnel.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_core.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 0d72dc8ae47a..aa8e3f42b23f 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -76,9 +76,10 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(flow_offload_alloc);
 
-static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple)
+static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple,
+				   u8 l3_proto)
 {
-	if (flow_tuple->l3proto == NFPROTO_IPV6)
+	if (l3_proto == NFPROTO_IPV6)
 		return rt6_get_cookie(dst_rt6_info(flow_tuple->dst_cache));
 
 	return 0;
@@ -100,9 +101,15 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 {
 	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
 	struct dst_entry *dst = nft_route_dst_fetch(route, dir);
+	u8 l3_proto = flow_tuple->l3proto;
 	int i, j = 0;
 
-	switch (flow_tuple->l3proto) {
+	if (route->tuple[!dir].in.tun.encap_proto) {
+		/* For IP tunnels we need to consider tunnel IP protocol. */
+		l3_proto = route->tuple[!dir].in.tun.encap_proto;
+	}
+
+	switch (l3_proto) {
 	case NFPROTO_IPV4:
 		flow_tuple->mtu = ip_dst_mtu_maybe_forward(dst, true);
 		break;
@@ -130,7 +137,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		if (route->tuple[!dir].in.num_tuns) {
 			flow_tuple->dst_cache = dst;
 			flow_tuple->dst_cookie =
-				flow_offload_dst_cookie(flow_tuple);
+				flow_offload_dst_cookie(flow_tuple, l3_proto);
 		} else {
 			dst_release(dst);
 		}
@@ -144,7 +151,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		flow_tuple->ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->dst_cache = dst;
-		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
+		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple,
+								 l3_proto);
 		break;
 	default:
 		WARN_ON_ONCE(1);

-- 
2.56.0

