Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE03481241
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 16:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280365; cv=none; b=aO24H5RrLVRijPi/Um1s/8cb3m3ZdipmTabw92XlLwJPM3tzCzJeYKcDNAviZsjKCds0/RB96PXyxUoa9pw4ADAOuG/oOcpgyDCgTfgjZpIt5+7mOhrFbOAo10rGx+vdgSa8eI5cREyaynY2ZXxiuFRBp0FwwF3btxbyoN6VBvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280365; c=relaxed/simple;
	bh=g+TFW9abJUhRiMUcK8eCZhKAHBcCLM5cj4RR4Q8Owuw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JWYBIo8CC130UtEDckNHFgnkutUyCX6VdE1uqYhgZmur3z2GEKUcl5r+GdFgZyQII9n59/nI/Moy+Q5sBU23pJpxVKb2+k9vANODvP/7qbTaqpw/Kd9b3KXnFUKEwKhRCXIzQKA2Zv1dLpjszDliz1ypnrJrxMC4fIZCJsWXLbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ahdnaVHF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jB45CY0c; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ahdnaVHF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jB45CY0c"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681E8gqg2910588
	for <netfilter-devel@vger.kernel.org>; Tue, 1 Sep 2026 16:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5uxRZ2UTtZbGWvdtadjbSiVLyF+IRytM/4hZqHjVbZI=; b=ahdnaVHFewTz9Y6w
	FlKFVr2fBuVp6aamKgiasbGciP3Tw8tRubtb+nZeg8JFKstVCRalgfDnXbOHW87R
	iTBvgtBSJKq/cMKY4GD7PCaqQ6H9oJObfK19qYDFkff4fXf/Lj1VElZsWrFApNG+
	GWwbQkuqV3EeHs9NTRa3m9vBXGJH0KlN1FpE2BG5o/wmAzDBDTbXVZnT/Wh/uPXv
	05TEKvkBzsnqllGXR6KFh4Td7HGERygdPuO6fq9WzSXZLhOntYU7AZ1+wYgK9FZJ
	uu/in6Xgj+OdWb9mvKQwWbKQsVbuA0nGSIM0BToNZ6Oopz7k0INnsiTncVFHWJ3Z
	4Fvknw==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdp7r3g6r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 16:32:42 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-73760a7cd83so70677137.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 09:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788280362; x=1788885162; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5uxRZ2UTtZbGWvdtadjbSiVLyF+IRytM/4hZqHjVbZI=;
        b=jB45CY0cGtKZjSyKGCemgfDkkTDlBS22CjxSeOKoF+A2QNU1IPorANoe9CGIqoQZ0j
         a1ZEvfnARd6Wl2ie7ZOOgx6AXqcGDQ0LcGOHJSJHIAJ6eLSDP08dOmujcwU6AJCb1mGq
         bdstTaA3PnV0MQ4roEZkx+BUR5BHEpEqUo+vd6BpLU2IGHuEsYF9Pao1AZw8cZHH8MYa
         9jZQI3S4QH7KJPvoayuJVd4Pwxovbdf66auvtcGsYIBAOP1yJGifimkc0u6Qq+gre00L
         pINvPShTWbxTObIwmglr3YT6nRzPep3HKBh0ZNmaAsg/Ajf/pwoa+ygaZHgQsfAfq9pq
         JkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788280362; x=1788885162;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5uxRZ2UTtZbGWvdtadjbSiVLyF+IRytM/4hZqHjVbZI=;
        b=DkCY1VmxBvyLovrpwgnO2tu40qcosM70NAitPjLIWC5lkj5spEvO8xVTxUOXun8QzS
         BQEsguXZyljZLSmJWWNvISmS5y9x3beKb81lujHSiLwcpcRa+DdjwHwFiVJI0pQdTmfT
         Pppbqok1c6ET6zECwQF6VKxLMvqSBtiB2C/RgM77UatOIkJ5B6hZTG0egwZ5hUGNJ7es
         RZNP3T9kp8Z50sNLH4CWslCyIOrbPKBClfCgnpPVQbhqMy4A0xshhWs6+hH2SMo6Sg4R
         jjEC1CUsQCwHfTT7MObBoJvLBKHL5N+6MAeXSYy0bCy2AdIagDMhRt1AZONL1lDNtJcw
         Hdsg==
X-Gm-Message-State: AFuF++nB+XDPILDqrxZ6TC2Da1GA+/ZdkIVvsLc+SYBtgfICDB5rqOLQ
	ypJalQpSfLLNnyTpZVutxifCNeoHgssUVFXn9BIH0MPYd250YtWSQeCdo/3Gc17OnQPIdsoJgW3
	hqklGNze9a+BrutnaoCkJpVfw6QUT5UDQOqfJh2iS4mHz2sxPOk3leZ+ZFxbtv3CLEG41bZ8=
X-Gm-Gg: AR+sD13D1CdqAvUYVWAZhMB4dthTey/nodkfdTmeg79/0faNKiEv/BOF0ENU8ubKcoB
	sUelFXyeBPX7Itdll/5WftKUUx8mnBf1FNCJscVaTBZOfXFmEyJjvTOYvQ6iQtq2F30TSx96U2g
	+Vnv0s+oCiosczoxSqYVaeoMhYaWNPO7+ngYOAebI8isgJ+4Lfmsh/f1vvSsPsTpbRtyl0UL/pu
	txQ9aUt0935aWODBq7Nam5xg1bSM8ujvKsD1RDgs78RGOvzpNS/kyfvs9CsUBuLrYL768Fb7fQu
	fs73Pc0lFVfkuLn9Vh00NA+K9A+xQBD677ioBYA51mzApMmHcmnCEHEvnWLyD1CqENv3fulkNsH
	Tke2JxImmaIu4pw==
X-Received: by 2002:a05:6102:4412:b0:785:a48a:e3b9 with SMTP id ada2fe7eead31-789fc1a33b9mr4214878137.4.1788280362089;
        Tue, 01 Sep 2026 09:32:42 -0700 (PDT)
X-Received: by 2002:a05:6102:4412:b0:785:a48a:e3b9 with SMTP id ada2fe7eead31-789fc1a33b9mr4214841137.4.1788280361600;
        Tue, 01 Sep 2026 09:32:41 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b91c510c9sm237352415e9.0.2026.09.01.09.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:32:40 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 01 Sep 2026 18:32:17 +0200
Subject: [PATCH nf-next 2/6] net: netfilter: nf_flow_table: set inner
 protocol when popping tunnel header
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-2-72e49be8c31f@oss.qualcomm.com>
References: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com>
In-Reply-To: <20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=beZbluPB c=1 sm=1 tr=0 ts=6a96fe2a cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=efGzO-dN_8w9Us9pE3AA:9 a=QEXdDO2ut3YA:10
 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfX44Ps0x/BP9Kt
 PalxA3LjcyJpuo+aE4hlouf05MSIG65PPKHIJaMod4eohV98WDdwI/h3yPAU3uP9cTQW/dml9SQ
 WtIQn4ij1gBR3+N7RYiNT1p1UT4QMM0Edv1YOjnE+mg8qHZ9wSSaCeKQflxkmZ0H9dDucyI+waf
 z/zAvk2foA9OZzpYk4aMHGYbNn/+DYllhgCaz6rrAeIV2Jr470gDJthDPacqkOqYNTVfg7i74JU
 bsK9M5PFf/huEg4LAqBSAiiGNZvfHMmzbdikqz7jETuOW/nTZODkCQoboVIWQHJnyzY8IAgXmqG
 86askCp6OukZ+O9j0TSYYOeUXKYov2USv5ivC+3uhN/m4N5TxLC06/v+PFe+nuTqpsDWCc58NS2
 /LS8pzTTyoGJR6zS9H9Bw3xGelptS+Ti3q6mTKf9yA42DpX13mEHmluhGg8ZE4tH0JlSg09Y8fr
 EYLq8PBxijyKEA3DjPQ==
X-Proofpoint-GUID: f2-0Ps2WCh44e-8j8QCap0XAuR2wqQ8X
X-Proofpoint-ORIG-GUID: f2-0Ps2WCh44e-8j8QCap0XAuR2wqQ8X
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDE0NiBTYWx0ZWRfXxVMlIC9qGXJB
 9wuB0jmPmc250fKjM1c2Z18jO4YydNWURT0pX3F6nPpE8KW1YaVKojGhr+3pEwYXTVX9ML1Zlvk
 ZUrUinmgXWJyMUNidOEmFfXZa/rXhfI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_04,2026-09-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010146

Pop the outer tunnel header and set skb->protocol to the inner protocol
derived from ctx->tun.inner_proto in nf_flow_ip_tunnel_pop(), instead of
bailing out unless the tunnel carries IP-in-IP or IPv6-in-IPv6.
While at it, key nf_flow_encap_pop() off ctx->tun.inner_proto rather than
skb->protocol to decide whether the tunnel header needs to be popped, as
the skb protocol may not be updated yet at that point.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/netfilter/nf_flow_table_ip.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 42e8de696474..8af3d98ef4b2 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -158,6 +158,12 @@ struct nf_flowtable_ctx {
 	} tun;
 };
 
+static bool nf_flow_is_tunnel_ip(struct nf_flowtable_ctx *ctx)
+{
+	return ctx->tun.inner_proto == IPPROTO_IPIP ||
+	       ctx->tun.inner_proto == IPPROTO_IPV6;
+}
+
 static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 				struct sk_buff *skb,
 				struct flow_offload_tuple *tuple)
@@ -366,12 +372,13 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
 				  struct sk_buff *skb)
 {
-	if (ctx->tun.inner_proto != IPPROTO_IPIP &&
-	    ctx->tun.inner_proto != IPPROTO_IPV6)
-		return;
-
 	skb_pull(skb, ctx->tun.hdr_size);
 	skb_reset_network_header(skb);
+
+	if (ctx->tun.inner_proto == IPPROTO_IPIP)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
 }
 
 static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
@@ -448,8 +455,7 @@ static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
 		}
 	}
 
-	if (skb->protocol == htons(ETH_P_IP) ||
-	    skb->protocol == htons(ETH_P_IPV6))
+	if (unlikely(nf_flow_is_tunnel_ip(ctx)))
 		nf_flow_ip_tunnel_pop(ctx, skb);
 }
 

-- 
2.55.0

