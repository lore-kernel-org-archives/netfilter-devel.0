Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793559746;
	b=ARPVbcRPPJoV7A10tWjo/E1/Id5Y+iCuLwg10ATh2a0IqoPB6hs/Z9M2EZCxLXf89e1F
	 fs7cuNPpnXPPMyw3mayOiBD3xcI/BOLxz4Qsu2sTu1dqePL4ohoJ1TaJtgtyi+RbemVX6
	 uQz1Jou2GTBnEvsEWG3k2mwOl16kGvnwMcvEcZL2zFsAZJ9LGgrbn2gykfh3BiZkN+fcK
	 T46V/ZKfTh9w8QNb3YSHxkXGv3SX1WsgONtC3LKKjzw+cHQZzMI684NcVfX1CAVuf+WJi
	 tglukS7DCKELPZTOjz6awBZx08FdKWrGjxf6lEU6EVmje+9XD9WO6a2OimthC1ywnww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793559746;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=3SXKAJvkWEfH8lskfIpG/LcDHtbUmYSyuBcyRooPK28=;
	b=1Gg5VmZT3zTCJ1lEhRK4b1QLGLeINYVtN1tQ3KmLDm8XDINlzbP01T5Qxi6SV/ks+nGp
	 IpF/ezxhiZ8eAZD/s1ixJKxDjZ3xsJ9fPKozP5OGqnUMfB9B6PTnux0WSmwGAFXFv8ic5
	 uba5nJi2A336ua+TA3bbkSdTQR1wO2H9jbyjkPHtvQR/53bsO+xxgcrqtJZCpe93RWdyq
	 TueHsJ6rvTN5cxf0F1NFcEi4Mfw7qciVUe+izwkwPKVSImHpmC3BAVn+gzHBTfgTvYC3U
	 2gptmZhE7Oc+y1tUOOZMtzv5Q8mqC22GsdslAdMb3BbAsFFiQloT3S3tZp6nwLnO1LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CXtmdTwF;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MRFlQLMM;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFB9606A326
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 19:02:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCFB9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CXtmdTwF;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MRFlQLMM
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1HQger2422169
	for <netfilter-devel@vger.kernel.org>; Sun, 1 Nov 2026 19:02:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3SXKAJvkWEfH8lskfIpG/LcDHtbUmYSyuBcyRooPK28=; b=CXtmdTwFZqklS/tX
	wirZVFAPARgzifJofkDYUedIOturWsEqDZlqmJIXKpzpLk96l5JXRN2FJvCg0p7c
	twQ9OpISNkrEujeIfOA3lX1BQBzKvVo8oWUr4ddBOGPRSsL1zdhwahkgWcFSdImT
	Vtw/j32cl4FDQksEM1tn2VmU2eIY8rS7wzZzVXGcpNbr1qEtOxUtQlaCXxb2dmWg
	DQs93JiUubLNsoiAWJPuX0lTwKIY4gw+2y60nadaovaxmLye5KfAdIdPVid4ExSB
	zS0Tnz4tKSlrrkw/wawE6mQV4qM0w/fhDRS6XQlSByn4hiwIO3rMLwYqs/mWrrrZ
	GPfdYQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn61fvahu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 19:02:24 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-944138ed63fso380996885a.3
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 11:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793559744; x=1794164544; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3SXKAJvkWEfH8lskfIpG/LcDHtbUmYSyuBcyRooPK28=;
        b=MRFlQLMMyvIDHYsly6aA664dnSpyJyV1DjaGHWA82z+YZrNv24ocq74qu0yAnJ7Bcv
         YaDyVd6uaaqo3bNRpVGLvt5+enP19fqdoWS+/5RvsE+O63szetWlM13fbGNMz5IpVWdd
         tAeL02pginy8o2tF+XvItRy+S88/N0Csc9Ju2u7JfAcuOAIJjNEZL5K15H9y8rTu9W5+
         d6X2KkI1QunRFePsJMcOPdDru3FfskViQ1thoLX8TQupsn9CmDnn8QezYjVU0qKmPTf6
         HGTRXgOAUiqNrLZJj+g7jWnYRLmuSgK8Gd9hF1ECS7DMyn7FSvl+ucnCARTEKSZyxfTu
         QQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793559744; x=1794164544;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3SXKAJvkWEfH8lskfIpG/LcDHtbUmYSyuBcyRooPK28=;
        b=gaxFcVDnfy2RAsPXS0/tsr7tcyMg4hLyF45SwC96QUo1YMhxkEGJ/W+O51yN/vDNjj
         n5suVn9/NCrDbmnrrrRiFFgqlHNKONBFXh5loKUQnRi09d1ijVmQK1S35iRUost0Ckx3
         ckZPc1DgEyb+2Y8bS4Fw35fxpAhs78SjqhSfmboz1yMzXoj18EDabeL1K1Kv231kXG0x
         uXkazC0ED6wYHjGAQGObOIdkgZbbgT6017g8xoAL2MQaw8xpxb4jE7vl2UlG2URIwabT
         2hHKBMHBkd6Inj4Yx4C955tXGTuFRl6HrSJfscYPH7Q71nR26MLSqYj05jdLnDpKQVtr
         DtSQ==
X-Gm-Message-State: AFq9FYJsRfcM7PQ7jr5CpcFxovb+LIsbSRntHmNNd8nBX9sH5EXfDQgT
	1S4LsrnIQMtGnPiMcNtrB1/VmSBs3tstMWmZ6MkyQCJQ9Me0hwEhKZLHYwCkgaxHsdDjsZ9nT8P
	b0Bziz2YDnM1chNfp6XJ7Q9SKr2NSCwi1Qs5eDAs92MTCALc84YbOfqP200itCeQRcIztUfM=
X-Gm-Gg: AYBFou2syDdhC3U0DGzGfAMDW3bwQ79h1BXDVZtInf6jMMf7T6si5vGhEwO6XjYG+lO
	xH1tJhqzZCITK/uymPEA0vvyaKR4QBgM17SzM2OZM1fEPNzzRdzhg1uncLwK/frZvC/ToDh2LNq
	7gKHRlLHW6up0p2mtZfmv+Xw0tvOi9yE+6cqcSUAecqW1nz02TuSr9Vezfc7VikgidAX2ks/cMR
	nEs9ceB7w2h5UwQxb5sQFdkYCePMoopY6Lte1DUbDpYKNCCB+hNSqLfbWeGUzoijtafkuW0s3nt
	xGhr6K1KNFt+rxWXyK22ykbX4qwaOgFmhtmZzxgeLu6FC3eRRQMbXtEHRLh2/kJL0j2qepYy+cX
	sZBL4M0JZcsh9PxTv9TdUpFeGngfTXbNxDFZHvdTJ4sHd+hTOzWMKTsC655sKHg4=
X-Received: by 2002:a05:620a:2b89:b0:93f:4d4e:ff6b with SMTP id af79cd13be357-94421585ce2mr1281218185a.12.1793559743809;
        Sun, 01 Nov 2026 11:02:23 -0800 (PST)
X-Received: by 2002:a05:620a:2b89:b0:93f:4d4e:ff6b with SMTP id af79cd13be357-94421585ce2mr1281211385a.12.1793559743192;
        Sun, 01 Nov 2026 11:02:23 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm327969315e9.11.2026.11.01.11.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 11:02:21 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Sun, 01 Nov 2026 20:01:57 +0100
Subject: [PATCH nf-next v2 3/8] net: ip6_tunnel: add IPv4 over IPv6
 flowtable tunnel offload
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
Message-Id: <20261101-flowtable-sw-accel-ip6ip-sit-v2-3-c6c282cab5cb@oss.qualcomm.com>
References: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
In-Reply-To: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX9om6kQrFbDkR
 SLZxS494pA/eC4Sj6+agYwOJdPXQaYWvsQlf7KEjaasdHjiTXU/5tve6AgTAG1RrdBjoIo97ICT
 kP+bciCZB2ZCYQpzW8IfUvrbMCPTtJk=
X-Authority-Analysis: v=2.4 cv=V/LoQuni c=1 sm=1 tr=0 ts=6ae78cc1 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=j_WIp6COnZI3mYKyEBAA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: NlEg5aLrMKjdGk2hNPRgyA-NXRWrr6i8
X-Proofpoint-ORIG-GUID: NlEg5aLrMKjdGk2hNPRgyA-NXRWrr6i8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX3r2LijFqJwN3
 H/jRS+zuUiP+RpZ21DnFdz/34VtUpcg8e0Dp04FzzC7k1tew0h/7fNGFCfZrp1xAzWN7OhD0xLw
 9KB8EF/2N0LLnFkH+UBKPsBPOaQMzoNk+DY1lR3sIUXFaJzgiJ4wuqO6DkRJfEmEf0URPHcTzkz
 /eLSTVrOFYg580bpY6Kbe66tCWqjB3udncuh8w8P4KI82/yWjHNMUNqVwrGoImp9A8DRSSkhdJ5
 3cdUqrQ/i0U2wmedWs71D04zo+KG7hRbMGzcZN3qyJ28GS1RUmsHv8OZmMzBM9LG1/DQ5fzN1vv
 JEy6g76luojJNWkIR4ayd/FOCg/JUiqTZnoFkJpEVJC8UqWiO5PnGtdu45OICLgGkvwQiWJY2mn
 GYR7QUmVq+ACCOi1QtA9ZI/YJ04ncm4RnBVq4t5HFIfaf/44gTX6GtMtBnRHJDWYR7Wn3p3gyZj
 r336QJZ3s182U8tQfiw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-01_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010075

Allow ip6_tnl_fill_forward_path() to set the inner protocol for IPv4
packets (IPPROTO_IPIP) in addition to IPv6 (IPPROTO_IPV6), so that the
flowtable can offload IPv4-in-IPv6 tunnels.

Return -EOPNOTSUPP for any other ethertype, and when the tunnel is
configured for a specific inner protocol (t->parms.proto) that does not
match the inner packet protocol, so the fast path does not bypass the
check enforced by ipxip6_tnl_xmit() and ipxip6_rcv().

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/ipv6/ip6_tunnel.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 64a184bca467..920eb231945a 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1840,13 +1840,11 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 				     struct net_device_path *path)
 {
 	struct ip6_tnl *t = netdev_priv(ctx->dev);
+	u8 tproto = READ_ONCE(t->parms.proto);
 	struct dst_entry *dst;
 	struct flowi6 fl6;
 	int err;
 
-	if (ctx->ether_type != cpu_to_be16(ETH_P_IPV6))
-		return -EOPNOTSUPP;
-
 	if (t->parms.flags & (IP6_TNL_F_USE_ORIG_TCLASS |
 			      IP6_TNL_F_USE_ORIG_FLOWLABEL |
 			      IP6_TNL_F_USE_ORIG_FWMARK))
@@ -1858,6 +1856,20 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
 		return -EOPNOTSUPP;
 
+	switch (ctx->ether_type) {
+	case cpu_to_be16(ETH_P_IP):
+		path->tun.inner_proto = IPPROTO_IPIP;
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
+		path->tun.inner_proto = IPPROTO_IPV6;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (tproto && tproto != path->tun.inner_proto)
+		return -EOPNOTSUPP;
+
 	memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
 	fl6.flowi6_mark = t->parms.fwmark;
 	fl6.flowi6_proto = 0;
@@ -1867,7 +1879,6 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 		path->type = DEV_PATH_TUN;
 		path->tun.src_v6 = fl6.saddr;
 		path->tun.dst_v6 = fl6.daddr;
-		path->tun.inner_proto = IPPROTO_IPV6;
 		path->tun.encap_proto = AF_INET6;
 		path->tun.dst = dst;
 		path->dev = ctx->dev;

-- 
2.56.0

