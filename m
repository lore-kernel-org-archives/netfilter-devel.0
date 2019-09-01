Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A150DC3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 720E62190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="YOwdafr5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfIAVCO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:02:14 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53696 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729031AbfIAVCO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:02:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rF510F0tws7FAC75hk7hpC9Uyktc9J5TM7qtE5Te2HU=; b=YOwdafr5V2zqbL38bINFASbuzw
        DonVxlKqecxtEWA1vIzlqWfmlblOs/eP6uppWA9O7VhaUCWGzZ8ZcQ1iIintxX/2t37vn/fxcpNGc
        Pl239IGxspg30gIca/O5Fbor2kKCsr71Q3PbfpRZb7i9x4dy1A6Fd+isr/yCxHgQeBL55r3AZ1ntU
        X/VuXi7w1kZg77x2GYfDc5pPsC4CWSEVb2bkWwZy7aAE8Op7GSR8vJVzNEn4C7L7EJ6HjvAH0rgTG
        FTpkwmCzwhwyXspBFXnn56MgSE/nD7AZ/Sl3Ct05z2J0DsxS2l9jbLQwzaawFIzMAhOKcalb+3dNO
        BEiJ8ojQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Woq-0002Uf-Id; Sun, 01 Sep 2019 21:51:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 16/29] netfilter: move struct definition function to a more appropriate header.
Date:   Sun,  1 Sep 2019 21:51:12 +0100
Message-Id: <20190901205126.6935-17-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190901205126.6935-1-jeremy@azazel.net>
References: <20190901205126.6935-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is a struct definition function in nf_conntrack_bridge.h which is
not specific to conntrack and is used elswhere in netfilter.  Move it
into netfilter.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter.h                   |  7 +++++++
 include/linux/netfilter_ipv6.h              | 14 +++++++-------
 include/net/netfilter/nf_conntrack_bridge.h |  7 -------
 net/bridge/netfilter/nf_conntrack_bridge.c  | 14 +++++++-------
 net/ipv6/netfilter.c                        |  4 ++--
 5 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 049aeb40fa35..4c94dd4cc8d0 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -479,4 +479,11 @@ extern struct nfnl_ct_hook __rcu *nfnl_ct_hook;
  */
 DECLARE_PER_CPU(bool, nf_skb_duplicated);
 
+struct nf_bridge_frag_data {
+	char    mac[ETH_HLEN];
+	bool    vlan_present;
+	u16     vlan_tci;
+	__be16  vlan_proto;
+};
+
 #endif /*__LINUX_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index b8f872844ba3..cec3253e736d 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -33,7 +33,7 @@ struct ip6_rt_info {
 };
 
 struct nf_queue_entry;
-struct nf_ct_bridge_frag_data;
+struct nf_bridge_frag_data;
 
 /*
  * Hook functions for ipv6 to allow xt_* modules to be built-in even
@@ -62,9 +62,9 @@ struct nf_ipv6_ops {
 	int (*br_defrag)(struct net *net, struct sk_buff *skb, u32 user);
 	int (*br_fragment)(struct net *net, struct sock *sk,
 			   struct sk_buff *skb,
-			   struct nf_ct_bridge_frag_data *data,
+			   struct nf_bridge_frag_data *data,
 			   int (*output)(struct net *, struct sock *sk,
-					 const struct nf_ct_bridge_frag_data *data,
+					 const struct nf_bridge_frag_data *data,
 					 struct sk_buff *));
 #endif
 };
@@ -136,16 +136,16 @@ static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
 }
 
 int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
-		    struct nf_ct_bridge_frag_data *data,
+		    struct nf_bridge_frag_data *data,
 		    int (*output)(struct net *, struct sock *sk,
-				  const struct nf_ct_bridge_frag_data *data,
+				  const struct nf_bridge_frag_data *data,
 				  struct sk_buff *));
 
 static inline int nf_br_ip6_fragment(struct net *net, struct sock *sk,
 				     struct sk_buff *skb,
-				     struct nf_ct_bridge_frag_data *data,
+				     struct nf_bridge_frag_data *data,
 				     int (*output)(struct net *, struct sock *sk,
-						   const struct nf_ct_bridge_frag_data *data,
+						   const struct nf_bridge_frag_data *data,
 						   struct sk_buff *))
 {
 #if IS_MODULE(CONFIG_IPV6)
diff --git a/include/net/netfilter/nf_conntrack_bridge.h b/include/net/netfilter/nf_conntrack_bridge.h
index 34c28f248b18..01b62fd5efa2 100644
--- a/include/net/netfilter/nf_conntrack_bridge.h
+++ b/include/net/netfilter/nf_conntrack_bridge.h
@@ -16,11 +16,4 @@ struct nf_ct_bridge_info {
 void nf_ct_bridge_register(struct nf_ct_bridge_info *info);
 void nf_ct_bridge_unregister(struct nf_ct_bridge_info *info);
 
-struct nf_ct_bridge_frag_data {
-	char	mac[ETH_HLEN];
-	bool	vlan_present;
-	u16	vlan_tci;
-	__be16	vlan_proto;
-};
-
 #endif
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index c9ce321fcac1..8842798c29e6 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -26,9 +26,9 @@
  */
 static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 			     struct sk_buff *skb,
-			     struct nf_ct_bridge_frag_data *data,
+			     struct nf_bridge_frag_data *data,
 			     int (*output)(struct net *, struct sock *sk,
-					   const struct nf_ct_bridge_frag_data *data,
+					   const struct nf_bridge_frag_data *data,
 					   struct sk_buff *))
 {
 	int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
@@ -278,7 +278,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 }
 
 static void nf_ct_bridge_frag_save(struct sk_buff *skb,
-				   struct nf_ct_bridge_frag_data *data)
+				   struct nf_bridge_frag_data *data)
 {
 	if (skb_vlan_tag_present(skb)) {
 		data->vlan_present = true;
@@ -293,10 +293,10 @@ static void nf_ct_bridge_frag_save(struct sk_buff *skb,
 static unsigned int
 nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 		    int (*output)(struct net *, struct sock *sk,
-				  const struct nf_ct_bridge_frag_data *data,
+				  const struct nf_bridge_frag_data *data,
 				  struct sk_buff *))
 {
-	struct nf_ct_bridge_frag_data data;
+	struct nf_bridge_frag_data data;
 
 	if (!BR_INPUT_SKB_CB(skb)->frag_max_size)
 		return NF_ACCEPT;
@@ -319,7 +319,7 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 
 /* Actually only slow path refragmentation needs this. */
 static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
-				     const struct nf_ct_bridge_frag_data *data)
+				     const struct nf_bridge_frag_data *data)
 {
 	int err;
 
@@ -340,7 +340,7 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 }
 
 static int nf_ct_bridge_refrag_post(struct net *net, struct sock *sk,
-				    const struct nf_ct_bridge_frag_data *data,
+				    const struct nf_bridge_frag_data *data,
 				    struct sk_buff *skb)
 {
 	int err;
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 61819ed858b1..a9bff556d3b2 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -113,9 +113,9 @@ int __nf_ip6_route(struct net *net, struct dst_entry **dst,
 EXPORT_SYMBOL_GPL(__nf_ip6_route);
 
 int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
-		    struct nf_ct_bridge_frag_data *data,
+		    struct nf_bridge_frag_data *data,
 		    int (*output)(struct net *, struct sock *sk,
-				  const struct nf_ct_bridge_frag_data *data,
+				  const struct nf_bridge_frag_data *data,
 				  struct sk_buff *))
 {
 	int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
-- 
2.23.0.rc1

