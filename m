Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1E435AC20
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 16:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280361; cv=none; b=uWvblLthi+lPYTT/gft5aTwnoaln3+vFUt17wKcKWL/99e69LHdfQz0Hfn9N/jqEerP9W2yju/fatV44PucQXHBiW6sxnOJJKENUxBbQJ+jnwJCwDv/4DkwXEakxSbjSuRlPAd0MORIBFKIZQ7w112nB13VSnB8HuOe27oEj/xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280361; c=relaxed/simple;
	bh=2dwZqLAyhY/4Vfm9IVVL6KRgYtolqzmaN8lua+AT/Ho=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HMy12vA24XVgfnElXPk7XC1rv9/JHWvhOpeh6rFHN6UWiQmAfxSyV2obLX7eT86I4r6BsXNm7NokKTyHrYLv1WyqVGxbNDki0Wy0UlaRvNXPyXoqpvHSUaxfbahTK8eqzvGqzf1lFlLnitXQD+Ae/jCXMpdBLeUY1R5tFEHqVBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cU3Cj8Aj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Tj2ERVoV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cU3Cj8Aj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Tj2ERVoV"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681E8WRI3256336
	for <netfilter-devel@vger.kernel.org>; Tue, 1 Sep 2026 16:32:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=RWmplTuZP4ejGGGca10U+y
	p/avXJxOthQiyPce9Gzso=; b=cU3Cj8Aj5NA9y2Npk/8BOX7uqMesLcYQ52QMek
	vKOYkSX1cRfh/QDmuWMCdTzrE9KRdPPvJmkDGvVSB5TTOYAXVHhRRNLO7e5GpXS6
	wZ53/pXPT594h9J2lAn1v/djrQ/r3cz5xk33Xidf2q0CkDsChTU+tAg3tbAgEj9k
	FriXdXWnlmndPs4lMWyLdNuRa9q81w4gn9ShwuqXUicsAViFPhMS4CEyyYn5snBs
	XaxJ927nw7eCrf8IF7v6I7Sl/6DeYr9VngW53/9Fsd9EgAWKVB0FC7/vj4htgu/S
	2oj99Y58rLZNyH1+AooacEzhfG+zTro6iM5tR9C4xNM6clZg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdynt0y7p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 16:32:38 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92ef13b61bcso21907685a.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 09:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788280358; x=1788885158; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RWmplTuZP4ejGGGca10U+yp/avXJxOthQiyPce9Gzso=;
        b=Tj2ERVoVNLlyWjnOJITTegKpAglrap25q4cXHwSZDMSDEx1i4xO0fjb21VTMf0Wp3V
         O2uvlkFg3pyq7/32mr4Im4Bu+TwQAf2dPFZlJEcZznHf1U4nk9Z5a4EuquUjYaHvYS5s
         A4kVW/ityE4qLHVpj5gbI+glLvGA/7DE3Duxc2KjLhUmBdf0cKYLjKicjQslBOXdFJHn
         3q6FFLULb8fIrk5m5HbdlEX8hOtP8PYmNRomp8PCn/G2kYD0xeAjorPC8SDHZ+AwuCSH
         gL7PIiPLdP7Zm/RJNqyOUjK2Cj1No1FzaoRxjQI2zuYAdWFpduyaZKsZ2Dj7U/woYG3g
         t74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788280358; x=1788885158;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RWmplTuZP4ejGGGca10U+yp/avXJxOthQiyPce9Gzso=;
        b=D2P7xjpK3QXOjzCJOAfJ5nk/u8V/TyPfZNRcZg273ofog7qC1JgocQukdwKRRHbTHv
         rQ61Wtwt1VE2mZU6265DZRp1K5QQrkABlNbvaf9n8zLLPTduSg0vHARj4ITSdfNuO/1H
         DQs3iR/XXZqfpCCBPC0fXCh0yFo4quwBPnwaGIZuXdSR6IqG6d21VcmcxDA3IFhi38J0
         cmfVXGAiBOxXxHGM0PdDe3GrYFhxL5HRW0xv/7YhDfkCnaobXXhfpfA3QfwiQHTdeSOz
         INPJ9gSLOXcL5/ShDPAzSp2VImQd0iw2dXr7FioAisfxsENlmKcs32EyjhT+yfR0n1dy
         uAKg==
X-Gm-Message-State: AFuF++kxmciMia4bUhSF9hIzLlGeTDfZWA6vCi7TgJrcrq0dx+rUSuOt
	bOtrfL+7wAtQBMy0dt7wup+ALDRBRaU9TxyPdM2dMjHR5cbcB/tlExf+UZmbFAzibADOY8P30yN
	/zyXqCOAL+ZTrrbDhbPeC+F5ShrTU6C9U1KHGV6lNILH/G/RYDCGQbM0koX9pCplsMrZSUe8=
X-Gm-Gg: AR+sD10Xc2+CBqTW/NahMkKXNR0aziPTIkI+KdTvErvBEEbcCkgGc88/L3AoSCIMhoo
	E81Z6WE/sWtSI4igQO5/rtvQ7+SHEQB9rnAta6rUR+Cc7n0N7m+D15PlSA/YwQskn47HNyi70Ht
	2bKQ9+dg3FHQkzM/N8owA76YhcfaXVU8itlJWX4tFF11XCtjhUyo6r81N43E/mvDhL9UumdDHQu
	DyrgBdzAU+l+a+BZZwWIp55rTB7ggt/N60gvqOufkMzfc6QgTdL3T0cOVlBYAAZN72MHeu9XFDj
	GPjwNG9wLpKerLQr+tfxha8lO102taEjr8SlvRGqceraNikJfK5trsVPkr0FNao1vF4ZZ3V3ZCU
	8uAa6y+sTSJzxlw==
X-Received: by 2002:a05:620a:19a8:b0:939:f89:3688 with SMTP id af79cd13be357-9391397dc88mr3819558485a.42.1788280358268;
        Tue, 01 Sep 2026 09:32:38 -0700 (PDT)
X-Received: by 2002:a05:620a:19a8:b0:939:f89:3688 with SMTP id af79cd13be357-9391397dc88mr3819549285a.42.1788280357634;
        Tue, 01 Sep 2026 09:32:37 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9266be71sm793114285e9.2.2026.09.01.09.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:32:36 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Subject: [PATCH nf-next 0/6] net: netfilter: preliminary support for IPv4
 over IPv6 and SIT flowtable offload
Date: Tue, 01 Sep 2026 18:32:15 +0200
Message-Id: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2N0QrCMAwAf2Xk2UC3soL+ivgQa6KBmpW2uMnYv
 1t8PA7udqhclCtchh0Kf7TqYh3G0wDxRfZk1EdnmNwU3NmNaIKSlrXRPTHWFSlGTqg5aMaqDXP
 hpG81Kl+cg5+F2HnxDL3Ynej2v12hh4y3Brfj+AHU6v1BhgAAAA==
X-Change-ID: 20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-5635fae03f3e
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfX2PnsdsF8jtUY
 xhwEYPpajIOKtt5GK3rYkF2SBA1gyoFtcJctyeTGEA/L+gGa61TljDSxG6kit+trSfumsezLd6p
 Nk2ywR6junvun8U1C9s2iaa967b8Cj1/dtQzN4cnjGgJv3JJedIxBzrV8sdX0gIQJqtST2Eical
 IhCayUmq8qsYkxjHjsbOQu9fjB/Gv+uwFILFpojZDfv4LDIJLBAphUkByAYcEAk1sglpsLWaLxp
 wIXRmdWDSLoyhqHN/HQYKZTH06oTkvpMoo/sK+3L6W4DWIjt1/QM9g7SUEswN+m1EfdF+RwcZxu
 d0/8XCZovAtWGTHOsl4RfaR6rTZ/dgMM6JANk8hKCVb0EX2XohXF6nmcn8kqWwnhnQUxIJbSmCR
 6LR/p0THuSTO7E/7L8QEELbMGPgyR3mqUMMJdmh7LbrPQGY3Rkw5eN+ES1C0HeHGLChK9Bqdm8Z
 7PGTxpSdvlhbCMzLZQA==
X-Proofpoint-ORIG-GUID: 9MUz6jzi5kaXxMuCPfFhYGZfg8CrKPnu
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfX0R7PBSxvwEO+
 7joxVVpwA9LAbNyLx8rNLP7bEcSqkL7MCLbs05YQdUYJ29BsuVET/f5z0FH2Ypu6f0E7N2ePBPi
 3uYfDoOQDP3X/0JprUs+7oDyqwGvkzE=
X-Authority-Analysis: v=2.4 cv=LfkMLDfi c=1 sm=1 tr=0 ts=6a96fe26 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=hjUsVgM4bzNdy_QoUQ0A:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: 9MUz6jzi5kaXxMuCPfFhYGZfg8CrKPnu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_04,2026-09-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010146

Introduce some preliminary changes needed to support flowtable offload
for IPv4 over IPv6 and SIT traffic.

---
Lorenzo Bianconi (6):
      net: netfilter: nf_flow_table: recognize IPv4/IPv6 in tunnel proto matching
      net: netfilter: nf_flow_table: set inner protocol when popping tunnel header
      net: netfilter: nf_flow_table: populate tunnel tuple regardless of inner protocol
      net: netfilter: nf_flow_table: refactor MTU check for tunnel offload
      net: netfilter: add encap_proto to flow_offload_tunnel
      net: netfilter: nf_flow_table: unify tunnel push for IPv4 and IPv6

 include/linux/netdevice.h             |   1 +
 include/net/netfilter/nf_flow_table.h |   1 +
 net/ipv4/ipip.c                       |   1 +
 net/ipv6/ip6_tunnel.c                 |   1 +
 net/netfilter/nf_flow_table_ip.c      | 211 +++++++++++++++++++++-------------
 net/netfilter/nf_flow_table_path.c    |   2 +
 6 files changed, 139 insertions(+), 78 deletions(-)
---
base-commit: 91ec2035134982b98fab0609a9fd8480e8217dc1
change-id: 20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-5635fae03f3e

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

