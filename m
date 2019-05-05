Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3B2C46470
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 12:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99F2B2082F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 12:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfEEMP7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 08:15:59 -0400
Received: from ja.ssi.bg ([178.16.129.10]:56758 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbfEEMP6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 08:15:58 -0400
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x45CFi1p016492;
        Sun, 5 May 2019 15:15:44 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.15.2/8.15.2/Submit) id x45CFiEG016491;
        Sun, 5 May 2019 15:15:44 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: [PATCHv2 net-next 2/3] ipvs: add function to find tunnels
Date:   Sun,  5 May 2019 15:14:39 +0300
Message-Id: <20190505121440.16389-3-ja@ssi.bg>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505121440.16389-1-ja@ssi.bg>
References: <20190505121440.16389-1-ja@ssi.bg>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add ip_vs_find_tunnel() to match tunnel headers
by family, address and optional port. Use it to
properly find the tunnel real server used in
received ICMP errors.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 include/net/ip_vs.h             |  3 +++
 net/netfilter/ipvs/ip_vs_core.c |  8 ++++++++
 net/netfilter/ipvs/ip_vs_ctl.c  | 29 +++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 9a8ac8997e34..b01a94ebfc0e 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1404,6 +1404,9 @@ bool ip_vs_has_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
 struct ip_vs_dest *
 ip_vs_find_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
 			const union nf_inet_addr *daddr, __be16 dport);
+struct ip_vs_dest *ip_vs_find_tunnel(struct netns_ipvs *ipvs, int af,
+				     const union nf_inet_addr *daddr,
+				     __be16 tun_port);
 
 int ip_vs_use_count_inc(void);
 void ip_vs_use_count_dec(void);
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 14457551bcb4..4447ee512b88 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1598,6 +1598,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	struct ip_vs_proto_data *pd;
 	unsigned int offset, offset2, ihl, verdict;
 	bool ipip, new_cp = false;
+	union nf_inet_addr *raddr;
 
 	*related = 1;
 
@@ -1636,15 +1637,22 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
 	if (cih == NULL)
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
+	raddr = (union nf_inet_addr *)&cih->daddr;
 
 	/* Special case for errors for IPIP packets */
 	ipip = false;
 	if (cih->protocol == IPPROTO_IPIP) {
+		struct ip_vs_dest *dest;
+
 		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
 			return NF_ACCEPT;
 		/* Error for our IPIP must arrive at LOCAL_IN */
 		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL))
 			return NF_ACCEPT;
+		dest = ip_vs_find_tunnel(ipvs, AF_INET, raddr, 0);
+		/* Only for known tunnel */
+		if (!dest || dest->tun_type != IP_VS_CONN_F_TUNNEL_TYPE_IPIP)
+			return NF_ACCEPT;
 		offset += cih->ihl * 4;
 		cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
 		if (cih == NULL)
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 7f624f4c402b..e504aa45fcb9 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -617,6 +617,35 @@ struct ip_vs_dest *ip_vs_find_real_service(struct netns_ipvs *ipvs, int af,
 	return NULL;
 }
 
+/* Find real service record by <af,addr,tun_port>.
+ * In case of multiple records with the same <af,addr,tun_port>, only
+ * the first found record is returned.
+ *
+ * To be called under RCU lock.
+ */
+struct ip_vs_dest *ip_vs_find_tunnel(struct netns_ipvs *ipvs, int af,
+				     const union nf_inet_addr *daddr,
+				     __be16 tun_port)
+{
+	struct ip_vs_dest *dest;
+	unsigned int hash;
+
+	/* Check for "full" addressed entries */
+	hash = ip_vs_rs_hashkey(af, daddr, tun_port);
+
+	hlist_for_each_entry_rcu(dest, &ipvs->rs_table[hash], d_list) {
+		if (dest->tun_port == tun_port &&
+		    dest->af == af &&
+		    ip_vs_addr_equal(af, &dest->addr, daddr) &&
+		    IP_VS_DFWD_METHOD(dest) == IP_VS_CONN_F_TUNNEL) {
+			/* HIT */
+			return dest;
+		}
+	}
+
+	return NULL;
+}
+
 /* Lookup destination by {addr,port} in the given service
  * Called under RCU lock.
  */
-- 
2.17.1

