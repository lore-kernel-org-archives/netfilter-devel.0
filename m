Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1751C3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 11:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE1692082F
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 11:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbfHTL2d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:28:33 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:32787 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729426AbfHTL2d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 07:28:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id 4503D64DC;
        Tue, 20 Aug 2019 13:28:29 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HktjCg8DRHmX; Tue, 20 Aug 2019 13:28:02 +0200 (CEST)
Received: from mail-backup.fem.tu-ilmenau.de (mail-backup.net.fem.tu-ilmenau.de [10.42.40.22])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTPS;
        Tue, 20 Aug 2019 13:26:23 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail-backup.fem.tu-ilmenau.de (Postfix) with ESMTP id ABCC85612A;
        Tue, 20 Aug 2019 13:26:23 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id 8E15F300183D; Tue, 20 Aug 2019 13:26:23 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCHv2] netfilter: nfnetlink_log:add support for VLAN information
Date:   Tue, 20 Aug 2019 13:26:17 +0200
Message-Id: <20190820112617.18095-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, there is no vlan information (e.g. when used with a vlan aware
bridge) passed to userspache, HWHEADER will contain an 08 00 (ip) suffix
even for tagged ip packets.

Therefore, add an extra netlink attribute that passes the vlan information
to userspace similarly to 15824ab29f for nfqueue.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

--
v2: mirror nfqueue behaviour
---
 include/uapi/linux/netfilter/nfnetlink_log.h | 11 ++++++
 net/netfilter/nf_log_common.c                |  2 +
 net/netfilter/nfnetlink_log.c                | 40 ++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_log.h b/include/uapi/linux/netfilter/nfnetlink_log.h
index 20983cb195a0..45c8d3b027e0 100644
--- a/include/uapi/linux/netfilter/nfnetlink_log.h
+++ b/include/uapi/linux/netfilter/nfnetlink_log.h
@@ -33,6 +33,15 @@ struct nfulnl_msg_packet_timestamp {
 	__aligned_be64	usec;
 };
 
+enum nfulnl_vlan_attr {
+	NFULA_VLAN_UNSPEC,
+	NFULA_VLAN_PROTO,		/* __be16 skb vlan_proto */
+	NFULA_VLAN_TCI,			/* __be16 skb htons(vlan_tci) */
+	__NFULA_VLAN_MAX,
+};
+
+#define NFULA_VLAN_MAX (__NFULA_VLAN_MAX + 1)
+
 enum nfulnl_attr_type {
 	NFULA_UNSPEC,
 	NFULA_PACKET_HDR,
@@ -54,6 +63,8 @@ enum nfulnl_attr_type {
 	NFULA_HWLEN,			/* hardware header length */
 	NFULA_CT,                       /* nf_conntrack_netlink.h */
 	NFULA_CT_INFO,                  /* enum ip_conntrack_info */
+	NFULA_VLAN,			/* nested attribute: packet vlan info */
+	NFULA_L2HDR,			/* full L2 header */
 
 	__NFULA_MAX
 };
diff --git a/net/netfilter/nf_log_common.c b/net/netfilter/nf_log_common.c
index ae5628ddbe6d..c127bcc119d8 100644
--- a/net/netfilter/nf_log_common.c
+++ b/net/netfilter/nf_log_common.c
@@ -167,6 +167,8 @@ nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
 	physoutdev = nf_bridge_get_physoutdev(skb);
 	if (physoutdev && out != physoutdev)
 		nf_log_buf_add(m, "PHYSOUT=%s ", physoutdev->name);
+	if (skb_vlan_tag_present(skb))
+		nf_log_buf_add(m, "VLAN=%d ", skb_vlan_tag_get_id(skb));
 #endif
 }
 EXPORT_SYMBOL_GPL(nf_log_dump_packet_common);
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 6dee4f9a944c..dd5b63205d31 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -385,6 +385,40 @@ nfulnl_timer(struct timer_list *t)
 	instance_put(inst);
 }
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+static int nfulnl_put_bridge(struct nfulnl_instance *inst, struct sk_buff *skb)
+{
+	if (!skb_mac_header_was_set(skb))
+		return 0;
+
+	if (skb_vlan_tag_present(skb)) {
+		struct nlattr *nest;
+
+		nest = nla_nest_start(inst->skb, NFULA_VLAN);
+		if (!nest)
+			goto nla_put_failure;
+
+		if (nla_put_be16(inst->skb, NFULA_VLAN_TCI, htons(skb->vlan_tci)) ||
+		    nla_put_be16(inst->skb, NFULA_VLAN_PROTO, skb->vlan_proto))
+			goto nla_put_failure;
+
+		nla_nest_end(inst->skb, nest);
+	}
+
+	if (skb->mac_header < skb->network_header) {
+		int len = (int)(skb->network_header - skb->mac_header);
+
+		if (nla_put(inst->skb, NFULA_L2HDR, len, skb_mac_header(skb)))
+			goto nla_put_failure;
+	}
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+#endif /* IS_ENABLED(CONFIG_BRIDGE_NETFILTER) */
+
 /* This is an inline function, we don't really care about a long
  * list of arguments */
 static inline int
@@ -580,6 +614,12 @@ __build_packet_message(struct nfnl_log_net *log,
 				 NFULA_CT, NFULA_CT_INFO) < 0)
 		goto nla_put_failure;
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (pf == PF_BRIDGE &&
+	    nfulnl_put_bridge(inst, skb) < 0)
+		goto nla_put_failure;
+#endif
+
 	if (data_len) {
 		struct nlattr *nla;
 		int size = nla_attr_size(data_len);
-- 
2.20.1

