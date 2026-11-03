Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714823;
	b=bN+npGLu4A61ryWhXawVqRWkAgb6MZYSnra/j//iK/HZoL+xDMPCC8mycRZ0D6h4CfjE
	 2m2J8cBxu2Og0nfe2oEM8mTkndy4OrzG/Zs4Y83IUKg3+YiB9VHGRAM5IHanPJzWtsHSe
	 vn7NiYh7HGlXSLN31kdW8Z3t85oPQSBNAAK4C1etlm8O2SxyBAgTFJsb4QWiyUDvxeN5y
	 hWZgQ/hxeNfoUSu9FeSCbZm3tF9y6vdTfu/qpjrCb4renCfLqQdKw+aZFz4KTkiQ6SmPF
	 Ahnkpl3U/IB4qhWUESBRBs2YjW7juzBLWPVTlQl5H3m9ojMtzsmc0ErqG6lsFD7AodA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714823;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=85RUdm5fHz/EURSg1WKsbBmBBP/Gz+V5vxANV+AddtQ=;
	b=kP4Rl/487ihpfGBc0FC2RgrcAe2/ZC7uXdzc8+IEpbNetxpAXVqPavQUl2cratcjkROX
	 NcCqxE72+7LqQVHWu4cryVeGvwEvOxTqh5v0yH/R+L2JAyyZhOvLP4BqQsAMvomUvalYg
	 A5NF2hrG9wvxQ6Nixqyik5sxd7xIqJ6MUva1LFV1TWZG1kauYLRDfHoBw6UYzKJM6XTwA
	 u8TGTtSF78G8DbJnZB8WBq9tyTaUtKj31YxiL+G3KprLNZi6zYpItC9/ZYu9pfZGSgVS3
	 VJyyqKqvPww8AJoDD+gFOeX5lP3hlOOZGFuMh3YCCMAIRYrmB8fxWy8uUVcPCK0ePLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TmR6kNxl;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fKtcAwuB;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB21606D818
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 14:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACB21606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TmR6kNxl;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fKtcAwuB
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3DZFIP4027554
	for <netfilter-devel@vger.kernel.org>; Tue, 3 Nov 2026 14:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=85RUdm5fHz/EURSg1WKsbB
	mBBP/Gz+V5vxANV+AddtQ=; b=TmR6kNxluCMK9SILJrHgMoURPFDlpNxyeeXSX0
	QDvZx8OYo7Ht7FLEIva7VvCZueXQuVvJTAmkYd3RUChuTRwb9+3kHR8AU8eSaqGp
	Z73xNNrh5xZWPV+ZPIvtw6zPlWxpN2TK1a6VVVreia2i4CbX4DCfMJ6s5dBLNNFK
	0KCYPtQ5UK8tL3Y3B83zm7IzFXAmqvIeICkRHnMI9NcFnXFJUGlqZYWA2jNRxwlU
	1MhH/ofWaDA/Om2EJG3/io2ttgQpjbhNzPozMgLbfRQm5ZUWYfpgWUAl6ufCCOCU
	TyF83gf61QJB6kZh9I/3z6C4M9IA/Xvu7mLBMsdhO0nVwXrQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq76dafqa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:07:01 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-351788121cfso2010252eec.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 06:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793714821; x=1794319621; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=85RUdm5fHz/EURSg1WKsbBmBBP/Gz+V5vxANV+AddtQ=;
        b=fKtcAwuBVDt069MmFvevE8zO0A0Nb9VI38sz+LAp/dvm75r7EZhxQVLkFIGcz4dIQJ
         SbfIif3JE+sLmeDA1yQigoBBppvpQaLQWcj+IYx/kXGhsB0tU2dJVbI0N+TL8GqswPTH
         QGNpSJ52x1etM5KhGczEy+lhO/XMCgTV2LXwNBFXHiQyTgTkamRO0H98DAtzq3hwlwCF
         gKn5BHp2XOBwj95Wy98YsY0UowaMUUw41+nJzBw+96PN+aj8QF2tq06dLtmqlEX9LAKs
         LFrXFN56V6/2AmW/PdO5jJJWKwtdx7CsulmpvxZ5EsuAMLot1/0fnBDmukYr/Om926fk
         OMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714821; x=1794319621;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=85RUdm5fHz/EURSg1WKsbBmBBP/Gz+V5vxANV+AddtQ=;
        b=EnUAyjt+o6tw6kcNz0VYXKcmAMm3W+AhNDkpNM4Ne2TCNW30skDMo/gwWGOWhZzfBG
         gNNammwG3YeZ52URgeYIRcRP1yIGX2NNfK8EmatxdQHpj+Il1LvCYQG15JYQrlKXW/EB
         PNT5nPPM7QsNeF3kgaLrt7v2xDdB/Hma8wjZ+d9tZOcs/vRY7Y55hdlirGzmsddE3IbU
         puL3UEL1eG+PxcO8QWwt19OKpY4NRexMCODaQs6LJzCNQyVcbvxE2pDl9S3646IWoLC5
         KQX48UDzG2/VPdYc6Bnv/ZZiTGnK8cKRYU/oruEbwA6KSoUhVaInvFns00FgB2ls5SKY
         6aPw==
X-Gm-Message-State: APuU4Z+V+SxntWO+gvArSXlcvFt8RBUoIfYRsM2vj36kBKcgA/Ubbpzc
	AVtCRZmXSrNiC9xk2KQfl8A/VSw/i9u4m7baPSicPtw/toGmDLC0tHpjCdh8LGR56ny2hME2YAI
	t7qmcIor9NNpL5Rris/Z/CxABFckED1XOPVevNBS2wIrKzAWMcADgttElZ4OmvWS9WwrehZVT4R
	oYme8=
X-Gm-Gg: AYBFou2Zdurrpu8obZN9m5I/PwNbgdul7P9QqaxqsUahgiuIJTPBJ2h37y5r1rQPcx+
	rESZOInx1qA6aQ32XwtDOh77cFvbpX2IOVLs0Cm4YCdrJXqFteUlV8cSfmgS1HQdvC9r6uM9N/E
	Nlp4Oy7prz6ZOrvxdFqw482G1DvlJsUUWOQpC6y2jt95lkFPmvaN+riZYvy20b35nc5E0mQdbDY
	IWK+V9zRnaGpw6l2nsbcFNzdT5dgEwUDFw7DQzWHT8BGwjFkTh9j8GkiRVz0Mk+bd0axosixcXU
	6vZMS7gLf8emXcd6XAmGzK1v2Tpq2nUvTzPV01qRuBBJqIIDoS5GYKTy3HIFo8nefZCC4flw03I
	eEYByr7x1kD5JXnXLP7dugbq6YEMPv2vqhkviOI/7telEM8T3PU7CLR/05qLjGjg=
X-Received: by 2002:a05:7301:2a95:b0:36c:9afe:fcd8 with SMTP id 5a478bee46e88-36c9afefe8dmr1037850eec.30.1793714820378;
        Tue, 03 Nov 2026 06:07:00 -0800 (PST)
X-Received: by 2002:a05:6122:4b19:b0:5d6:7f46:b8dc with SMTP id 71dfb90a1353d-5ec68971952mr5502063e0c.21.1793714467380;
        Tue, 03 Nov 2026 06:01:07 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba4ac6sm26968839f8f.52.2026.11.03.06.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:01:05 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Subject: [PATCH nf-next v3 0/8] Add IPv4 over IPv6 and SIT flowtable SW
 acceleration
Date: Tue, 03 Nov 2026 15:00:41 +0100
Message-Id: <20261103-flowtable-sw-accel-ip6ip-sit-v3-0-60b5f063f1df@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43NzQ6CMBAE4FchPbukLfLnyfcwHsq6lU2AIkXAE
 N7dhosXE71MMpnkm1V4Gpi8OEWrGGhiz64LJTlEAmvT3Qn4FrrQUmdK6hJs4+bRVA2Bn8EgUgP
 cZ9yD5xFskpRJnuuikCQC0Q9kedn5i+gsdLSM4hqGmv3ohtd+O6l9/u9hUiAhMyrH9GhLW+Vn5
 338eJoGXdvGIXZ/0h9TSfXD1MHEDHWh0VQpVl/Mbdve15XnjSwBAAA=
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
X-Authority-Analysis: v=2.4 cv=KJTPn1Fo c=1 sm=1 tr=0 ts=6ae9ea85 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=bI6sO-iELKRFtQfF1kgA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA1NiBTYWx0ZWRfX3n6Ntu+FG/V3
 lJbZnWPteiKSV8K8x4G1U1v97zKZhwOGxUrfRii0KFSRTRCyGLzxwJ4UeJ6EDURn704rwj/xo1C
 kTSRBrGq4MwXg1JiKUUcgvNj7hkhw+A=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA1NiBTYWx0ZWRfXzathIuemv0M8
 GTFHlKzVOTbssM//x4wFQO88SPj6KEcZVWrFMETY1+nM1GP/z/GVE7N8L4AGyp84xYCqgxeWvey
 PNCnQEOpKVSXybb/vaoQCIluqW/e27iW9btQWsoYc77XmD4Zh/ZeJIHmSgm1CB3ifn3PASqPYvH
 A2Obs2dtxEnIhSdJrSGJMGE02IdVAYTuytbuK1PMjFNQXWN2zaTLR5Ehs/DWrxpOYbW95xoXMK+
 aCUhmbf+/XGrDlL1BBqDKAdlamBOAGYVit3QMs2ufl/hFhp95uAotxshqjrPqPf0MzPjMEByiUe
 fsxic+q7gFrPwyqXk4Y03I5YW04kqS7CDR4TjqrDqFaYW4dCuCDAcjl03aR6mM2cOsxnwSlQkuZ
 PQbD6traswgAaOMm9oowrP+dS4PxP/Q/30EAVcWrU3aiZ6I9MTlJRS4mvJnfZQRrQOP3+jnSMPY
 GXD3jcVqLM8k6h7QWHQ==
X-Proofpoint-GUID: lKsm8ITj6u6c_ISEpWD7SgwGUlP_9YQW
X-Proofpoint-ORIG-GUID: lKsm8ITj6u6c_ISEpWD7SgwGUlP_9YQW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611030056

Similar to IPIP and IP6I6 tunnels, introduce sw acceleration for IPv4 over
IPv6 and SIT tunnels in the netfilter flowtable infrastructure.

---
Changes in v3:
- Fix FLOW_OFFLOAD_XMIT_XFRM for IPv6 in IPv6 and SIT tunnels.
- Link to v2: https://lore.kernel.org/r/20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com

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
 net/ipv6/sit.c                                     |  72 ++++++++++
 net/netfilter/nf_flow_table_core.c                 |  18 ++-
 net/netfilter/nf_flow_table_ip.c                   | 157 +++++++++++++++++----
 tools/testing/selftests/net/netfilter/config       |   1 +
 .../selftests/net/netfilter/nft_flowtable.sh       |  86 ++++++++++-
 6 files changed, 310 insertions(+), 43 deletions(-)
---
base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
change-id: 20261029-flowtable-sw-accel-ip6ip-sit-f3393772880e

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

