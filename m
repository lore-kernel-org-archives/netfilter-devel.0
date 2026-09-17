Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8B542E436
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789633801; cv=none; b=FTiQMm12ksUSM6P4I88WOCHlBAikIjDgiM+zHSeP4KzFVCLz/xyXTAY3sjJsXQ1JfDOfQRBP3SHj+VI43Hf/KygKjjky/uLrKwQBJ4rI+Op5HunxPF2kzspNjUBHNEtnhnK+M+tHcid/+5cROM/ybp3d6db6OuepDrWT+Ih22xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789633801; c=relaxed/simple;
	bh=CFRrn4x6ponRYhQFZSF7DOt0uGwt2i4dOTnusXvOQb0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hUwV8S/3dTv7glsax1nKMYKgn2T70psw4xQ8rr8SWDDeyZYVxWiBrsXGv8u6zpMtm51FH5zUqjNY7a0zyjaanzpB3f6Yy8S1AAdvNYJeu5vjQ+lioXwytm0CTIP1iANS6r8SUs1jbS+mMkgZ1lSesZG8OZBxlUeZ6ehIEo/EIeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Nep53tXD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eqbmLGoO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Nep53tXD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eqbmLGoO"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H60Nox3702423
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LoFiFadfWvsKDJXbfNr3lKGOOeQeasFcKWql2l4h94M=; b=Nep53tXDRmyvNxjO
	UdWe3HxdJMbHkxJkXsLVuZgfX4eyf9bbheqRvNPFp1RGyxHD1Mrcwdn7hlHpmhWE
	dqSHFmXhutcfrZk//Ta6XX59KUTDmLRH/TX5ORBhjVWFvp1od9Eu7VMu02absITx
	s0TnbZTvccHYtrHjbltIQof8xB5955cCCWa+fT60Z37oaLcQO+3xYO5+wKcg82ds
	VJcu95N/z/F/I8sx/UScBqv1joVb60ZlJbn5TiIwhHigBe1d33CRFgZEIvCP8IwK
	yyeW/LUg4/v3iyPF+W7az8ueIUOTxId8dPdSCcj1MGVNipmDDq7K4FYxjR7NgVga
	DDiN5w==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gr7uc96ud-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 08:29:39 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93a3f673221so204589785a.0
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 01:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789633779; x=1790238579; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LoFiFadfWvsKDJXbfNr3lKGOOeQeasFcKWql2l4h94M=;
        b=eqbmLGoOB7K+4rSeccq8QnX8Mcb+3Pttj3qmit4Dl4eG2UjYpKNyrpG4EgzRX4M7B8
         l/XdlivywPNwwjp/WFqoEXzGh6Wg/xf6+59aPOJNAbuDEcd9hFF9Zm9dAStp6ql/77vO
         g50PTyxddE81LJG5xDganX3FBIzL0PZJCEbacR/QM/vQ8DX9sRx7yVgWJPZs3Ve0rlT5
         noDjFYw8PZiRQvofLheR1/H8ZeDZE+kHg32iP4feevnuY08/WL8CKQsjaYqmt8w5Mft9
         NKiyvl0AnpdnMa0/1X7N7nONgHhogdK3ZyE3fwiTsP9JbTiCtYjhnt+/cibpNyrF+7o+
         FeHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789633779; x=1790238579;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LoFiFadfWvsKDJXbfNr3lKGOOeQeasFcKWql2l4h94M=;
        b=w+xEL0aTgCr98FayMQIOA0atKBsTZRWfK7OpZM3dbuz9DFPEx5mi25P1US7OAPrRGa
         mrema07WfPzzT5/kkh1yzhIuNEgB7rRtodeZ1cd3oQJBVJtI7L4hQyFIkKoCy/0VYiw3
         BmT83T/g0VGtZjc4ryyEtrDALJI+7yKOES8IxOq/48igFCTZjcBq1s2HW9FeT3IW4Jwy
         /ARN+dyHU7sZ4jYCoGO/Pg+mUckmbouIAPNVFCxXU2FytrI4UQFQO5ww2Ilq4nKGSMuG
         4L6V69R153V1utbMZRvphK4Pk5GJ3fzXl0F8qfAPDXpErbzZpWDrU4+RA6n5tqakBvbI
         o1Wg==
X-Gm-Message-State: AFuF++mOJgczm/32HLt7YFaAl2eV6s0dUoiUsWkqbj8FL/vK7X9QN1JI
	5ktc5D7ZnfGji9cY3mi5KnKWL+YoulpxYucLHt9Wm632pWwr2NE3f3z1Ev/FU1iac00dS3qn8br
	0f9NvuzL2LW+CtoGgabjOC/bdj4uKlGWQ+ry0FvBPxWbWDxg9myKp/m1Rzf98LH3YJTV7GSw=
X-Gm-Gg: AYBFou3I4MySdKeiyNUb+7BBAYWEsBJHNB1mdojzNPLUhll2YesPR6rJEat4wOxz2wo
	uxBVToXxVhJh8jC3+qrUbnRKK0rhYaFTaEede8VJqnkTeczxfbn00puyOXYOtwHlYfLWnesag8P
	C7bw0N7VVJbHNf69THhu4GSry0E4okKLuii/lX7E9z9wL/xNeKtj5EhulcMf+STSumu8Lz/AEZV
	gMA6snSsCGLXLBhphqMu0EzUoWBSnTU5GIsoNt7CMxwKNyqE6DEBmyUQxnmt6+hCVCB0qEOSfMf
	oK+ADg5OJtiscuKe5W4Wuc1xnoVFbEBf5OzHt9zn+q8SVNyR4H1gTzv3v00Qg23+r28MIhWf6k5
	Xi6n9X4sAQYWFEg==
X-Received: by 2002:a05:620a:7018:b0:938:fc91:91ce with SMTP id af79cd13be357-93bb771e83cmr987989585a.20.1789633778976;
        Thu, 17 Sep 2026 01:29:38 -0700 (PDT)
X-Received: by 2002:a05:620a:7018:b0:938:fc91:91ce with SMTP id af79cd13be357-93bb771e83cmr987985585a.20.1789633778521;
        Thu, 17 Sep 2026 01:29:38 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27198sm13477625f8f.15.2026.09.17.01.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 01:29:37 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 17 Sep 2026 10:29:08 +0200
Subject: [PATCH nf-next v3 2/6] net: netfilter: nf_flow_table: set inner
 protocol when popping tunnel header
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-2-fd2ea96fac7d@oss.qualcomm.com>
References: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-0-fd2ea96fac7d@oss.qualcomm.com>
In-Reply-To: <20260917-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v3-0-fd2ea96fac7d@oss.qualcomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDExNSBTYWx0ZWRfX3CMUbWWv4zg/
 yJPeeGrs46+wZyJL1sXfJorznWrsFPvejw7qmYAsky/cfB2wWz87sQ/2fxsFPjVi3TS4Mmh9568
 RTXmm+5oocz+l9b1Mtn90fmfYlytaguDiu9DkUmcC5+EEtHvuOlkC27B8FvfKDF7AeyKnIX8uxW
 fhQ1FKbw4KzFHSaQXZRQ5IFfAbv8cj2TyW7zOUT5Yze5PbgLKr5DEGhgsevd33ZCwe4zPjvfK7b
 7hv5SoGQRFc75PwJ2viqz1xaHx9QyHC2IY1dVnmHibLLWbWJn85xURjvqSsHbKN8yYaTS6eArJd
 QSRdY9vwfeXgHFr9R5X5oh6JSPdFPfH9Nz08GrplJmGlskQGxkuKiyWvSSvpDLJ0brTfOJd7fwL
 QPj5vDJ2LxRnKis5HJL1V0jV+QT5uEVcGYMuNJNBDwBnsOmyw1gHvUbv0JhqRfvn9C49ANeXwb1
 C6uYr/+jL/7ea/J1jTg==
X-Proofpoint-GUID: JOWtLDFVE6Ibp1FwREG8flBcnAs4dgjp
X-Proofpoint-ORIG-GUID: JOWtLDFVE6Ibp1FwREG8flBcnAs4dgjp
X-Authority-Analysis: v=2.4 cv=F9zC5ahN c=1 sm=1 tr=0 ts=6aaba4f3 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=gKarwEfFoU5_EcFYj1IA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDExNSBTYWx0ZWRfX5cSn22/ZpZgU
 85qb0Wq3X4DnZlfP/htAPD0hDBX7TIa6+D4AvUugijLvkRxmQ6ocfqi7k/IZsfOx6ZU3tMDidYj
 BYARAg9vNaSrrlkvSpH9UJw8zHItPHM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170115

Pop the outer tunnel header and set skb->protocol to the inner protocol
derived from ctx->tun.inner_proto in nf_flow_ip_tunnel_pop(), instead of
bailing out unless the tunnel carries IP-in-IP or IPv6-in-IPv6.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 42e8de696474..cd636b4cf74b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -372,6 +372,11 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
 
 	skb_pull(skb, ctx->tun.hdr_size);
 	skb_reset_network_header(skb);
+
+	if (ctx->tun.inner_proto == IPPROTO_IPIP)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
 }
 
 static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,

-- 
2.55.0

