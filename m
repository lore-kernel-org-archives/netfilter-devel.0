Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9F0C28CC1
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 18:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98FED2771D
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 18:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfFASYF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jun 2019 14:24:05 -0400
Received: from mail.us.es ([193.147.175.20]:39992 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfFASYE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 50355B60DF
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3086DDA701
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 73694FF134; Sat,  1 Jun 2019 20:23:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80F19B7FE0;
        Sat,  1 Jun 2019 20:23:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0FCB84265A32;
        Sat,  1 Jun 2019 20:23:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/15] ipvs: allow rs_table to contain different real server types
Date:   Sat,  1 Jun 2019 20:23:26 +0200
Message-Id: <20190601182340.2662-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Before now rs_table was used only for NAT real servers.
Change it to allow TUN real severs from different types,
possibly hashed with different port key.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h            |  3 +++
 net/netfilter/ipvs/ip_vs_ctl.c | 43 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 2ac40135b576..9a8ac8997e34 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1497,6 +1497,9 @@ static inline int ip_vs_todrop(struct netns_ipvs *ipvs)
 static inline int ip_vs_todrop(struct netns_ipvs *ipvs) { return 0; }
 #endif
 
+#define IP_VS_DFWD_METHOD(dest) (atomic_read(&(dest)->conn_flags) & \
+				 IP_VS_CONN_F_FWD_MASK)
+
 /* ip_vs_fwd_tag returns the forwarding tag of the connection */
 #define IP_VS_FWD_METHOD(cp)  (cp->flags & IP_VS_CONN_F_FWD_MASK)
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 0e887159425c..30b1a9f9c2e3 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -515,15 +515,36 @@ static inline unsigned int ip_vs_rs_hashkey(int af,
 static void ip_vs_rs_hash(struct netns_ipvs *ipvs, struct ip_vs_dest *dest)
 {
 	unsigned int hash;
+	__be16 port;
 
 	if (dest->in_rs_table)
 		return;
 
+	switch (IP_VS_DFWD_METHOD(dest)) {
+	case IP_VS_CONN_F_MASQ:
+		port = dest->port;
+		break;
+	case IP_VS_CONN_F_TUNNEL:
+		switch (dest->tun_type) {
+		case IP_VS_CONN_F_TUNNEL_TYPE_GUE:
+			port = dest->tun_port;
+			break;
+		case IP_VS_CONN_F_TUNNEL_TYPE_IPIP:
+			port = 0;
+			break;
+		default:
+			return;
+		}
+		break;
+	default:
+		return;
+	}
+
 	/*
 	 *	Hash by proto,addr,port,
 	 *	which are the parameters of the real service.
 	 */
-	hash = ip_vs_rs_hashkey(dest->af, &dest->addr, dest->port);
+	hash = ip_vs_rs_hashkey(dest->af, &dest->addr, port);
 
 	hlist_add_head_rcu(&dest->d_list, &ipvs->rs_table[hash]);
 	dest->in_rs_table = 1;
@@ -555,7 +576,8 @@ bool ip_vs_has_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
 		if (dest->port == dport &&
 		    dest->af == af &&
 		    ip_vs_addr_equal(af, &dest->addr, daddr) &&
-		    (dest->protocol == protocol || dest->vfwmark)) {
+		    (dest->protocol == protocol || dest->vfwmark) &&
+		    IP_VS_DFWD_METHOD(dest) == IP_VS_CONN_F_MASQ) {
 			/* HIT */
 			return true;
 		}
@@ -585,7 +607,8 @@ struct ip_vs_dest *ip_vs_find_real_service(struct netns_ipvs *ipvs, int af,
 		if (dest->port == dport &&
 		    dest->af == af &&
 		    ip_vs_addr_equal(af, &dest->addr, daddr) &&
-			(dest->protocol == protocol || dest->vfwmark)) {
+		    (dest->protocol == protocol || dest->vfwmark) &&
+		    IP_VS_DFWD_METHOD(dest) == IP_VS_CONN_F_MASQ) {
 			/* HIT */
 			return dest;
 		}
@@ -831,6 +854,13 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 	conn_flags = udest->conn_flags & IP_VS_CONN_F_DEST_MASK;
 	conn_flags |= IP_VS_CONN_F_INACTIVE;
 
+	/* Need to rehash? */
+	if ((udest->conn_flags & IP_VS_CONN_F_FWD_MASK) !=
+	    IP_VS_DFWD_METHOD(dest) ||
+	    udest->tun_type != dest->tun_type ||
+	    udest->tun_port != dest->tun_port)
+		ip_vs_rs_unhash(dest);
+
 	/* set the tunnel info */
 	dest->tun_type = udest->tun_type;
 	dest->tun_port = udest->tun_port;
@@ -839,16 +869,13 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 	if ((conn_flags & IP_VS_CONN_F_FWD_MASK) != IP_VS_CONN_F_MASQ) {
 		conn_flags |= IP_VS_CONN_F_NOOUTPUT;
 	} else {
-		/*
-		 *    Put the real service in rs_table if not present.
-		 *    For now only for NAT!
-		 */
-		ip_vs_rs_hash(ipvs, dest);
 		/* FTP-NAT requires conntrack for mangling */
 		if (svc->port == FTPPORT)
 			ip_vs_register_conntrack(svc);
 	}
 	atomic_set(&dest->conn_flags, conn_flags);
+	/* Put the real service in rs_table if not present. */
+	ip_vs_rs_hash(ipvs, dest);
 
 	/* bind the service */
 	old_svc = rcu_dereference_protected(dest->svc, 1);
-- 
2.11.0

