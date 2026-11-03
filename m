Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714498;
	b=3kqwMm6KfiTx3GjA/m7W7ScD4Zt8MqyP6kmtHTBK2TGWRa4qvJ+wo1jTQzf4P0QYOEP8
	 XHiudRyoQCiCo3iG/zxMgSXoZbnUFkjpjwtFQl1mGQZ9HluQQORf0inpo9wE4C7awV50d
	 2c3bTjO6ocDhGGOszpMEl7qQsyXDB+OhJEdbJfYcQzx/M+6RU4JcWkaBtEyJc3dySDMtt
	 z++uYpo0myiVagcHJHl9MI0S3sbguHNbryorHompwxJXezJz+rgbd2du9wtiR9AocKtsd
	 fXy8MMcUvRKqy5I6zVW/1rI5AHh0RQbZdhNd8fOpdyYlsqaNtpuVt7c8Hh7ss/wRd0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714498;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=+v1lyr0F+NYxmmWfY7nRdeG/btbkNPCYzNKZ7ztJWmk=;
	b=Qcf8H38ZbuVxhMflnEcws2Ur7syk/iyGrlPRr6/zgE88LAjWSuL5yPzWnVPXwvswyyrX
	 e6iIQyDSyDgLm+mD6EeLsAlSTwbk4NWW5WAzexBnGuddW3dcyfRE31g0SSpBJP59FgFtD
	 9qNzpk6s4p6wls8N3o6plc7qC8mAtT0ElJdbdFctccedEUjjLOFvLOEe9ZbDqmyx5il9Y
	 0ncvd8zCYVLvBFNUtpYfHrAcK9rFasKkm2mKjAXCzze4KP7qg7nxYZjT/ywvg0ap1xyQN
	 O1amiG6SpyCEuwnkFFsLxYC9ahtwNRt4NCELhKo9d0FxLZBwIVeap1ge2OU2XYqWpZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JKLbGSvX;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KIwnR0RN;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0002C606EE9B
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 14:01:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0002C606EE9B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JKLbGSvX;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KIwnR0RN
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3DZCQE3612399
	for <netfilter-devel@vger.kernel.org>; Tue, 3 Nov 2026 14:01:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+v1lyr0F+NYxmmWfY7nRdeG/btbkNPCYzNKZ7ztJWmk=; b=JKLbGSvXuh48q1AH
	hpJqirVnyJ7WB7cuxGoyNyKvbx53Semif+UU4uwxR60xOWYsPoZNJBR+3ZGFhINE
	VxScuoc0cyUJWVJCIYz7lM4RcGJYeE61q/JQvt04EBHZKIVVZtc/GOOdD1IpIT+Q
	Ke+5TUD8w5F913YrU2kETnR9BfKVXLMODrgG74SZiQ3xySovWZw+oOMWtH6p5Nv7
	5j90OBPUeC8OKfCNOVxNdZ6QcfHlgeKI3B4zscxFJI05j4P/4uwno+FumydsffP9
	pQpfiv3Mig2pehcOhJYg7P57v49lnQ0W6uKLTYw+B6ypOP3fOlKkvY+hoD6zncHs
	R1DXtQ==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq6m9ajuj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:01:36 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5eac41ff334so4432723e0c.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 06:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793714496; x=1794319296; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+v1lyr0F+NYxmmWfY7nRdeG/btbkNPCYzNKZ7ztJWmk=;
        b=KIwnR0RNLWqyWyADMe6RuD+hfm+0K4ZuURSh0A1kQkT1lMJIVNdL55v3qyuVnOfi2a
         0/4zZWZAeOoredqRrHwAY2SqWvcTPjOJTz8uZml4pm5ZDnsoYmxPufrsEDTcAnfUs9Iu
         QAkoUVpXamV4DVp2IcpkPAehjmOIPIyxT6yEaO3QlCB7ojNVcbMXtc/N7+rrWeZYLb5a
         rv50C/lClS2vwc2cKHsTxkssQY9bneRZciRgao5fmsFkb882c3HuWUYHqjTZfz3l9zDs
         zyqFPf72KSo3T6XPMHsg6VpbNL8WNFCSRgGu80pRElmmxCvuvE6mfLHyKELMxsnn7qdc
         qlKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714496; x=1794319296;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+v1lyr0F+NYxmmWfY7nRdeG/btbkNPCYzNKZ7ztJWmk=;
        b=n9D34O8Pp/VTjSX+KSkr6LoNH2Qv8HeF9gUz+t95tgZ4NoSVFGWFq3O0GA2c9vpPEA
         bEdkY2GkyLQ0/hDeT+SdOLmDQrgqJM6zFHlF7WqlryEZYJbQl3YELooQnDmly6tnINxF
         GxGznBMrOHKfNWRmyOEXUHBIvx4CZZRBu3ygQorvRxlg4IDj8oU9d9YaXQwZAy2ZfqGV
         Kiqd449zZfmWTrnMa4rbBjHVRWEZr/NVivx9+3RP3PCjrs6ZsxgPDYCoVrUUNI+PZWA7
         eus6S8nF+HaD7Qrpe9WGj2I4dbsh+w68+A0mW/jdUGfIXrRMhZftlWihHpm1BsT/QQT1
         5pVw==
X-Gm-Message-State: APuU4Z9YjGJeoURCI+KEX7R96J24/1SCIqwkaIGfu6/e16Hb66R4K6bM
	lRaJDaylOkmrGKLPiNBkGH0jWI7AosKLdygoKcXJ7AjIgc7vCo2m6wL0w5mDM/2ZjliZfTKgnc3
	Bm3+/3QVDJJrxpUqkC1rioJJNf5DvbrwaPlqVEP4pn4mFTDysaHlJBMo+6+oOf1WSbFDe3A8=
X-Gm-Gg: AYBFou3LacJRnlNLRsowHlcZI7yTgteQkbYMeIbn6v6AT/KFzTBEiZX4sf//RI4pGJy
	+L2A2m77qWGDfKEcjXCwJhmcp858VExZyHc4XRzoKL1gDTtoVVwnXI1bieI6Rc8Nu1UaekRv1r4
	kRcrrjXSgtRQWYrQCXF/uffFQ6fmoxyaOaO9MjmjQ7dorcHQcJ/1gbzRQCG3GbP3XnQivYvtdzw
	eo3O3W3u7LqumbGgibXr0psagIgcRji7u98lnJpRYOv4ELiJ2obK6E/LzRtuodKt1TpwNcLBW6R
	oNnj8icSmL5/hQHlzjNAQ/MhWVp7GvNsPdgzxwNtCSwTuYcRga/nE0cTh5Qxx1iTDid+hKl24mw
	pSF4zBiOQmmDDDOrMKemuny1WbD06NFg0A+nABWRiJ04Srms5iVkiQs6Uiw0HyeQ=
X-Received: by 2002:a05:6122:469b:b0:5ea:b972:1403 with SMTP id 71dfb90a1353d-5ec68539420mr5364019e0c.3.1793714493364;
        Tue, 03 Nov 2026 06:01:33 -0800 (PST)
X-Received: by 2002:a05:6122:469b:b0:5ea:b972:1403 with SMTP id 71dfb90a1353d-5ec68539420mr5363558e0c.3.1793714491115;
        Tue, 03 Nov 2026 06:01:31 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abe7700c3bsm305140525e9.0.2026.11.03.06.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:01:29 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 15:00:48 +0100
Subject: [PATCH nf-next v3 7/8] net: netfilter: add SIT tunnel flowtable
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
Message-Id: <20261103-flowtable-sw-accel-ip6ip-sit-v3-7-60b5f063f1df@oss.qualcomm.com>
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
X-Proofpoint-GUID: Nyc4E_RZT2HRPRirJapf6F7UtM8Oh4AR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX4MQxS7y0maFJ
 hJOu5kU/c4HtJCisO/MG5mJWaYFza1QYXclPB4QWOmEcleL8tEmsujZh4Oa2mxIgZF2kQWMih/6
 hQ33UpGI+H9oag8c+qs+p607gtTRry8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX3o2Az5afj+BH
 E6l1DE9/xfkM9ufhic+0Ee5ixp64bD2stHQDa6jTyJSM3rnJKY+gxlAOADDRvvRmfVGbTxgUQRD
 HikDRVOhPHhzfbYHnos/4c905/27EEP9ce8v5ckXgqZgiBktmfBiINNGnKwhIxTcNsXkZVdOS1p
 H1qU1XpPHbgxxrsgrroAeIGJixBTxfUNT79SAAWNLCesKrklOfxFn6XW7kdbrT1mU4W6xlL6t4t
 1I7mP/dDU5vQS5IULnqIOsu7OIcr3sqVRit1olKlNOF7A3Wzmo4+UkOhm9sI42qS/cSxvrOyYhM
 9RfSdXPuBVhcR66bZCOGXaz8k0wve7GBVAnUJCqqzkJtMXz8ho9O/V9j97v0Av6zJtNT+ccjcYy
 N+CDf/0BWLzqV9JhsYyaEyOthLj4Dia46NRqFFU0VPiC9Sxcqa9ri5xEeRtNJmsqqxSmqA8NtTm
 sTVBC0ov+0UH2FC1/SA==
X-Authority-Analysis: v=2.4 cv=C7B8WgP+ c=1 sm=1 tr=0 ts=6ae9e940 cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=zZ2q_vh7tRSsUQjCfn8A:9 a=QEXdDO2ut3YA:10
 a=tNoRWFLymzeba-QzToBc:22
X-Proofpoint-ORIG-GUID: Nyc4E_RZT2HRPRirJapf6F7UtM8Oh4AR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030055

Introduce sw flowtable acceleration for the TX/RX paths of
SIT tunnels, relying on the netfilter flowtable infrastructure.

Only plain SIT tunnels are offloaded: NBMA tunnels (ISATAP, 6to4, 6rd),
FOU/GUE encapsulation, inherited TOS, and packets whose inner protocol
does not match the configured SIT mode are rejected.  Tunnel parameters
are read from the RCU-protected snapshot and the outer route is resolved
in the tunnel netns using its fwmark, mirroring the slow path.

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
 net/ipv6/sit.c                   | 72 ++++++++++++++++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c | 22 ++++++++++--
 2 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index a7ec800216ad..9e6ef3b72cfc 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1483,6 +1483,77 @@ ipip6_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm_kern *p,
 	}
 }
 
+static int ipip6_tunnel_fill_forward_path(struct net_device_path_ctx *ctx,
+					  struct net_device_path *path)
+{
+	struct ip_tunnel *tunnel = netdev_priv(ctx->dev);
+	const struct ip_tunnel_parm_kern *parms;
+	const struct iphdr *tiph;
+	struct flowi4 fl4;
+	struct rtable *rt;
+
+	/* NBMA tunnels (ISATAP, 6to4, 6rd) resolve the outer destination
+	 * per-packet from the inner IPv6 address; not offloadable.
+	 */
+	if (ctx->dev->priv_flags & IFF_ISATAP)
+		return -EOPNOTSUPP;
+
+	parms = rcu_dereference(tunnel->sit_parms);
+	tiph = &parms->iph;
+	if (!tiph->daddr)
+		return -EOPNOTSUPP;
+
+	if (tiph->tos & 0x1)
+		return -EOPNOTSUPP;
+
+	/* FOU/GUE encapsulation is handled in the slow path by
+	 * ip_tunnel_encap(); the fast path only pushes a plain
+	 * IPv4 header and would skip the UDP encapsulation.
+	 */
+	if (READ_ONCE(tunnel->encap.type) != TUNNEL_ENCAP_NONE)
+		return -EOPNOTSUPP;
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
+	if (parms->iph.protocol &&
+	    parms->iph.protocol != path->tun.inner_proto)
+		return -EOPNOTSUPP;
+
+	flowi4_init_output(&fl4, parms->link, READ_ONCE(tunnel->fwmark),
+			   tiph->tos & INET_DSCP_MASK, RT_SCOPE_UNIVERSE,
+			   path->tun.inner_proto, 0, tiph->daddr,
+			   tiph->saddr, 0, 0,
+			   sock_net_uid(tunnel->net, NULL));
+	rt = ip_route_output_key(tunnel->net, &fl4);
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
+
+	if (dst_xfrm(&rt->dst)) {
+		ip_rt_put(rt);
+		return -EOPNOTSUPP;
+	}
+
+	path->type = DEV_PATH_TUN;
+	path->tun.src_v4.s_addr = fl4.saddr;
+	path->tun.dst_v4.s_addr = tiph->daddr;
+	path->tun.encap_proto = AF_INET;
+	path->dev = ctx->dev;
+	path->tun.dst = &rt->dst;
+
+	ctx->dev = rt->dst.dev;
+
+	return 0;
+}
+
 static int
 ipip6_tunnel_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			    void __user *data, int cmd)
@@ -1533,6 +1604,7 @@ static const struct net_device_ops ipip6_netdev_ops = {
 	.ndo_siocdevprivate = ipip6_tunnel_siocdevprivate,
 	.ndo_get_iflink = ipip6_get_iflink,
 	.ndo_tunnel_ctl = ipip6_tunnel_ctl,
+	.ndo_fill_forward_path = ipip6_tunnel_fill_forward_path,
 };
 
 static void ipip6_dev_free(struct net_device *dev)
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index ea2cd9df33f8..3a7c5318ed15 100644
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
@@ -969,7 +983,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
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

