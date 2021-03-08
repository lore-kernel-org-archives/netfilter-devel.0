Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F257AC4332E
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 01:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C377B65142
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 01:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhCHBZN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Mar 2021 20:25:13 -0500
Received: from smtp-out-so.shaw.ca ([64.59.136.138]:39301 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbhCHBYm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Mar 2021 20:24:42 -0500
Received: from fanir.tuyoix.net ([68.150.218.192])
        by shaw.ca with ESMTP
        id J4VelVweWnRGtJ4VflAVZ6; Sun, 07 Mar 2021 18:16:35 -0700
X-Authority-Analysis: v=2.4 cv=cagXElPM c=1 sm=1 tr=0 ts=60457af3
 a=LfNn7serMq+1bQZBlMsSfQ==:117 a=LfNn7serMq+1bQZBlMsSfQ==:17
 a=dESyimp9J3IA:10 a=M51BFTxLslgA:10 a=3I1X_3ewAAAA:8 a=bS_0ojvJHiWYQsesOFsA:9
 a=QEXdDO2ut3YA:10 a=VG9N9RgkD3hcbI6YpJ1l:22
Received: from tuyoix.net (fanir.tuyoix.net [192.168.144.16])
        (authenticated bits=0)
        by fanir.tuyoix.net (8.15.2/8.15.2) with ESMTPSA id 1281GYuE021021
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <netfilter-devel@vger.kernel.org>; Sun, 7 Mar 2021 18:16:34 -0700
Date:   Sun, 7 Mar 2021 18:16:34 -0700 (MST)
From:   =?UTF-8?Q?Marc_Aur=C3=A8le_La_France?= <tsi@tuyoix.net>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter REJECT: Fix destination MAC in RST packets
Message-ID: <alpine.LNX.2.20.2103071736460.15162@fanir.tuyoix.net>
User-Agent: Alpine 2.20 (LNX 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463807856-1355267220-1615164351=:15162"
Content-ID: <alpine.LNX.2.20.2103071816160.20147@fanir.tuyoix.net>
X-CMAE-Envelope: MS4xfAlUggXO+Vkw6iYMWfVimnrGBXXeYqEC1JZiwG9m/m7oShSaDosDVpHf0gCKg9tZDvyF+WvcadtBF3hE9Mmwm1Qu6cCu4iAp5WER0tADOq4BT+3ZX2Q1
 iGX0RAo1F9YMxg7jT8DJN3LYtnlTazsjfeA0uFn5J/BLho8aBkBUFU2yiF+HEYf14YcIg3SuI7MlOYHRkq63+wHOWQQHyLj8zAE=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

---1463807856-1355267220-1615164351=:15162
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.20.2103071750301.15181@fanir.tuyoix.net>

In the non-bridge case, the REJECT target code assumes the REJECTed
packets were originally emitted by the local host, but that's not
necessarily true when the local host is the default route of a subnet
it is on, resulting in RST packets being sent out with an incorrect
destination MAC.  Address this by refactoring the handling of bridged
packets which deals with a similar issue.  Modulo patch fuzz, the
following applies to v5 and later kernels.

Please Reply-To-All.

Thanks.

Marc.

Signed-off-by: Marc Aurèle La France <tsi@tuyoix.net>
Tested-by: Marc Aurèle La France <tsi@tuyoix.net>

--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -237,7 +237,7 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
 void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		   int hook)
 {
-	struct net_device *br_indev __maybe_unused;
+	struct net_device *indev;
 	struct sk_buff *nskb;
 	struct iphdr *niph;
 	const struct tcphdr *oth;
@@ -279,18 +279,20 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,

 	nf_ct_attach(nskb, oldskb);

-#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	/* If we use ip_local_out for bridged traffic, the MAC source on
-	 * the RST will be ours, instead of the destination's.  This confuses
-	 * some routers/firewalls, and they drop the packet.  So we need to
-	 * build the eth header using the original destination's MAC as the
-	 * source, and send the RST packet directly.
+	/* Swap the source and destination MACs of the RST packet from that
+	 * of the REJECTed packet's, if available from it.  Otherwise, let
+	 * ip_local_out decide.
 	 */
-	br_indev = nf_bridge_get_physindev(oldskb);
-	if (br_indev) {
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	indev = nf_bridge_get_physindev(oldskb);
+	if (!indev)
+#endif
+		indev = oldskb->dev;
+
+	if (indev) {
 		struct ethhdr *oeth = eth_hdr(oldskb);

-		nskb->dev = br_indev;
+		nskb->dev = indev;
 		niph->tot_len = htons(nskb->len);
 		ip_send_check(niph);
 		if (dev_hard_header(nskb, nskb->dev, ntohs(nskb->protocol),
@@ -298,7 +300,6 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 			goto free_nskb;
 		dev_queue_xmit(nskb);
 	} else
-#endif
 		ip_local_out(net, nskb->sk, nskb);

 	return;
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -278,7 +278,7 @@ static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
 void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		    int hook)
 {
-	struct net_device *br_indev __maybe_unused;
+	struct net_device *indev;
 	struct sk_buff *nskb;
 	struct tcphdr _otcph;
 	const struct tcphdr *otcph;
@@ -346,18 +346,20 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,

 	nf_ct_attach(nskb, oldskb);

-#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	/* If we use ip6_local_out for bridged traffic, the MAC source on
-	 * the RST will be ours, instead of the destination's.  This confuses
-	 * some routers/firewalls, and they drop the packet.  So we need to
-	 * build the eth header using the original destination's MAC as the
-	 * source, and send the RST packet directly.
+	/* Swap the source and destination MACs of the RST packet from that
+	 * of the REJECTed packet's, if available from it.  Otherwise, let
+	 * ip6_local_out decide.
 	 */
-	br_indev = nf_bridge_get_physindev(oldskb);
-	if (br_indev) {
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	indev = nf_bridge_get_physindev(oldskb);
+	if (!indev)
+#endif
+		indev = oldskb->dev;
+
+	if (indev) {
 		struct ethhdr *oeth = eth_hdr(oldskb);

-		nskb->dev = br_indev;
+		nskb->dev = indev;
 		nskb->protocol = htons(ETH_P_IPV6);
 		ip6h->payload_len = htons(sizeof(struct tcphdr));
 		if (dev_hard_header(nskb, nskb->dev, ntohs(nskb->protocol),
@@ -367,7 +369,6 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		}
 		dev_queue_xmit(nskb);
 	} else
-#endif
 		ip6_local_out(net, sk, nskb);
 }
 EXPORT_SYMBOL_GPL(nf_send_reset6);
---1463807856-1355267220-1615164351=:15162--
