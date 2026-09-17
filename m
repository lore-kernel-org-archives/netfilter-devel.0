Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713F7434E21
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789633790; cv=none; b=utC7ZTmJkWnlYZZ3+R0Qf+MF357XsWa3vQo1VYiTw8Ax+zflvyu3JllOCHsTRJ/TsBxr0zBDUOhASm76zQzLayhFr+lyjNZnCB9fMAH54h0rW+inctszXuty/fpDBD9nRpfl/OCQYZgBCstNXoBBHRbVoVjo1t1/QKh/x13uKW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789633790; c=relaxed/simple;
	bh=J53d4ZAEFQL4u+cRW7KTszqjCVHcAreiqPpsicwRi8Y=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Kvm2JCGyEzT2axWGEwPDTbi0B7i/tNNDuN7fLmp1dK7kKFvoaScMAfMHO3jHt3i16yeez71Hs3KeEwsMOwNm7lIg2Z2vJh0ooIOyC2AcZDDMtdW7ZA5zR1zPlqqAI/NPKMfF/lwPPjNV1dDTjtt4/AJAIfK1a9hCkFJZ6Xi7V74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dMhs3mAf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=darpooeN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dMhs3mAf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="darpooeN"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H60BB01721142
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=IDEYVQCkx7UdqLCZalqnFH
	UrirML9c+nDMbyTl+aRvE=; b=dMhs3mAfJpYrLtcVaNVgvJ1dqzIfU96wDvLSw8
	ob3k4XBA7LG+Mxu3RT7iJ/mUvsudq+6ZCKarWwobQ0gjrw3m4Q8ajFpTrUrZ95UG
	fzzeMA/367mU+DBGhprkFAv45dOpzoUZL/Xs5lyqZ/AORRXro7cevyi31ee33SMZ
	/En4N3BdvUgO8GQwH7N/OsB+Hcal/TCFW/XQB+gbbeZf52djGeS5HqvtfHUaGeD9
	kjKRmtAvjln7YiuqqETeLgQ+hke27a+WSg9ABhDAJwIJ6F3McBspD1p6gQoHVYhy
	jSyrJPu5Bvp8ymnc1f9PgMajTBn9xI/NAai9nc1nJWGpeJbg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gr79m1a0n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:35 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93a1e564fd5so94755885a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 01:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789633775; x=1790238575; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IDEYVQCkx7UdqLCZalqnFHUrirML9c+nDMbyTl+aRvE=;
        b=darpooeNMt4mOqVtVtgBkuGiGanP+kIu6MK2UH4YnU4bVYuhD80Kv/VIszavf4wXX5
         oXgi1HRqUg5hYa8vJNbMyZeNMaw2cq4Ufa3MrJPe9pJAgMmp5J0TKEyu5lZhBRut13sT
         c2yyKt+AKVsvFoLNuW2oEPF9CU6iyehAQc2GcfTscKpnVgAPR6KQUjYDIuGD+0idyb0o
         peyK/oRrMpl6A3ImrZxdrjBE+O59c0VGITy46bUEOk6/UJBCPA+ld8xO3t+P5/LXvxj/
         BsRcgNqyoMplF6A3ywbHKxQeojZ+CJ2gwxtiCbA4X3ALKF3+6yJksHCWdwarLh1XcLtE
         DHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789633775; x=1790238575;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IDEYVQCkx7UdqLCZalqnFHUrirML9c+nDMbyTl+aRvE=;
        b=23x0R55/z6EYpb7aeoYZNqntg5L3YREcJJnGXeOU/7yrVVP42Id880uGjBkBCqH9oa
         Nf+2pnQmVEaoCT5aLDYn4fWpWAIbe4Ry3v1Oj2qplO120crvVMQZwKfIv7U/3cuY/tzP
         TGYwDRghonWmJ31ngZnHOTbWGX38RTPyJzFZnQ6E15xKL22bpGF/B5EfoUoz5jFUF+YG
         51U0EyDL+rS7J68d3AEylI+EreTi+eIFw30tQe4Gi5fFRHxXZtE/Q1yWI5WdGcU/6bSv
         DS+Bz64KKOZE/I0BA7g5CT7ye1NGZ/Vkef4lm1s9A0nYuSfYkqXXVlTKjOUSOS9FECtq
         /vKQ==
X-Gm-Message-State: AFuF++lCXFZdoPpk4yqxaCVGfRyHAl4YvGPJykuiTV9/tpOij0J+SYiF
	qr3HLi2uJk8F+YFtVHZSeLnqcgKDvHf6DQo8Wze+UUXtlF0xHH7cOx5lUawftVcAr1c5p+30I4Y
	gOcW5fhvJeSuccXPugCqd+u21AG8/4Zm1Q0JrKZTfZwkivNSQ0qyDzVMGWgSgiqiEXkpBhvY=
X-Gm-Gg: AYBFou1F+kqHENg4xdwsZYmyBXbpDLNPjPvBUbSbwgHVutkbJJ8aJAZTNXLXNbuPrI7
	AHPcYsXzoBwfOXLdGwTLNGr5EM6tPhwK2ytQrIqURU6WuFmHqe7zZ5E4X9/rU/e6iXCTzJ2sA9P
	4huyqCPO9tTjlfswEwzc42+wTMv5Ys1QiRYhJMbN+AlAVM0XMj0GxE3ULTO+g1wL0bNT4n4ALqN
	bVa7aFJQctc22BuMsrNDaPNwFRnyJTw10LzbrlK1b+Q3M9wVs4ilcc/+kPv+BM+a7UGvK0ICjhw
	+WD2dmsMWZ2b0pwZlzly9iraodLpWvf8BleV+1b3UqwFrUiSkBT95vwVGZOLjwcoSGwIhXYAadZ
	tViPjOjiNhbMA5A==
X-Received: by 2002:a05:620a:a18a:10b0:93b:be6d:4f3e with SMTP id af79cd13be357-93bbe6d4ffemr598950885a.25.1789633774657;
        Thu, 17 Sep 2026 01:29:34 -0700 (PDT)
X-Received: by 2002:a05:620a:a18a:10b0:93b:be6d:4f3e with SMTP id af79cd13be357-93bbe6d4ffemr598948485a.25.1789633774156;
        Thu, 17 Sep 2026 01:29:34 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29de63c5e7sm240916666b.53.2026.09.17.01.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 01:29:33 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Subject: [PATCH nf-next v3 0/6] net: netfilter: preliminary support for
 IPv4 over IPv6 and SIT flowtable offload
Date: Thu, 17 Sep 2026 10:29:06 +0200
Message-Id: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-0-fd2ea96fac7d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/53OTQ6CMBAF4KuYrh3THwFx5T2Mi1qnMklpsUXAG
 O5uZeXCjW4meXnJ++bJEkbCxParJ4s4UKLgc1DrFTON9lcEuuTMJJclr7kAb8G6MPb67BDSCNo
 YdEBdSR0k6qGL6Kglr+MDilIVViNXViHLi7mzNC3akeUhj1PPTrloKPUhPpYvBrHUf4GDAA6Vx
 G19xp1Rwh5CSpvbXTsT2naTz8IN8pOofiPkmzClNqIqeCWLL8Q8zy8VoXGyWQEAAA==
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
X-Authority-Analysis: v=2.4 cv=Qf7zLcbv c=1 sm=1 tr=0 ts=6aaba4ef cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=hjUsVgM4bzNdy_QoUQ0A:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: Q5CdFy18WY_z1zFIYJshTxKJ-cjqtl30
X-Proofpoint-ORIG-GUID: Q5CdFy18WY_z1zFIYJshTxKJ-cjqtl30
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDExNSBTYWx0ZWRfX1Nb+JSSOIYKM
 L2iWBi6YRXbnwPXYAzLJzH7PMaL5vALPd/kUFvC703+MZ9D+6MZgO3e6vbF9tjZrU4Tg0e9KjJZ
 eN+g/7dvwKopi6NQ81huSNVlMd7UuTd9mcG5PS+pD5F/6qVUzL8Te6MgLaNGKxmGlmxCVCNU1E9
 bJHKMab5t9W341r1Ls2jcHQa1jNx/uT5NfPcHIXO6yJ3qBsu0yILB7wAO9wgCYkyk3rGLSzxANw
 8yTJ+rOCVc5wHonF+oeNN9ng2Xb3i8kdpFA8vtPRcgzKAO1i6Llc2M+lkpI2wVA1Z3R6cBZJAOu
 7AO56zsVlk0eatjw2JhfTNBS2ddYPGqb5hqBkAJqp+aXslzr2OzTudf21SxIKxvKmuuoyKEhOSl
 bP/fxV5to3Cie64MFZMk8MI4sLatYae+A0XIYGbJigVAYWbOdVgZ9KwulDQyfmsTYdvKk7e9CGB
 yMsgGgP9elcFQvMv5PQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDExNSBTYWx0ZWRfX4Wg6HmToQBYg
 xB01TwJ0ph2WiD/9/hadxwZTcBnqbOUTf7mPBkhVexPbuZeqFB/HtLlZHTVx7bUkVhiU5uw6ERx
 YjZuC3iZ5Hk2q89igGz14HxwkWtBYPQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170115

Introduce some preliminary changes needed to support flowtable offload
for IPv4 over IPv6 and SIT traffic.

---
Changes in v3:
- Rely on nf_inet_addr instead of using two pointers for the same
  address.
- Add specific IPPROTO_IPV6 and IPPROTO_IPIP cases in
  nf_flow_tunnel_ip6ip6_push() and nf_flow_tunnel_ip_push().
- Rebase on top of nf-next main branch
- Link to v2: https://lore.kernel.org/r/20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com

Changes in v2:
- Fix dir configuration in nf_flow_offload_check_mtu() to compute tunnel
  MTU overhead.
- Link to v1: https://lore.kernel.org/r/20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com

---
Lorenzo Bianconi (6):
      net: netfilter: nf_flow_table: recognize IPv4/IPv6 in tunnel proto matching
      net: netfilter: nf_flow_table: set inner protocol when popping tunnel header
      net: netfilter: nf_flow_table: populate tunnel tuple regardless of inner protocol
      net: netfilter: add encap_proto to flow_offload_tunnel
      net: netfilter: nf_flow_table: refactor MTU check for tunnel offload
      net: netfilter: nf_flow_table: unify tunnel push for IPv4 and IPv6

 include/linux/netdevice.h             |   1 +
 include/net/netfilter/nf_flow_table.h |   1 +
 net/ipv4/ipip.c                       |   1 +
 net/ipv6/ip6_tunnel.c                 |   1 +
 net/netfilter/nf_flow_table_ip.c      | 215 +++++++++++++++++++++-------------
 net/netfilter/nf_flow_table_path.c    |   2 +
 6 files changed, 141 insertions(+), 80 deletions(-)
---
base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
change-id: 20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-5635fae03f3e

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

