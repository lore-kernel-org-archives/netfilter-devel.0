Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248EEC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F39C12083D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfCUL3Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:29:25 -0400
Received: from mail.us.es ([193.147.175.20]:42682 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbfCUL2z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 07:28:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E775FC2305
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2019 12:28:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9156BAAB4
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2019 12:28:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C3EE6BAAB3; Thu, 21 Mar 2019 12:28:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F3F0BAAA5;
        Thu, 21 Mar 2019 12:28:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Mar 2019 12:28:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [195.39.71.253])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2ACF94265A4E;
        Thu, 21 Mar 2019 12:28:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/9] netfilter: nf_conntrack_sip: remove direct dependency on IPv6
Date:   Thu, 21 Mar 2019 12:28:37 +0100
Message-Id: <20190321112845.10627-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190321112845.10627-1-pablo@netfilter.org>
References: <20190321112845.10627-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Alin Nastac <alin.nastac@gmail.com>

Previous implementation was not usable with CONFIG_IPV6=m.

Fixes: a3419ce3356c ("netfilter: nf_conntrack_sip: add sip_external_media logic")
Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f067c6b50857..39fcc1ed18f3 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -20,9 +20,9 @@
 #include <linux/udp.h>
 #include <linux/tcp.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
 
-#include <net/route.h>
-#include <net/ip6_route.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_expect.h>
@@ -871,38 +871,33 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 	} else if (sip_external_media) {
 		struct net_device *dev = skb_dst(skb)->dev;
 		struct net *net = dev_net(dev);
-		struct rtable *rt;
-		struct flowi4 fl4 = {};
-#if IS_ENABLED(CONFIG_IPV6)
-		struct flowi6 fl6 = {};
-#endif
+		struct flowi fl;
 		struct dst_entry *dst = NULL;
 
+		memset(&fl, 0, sizeof(fl));
+
 		switch (nf_ct_l3num(ct)) {
 			case NFPROTO_IPV4:
-				fl4.daddr = daddr->ip;
-				rt = ip_route_output_key(net, &fl4);
-				if (!IS_ERR(rt))
-					dst = &rt->dst;
+				fl.u.ip4.daddr = daddr->ip;
+				nf_ip_route(net, &dst, &fl, false);
 				break;
 
-#if IS_ENABLED(CONFIG_IPV6)
 			case NFPROTO_IPV6:
-				fl6.daddr = daddr->in6;
-				dst = ip6_route_output(net, NULL, &fl6);
-				if (dst->error) {
-					dst_release(dst);
-					dst = NULL;
-				}
+				fl.u.ip6.daddr = daddr->in6;
+				nf_ip6_route(net, &dst, &fl, false);
 				break;
-#endif
 		}
 
 		/* Don't predict any conntracks when media endpoint is reachable
 		 * through the same interface as the signalling peer.
 		 */
-		if (dst && dst->dev == dev)
-			return NF_ACCEPT;
+		if (dst) {
+			bool external_media = (dst->dev == dev);
+
+			dst_release(dst);
+			if (external_media)
+				return NF_ACCEPT;
+		}
 	}
 
 	/* We need to check whether the registration exists before attempting
-- 
2.11.0

