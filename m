Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793559742;
	b=18QxDVEvJZ3iEU1Yk21xafbXz9bz0rKZpdbRIPONx9CKI+eQ/AYICmEdPqP/2HHSTfce
	 9CTU+Gaqosn/+5WHH6qgLcKhRFXZWGoDwo+Eb1dxhWgyzp9GtGIzJPgXmSVl4BJZ2FOOD
	 Kb0qrLfZUzyOTFVe8pZ6bCdOYG4owMv8b4+hjpdlsJrOdNPK+pe+upCQZYX47oNebzbZ2
	 SHDOzFZ+BwoP4g+SsOQTiZOvwjg7z52P9WP3LkowK12mNs5ThFLVTDUzPVbN9ds+p2aK6
	 p+DPmzeUEi1h16YKaXXSZ6OxrbIWwq5VCdyy2hYRBE0s+iwyj1b1Gt4rxfkfJFg929Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793559742;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=mZslQFVUM++BBw+BwrpJpXtc4dPPTdLJDng3B+Sldh8=;
	b=MA6xWO0NIkloY575IBJVb5IGtc+bG1Do6k2ouopYf04Vj4LLpkZALuN+IL4Ai01tULK4
	 FgBdH/7+etfus62PAHHxcdw3UkdAUV/FvKNV/TrHeRTgcjQO4edqb0c3mY64wr+cY3i6u
	 xIdR50viSuNjkR70J13I7uIsurZnCderkXaRO84SMliW16ycfDeO/DX8jXYWfHLQJJlCB
	 F/Ivv/s6IbnHtRlbL17ZnUmIn0VYgLwA5b9b2apRdiodimU7jm8f/fcBoTu/XpggCxgjj
	 yhvJgYQUw2ceFSA7P6Q98T0Cs4Sli2PSRWrM/E0gi0++SX+uuJph2p561zUVoLfQW7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=J66abi7e;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=gslcqi1h;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A74606A32D
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 19:02:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52A74606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=J66abi7e;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=gslcqi1h
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1HPtvV1443240
	for <netfilter-devel@vger.kernel.org>; Sun, 1 Nov 2026 19:02:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=mZslQFVUM++BBw+BwrpJpX
	tc4dPPTdLJDng3B+Sldh8=; b=J66abi7eifh/tm4V4JGcRluuWF7pHayao9EUFL
	n9RYqHG8e7I2VgbDaMpHc975iPoHvcNcpWaKmY+AmS2lxnrftmQLloV6XpllNcyG
	kB54B8P5wyWBrVwWP4wC6lGR81d24Mjp8vGW6QdvruKYgIf7mq+3BC/kdMUOttkY
	rkP1DndcqGwwyBG//jsUQyO4BjW8V7c62FPH0s6uCrzCoGrtTP4jJ0jKkUSZ9AYF
	b3ixboyQ0CEEu2BntPRyjLQfwCb4dKUzUlDclxCX0LqaOEX67/JI1Pf2lYYKUYhL
	2ySPMR9BFq4gs40uf37CnnLKWwTvZUdr4hxlpkePCJd+Hxmg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn8dubyyt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 19:02:21 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-9441113670dso564726285a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 11:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793559741; x=1794164541; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mZslQFVUM++BBw+BwrpJpXtc4dPPTdLJDng3B+Sldh8=;
        b=gslcqi1ha2m8j/jsQyjvoZ0j9YpDzatGb+piGC5WSoAOJF0sybG2FWKAA3mvvxB8eM
         UQ994jnP3NafpxbZAdDdLIOo6pA+OiczKCjA6UHznGtc/DuCaYFc1i8YpY2wTLc5frax
         /sq1sScdd6cn9umxApZa6VVuVANSX0ZiWuGMyLx58pd5ISeaa1eDamtOpwM0rEVdA+dv
         o6HkgccNz3UFrpstRqXCB7DZBtQ234iqurPyAap/y0Thb8rFQApDAmuBuDua28KKj1UB
         t6r7Rdy2wcicbb72aBLgsnemqSCcDzRVSDIWSLIjLEMIF6+hj3A7kByHyj7La5f1agoJ
         hsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793559741; x=1794164541;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mZslQFVUM++BBw+BwrpJpXtc4dPPTdLJDng3B+Sldh8=;
        b=e2Q7G9d5GTjH4eU5FzsOmexc/BQZ4Y1xHqNHOsR4XdpLGP1Z1OOHiRwUiP4nSaVYpB
         UrHo6irnsar85JzPjOmputBao4VKTSzyEJLVhOGV4VsjULBXy9JUMdc54hEU4SasizB5
         VqsUFiiTBODTVXmRy87hZgU2oYqp6fb9mR0IsmLcMrVTiJpKgOeTpKN+WgYGf7ROhLia
         PyjBUinVPKIsOUKMXG1eWUMc8V+mdC56Pt6/7f45cBIg1tEkSzXta7le7P9s8xdzbNNV
         dWPgSq713StyvHd6hSF+qfvrZ752jC5P1W3AC7c2/iVJhFaO/4jBy8mpweFlPe0iCGwu
         2oLg==
X-Gm-Message-State: AFq9FYLyPZOvmXeqQG5b7tVcKLTd9wbigYUmz5mtulp/dLuRj15yej1o
	xRqpBeSNBH/cPKjujcSC9EIsYJROiqCb2wimjn2/OsQqyGVSEcB2SgfN5dprUvD0joLr71EORZS
	TuMNKs7eo1Is4wCUd8yC7LZ8jc1rOls4hWw5XL52RP0QzwR6rhcE3vi5SD99CR+jlfPhtFR4=
X-Gm-Gg: AYBFou3WdGnx/QO6w5F5wDv8ZRkzA5Y2sROYjkYSucozGqvRQJfOLAR13jb6jt2nuQF
	tu+Q/P0pKxg5JXM4WYnUAD1Bg4Sdh66M0KJjjBKOFTAQr89//A8HdVxEHh0IRpw9qyDI0D62yUL
	cqNAJTNVlDYi2knN1vZPIMd+GjR1i8wumzAPT61ZBcfXiFhpaxk2Gkmv3FeHnK96xT6ik+seK2C
	K0RCKyMk6nToEYdL76MdOteqyFHfMBXznRmZ+B8J+T/scuBovuvuxV7OozGghuArEH3KPj1PoDj
	TXl0Cxy6SaDv4ry0PYy+pZU8kgDKrWSCW6/wJnoi5l+mXwAqAhta7mb2XwyCKzna3lBpf/RJ+FY
	I/MY3DdemIHSGR36WDs2xOTTPf8IOK4ETxJkIe8UHgH03D1tTJAD1TgSNpRtKZdk=
X-Received: by 2002:a05:620a:45a2:b0:93c:c96c:a5a8 with SMTP id af79cd13be357-944217b0af2mr1362280285a.53.1793559740439;
        Sun, 01 Nov 2026 11:02:20 -0800 (PST)
X-Received: by 2002:a05:620a:45a2:b0:93c:c96c:a5a8 with SMTP id af79cd13be357-944217b0af2mr1362232285a.53.1793559735153;
        Sun, 01 Nov 2026 11:02:15 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm327961625e9.11.2026.11.01.11.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 11:02:14 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Subject: [PATCH nf-next v2 0/8] Add IPv4 over IPv6 and SIT flowtable SW
 acceleration
Date: Sun, 01 Nov 2026 20:01:54 +0100
Message-Id: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42NQQ6CMBBFr0Jm7ZC2KAVX3sOwKHUqk1SKFAFDu
 LsNJ3Dzk5eXvL9BpJEpwjXbYKSZI4c+gTplYDvTPwn5kRiUUKUUqkbnwzKZ1hPGBY215JGHkge
 MPKErirrQWlWVIEiJYSTH65G/Q++wp3WCJomO4xTG73E7y0P/9zBLFFgaqe3l7GrX6luIMX9/j
 Lfh9crTQLPv+w8nEdmf2AAAAA==
X-Change-ID: 20261029-flowtable-sw-accel-ip6ip-sit-f3393772880e
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
X-Authority-Analysis: v=2.4 cv=O6esLx9W c=1 sm=1 tr=0 ts=6ae78cbd cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=q9g148jr9wMc7ZL12-MA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: L4E2u7NXehkK7QpsJOoJTc4yfYIq1C4O
X-Proofpoint-GUID: L4E2u7NXehkK7QpsJOoJTc4yfYIq1C4O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX7P43bAdz+rh0
 3Jkxkr3WjG5khJjZ8rmCYU8dsfrT7rTcwU3ftnwC6+Nurhf+ArGRRrsCkO4R9oM5Y6nwkx0xf4J
 JaPW+6+urx7mV5QPZVh8b22RshVuTvsaiHQZx7YqYwUn4m4KzCmPaAIM5mkUjBoHzJCswOXwkkl
 jWuWNwSV3jzOGla+VMEv8uSAxpUnYyCPGODUedjC/mwBjLV5e5Bm90YCbQXbx9xtX950HqNYxbc
 s/OvIRg1IGpKlMQaLgTBglZp8G6PcVLNoXzOD59uA/cJ1YXQB1Bb9oLZika02GTofTglVGFK5K8
 UwkOG5OfKyUHIN6RYxdk/YDCZB7HLHmSdqwQTLQQYd2e4/bWwlx03w3T7o/M7x3BMtXpu69u3ds
 uRbxRSl1TlTlo8LADN6+3L8PA94qLJuzL+59Of9Bix18ZZH17yuz6YlIqoPlXi6S0OUrz6gnu6A
 UATlPC8eBeNZDgXGjmw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX4xLm2kSl94YT
 DJp3JgacezetZ4UvLTMsOSSCSgHy398m2PkCOOvnkpYEOejN0Zj4V/HLZjZ9k3Lpj7z1aybQCos
 TRrh1gXpGVxKaueZo0e8gR6sxA7A6cg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-01_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010075

Similar to IPIP and IP6I6 tunnels, introduce sw acceleration for IPv4 over
IPv6 and SIT tunnels in the netfilter flowtable infrastructure.

---
Changes in v2:
- Fix skb dst configuration in nf_flow_queue_xmit{4,6}().
- Rely on tunnel->sit_parm pointer in ipip6_tunnel_fill_forward_path().
- Link to v1: https://lore.kernel.org/r/20261029-flowtable-sw-accel-ip6ip-sit-v1-0-6a17c54f9fb7@oss.qualcomm.com

---
Lorenzo Bianconi (8):
      net: netfilter: nf_flow_table: recognize IPv4/IPv6 in tunnel proto matching
      net: netfilter: nf_flow_table: refactor MTU check for tunnel offload
      net: ip6_tunnel: add IPv4 over IPv6 flowtable tunnel offload
      net: netfilter: nf_flow_table: use tunnel encap proto for route lookup
      net: netfilter: add IPv4 over IPv6 tunnel flowtable acceleration
      selftests: netfilter: nft_flowtable.sh: add IPv4 over IPv6 flowtable selftest
      net: netfilter: add SIT tunnel flowtable acceleration
      selftests: netfilter: nft_flowtable.sh: add SIT flowtable selftest

 net/ipv6/ip6_tunnel.c                              |  19 ++-
 net/ipv6/sit.c                                     |  72 +++++++++++
 net/netfilter/nf_flow_table_core.c                 |  18 ++-
 net/netfilter/nf_flow_table_ip.c                   | 137 ++++++++++++++++-----
 tools/testing/selftests/net/netfilter/config       |   1 +
 .../selftests/net/netfilter/nft_flowtable.sh       |  86 ++++++++++++-
 6 files changed, 290 insertions(+), 43 deletions(-)
---
base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
change-id: 20261029-flowtable-sw-accel-ip6ip-sit-f3393772880e

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

