Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3F7C43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D50FB20838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfCBSgg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:36:36 -0500
Received: from mail.us.es ([193.147.175.20]:36166 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727485AbfCBSge (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:36:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 275A51361B8
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0AC19DA84C
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F38B8DA846; Sat,  2 Mar 2019 19:36:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1891DA846;
        Sat,  2 Mar 2019 19:36:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:36:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A07E34265A2F;
        Sat,  2 Mar 2019 19:36:26 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 18/29] ipvs: change some data types from int to bool
Date:   Sat,  2 Mar 2019 19:36:02 +0100
Message-Id: <20190302183613.3159-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183613.3159-1-pablo@netfilter.org>
References: <20190302183613.3159-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Andrea Claudi <aclaudi@redhat.com>

Change the data type of the following variables from int to bool
across ipvs code:

  - found
  - loop
  - need_full_dest
  - need_full_svc
  - payload_csum

Also change the following functions to use bool full_entry param
instead of int:

  - ip_vs_genl_parse_dest()
  - ip_vs_genl_parse_service()

This patch does not change any functionality but makes the source
code slightly easier to read.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c       | 12 ++++++------
 net/netfilter/ipvs/ip_vs_ftp.c       |  4 ++--
 net/netfilter/ipvs/ip_vs_proto_tcp.c |  8 ++++----
 net/netfilter/ipvs/ip_vs_proto_udp.c |  8 ++++----
 net/netfilter/ipvs/ip_vs_xmit.c      |  4 ++--
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 2a3d4e27cf3b..053cd96b9c76 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3086,7 +3086,7 @@ static bool ip_vs_is_af_valid(int af)
 
 static int ip_vs_genl_parse_service(struct netns_ipvs *ipvs,
 				    struct ip_vs_service_user_kern *usvc,
-				    struct nlattr *nla, int full_entry,
+				    struct nlattr *nla, bool full_entry,
 				    struct ip_vs_service **ret_svc)
 {
 	struct nlattr *attrs[IPVS_SVC_ATTR_MAX + 1];
@@ -3173,7 +3173,7 @@ static struct ip_vs_service *ip_vs_genl_find_service(struct netns_ipvs *ipvs,
 	struct ip_vs_service *svc;
 	int ret;
 
-	ret = ip_vs_genl_parse_service(ipvs, &usvc, nla, 0, &svc);
+	ret = ip_vs_genl_parse_service(ipvs, &usvc, nla, false, &svc);
 	return ret ? ERR_PTR(ret) : svc;
 }
 
@@ -3283,7 +3283,7 @@ static int ip_vs_genl_dump_dests(struct sk_buff *skb,
 }
 
 static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
-				 struct nlattr *nla, int full_entry)
+				 struct nlattr *nla, bool full_entry)
 {
 	struct nlattr *attrs[IPVS_DEST_ATTR_MAX + 1];
 	struct nlattr *nla_addr, *nla_port;
@@ -3545,11 +3545,11 @@ static int ip_vs_genl_set_daemon(struct sk_buff *skb, struct genl_info *info)
 
 static int ip_vs_genl_set_cmd(struct sk_buff *skb, struct genl_info *info)
 {
+	bool need_full_svc = false, need_full_dest = false;
 	struct ip_vs_service *svc = NULL;
 	struct ip_vs_service_user_kern usvc;
 	struct ip_vs_dest_user_kern udest;
 	int ret = 0, cmd;
-	int need_full_svc = 0, need_full_dest = 0;
 	struct net *net = sock_net(skb->sk);
 	struct netns_ipvs *ipvs = net_ipvs(net);
 
@@ -3573,7 +3573,7 @@ static int ip_vs_genl_set_cmd(struct sk_buff *skb, struct genl_info *info)
 	 * received a valid one. We need a full service specification when
 	 * adding / editing a service. Only identifying members otherwise. */
 	if (cmd == IPVS_CMD_NEW_SERVICE || cmd == IPVS_CMD_SET_SERVICE)
-		need_full_svc = 1;
+		need_full_svc = true;
 
 	ret = ip_vs_genl_parse_service(ipvs, &usvc,
 				       info->attrs[IPVS_CMD_ATTR_SERVICE],
@@ -3593,7 +3593,7 @@ static int ip_vs_genl_set_cmd(struct sk_buff *skb, struct genl_info *info)
 	if (cmd == IPVS_CMD_NEW_DEST || cmd == IPVS_CMD_SET_DEST ||
 	    cmd == IPVS_CMD_DEL_DEST) {
 		if (cmd != IPVS_CMD_DEL_DEST)
-			need_full_dest = 1;
+			need_full_dest = true;
 
 		ret = ip_vs_genl_parse_dest(&udest,
 					    info->attrs[IPVS_CMD_ATTR_DEST],
diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 4398a72edec5..fe69d46ff779 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -124,7 +124,7 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 	}
 	s = data + plen;
 	if (skip) {
-		int found = 0;
+		bool found = false;
 
 		for (;; s++) {
 			if (s == data_limit)
@@ -136,7 +136,7 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 				if (!ext && isdigit(*s))
 					break;
 				if (*s == skip)
-					found = 1;
+					found = true;
 			} else if (*s != skip) {
 				break;
 			}
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 479419759983..00ce07dda980 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -153,8 +153,8 @@ tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 {
 	struct tcphdr *tcph;
 	unsigned int tcphoff = iph->len;
+	bool payload_csum = false;
 	int oldlen;
-	int payload_csum = 0;
 
 #ifdef CONFIG_IP_VS_IPV6
 	if (cp->af == AF_INET6 && iph->fragoffs)
@@ -180,7 +180,7 @@ tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		if (ret == 1)
 			oldlen = skb->len - tcphoff;
 		else
-			payload_csum = 1;
+			payload_csum = true;
 	}
 
 	tcph = (void *)skb_network_header(skb) + tcphoff;
@@ -231,8 +231,8 @@ tcp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 {
 	struct tcphdr *tcph;
 	unsigned int tcphoff = iph->len;
+	bool payload_csum = false;
 	int oldlen;
-	int payload_csum = 0;
 
 #ifdef CONFIG_IP_VS_IPV6
 	if (cp->af == AF_INET6 && iph->fragoffs)
@@ -261,7 +261,7 @@ tcp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		if (ret == 1)
 			oldlen = skb->len - tcphoff;
 		else
-			payload_csum = 1;
+			payload_csum = true;
 	}
 
 	tcph = (void *)skb_network_header(skb) + tcphoff;
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index 646c384910fb..92c078abcb3e 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -143,8 +143,8 @@ udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 {
 	struct udphdr *udph;
 	unsigned int udphoff = iph->len;
+	bool payload_csum = false;
 	int oldlen;
-	int payload_csum = 0;
 
 #ifdef CONFIG_IP_VS_IPV6
 	if (cp->af == AF_INET6 && iph->fragoffs)
@@ -172,7 +172,7 @@ udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		if (ret == 1)
 			oldlen = skb->len - udphoff;
 		else
-			payload_csum = 1;
+			payload_csum = true;
 	}
 
 	udph = (void *)skb_network_header(skb) + udphoff;
@@ -226,8 +226,8 @@ udp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 {
 	struct udphdr *udph;
 	unsigned int udphoff = iph->len;
+	bool payload_csum = false;
 	int oldlen;
-	int payload_csum = 0;
 
 #ifdef CONFIG_IP_VS_IPV6
 	if (cp->af == AF_INET6 && iph->fragoffs)
@@ -256,7 +256,7 @@ udp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		if (ret == 1)
 			oldlen = skb->len - udphoff;
 		else
-			payload_csum = 1;
+			payload_csum = true;
 	}
 
 	udph = (void *)skb_network_header(skb) + udphoff;
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 473cce2a5231..175349fcf91f 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -126,7 +126,7 @@ static struct rtable *do_output_route4(struct net *net, __be32 daddr,
 {
 	struct flowi4 fl4;
 	struct rtable *rt;
-	int loop = 0;
+	bool loop = false;
 
 	memset(&fl4, 0, sizeof(fl4));
 	fl4.daddr = daddr;
@@ -149,7 +149,7 @@ static struct rtable *do_output_route4(struct net *net, __be32 daddr,
 		ip_rt_put(rt);
 		*saddr = fl4.saddr;
 		flowi4_update_output(&fl4, 0, 0, daddr, fl4.saddr);
-		loop++;
+		loop = true;
 		goto retry;
 	}
 	*saddr = fl4.saddr;
-- 
2.11.0


