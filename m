Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3D0C4CEC5
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7407B20717
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="LzDQ92S+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbfIMIRx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:17:53 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60846 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbfIMIRx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:17:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DJfq/7h5/+GUqGwUvyEt0H98CJoz/D+lqKvKW4Y91+k=; b=LzDQ92S+PL9i3LMq8O4Lkz9osM
        jup30klZKDd8TlYmRBoagv5Usl7W0qjZMc2VVfMtQTCU7UDJkas0baMM2Fy57eoPTr8t+tHqIiyK3
        yzuyXMzY2RZhKeHG1XFl/n/Z8Gy5PNPB/s3d28VNZod/C8xsx/likq3Q1avfmuF2NiFs2oAxo+y8C
        dKvG3uIQwGfjJDfc0WBmKnBrnmg/rq4+oiDNrMARp+gY6dyParSH3NHjLxnRr/syikhtkBBzEDW0H
        7f4+m/XRHZ8Gj6Jth6VOl52xFSIPLGkm5nm6PDB0rNO+zsxcGH4SKISw6s/d9jO4VFMICUkcdDGIR
        oWy6730w==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghl-0005yL-Lm; Fri, 13 Sep 2019 09:13:21 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 11/18] netfilter: replace defined(CONFIG...) || defined(CONFIG...MODULE) with IS_ENABLED(CONFIG...).
Date:   Fri, 13 Sep 2019 09:13:11 +0100
Message-Id: <20190913081318.16071-12-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913081318.16071-1-jeremy@azazel.net>
References: <20190913081318.16071-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A few headers contain instances of:

  #if defined(CONFIG_XXX) or defined(CONFIG_XXX_MODULE)

Replace them with:

  #if IS_ENABLED(CONFIG_XXX)

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter.h                      | 2 +-
 include/linux/netfilter/ipset/ip_set_getport.h | 2 +-
 include/net/netfilter/nf_conntrack_extend.h    | 2 +-
 include/net/netfilter/nf_nat.h                 | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 049aeb40fa35..754995d028e2 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -422,7 +422,7 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 }
 #endif /*CONFIG_NETFILTER*/
 
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_zones_common.h>
 
 extern void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *) __rcu;
diff --git a/include/linux/netfilter/ipset/ip_set_getport.h b/include/linux/netfilter/ipset/ip_set_getport.h
index a906df06948b..d74cd112b88a 100644
--- a/include/linux/netfilter/ipset/ip_set_getport.h
+++ b/include/linux/netfilter/ipset/ip_set_getport.h
@@ -9,7 +9,7 @@
 extern bool ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
 				__be16 *port, u8 *proto);
 
-#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 extern bool ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
 				__be16 *port, u8 *proto);
 #else
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 21f887c5058c..112a6f40dfaf 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -8,7 +8,7 @@
 
 enum nf_ct_ext_id {
 	NF_CT_EXT_HELPER,
-#if defined(CONFIG_NF_NAT) || defined(CONFIG_NF_NAT_MODULE)
+#if IS_ENABLED(CONFIG_NF_NAT)
 	NF_CT_EXT_NAT,
 #endif
 	NF_CT_EXT_SEQADJ,
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index eeb336809679..362ff94fa6b0 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -22,7 +22,7 @@ enum nf_nat_manip_type {
 /* per conntrack: nat application helper private data */
 union nf_conntrack_nat_help {
 	/* insert nat helper private data here */
-#if defined(CONFIG_NF_NAT_PPTP) || defined(CONFIG_NF_NAT_PPTP_MODULE)
+#if IS_ENABLED(CONFIG_NF_NAT_PPTP)
 	struct nf_nat_pptp nat_pptp_info;
 #endif
 };
@@ -47,7 +47,7 @@ struct nf_conn_nat *nf_ct_nat_ext_add(struct nf_conn *ct);
 
 static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
 {
-#if defined(CONFIG_NF_NAT) || defined(CONFIG_NF_NAT_MODULE)
+#if IS_ENABLED(CONFIG_NF_NAT)
 	return nf_ct_ext_find(ct, NF_CT_EXT_NAT);
 #else
 	return NULL;
-- 
2.23.0

