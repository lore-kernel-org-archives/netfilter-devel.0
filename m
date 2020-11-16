Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D300C4742C
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 13:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 457802223D
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 13:05:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MsICjj5F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgKPNEo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 08:04:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728150AbgKPNEn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 08:04:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605531881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=16F1Ae9+Lt+pnjHUyamx5MmnQ1PJZRCDvWTJnbrAA2g=;
        b=MsICjj5FpozIt86+IMkMdWf6jXV/Yu++MXyPioj7lXHTsZS59oiyEFIaTCB+fQdMJJb5Ln
        O4mPHz5TPgw8+7CZrJwK2PVeJPPU6qRooxKncyrKrS0E+3HEEZfbS+bV6tySXJwAzYTNGC
        gZ+7pmlF8UEljvhrFfVt7vQE5W5ctWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-luXAYhZoPHC6RbflqktWbQ-1; Mon, 16 Nov 2020 08:04:39 -0500
X-MC-Unique: luXAYhZoPHC6RbflqktWbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 889ED8015AD;
        Mon, 16 Nov 2020 13:04:37 +0000 (UTC)
Received: from nusiddiq.home.org.com (ovpn-116-24.sin2.redhat.com [10.67.116.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01FC01A8EC;
        Mon, 16 Nov 2020 13:04:33 +0000 (UTC)
From:   nusiddiq@redhat.com
To:     dev@openvswitch.org, netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Numan Siddique <nusiddiq@redhat.com>
Subject: [PATCH net-next v2] net: openvswitch: Be liberal in tcp conntrack.
Date:   Mon, 16 Nov 2020 18:31:26 +0530
Message-Id: <20201116130126.3065077-1-nusiddiq@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Numan Siddique <nusiddiq@redhat.com>

There is no easy way to distinguish if a conntracked tcp packet is
marked invalid because of tcp_in_window() check error or because
it doesn't belong to an existing connection. With this patch,
openvswitch sets liberal tcp flag for the established sessions so
that out of window packets are not marked invalid.

A helper function - nf_ct_set_tcp_be_liberal(nf_conn) is added which
sets this flag for both the directions of the nf_conn.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Numan Siddique <nusiddiq@redhat.com>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 14 ++++++++++++++
 net/netfilter/nf_conntrack_proto_tcp.c       |  6 ------
 net/openvswitch/conntrack.c                  |  8 ++++++++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 88186b95b3c2..9be7320b994f 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -203,6 +203,20 @@ static inline struct nf_icmp_net *nf_icmpv6_pernet(struct net *net)
 {
 	return &net->ct.nf_ct_proto.icmpv6;
 }
+
+/* Caller must check nf_ct_protonum(ct) is IPPROTO_TCP before calling. */
+static inline void nf_ct_set_tcp_be_liberal(struct nf_conn *ct)
+{
+	ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+	ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+}
+
+/* Caller must check nf_ct_protonum(ct) is IPPROTO_TCP before calling. */
+static inline bool nf_conntrack_tcp_established(const struct nf_conn *ct)
+{
+	return ct->proto.tcp.state == TCP_CONNTRACK_ESTABLISHED &&
+	       test_bit(IPS_ASSURED_BIT, &ct->status);
+}
 #endif
 
 #ifdef CONFIG_NF_CT_PROTO_DCCP
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index c8fb2187ad4b..811c6c9b59e1 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -834,12 +834,6 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 }
 
-static bool nf_conntrack_tcp_established(const struct nf_conn *ct)
-{
-	return ct->proto.tcp.state == TCP_CONNTRACK_ESTABLISHED &&
-	       test_bit(IPS_ASSURED_BIT, &ct->status);
-}
-
 /* Returns verdict for packet, or -1 for invalid. */
 int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4beb96139d77..6a88daab0190 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1037,6 +1037,14 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		    ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
 			return -EINVAL;
 		}
+
+		if (nf_ct_protonum(ct) == IPPROTO_TCP &&
+		    nf_ct_is_confirmed(ct) && nf_conntrack_tcp_established(ct)) {
+			/* Be liberal for tcp packets so that out-of-window
+			 * packets are not marked invalid.
+			 */
+			nf_ct_set_tcp_be_liberal(ct);
+		}
 	}
 
 	return 0;
-- 
2.28.0

