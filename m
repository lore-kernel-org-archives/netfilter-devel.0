Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8661F36E48D
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 07:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766925; cv=none; b=oxB0/HPut4AdD7jVAwUANp5NP+V015JOx9ijx81nJqhGuDWK0dE1ldXoZBMMToxINhZPIWXRn2gFLuwGZKyy2zw6lxNmtCE9GU1lEbU25hYnU+SsNAgMDJhds+Pmcfy+awg0l3bB8qgXu2lhkWexfCGdPkLYYCii9LiATo75KgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766925; c=relaxed/simple;
	bh=AmYTVtq9q2zdn0RuPo3cddtrzQkCt+YTwmkXJN2yUuE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=di/1iq0yHey9iyHfKC7VsbKPgQ/Zt4/33G32Am5Pn0W65nDmvf+zmlWFlThTG7luN48D8BTb5PkroX6t8NAg+ONfeRC66+adi5hDZZNQsCNQo+icpTMMdcONeJ+xN//SaRJZ8IzBZEVt5UGq3yGljUgikDyUs2JWMAKFA0tgymA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aqBawn7U; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RGv2TLJZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aqBawn7U";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RGv2TLJZ"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68777W0w2724133
	for <netfilter-devel@vger.kernel.org>; Mon, 7 Sep 2026 07:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fE4Th4zCBtqTO9C1K+gn1Kc8P08Hlw4ollCF0wc+vGw=; b=aqBawn7UPQKb2I/B
	/MFAC09C6D0z2fnwiCEfVWt4OOQ35gHZkdRDbx3CTV0Emee5xccVQy6bbN1DVKDk
	iQHFiXneu2LiXBfwC/qg1XQv1I/GXppXvOHoqM/H0+regLtbAiks6nIEJfE7TDwV
	3VMqVqo0ybvKec4EHxgC5f4UZ07XUM9OpZsCPlsiygINeZcvhnlIq97pDH2bxeVR
	Mi1iHrsMsquoL3Tbizkv1RRw5XobIJ2HRuSEv8LT71zv37E+XuqS846ftp7FKnYJ
	DbtmFwo9mxlRjX+alYEQrY5C3eEe1XO7sLZkyVOCi8k/vUKhThW5Dp6Ulrj1Wr50
	vb73Iw==
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghfxksgvg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 07:42:00 +0000 (GMT)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-49d4cb3ca23so4018795b6e.3
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 00:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788766920; x=1789371720; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fE4Th4zCBtqTO9C1K+gn1Kc8P08Hlw4ollCF0wc+vGw=;
        b=RGv2TLJZumHfCFFy010tQuKAlTCF3cVt5qokWm3Ns0avZ7xxkrbfBESOjuzEXFQLIe
         YpU21+iRlPkLvpcDH6/7bm3wasAQ04HY03OzxJ90mUkrt+8oUvJF0fPB2fuL70iff8e9
         jzKqk59tIzofsBNKE+gWjdtGy5J00BOGaN2tyG+DVHfp0DmUJfwjqfNqRnVMMegBkBl6
         GhjWqughqnfpcl/OMk/GZL+izc5utn4tEH0OGNkUqsQSRpDtR4LNNudwdHzZpaKBYa7V
         S/+CGJfJJRSatAU8ipzKqMAQdl+ypGy+Er0p9tZmlRMY7quqgS0vebAJqDTo5ozJGn8G
         x40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788766920; x=1789371720;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fE4Th4zCBtqTO9C1K+gn1Kc8P08Hlw4ollCF0wc+vGw=;
        b=R1tLf7LNOZ8R8eEokCm1f9Sdp+WAIel5MmHPVxbfmHdbIhO8euko0D5qnTAbVqEpCZ
         GhbB40Gksxj7HKe9vnZOyv7t6qb9F3tcwinPUxeSvtCrsoDKQiyRSPK3Nb5fzjMgi8xp
         xPAE/kqX6lgxusrDBlQuWTIeVug2/0XrI0/3yAolYeHO+n4ECZYTfvpK0KTUE1ovsC2C
         7SskvW5fWK61dby8Q8tfac15+scpRdaxUPDGX/81UbP7VHDKpssmDAMcNISgMha66eV0
         Hmu+GtkbiQ2efgcctz/mP7GdA5Gy78rBRzVfMxugrcb0LY/v8pH6gC0H9lt/iNOI69YB
         1GUQ==
X-Gm-Message-State: AFuF++kTNwqQH82G5+uXD1gmCczTXAkPoVhS7DTkdY52UTAPVbbuHVIw
	6b145TC+bWYTiRwA/cCZ0M7vz6u5QvoThqhJIV4xyiaL0de/nosyNq5usDVydT4DfELw4605gZX
	AzXv8hNx5s1e3z/R5bYnCy7GeRrfUK17oVlK3uKQ8GncNarK7oxjz0/XtEAqOwR+Zj48HwTSBNO
	xvCd0=
X-Gm-Gg: AYBFou2t1U4G5+c0V0JNkdaIDre5IHnAU1VaNuO2sAGzIkEtJxz86rTXhijOjpYt0x+
	IwD2QKy/NASKQJJvzl5NGGGONYxxaZpDYPmT69mEdcaaJQNQYBRd7i8ch2sZAU2T32dhpihGTz/
	TlEJZr1PKScnxIyC3iAGIcGNe+ZTW2abpaiYmA3GV3HieHnzEr+YjdCpfnnUWOc9vcXHRXAZeuI
	ngBkytkP7iUYub65+C9gQU2/V9uPh57ZeXkO7mVrJCrTICecgPpS8jTahVEaHotFzAui1X1mNpW
	ZKQi3+Dpdd1L3iVr0ZRTpTOa8+HM7nCpkTel9Xq9NC07+bpWQP8ItCaB/1SBKO9WuLj3orUL2hg
	No65nOeOwp1hDBA==
X-Received: by 2002:a05:6820:16a4:b0:6b1:b375:481 with SMTP id 006d021491bc7-6b6f7c75a86mr20629390eaf.0.1788766919895;
        Mon, 07 Sep 2026 00:41:59 -0700 (PDT)
X-Received: by 2002:a05:620a:936c:b0:939:6d2a:6e38 with SMTP id af79cd13be357-9398044643emr2074255485a.33.1788766450579;
        Mon, 07 Sep 2026 00:34:10 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cff8195ffsm232774415e9.14.2026.09.07.00.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 00:34:09 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Mon, 07 Sep 2026 09:33:38 +0200
Subject: [PATCH nf-next v2 3/6] net: netfilter: nf_flow_table: populate
 tunnel tuple regardless of inner protocol
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-3-7c6ac1750725@oss.qualcomm.com>
References: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
In-Reply-To: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA4MiBTYWx0ZWRfXyaNZHt7J3X5x
 +JMM+4hFa/S9Y7kSAqzuPZdHvlHhG+m0HVzUAh3R2ToyYh1HrXA/t2Kp5kn4hzVveWyS0voMKkw
 qZ+z7HJ7dWONFd5od6/nVRSOVVDcFfDjUFI0sL6satkILOgcSxWDY92f9YY/8jQ5UDaVr42lBdE
 +xKf5RmbqJcFJwtduhgY++0/W2HYNta9ynaRmtOy6Jtp/PeqMRGfcbkL8JDoYaqXN3yoPal+Fvs
 tYFbn7ksdLtKpSBZzTcxbAT9dIVx9UHlFs7lKKJtgmlPwElar1TnLtU/+iGzlh+dCRBLRmowYLK
 9D7RiVOlXE4o8AAvfdJnK3/rlzar5Eb6JtO5cWD2hWdL/1oMydfCmXq5uyBZNiVot1kaji0YqII
 FN5UEUb8f0Wv9Yp/fFYX49Jv/0lXordjy9NSfDYBUhl2AIjp3GltsJ7/FF/0FpybYZBIPb5wFMg
 6s0F0Rf2XHBWA9WBipQ==
X-Proofpoint-GUID: l7_lyTelR8ga0IrsZ0rQMVuRO09WgV1a
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA4MiBTYWx0ZWRfX60Irdvi0fhhg
 W/82JNsTvzTu0XCADOfbPaG4WMDXdN8doOVSjxzwKj/ZDgLAHfhABl/SHr/8tN1AW+e6iyXJ9rX
 TtdjwlF+r7UPQIzIhaPFb+VM/Ivytmk=
X-Authority-Analysis: v=2.4 cv=daOwG3Xe c=1 sm=1 tr=0 ts=6a9e6ac8 cx=c_pps
 a=AKZTfHrQPB8q3CcvmcIuDA==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=9AI-LCzJV_BIknmlFlkA:9 a=QEXdDO2ut3YA:10
 a=pF_qn-MSjDawc0seGVz6:22
X-Proofpoint-ORIG-GUID: l7_lyTelR8ga0IrsZ0rQMVuRO09WgV1a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070082

Store the outer tunnel addresses and inner protocol in the flow tuple
unconditionally in nf_flow_tuple_encap(), instead of only when the
tunnel is IP-in-IP or IPv6-in-IPv6. Bail out early when the inner
protocol is neither IPPROTO_IPIP nor IPPROTO_IPV6.
This makes the tuple usable for cross-family tunnels such as
IPv4-over-IPv6 and SIT, where the inner protocol differs from the
outer address family.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.
Please note IPv4 over IPv6 and SIT tunnel flowtable offloading is not
enabled yet.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index cd636b4cf74b..a53393f8eda0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -189,22 +189,22 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		break;
 	}
 
+	if (ctx->tun.inner_proto != IPPROTO_IPIP &&
+	    ctx->tun.inner_proto != IPPROTO_IPV6)
+		return;
+
 	switch (ctx->ether_type) {
 	case htons(ETH_P_IP):
 		iph = (struct iphdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.inner_proto == IPPROTO_IPIP) {
-			tuple->tun.dst_v4.s_addr = iph->daddr;
-			tuple->tun.src_v4.s_addr = iph->saddr;
-			tuple->tun.inner_proto = IPPROTO_IPIP;
-		}
+		tuple->tun.dst_v4.s_addr = iph->daddr;
+		tuple->tun.src_v4.s_addr = iph->saddr;
+		tuple->tun.inner_proto = ctx->tun.inner_proto;
 		break;
 	case htons(ETH_P_IPV6):
 		ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.inner_proto == IPPROTO_IPV6) {
-			tuple->tun.dst_v6 = ip6h->daddr;
-			tuple->tun.src_v6 = ip6h->saddr;
-			tuple->tun.inner_proto = IPPROTO_IPV6;
-		}
+		tuple->tun.dst_v6 = ip6h->daddr;
+		tuple->tun.src_v6 = ip6h->saddr;
+		tuple->tun.inner_proto = ctx->tun.inner_proto;
 		break;
 	default:
 		break;

-- 
2.55.0

