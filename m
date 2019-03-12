Return-Path: <SRS0=/pLU=RP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FC6C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 06:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B7312171F
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 06:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G9s2MZ3v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfCLG6s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 02:58:48 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34955 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbfCLG6q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 02:58:46 -0400
Received: by mail-pg1-f193.google.com with SMTP id e17so1117940pgd.2;
        Mon, 11 Mar 2019 23:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DITBBTDueFMwgO9c43r4QUnl5fmEGfsFdxK6pS4NikQ=;
        b=G9s2MZ3vaLoDkFwdaFR3YRLiQmWbMq51AaDFVahT4YmghTysQGLytVDJxOvU1TYmqE
         sjrpUPX10RMN1v2YfefOR/xhriqzuIxmHYUL49v/BzbXSEJI+GuJep0fCJfxAy0Y/LkJ
         MQp98LZCCQGzqKT4B9McHbJh9YEwrAy9tsxqDMVSEc3PDJcIRE2CvS1QSOdnJlWhYg6X
         oO3sGt0cfOTMQuSFVWp3hPTmix3Fs1Z0JV/6XOlSPTwiiMWeLMIuSyYROWFkLYVvfVD2
         Ar8sHMXpLUWLsNyrAQo/A7TjmcvNqmMNATzFGbAcsGraSX5tkaqxw55aotQC/toZIyjm
         RGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DITBBTDueFMwgO9c43r4QUnl5fmEGfsFdxK6pS4NikQ=;
        b=B03wx5UFcFtrim7CPmAnvj0v1JPtiRakASsAZUSAStG1Bkf62Fp+AR7dzcpEJqBu/h
         39yjqqD6LotwSFnVQHQZdDCQ/Z5JsFGyt9L8P2dktE5i3VqavKOQ9RP/j6yK3abo/fps
         2rhQPmI3LV6KWcv8XrKNi6rj5g4vdq5lzHmun1Zelm/8k4j8Wf525GvsEKnwL4o1zJis
         E+1vTDONAiA+UAN3NJXci8nQBWVO3B19JJ5QafmnVJEIRkrpIMU+NYFTWnXwhVcB7PzD
         YVgJwZ7EukCQ/eBA2YEEO5SfHDhklMkhRxNNPPZ5DZs/GUA6D7rZy8H5N5r3qVbGYS59
         jKsw==
X-Gm-Message-State: APjAAAWXzVLl/DhAbEmx6XKJSxza7FB5+Rj4NXDr1WmRbsMFVTtX0npu
        mGEFqMXRLbCluZxPgialuA==
X-Google-Smtp-Source: APXvYqw7at1dWthONyoJAZjx9ja9nkMG3En7GZYw6PTQSU0m40p577AkjsB7R4ZGkrl4XQRBi98hpA==
X-Received: by 2002:a17:902:6b81:: with SMTP id p1mr38781502plk.106.1552373925173;
        Mon, 11 Mar 2019 23:58:45 -0700 (PDT)
Received: from localhost ([2001:19f0:7001:54c5:5400:1ff:fec8:7fc2])
        by smtp.gmail.com with ESMTPSA id j9sm12485031pfc.67.2019.03.11.23.58.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 23:58:44 -0700 (PDT)
From:   Jacky Hu <hengqing.hu@gmail.com>
Cc:     jacky.hu@walmart.com, jason.niesz@walmart.com,
        Jacky Hu <hengqing.hu@gmail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH] ipvs: allow tunneling with gue encapsulation
Date:   Tue, 12 Mar 2019 14:58:35 +0800
Message-Id: <20190312065835.19251-1-hengqing.hu@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ipip packets are blocked in some public cloud environments, this patch
allows gue encapsulation with the tunneling method, which would make
tunneling working in those environments.

Signed-off-by: Jacky Hu <hengqing.hu@gmail.com>
---
 include/uapi/linux/ip_vs.h      | 17 +++++++-
 net/netfilter/ipvs/ip_vs_ctl.c  |  4 +-
 net/netfilter/ipvs/ip_vs_xmit.c | 71 ++++++++++++++++++++++++++++++++-
 3 files changed, 87 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index 1c916b2f89dc..6637e45b93f4 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -96,13 +96,25 @@
 #define IP_VS_CONN_F_TEMPLATE	0x1000		/* template, not connection */
 #define IP_VS_CONN_F_ONE_PACKET	0x2000		/* forward only one packet */
 
+/* tunneling with gue */
+#define IP_VS_CONN_F_GUE	0x0008
+
+/* gue destination port bit 0 */
+#define IP_VS_CONN_F_GUE_PORT_LSB	0x4000
+
+/* gue destination port bit 1-15 */
+#define IP_VS_CONN_F_GUE_PORT_MSB	0xFFFFE0000
+
 /* Initial bits allowed in backup server */
 #define IP_VS_CONN_F_BACKUP_MASK (IP_VS_CONN_F_FWD_MASK | \
 				  IP_VS_CONN_F_NOOUTPUT | \
 				  IP_VS_CONN_F_INACTIVE | \
 				  IP_VS_CONN_F_SEQ_MASK | \
 				  IP_VS_CONN_F_NO_CPORT | \
-				  IP_VS_CONN_F_TEMPLATE \
+				  IP_VS_CONN_F_TEMPLATE | \
+				  IP_VS_CONN_F_GUE | \
+				  IP_VS_CONN_F_GUE_PORT_MSB | \
+				  IP_VS_CONN_F_GUE_PORT_LSB \
 				 )
 
 /* Bits allowed to update in backup server */
@@ -116,6 +128,9 @@
 #define IP_VS_CONN_F_DEST_MASK (IP_VS_CONN_F_FWD_MASK | \
 				IP_VS_CONN_F_ONE_PACKET | \
 				IP_VS_CONN_F_NFCT | \
+				IP_VS_CONN_F_GUE | \
+				IP_VS_CONN_F_GUE_PORT_MSB | \
+				IP_VS_CONN_F_GUE_PORT_LSB | \
 				0)
 
 #define IP_VS_SCHEDNAME_MAXLEN	16
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 432141f04af3..cecfb52cdea4 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3169,7 +3169,7 @@ static int ip_vs_genl_fill_dest(struct sk_buff *skb, struct ip_vs_dest *dest)
 	    nla_put_be16(skb, IPVS_DEST_ATTR_PORT, dest->port) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_FWD_METHOD,
 			(atomic_read(&dest->conn_flags) &
-			 IP_VS_CONN_F_FWD_MASK)) ||
+			 IP_VS_CONN_F_DEST_MASK)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_WEIGHT,
 			atomic_read(&dest->weight)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_U_THRESH, dest->u_threshold) ||
@@ -3305,7 +3305,7 @@ static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
 			return -EINVAL;
 
 		udest->conn_flags = nla_get_u32(nla_fwd)
-				    & IP_VS_CONN_F_FWD_MASK;
+				    & IP_VS_CONN_F_DEST_MASK;
 		udest->weight = nla_get_u32(nla_weight);
 		udest->u_threshold = nla_get_u32(nla_u_thresh);
 		udest->l_threshold = nla_get_u32(nla_l_thresh);
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 473cce2a5231..2667b587b91d 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/tcp.h>                  /* for tcphdr */
 #include <net/ip.h>
+#include <net/gue.h>
 #include <net/tcp.h>                    /* for csum_tcpudp_magic */
 #include <net/udp.h>
 #include <net/icmp.h>                   /* for icmp_send */
@@ -989,6 +990,42 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
 	}
 }
 
+static int
+__build_gue_header(struct net *net, struct sk_buff *skb,
+		   struct ip_vs_conn *cp, __u8 *next_protocol)
+{
+	__be16 dport;
+	__be16 sport;
+	struct udphdr  *udph;	/* Our new UDP header */
+	struct guehdr  *gueh;	/* Our new GUE header */
+
+	skb_push(skb, sizeof(struct guehdr));
+
+	gueh = (struct guehdr *)skb->data;
+
+	gueh->control = 0;
+	gueh->version = 0;
+	gueh->hlen = 0;
+	gueh->flags = 0;
+	gueh->proto_ctype = *next_protocol;
+
+	skb_push(skb, sizeof(struct udphdr));
+	skb_reset_transport_header(skb);
+
+	udph = udp_hdr(skb);
+
+	dport = htons(((cp->flags >> 16) & 0xFFFE) | ((cp->flags >> 14) & 1));
+	sport = udp_flow_src_port(net, skb, 0, 0, false);
+	udph->dest = dport;
+	udph->source = sport;
+	udph->len = htons(skb->len);
+	udph->check = 0;
+
+	*next_protocol = IPPROTO_UDP;
+
+	return 0;
+}
+
 /*
  *   IP Tunneling transmitter
  *
@@ -1025,6 +1062,8 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	struct iphdr  *iph;			/* Our new IP header */
 	unsigned int max_headroom;		/* The extra header space needed */
 	int ret, local;
+	bool gue = false;
+	int type;
 
 	EnterFunction(10);
 
@@ -1041,11 +1080,16 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	rt = skb_rtable(skb);
 	tdev = rt->dst.dev;
 
+	gue = (bool)(cp->flags & IP_VS_CONN_F_GUE);
+
 	/*
 	 * Okay, now see if we can stuff it in the buffer as-is.
 	 */
 	max_headroom = LL_RESERVED_SPACE(tdev) + sizeof(struct iphdr);
 
+	if (gue)
+		max_headroom += sizeof(struct udphdr) + sizeof(struct guehdr);
+
 	/* We only care about the df field if sysctl_pmtu_disc(ipvs) is set */
 	dfp = sysctl_pmtu_disc(ipvs) ? &df : NULL;
 	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
@@ -1054,11 +1098,19 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	if (IS_ERR(skb))
 		goto tx_error;
 
-	if (iptunnel_handle_offloads(skb, __tun_gso_type_mask(AF_INET, cp->af)))
+	if (gue)
+		type = SKB_GSO_UDP_TUNNEL;
+	else
+		type = __tun_gso_type_mask(AF_INET, cp->af);
+
+	if (iptunnel_handle_offloads(skb, type))
 		goto tx_error;
 
 	skb->transport_header = skb->network_header;
 
+	if (gue)
+		__build_gue_header(dev_net(tdev), skb, cp, &next_protocol);
+
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
@@ -1112,6 +1164,8 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	struct ipv6hdr  *iph;		/* Our new IP header */
 	unsigned int max_headroom;	/* The extra header space needed */
 	int ret, local;
+	bool gue = false;
+	int type;
 
 	EnterFunction(10);
 
@@ -1129,22 +1183,35 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	rt = (struct rt6_info *) skb_dst(skb);
 	tdev = rt->dst.dev;
 
+	gue = (bool)(cp->flags & IP_VS_CONN_F_GUE);
+
 	/*
 	 * Okay, now see if we can stuff it in the buffer as-is.
 	 */
 	max_headroom = LL_RESERVED_SPACE(tdev) + sizeof(struct ipv6hdr);
 
+	if (gue)
+		max_headroom += sizeof(struct udphdr) + sizeof(struct guehdr);
+
 	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
 					 &next_protocol, &payload_len,
 					 &dsfield, &ttl, NULL);
 	if (IS_ERR(skb))
 		goto tx_error;
 
-	if (iptunnel_handle_offloads(skb, __tun_gso_type_mask(AF_INET6, cp->af)))
+	if (gue)
+		type = SKB_GSO_UDP_TUNNEL;
+	else
+		type = __tun_gso_type_mask(AF_INET6, cp->af);
+
+	if (iptunnel_handle_offloads(skb, type))
 		goto tx_error;
 
 	skb->transport_header = skb->network_header;
 
+	if (gue)
+		__build_gue_header(dev_net(tdev), skb, cp, &next_protocol);
+
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
-- 
2.21.0

