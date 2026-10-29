Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280952;
	b=EFxcD0c+gQviP73qoys6lPjcRNDt1XOgzUk6odhQvZLtS+OJK6I2eveH+I6LwNePdQ96
	 vfuZMR4WlkTvLekWFStJdpxOiF0AoaT4naQTKk8safztsf1mdQvVLf3tgozo6au8M8G/Z
	 Hc4B7nwW4ivI0WRdhZ/apemQKikSTEc626qdHxNyHee8I1mAmzSOMu9w6BfUweTOL5NuW
	 8VV+my1V7hKRLybRiFZL6yJHqsAUaQ+M0Z3CichViwj5W0idseMXX9qfXsU+4MNzGB27k
	 ZtcXCc3AtJGaTrfZaBIWVVLA0DNeP37rxdkGHcl+zWeQpJ0PsiOBVhpz4idbRsK/GKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280952;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=jD67U8cEb5mXQxJpLx9Pz6t73IEh++JQfI/KJ8zvOCs=;
	b=CVflesXUnt+vaj/MVQV3a70U/DAYMW1RvLTggUYYDiPRhARC9UVxwGWOr/BVhB9NHkEy
	 Sssxn0GVdNFjeKh74iQa4Wk+LyFr57AEn+zaRjUbBJJS4Lpu4lErkoleV75q0UnO/f+Zz
	 FVhJq1yLPbtjwyqoiRZTPRkgKs588jGbDjL4f4yPdy1CSWEnasfOOEzlfVwsj4g8JDuQd
	 oc2OwOcAB2JZDt+V7KRmM2wIdfFO0iI3m04pVBqoaZNbpTRjylQe6dwv1eAceonr3H2F8
	 wqgHREDEQWOCzKyy541Wouzh3CFOFf0kHsYHUG5bU97FXAdmS7iSslDVQAFaui/dsrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mFVkaWwL;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="IQLGu8/v";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8F3606A323
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F8F3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mFVkaWwL;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IQLGu8/v
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCe4x71147638
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jD67U8cEb5mXQxJpLx9Pz6t73IEh++JQfI/KJ8zvOCs=; b=mFVkaWwLiL9tELRw
	LG+bfS2gk19C9eMnCdl4vBcpyTLNT97W+oBQf7p/ebnSbTmHll9G478aaQPrwoQL
	HiSpE+CcAWfc4NNVwfTIA34BCjFkYaroewazRsIy+lt+7K/6B3um0fU8qmtOXYtc
	/+EhkiHQsg58e33z22Fjp3bvMexNZati6dNRgKN60ILfAF9uKLw9Qu6oa8NMOd7I
	UAORWdUoMvq29Ay3A2Hgf+lXydp8fKyEWejoAeXmYfA7q6rxMqIITQoDz7GE1fdh
	6VBrocmHDF+Y3vnVRh2yCSwKZ5UANDkkQ7TIJOUl/hqOLQIJAbbeaHCkn151pikB
	zaBAxw==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hm44q8phk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:51 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-7c0f07b4e97so944815137.0
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793280950; x=1793885750; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jD67U8cEb5mXQxJpLx9Pz6t73IEh++JQfI/KJ8zvOCs=;
        b=IQLGu8/vf+Lpnth8/MgAbGOjkurbxsfRTNauVEOaterfvOzsuxCCQhRaQ395bomtiX
         /GUGsp2M4V9Jwq8KFsK9KBaPVFIAtWEdnqCusUK3YkTdeGo5B2G0gTCWoHOWrB63VNmP
         712rO2QZGM4+grb5nG3PWk8nU50n3kZKapUWth1YCzoiEmHJw3IJUo7JWPc6oOz58H5V
         QIZHgQ3seR63oci/OzHQencQ/B7cCLAa+83O3dzIyUQlXnGzyfmevfwPEr7GBiDKLlUx
         TLTWj6zJcThofoJ81S+bQWiCjyXgR5epMqm4PId7LknSgbLZbicC4NeQMG/S28WkdmgA
         BhFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280950; x=1793885750;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jD67U8cEb5mXQxJpLx9Pz6t73IEh++JQfI/KJ8zvOCs=;
        b=y6WqmS0Eocgo6MzSLqPfV1HMZf6a3IijhYqCu2Ys4wE9JX1dLVtQVPh1ckkoyY37qL
         FBUy7OP3/A7oC5SoSrRUXY46FxGlnCAG4DVKM68k5NtbxZ9zW1ojLaPSkLYpQALohiTH
         Y3AVxrwpxiMx8GVOXWykkmPPVtRJupgqSWpaDbkUpD3bce+Kb7BETmJTYKM1KiXgAnZz
         tve6N6wx3Cm/S09mXLKIIpOrZ8lOnPCkX8t9Fc+9h9dNcep4RQWlHPld3+TXUeLraU6O
         4kWkz+onk7w2ELwj6oxyvP7SPw4RyDgwHgVtF88g33Q/gxabR1R5InGDpxkRFSD7R2HQ
         0t1Q==
X-Gm-Message-State: AFq9FYKeKOYPRpcHCpwLB1/ULfrHb9ZP0I1vPsjfh9vhL3xuhmJOIrxC
	e0JKlSULO79WLYhESwZo5OkMvBaOY85uWyJl/9+tFHaFFX076Y6i6ZGOVTCn5XyyX1AhaQFPy8I
	X1YFI1l1Lvb627bMJNLR+aHNE9FTOfXd4oh3PdW5m4iPC9mMJ8dhltKmXzsjtPLZhlSZ07uU=
X-Gm-Gg: AYBFou2KNw7R2nOnIFRrQh3Ou8mJO8j8Ua+AzWdyQFKbyzKiBOz737bQY5IiW48+cGy
	z4tRypizhWiW6mQOFHAVgOQZ6w4KE/UCuyiqEuAASYEh4zU7aLOKfSWftmdsAXHDnPOKuiUkVv/
	70wh2zTvcVZSdDEtUV+gTAPXihVUEYvzbJUOhWyrjRFWwdqvowdnuCJpyBdlfmF76wxMkF5r96U
	K3mLu6AM9rY1DRuSUpUbsZwrfqKfy/iJSDZJe09RQNXay0wkNsCaV0WO2CR+BFEUPIeM2yD3VFd
	sUGqh7QeRzgXguTFWo8Ibvpw7iF0d2iAc2MstLnpQznqGXpjyskvjUrh/m9G14agY+OMRPt9Wv3
	e/O4TktvtHrTFb7O7gRffXHCX0jGeszpONxVlrysIbbsmLff4Cpdh3d3cBNlu5ELLMA9+YEQ8T/
	vm1E15DcYYKpY5nY994L8+WA==
X-Received: by 2002:a67:e705:0:b0:7c7:f976:ea9c with SMTP id ada2fe7eead31-7d03a42b526mr2867135137.13.1793280950384;
        Thu, 29 Oct 2026 06:35:50 -0700 (PDT)
X-Received: by 2002:a67:e705:0:b0:7c7:f976:ea9c with SMTP id ada2fe7eead31-7d03a42b526mr2867120137.13.1793280949831;
        Thu, 29 Oct 2026 06:35:49 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3a1csm34898437f8f.16.2026.10.29.06.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:35:48 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 14:35:18 +0100
Subject: [PATCH nf-next 7/8] net: netfilter: add SIT tunnel flowtable
 acceleration
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
Message-Id: <20261029-flowtable-sw-accel-ip6ip-sit-v1-7-6a17c54f9fb7@oss.qualcomm.com>
References: <20261029-flowtable-sw-accel-ip6ip-sit-v1-0-6a17c54f9fb7@oss.qualcomm.com>
In-Reply-To: <20261029-flowtable-sw-accel-ip6ip-sit-v1-0-6a17c54f9fb7@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX8V1scycH7blA
 3zqxaKN6GfEBkHwr/OUpp/KAHtTNTRap1zZXRPk2dMO88DddZTmyQeov3FR3+AEUzScSyQizlN0
 rLIKBzBtFOm1vw4H5T8m7id+nC1gEY4=
X-Proofpoint-ORIG-GUID: QBNGQJKwUw5jNGz70WkrauJ6R3kIFn9z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX1awoP9+arZA4
 6QJ2jwgEK0NwL1G53W2/mXZSqr1CJLDu06RVlU2rmXstJVhwzIvG+wmAXtSd/5/BxIuKOnsx1SA
 HdFCfU0Ln/o/Xnp6RdwAFcDfZMkysfrvGX+xuwRupWHhna2C3OEAbfiIpRc0FzCRK9W0xU/b4IN
 q8MkQMWIpzYyzDBXkCcF1DyOydRRHmT1ZOtLp8lLCnYAXhJkd8/vDFj+CminXtYnpCvSS3GuAlU
 9FcP5ZUB3tAgilLlNA0zbuHLPK2Pw1RLJH/p42/ragp6kFr/WHpsEjaVAjg7OYqpzt/Ijl/IZ7C
 v9tcR8czyYOWmna+6ZnF5QJbG38TvX4kq6oTXpc8Z2gSAuPCssrShz2Mhch292SkYWgIhzv7qbC
 pAa92/jdLzW/TvvliD61H4Mq5vtUqBQ2VzR/tCfUTaxITFS6sH58xLpCmM4tbXA/0KVeqH04mKH
 b+6ACbTmkkAMOhumkMw==
X-Authority-Analysis: v=2.4 cv=CYmdd7rl c=1 sm=1 tr=0 ts=6ae34bb7 cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=tw0Pf_tC_1SJ3CTrDgQA:9 a=QEXdDO2ut3YA:10
 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-GUID: QBNGQJKwUw5jNGz70WkrauJ6R3kIFn9z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290053

Introduce sw flowtable acceleration for the TX/RX paths of
SIT tunnels, relying on the netfilter flowtable infrastructure.
The feature can be tested with a forwarding scenario between two
NICs (eth0 and eth1), where a SIT tunnel is used to reach a remote
site via eth1 as the underlay device:

    ETH0 -- TUN0 <==> ETH1 -- [IP network] -- TUN1 (192.168.2.2)

[IP configuration]

6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:00:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet6 2001:db8:1::2/64 scope global nodad
       valid_lft forever preferred_lft forever
7: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:11:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.1/24 scope global eth1
       valid_lft forever preferred_lft forever
8: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000
    link/sit 192.168.2.1 peer 192.168.2.2
    inet6 2001:db8:200::1/64 scope global nodad
       valid_lft forever preferred_lft forever

$ ip route show
192.168.2.0/24 dev eth1 proto kernel scope link src 192.168.2.1

$ ip -6 route show
2001:db8:1::/64 dev eth0 proto kernel metric 256 pref medium
2001:db8:200::/64 dev tun0 proto kernel metric 256 pref medium
default via 2001:db8:200::2 dev tun0 metric 1024 pref medium

$ nft list ruleset
table inet filter {
    flowtable ft {
        hook ingress priority filter
        devices = { eth0, eth1 }
    }

    chain forward {
        type filter hook forward priority filter; policy accept;
        meta l4proto { tcp, udp } flow add @ft
    }
}

When reproducing this scenario using veth interfaces, the following
results were observed:

- TCP stream received from SIT tunnel:
  - net-next (baseline):                ~118 Gbps
  - net-next + SIT flowtable support: ~148 Gbps

- TCP stream transmitted to SIT tunnel:
  - net-next (baseline):                ~131 Gbps
  - net-next + SIT flowtable support: ~147 Gbps

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 net/ipv6/sit.c                   | 59 ++++++++++++++++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c | 22 +++++++++++++--
 2 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index a7ec800216ad..ed66358ab644 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -29,6 +29,7 @@
 #include <linux/icmp.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/inetdevice.h>
 #include <linux/init.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/if_ether.h>
@@ -1483,6 +1484,63 @@ ipip6_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm_kern *p,
 	}
 }
 
+static int ipip6_tunnel_fill_forward_path(struct net_device_path_ctx *ctx,
+					  struct net_device_path *path)
+{
+	struct ip_tunnel *tunnel = netdev_priv(ctx->dev);
+	const struct iphdr *tiph = &tunnel->parms.iph;
+	struct rtable *rt;
+
+	/* NBMA tunnels (ISATAP, 6to4, 6rd) resolve the outer destination
+	 * per-packet from the inner IPv6 address; not offloadable.
+	 */
+	if (ctx->dev->priv_flags & IFF_ISATAP)
+		return -EOPNOTSUPP;
+
+	if (!tiph->daddr)
+		return -EOPNOTSUPP;
+
+	/* FOU/GUE encapsulation is handled in the slow path by
+	 * ip_tunnel_encap(); the fast path only pushes a plain
+	 * IPv4 header and would skip the UDP encapsulation.
+	 */
+	if (tunnel->encap.type != TUNNEL_ENCAP_NONE)
+		return -EOPNOTSUPP;
+
+	rt = ip_route_output(dev_net(ctx->dev), tiph->daddr, tiph->saddr,
+			     inet_dsfield_to_dscp(tiph->tos),
+			     tunnel->parms.link, RT_SCOPE_UNIVERSE);
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
+
+	path->type = DEV_PATH_TUN;
+	if (tiph->saddr)
+		path->tun.src_v4.s_addr = tiph->saddr;
+	else
+		path->tun.src_v4.s_addr = inet_select_addr(rt->dst.dev,
+							   tiph->daddr,
+							   RT_SCOPE_UNIVERSE);
+	path->tun.dst_v4.s_addr = tiph->daddr;
+	path->tun.encap_proto = AF_INET;
+	path->dev = ctx->dev;
+	path->tun.dst = &rt->dst;
+
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
+	ctx->dev = rt->dst.dev;
+
+	return 0;
+}
+
 static int
 ipip6_tunnel_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			    void __user *data, int cmd)
@@ -1533,6 +1591,7 @@ static const struct net_device_ops ipip6_netdev_ops = {
 	.ndo_siocdevprivate = ipip6_tunnel_siocdevprivate,
 	.ndo_get_iflink = ipip6_get_iflink,
 	.ndo_tunnel_ctl = ipip6_tunnel_ctl,
+	.ndo_fill_forward_path = ipip6_tunnel_fill_forward_path,
 };
 
 static void ipip6_dev_free(struct net_device *dev)
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 0ffa6470c46d..876e3e87ef87 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -158,6 +158,16 @@ struct nf_flowtable_ctx {
 	} tun;
 };
 
+static int nf_flow_tuple_ipv6(struct nf_flowtable_ctx *ctx,
+			      struct sk_buff *skb,
+			      struct flow_offload_tuple *tuple);
+
+static int
+nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
+			     struct nf_flowtable *flow_table,
+			     struct flow_offload_tuple_rhash *tuplehash,
+			     struct sk_buff *skb);
+
 static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 				struct sk_buff *skb,
 				struct flow_offload_tuple *tuple)
@@ -466,8 +476,12 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
+	if (ctx->tun.inner_proto == IPPROTO_IPV6) {
+		if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
+			return NULL;
+	} else if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0) {
 		return NULL;
+	}
 
 	return flow_offload_lookup(flow_table, &tuple);
 }
@@ -959,7 +973,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (!tuplehash)
 		return NF_ACCEPT;
 
-	ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
+	if (ctx.tun.inner_proto == IPPROTO_IPV6)
+		ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash,
+						   skb);
+	else
+		ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
 	if (ret < 0)
 		return NF_DROP;
 	else if (ret == 0)

-- 
2.56.0

