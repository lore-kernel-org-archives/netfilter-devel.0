Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969D91DEFEC;
	Tue,  8 Apr 2025 14:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122289; cv=none; b=cDxRbLY76rDt6J+ipCZsQpcfQRUhM+dASIsgIMduH3N3Qz/0hXNzoucB4K3e6qwEW00ZA5mG1a9a4gmRw1qFGNv+ldQ3fNvTZ+G7kK75buou3MnUriMSomOKgLch5CTwlTpMja8dKxvxWAvvKD0emuLmbspXprBW8+6LAIpV7H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122289; c=relaxed/simple;
	bh=s07lOvRRAPD0wI1vkmhchP9Nu+tAcdm2Zk2Iuqf7qiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSKW3wraRYYaPxxYUHkm7XJyNyWQQno0f3OZ7HsDeVbzMFg5G9rzP6ks9P5I7YpRRQzC1629SImMRWlp/rhrEb7QmGgVdGkPibKrS7/qtuupeAVFyQTVa2L/Dlooy5ValvH1QYnqhwpIiZL+GvKdcnR2MPKKB3gRywvU2eaIjbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UcA/bKJc; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UcA/bKJc"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac298c8fa50so942316166b.1;
        Tue, 08 Apr 2025 07:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122286; x=1744727086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5pMHD9uStoCnBNTWXkJU60EfIV+//1NnZwDwW7uTTNc=;
        b=UcA/bKJcYnAQ9JOPvykl2Fh6amOfVXpImqXMVO8mxLn2X4q9WapDiMXJfAXjrw0t97
         CCdqYKOURN1Z5vQw8/JOTuJVtxvqTkTxS4nRATgon/HDuj75hLyhJFMeTvReTfavShLz
         YECjO8U1yVcRm1IWiwwpiGjKgv2Jef56mH8nk2az2xJGFDMv65P1JaG8cJJg0OsvLzTA
         oXZ1PRz+u2/NJeuwRnDlbPq2vgBRx3z1IWuG+Xe7C0lH4X+ipi/elYch2YXD587YPtJl
         M4/Xail+wjQArP/x34zBIO7i7Fy/+vwLjYt+1SbdC+clhGFvgiapZdsFCAtllvcLs4R9
         Pylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122286; x=1744727086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5pMHD9uStoCnBNTWXkJU60EfIV+//1NnZwDwW7uTTNc=;
        b=GaSOasl/RHQf3RWUYh9ULh9ci0uK0xODlWTxc4dteDcsnWrKoPEbIwD44fHJhj/p6o
         3liwXg5twHGOMiu1YIfe3xL0L7RHPX13yzkcIxjJMgYDQP43tX998UjeKBqdDKTfPbeT
         IjvlTYt8c6N/0zfvAVVbKKc0ESrztVGngMx1fj/yMMRLeYFPs4VnDnK/1lMOiXUVRe/f
         novlckElzRPQ7GgpcRL1zfCKOQ4qXwjbV+GkcJtE1J5OdzLRheMgZUUT8kmMKQRwtfwn
         LGTHeggd1+n3DZ/cN9SZMBPwdaxokfwmObYYbgLPUMFRKuJ6N2fTdcMA5R25T/sM8y/X
         5CfA==
X-Forwarded-Encrypted: i=1; AJvYcCUcSI/GVGtRr9fXA27Q0E0OwywkWDJ3kZDxCjOHkI890OAZLFWjoP46cD7dS3O9wMIM4AA93Xh6JuIA2b8vHw0=@vger.kernel.org, AJvYcCXlQdvMH/ARwoJReIwIRx9LBcND7XJsrAi3odq4+JjysZo9tUcpGyog8ZymU1f9b8r9Twqihl2Vk3R2Wkrhd6pD@vger.kernel.org
X-Gm-Message-State: AOJu0YwzyW31/cRhmWF/KqLsxP81CEKoJ3qa+YOJDrRkrPDhRRLlds0p
	X617cue/35YDNYaZAe9op4QVVEhviJaXnFdCtEWqQvvwDkMlprPT
X-Gm-Gg: ASbGncteJqp92KJIsEY/VMlPg3Wp2Y/ia4pySBK88kCK/6hKtjjFolaJvCbwg7MaLv6
	avG7rQ7+vkS1HDcvh2gymRsTGK2unFix3Bd/IvvvhGR4dOrSjyO9DiC5jKZF+RQWGs9pvkUJER5
	euCkY7yAufcBa2SQrNHuK5u7ZhzhzQ52zav2RyqsHf9K3UGabj1s3JmKSLrNqcsgPlTsHbmPLxs
	8Rlnu50/8KddYhk21kSMY6Dzcv440c7OnOz1AT5jMRVzNAyh+Huzgh23nUHZqsn/GxgPTpinkBJ
	IGMwmXrbAh5AbMk8630NUeY6AOOXx1xO6Qeg+fjQfKOSdUiAdvACGwb7XtgkqQDp5rjJk41YrKv
	SlnsGy1jie0yy1pBw6BGOgpOZZvvlSSo/pPoq97SWKbmIj64dzbDFIb97ZkDMta8=
X-Google-Smtp-Source: AGHT+IFJwM4RhEM4zcvwoVIqOYkxkQp82p5BtTgoplhrdnBIF6v/fTW84vH7V+rIW/OEO3yCncwqLg==
X-Received: by 2002:a17:907:3f8d:b0:ac6:fc40:c996 with SMTP id a640c23a62f3a-ac7d17b6e01mr1596364766b.23.1744122285573;
        Tue, 08 Apr 2025 07:24:45 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c1db6ea1sm928770066b.143.2025.04.08.07.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:24:45 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 2/2] netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit direct
Date: Tue,  8 Apr 2025 16:24:25 +0200
Message-ID: <20250408142425.95437-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142425.95437-1-ericwouds@gmail.com>
References: <20250408142425.95437-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Loosely based on wenxu's patches:

"nf_flow_table_offload: offload the vlan/PPPoE encap in the flowtable".

Fixed double vlan and pppoe packets, almost entirely rewriting the patch.

When there is no extra vlan-device or pppoe-device added to the fastpath,
it may still be possible that the other tuple has encaps.

This is the case when there is only a bridge in the forward-fastpath,
without a vlan-device. When the bridge is tagging at ingress and keeping
at egress, the other tuple will have an encap.

It will be also be the case in the future bridge-fastpath.

In these cases it is necessary to push these encaps.

This patch adds nf_flow_encap_push() and alters nf_flow_queue_xmit()
to call it, only when (tuple.out.ifidx == tuple.out.hw_ifidx).

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nf_flow_table_ip.c | 97 +++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8cd4cf7ae211..64a12b9668e7 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -306,6 +306,92 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 	return false;
 }
 
+static int nf_flow_vlan_inner_push(struct sk_buff *skb, __be16 proto, u16 id)
+{
+	struct vlan_hdr *vhdr;
+
+	if (skb_cow_head(skb, VLAN_HLEN))
+		return -1;
+
+	__skb_push(skb, VLAN_HLEN);
+	skb_reset_network_header(skb);
+
+	vhdr = (struct vlan_hdr *)(skb->data);
+	vhdr->h_vlan_TCI = htons(id);
+	vhdr->h_vlan_encapsulated_proto = skb->protocol;
+	skb->protocol = proto;
+
+	return 0;
+}
+
+static int nf_flow_ppoe_push(struct sk_buff *skb, u16 id)
+{
+	struct ppp_hdr {
+		struct pppoe_hdr hdr;
+		__be16 proto;
+	} *ph;
+	int data_len = skb->len + 2;
+	__be16 proto;
+
+	if (skb_cow_head(skb, PPPOE_SES_HLEN))
+		return -1;
+
+	if (skb->protocol == htons(ETH_P_IP))
+		proto = htons(PPP_IP);
+	else if (skb->protocol == htons(ETH_P_IPV6))
+		proto = htons(PPP_IPV6);
+	else
+		return -1;
+
+	__skb_push(skb, PPPOE_SES_HLEN);
+	skb_reset_network_header(skb);
+
+	ph = (struct ppp_hdr *)(skb->data);
+	ph->hdr.ver  = 1;
+	ph->hdr.type = 1;
+	ph->hdr.code = 0;
+	ph->hdr.sid  = htons(id);
+	ph->hdr.length = htons(data_len);
+	ph->proto = proto;
+	skb->protocol = htons(ETH_P_PPP_SES);
+
+	return 0;
+}
+
+static int nf_flow_encap_push(struct sk_buff *skb,
+			      struct flow_offload_tuple_rhash *tuplehash,
+			      unsigned short *type)
+{
+	int i = 0, ret = 0;
+
+	if (!tuplehash->tuple.encap_num)
+		return 0;
+
+	if (tuplehash->tuple.encap[i].proto == htons(ETH_P_8021Q) ||
+	    tuplehash->tuple.encap[i].proto == htons(ETH_P_8021AD)) {
+		__vlan_hwaccel_put_tag(skb, tuplehash->tuple.encap[i].proto,
+				       tuplehash->tuple.encap[i].id);
+		i++;
+		if (i >= tuplehash->tuple.encap_num)
+			return 0;
+	}
+
+	switch (tuplehash->tuple.encap[i].proto) {
+	case htons(ETH_P_8021Q):
+		*type = ETH_P_8021Q;
+		ret = nf_flow_vlan_inner_push(skb,
+					      tuplehash->tuple.encap[i].proto,
+					      tuplehash->tuple.encap[i].id);
+		break;
+	case htons(ETH_P_PPP_SES):
+		*type = ETH_P_PPP_SES;
+		ret = nf_flow_ppoe_push(skb,
+					tuplehash->tuple.encap[i].id);
+		break;
+	}
+	return ret;
+}
+
 static void nf_flow_encap_pop(struct sk_buff *skb,
 			      struct flow_offload_tuple_rhash *tuplehash)
 {
@@ -335,6 +421,7 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 				       const struct flow_offload_tuple_rhash *tuplehash,
+				       struct flow_offload_tuple_rhash *other_tuplehash,
 				       unsigned short type)
 {
 	struct net_device *outdev;
@@ -343,6 +430,10 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 	if (!outdev)
 		return NF_DROP;
 
+	if (tuplehash->tuple.out.ifidx == tuplehash->tuple.out.hw_ifidx &&
+	    (nf_flow_encap_push(skb, other_tuplehash, &type) < 0))
+		return NF_DROP;
+
 	skb->dev = outdev;
 	dev_hard_header(skb, skb->dev, type, tuplehash->tuple.out.h_dest,
 			tuplehash->tuple.out.h_source, skb->len);
@@ -462,7 +553,8 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
+		ret = nf_flow_queue_xmit(state->net, skb, tuplehash,
+					 &flow->tuplehash[!dir], ETH_P_IP);
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
 		break;
@@ -757,7 +849,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
+		ret = nf_flow_queue_xmit(state->net, skb, tuplehash,
+					 &flow->tuplehash[!dir], ETH_P_IPV6);
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
 		break;
-- 
2.47.1

