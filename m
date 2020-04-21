Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE99C54FCC
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 15:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63940206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 15:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgDUPFv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:05:51 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59875 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726628AbgDUPFu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 11:05:50 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from bodong@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 Apr 2020 18:05:47 +0300
Received: from sw-mtx-017.mtx.labs.mlnx. (sw-mtx-017.mtx.labs.mlnx [10.9.150.103])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03LF5kvN007815;
        Tue, 21 Apr 2020 18:05:46 +0300
From:   Bodong Wang <bodong@mellanox.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, ozsh@mellanox.com, paulb@mellanox.com,
        Bodong Wang <bodong@mellanox.com>
Subject: [nf-next V2] netfilter: nf_conntrack, add IPS_HW_OFFLOAD status bit
Date:   Tue, 21 Apr 2020 10:04:16 -0500
Message-Id: <20200421150416.19151-1-bodong@mellanox.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This bit indicates that the conntrack entry is offloaded to hardware
flow table. nf_conntrack entry will be tagged with [HW_OFFLOAD] if
it's offload to hardware.

cat /proc/net/nf_conntrack
	ipv4 2 tcp 6 \
	src=1.1.1.17 dst=1.1.1.16 sport=56394 dport=5001 \
	src=1.1.1.16 dst=1.1.1.17 sport=5001 dport=56394 [HW_OFFLOAD] \
	mark=0 zone=0 use=3

Note that HW_OFFLOAD/OFFLOAD/ASSURED are mutually exclusive.

Changelog:

* V1->V2:
- Remove check of lastused from stats. It was meant for cases such
  as removing driver module while traffic still running. Better to
  handle such cases from garbage collector.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h | 8 ++++++--
 net/netfilter/nf_conntrack_standalone.c            | 4 +++-
 net/netfilter/nf_flow_table_offload.c              | 3 +++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index b6f0bb1dc799..4b3395082d15 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -114,15 +114,19 @@ enum ip_conntrack_status {
 	IPS_OFFLOAD_BIT = 14,
 	IPS_OFFLOAD = (1 << IPS_OFFLOAD_BIT),
 
+	/* Conntrack has been offloaded to hardware. */
+	IPS_HW_OFFLOAD_BIT = 15,
+	IPS_HW_OFFLOAD = (1 << IPS_HW_OFFLOAD_BIT),
+
 	/* Be careful here, modifying these bits can make things messy,
 	 * so don't let users modify them directly.
 	 */
 	IPS_UNCHANGEABLE_MASK = (IPS_NAT_DONE_MASK | IPS_NAT_MASK |
 				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING |
 				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_UNTRACKED |
-				 IPS_OFFLOAD),
+				 IPS_OFFLOAD | IPS_HW_OFFLOAD),
 
-	__IPS_MAX_BIT = 15,
+	__IPS_MAX_BIT = 16,
 };
 
 /* Connection tracking event types */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9b57330c81f8..5a3e6c43ee68 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -348,7 +348,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
 		goto release;
 
-	if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
+	if (test_bit(IPS_HW_OFFLOAD_BIT, &ct->status))
+		seq_puts(s, "[HW_OFFLOAD] ");
+	else if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
 		seq_puts(s, "[OFFLOAD] ");
 	else if (test_bit(IPS_ASSURED_BIT, &ct->status))
 		seq_puts(s, "[ASSURED] ");
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e3b099c14eff..a2abb0feab7f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -754,12 +754,15 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 	err = flow_offload_rule_add(offload, flow_rule);
 	if (err < 0)
 		set_bit(NF_FLOW_HW_REFRESH, &offload->flow->flags);
+	else
+		set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 
 	nf_flow_offload_destroy(flow_rule);
 }
 
 static void flow_offload_work_del(struct flow_offload_work *offload)
 {
+	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
 	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
-- 
2.21.1

