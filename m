Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793559755;
	b=pXBz2EuXZpGvtaAMnxFinoOZD5MSJn3RgVTTZ4w3smPS/o5VABy2Tcw/kgiNPQDpSu0h
	 f8qkw1jddPGxlWbjBxC5unqzz/qzu1NLs9o0ifVWry7EqMuw/k0lDG1dlcFGGVaKDfssU
	 tK8Fa9UqvRQZQf41bzrGzEjvWwdn9JxPhG8sIC+gfJVfkmUDPuYszOacCPht72dPeX6Ok
	 221qkwx+ZsTZhH8Stl8j0dJkBGdYZoo9Enj9dpVbcBrulStZitIw8N/WWDVFypex9WQXs
	 QrVEuCilmKh/8tcjW/ykeO+b0Yiteavcp7wcDZJdjYHC4a948XcQhKU/VpDengkU3dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793559755;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VW9jX6l+k1XMF/axnPBeu/GQCOS1nkisIl1Hl7Ayquw=;
	b=vElsdsbg9R0G3lF5tseOjaYyCyBa0XUB+JF8DCl4E3o4NIQDuMKQagMDD0p7wDyXewhP
	 6l2ZCwE95McaV2FYmj8UHCHXoL+nS91e3xEiTKQUQQxaWdeuOP3+Kco5ZXOfMYW2v5z31
	 RoEW5N1didl8IfyQlmQMigiMvL5EIoJBsiQYrUeE/0B7mqGrT4crL+8sT8OsiGSyMSdh7
	 krEB0WsUUE/JXvMUADk6Gc8LAuAbMb1njsn4Fiou7yBuhj9nQ+BWxE+KGWD1Y9qT9Yead
	 ws5oBIZggTGdqOlXFMY9q8S+dIvLR/Ka5CQNgGDbIbpKP2tYjx72IQp2pcpm0de2xbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ArAbnkif;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SLGy0hPv;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8E9606A325
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 19:02:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD8E9606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ArAbnkif;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SLGy0hPv
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1HQLxg2044166
	for <netfilter-devel@vger.kernel.org>; Sun, 1 Nov 2026 19:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VW9jX6l+k1XMF/axnPBeu/GQCOS1nkisIl1Hl7Ayquw=; b=ArAbnkifugLyqxe3
	gTXRdXo/f1ibUQJPUwBSEn2jSQH0VcL4BpGIFuacevUoFZ+TcHeCt+wRN7T4xvZK
	ICUxmAmwyChksipJSFGv8lPv4O1MWOppwiFUB5ejghRqrDfY0Sr7SsWf1mlBKx7w
	o2lEpnbKnxVxkQCwm92264kRA1bB5F9CjYAi1XK2YudXR0Ecqj6YTAm1KPIsCskW
	u5XaP+7NhtVPafyp/Q7BWcgHg0o73vxeYl6K9HPJlzkFicR2W8adb70Szxzs67dT
	KAk60gNWLDhn9LNAD9ENcJcqS/iwtdjb7J4JSqb4GbD/GHclH7eTgQr/4R76XX0C
	nlZmmA==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn7wxm19d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 19:02:33 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5ec62c05c25so2828223e0c.1
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 11:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793559753; x=1794164553; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VW9jX6l+k1XMF/axnPBeu/GQCOS1nkisIl1Hl7Ayquw=;
        b=SLGy0hPvo1GDPi4S1MOp2n7Q0bsLEwkS5Qtz6e3Hzgxz4OIzaasrVc7zI1mRz7YHlJ
         ns0G7OydZCrHP6N5zzLpmMPShGroxtrNqzr1KZ5Ue4F8kNTgzQCiKGX59vHJMjc1kqza
         wFMDndHF3yyMwl3nJB+iks84CnkzFUd2e2cYm3URw0G7SWniuI8gV4bi+rNqBult+dZG
         VJCQLVh1Alo7nBmdJK72x3HrL3HBPGWAechQUdczt/Lj/kQ5YvrnJnkHQttvViqFxN1l
         a6aQpOVBqFYaoUr+qpu3T1hfK6ep5FKogiuAHW86qYM/B1uAWGnPWtKW1XuwtgFTnZQ4
         jSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793559753; x=1794164553;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VW9jX6l+k1XMF/axnPBeu/GQCOS1nkisIl1Hl7Ayquw=;
        b=QLrGodkiKO1ZyXdDNNxQdfyg5rLS7EOtrl3iWGXK/zCfQA4EfZxN2EWooyZDSRqboA
         Eqor1+eBXpnhb26tsyBUn1J21XOBlMNeAqAG0Lo48lTGqok53aqFrgkFaQwoHmT44est
         oGFna8k5lsYerzjZoi/pu0NJCuLK5g2g/24mOhKX64QNvQhsz09VYrOzxXzOK1Wvnqir
         xEGXj8WmZXU0Qu1gF3j96cTYMkcOgA23THcDfSdjSCnfyOoDOkbhAV1DG7pu90O6Hj2z
         Nr7W/8q5o+6bknIxWf+VtT9VtltWch2r+zwOUZWKW9ycbI/UwzvBg8Ac1eFlyiba/8b+
         oSWg==
X-Gm-Message-State: APuU4Z8uXdk+d5nxUftTeFhvdrX1tJlnWYbFp7txxDYzWLKGbt1fnU+J
	xS+QangZsd+wcaXs7zTYiLC3NRcg176NZWTGq2wsKw65phuqxSuqc7OL3bKFVkjuNQEh5QDG9qS
	S/R8FdgPFCWNTVF+zAgokKbqGQTp2oNyluaBX1FLmSZQFsUxaGDve6YJav3edUPk/VKloYSU=
X-Gm-Gg: AYBFou3sJm9jD3xGsyCuqHB4ZWXa8nZ4BG9HAbDGSF13qjUhGIIf01Ex8zGJqAlvkb0
	gFQ3EzFhlU9tajtMLZSXYWKxQb7aBKCz/PxJrwl+vZg6KUQWIMCYukUETMX1iwVDbZVvbt6gbfK
	l7E7QoUy4QUkQpUqDoXxoxR29VSDAVKlOEl3xMEyB2Rt3Wp8Xx9t/xouvaTPfxzo5ZHba3Sg9XH
	txPUL5x7119HbXdIPqNX0Q9c3J1wfF2LGJSOxhRHowe6Vqpel1mnC14IZFBG/fOyiKY1/P8/Aeb
	iWSTQUhYnZGgekKJJX1p67/U3UJihGT0PFZcHiirgUtuXGYt2cq6j3QspLPEK7C1cziCN70TfaN
	srHNdWYi6A9X27kXLFOLqAA0ELR7Edykj19DNVobf+DNMb3kqDgWGflkzLv4u5RQ=
X-Received: by 2002:a05:6102:5128:b0:7cb:6954:109a with SMTP id ada2fe7eead31-7d054180f14mr3593366137.12.1793559752708;
        Sun, 01 Nov 2026 11:02:32 -0800 (PST)
X-Received: by 2002:a05:6102:5128:b0:7cb:6954:109a with SMTP id ada2fe7eead31-7d054180f14mr3593361137.12.1793559752159;
        Sun, 01 Nov 2026 11:02:32 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d3cesm17462072f8f.7.2026.11.01.11.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 11:02:30 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Sun, 01 Nov 2026 20:02:01 +0100
Subject: [PATCH nf-next v2 7/8] net: netfilter: add SIT tunnel flowtable
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
Message-Id: <20261101-flowtable-sw-accel-ip6ip-sit-v2-7-c6c282cab5cb@oss.qualcomm.com>
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
X-Proofpoint-GUID: j4mhOEd7NdD5ny1bBMYijD7IRcrxQqHM
X-Proofpoint-ORIG-GUID: j4mhOEd7NdD5ny1bBMYijD7IRcrxQqHM
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX6OjJZAoOQpka
 4Tk8DWAdKUrnd53O5gtD+3p5ekM+fU4RwxYX3+EkpIggqER23HBUmXWRJv0ZrZISVTM/ZRPAjfR
 H5VwgdyJu+tumjqq6nfoMtCR1IqbJzk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX+zzXmUHBZ6lU
 3ZNjqbAq7LrzLSmzv9a8CwRFU6No4w55WTgfAhWCYOBWoJrw+FwUQewnfUfjBdbxMG782NPDGmo
 4LNI8tA9MtQa/lD9rbBUC28FQ/HhNk64mEepKMUq7Qm9yqcOso/C1qMZOmt2HSgJOaM6revnmfK
 G+I+PKQ0iIwht5+DvMEyTQWyt39nyy6wqhM++MqN7LBI4BmH/SiF1lQ+HqMjP3+qQHGFVmLNB2+
 +u/vjFDqZweTmpBWYTtFh6MiZyec6q7gDB87LoTwSrU4oDx6T945LV6+UEiNTgdOsLTzquEdAlm
 tqxg81VXVgbNjE12ksDFdCEtQWdKvX/HsWQm+fMbcm6Bh11NWadxRk7TVBejdaao9h4YaH6/80T
 JDFDZIKfKvZIVdK+nVkFh2RSkqHNq09ODb4DgokN0t2ATxFykYHikrxD04BklTMs2mQDoeZ0ofF
 4IPhw7wsZpb/hFBrVMg==
X-Authority-Analysis: v=2.4 cv=JLquIMKb c=1 sm=1 tr=0 ts=6ae78cc9 cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=Azys4kmTdsnWQ9nIUdYA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-01_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010075

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
index a7ec800216ad..851dfd37b518 100644
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
@@ -1483,6 +1484,76 @@ ipip6_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm_kern *p,
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
+			   0, 0, tiph->daddr, tiph->saddr, 0, 0,
+			   sock_net_uid(tunnel->net, NULL));
+	rt = ip_route_output_key(tunnel->net, &fl4);
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
index 2bdebd3ff5f9..7393ee782ce0 100644
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

