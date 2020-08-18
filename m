Return-Path: <SRS0=5oex=B4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E020CC433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Aug 2020 14:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA579207FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Aug 2020 14:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgHROQQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgHROQL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Aug 2020 10:16:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2C9C061389
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2020 07:16:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k82PD-0007M1-R7; Tue, 18 Aug 2020 16:16:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2] netfilter: conntrack: allow sctp hearbeat after connection re-use
Date:   Tue, 18 Aug 2020 16:15:58 +0200
Message-Id: <20200818141558.24232-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If an sctp connection gets re-used, heartbeats are flagged as invalid
because their vtag doesn't match.

Handle this in a similar way as TCP conntrack when it suspects that the
endpoints and conntrack are out-of-sync.

When a HEARTBEAT request fails its vtag validation, flag this in the
conntrack state and accept the packet.

When a HEARTBEAT_ACK is received with an invalid vtag in the reverse
direction after we allowed such a HEARTBEAT through, assume we are
out-of-sync and re-set the vtag info.

v2: remove left-over snippet from an older incarnation that moved
    new_state/old_state assignments, thats not needed so keep that
    as-is.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_conntrack_sctp.h |  2 ++
 net/netfilter/nf_conntrack_proto_sctp.c     | 39 ++++++++++++++++++---
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sctp.h b/include/linux/netfilter/nf_conntrack_sctp.h
index 9a33f171aa82..625f491b95de 100644
--- a/include/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/linux/netfilter/nf_conntrack_sctp.h
@@ -9,6 +9,8 @@ struct ip_ct_sctp {
 	enum sctp_conntrack state;
 
 	__be32 vtag[IP_CT_DIR_MAX];
+	u8 last_dir;
+	u8 flags;
 };
 
 #endif /* _NF_CONNTRACK_SCTP_H */
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 4f897b14b606..810cca24b399 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -62,6 +62,8 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 	[SCTP_CONNTRACK_HEARTBEAT_ACKED]	= 210 SECS,
 };
 
+#define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
+
 #define sNO SCTP_CONNTRACK_NONE
 #define	sCL SCTP_CONNTRACK_CLOSED
 #define	sCW SCTP_CONNTRACK_COOKIE_WAIT
@@ -369,6 +371,7 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 	u_int32_t offset, count;
 	unsigned int *timeouts;
 	unsigned long map[256 / sizeof(unsigned long)] = { 0 };
+	bool ignore = false;
 
 	if (sctp_error(skb, dataoff, state))
 		return -NF_ACCEPT;
@@ -427,15 +430,39 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			/* Sec 8.5.1 (D) */
 			if (sh->vtag != ct->proto.sctp.vtag[dir])
 				goto out_unlock;
-		} else if (sch->type == SCTP_CID_HEARTBEAT ||
-			   sch->type == SCTP_CID_HEARTBEAT_ACK) {
+		} else if (sch->type == SCTP_CID_HEARTBEAT) {
+			if (ct->proto.sctp.vtag[dir] == 0) {
+				pr_debug("Setting %d vtag %x for dir %d\n", sch->type, sh->vtag, dir);
+				ct->proto.sctp.vtag[dir] = sh->vtag;
+			} else if (sh->vtag != ct->proto.sctp.vtag[dir]) {
+				if (test_bit(SCTP_CID_DATA, map) || ignore)
+					goto out_unlock;
+
+				ct->proto.sctp.flags |= SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
+				ct->proto.sctp.last_dir = dir;
+				ignore = true;
+				continue;
+			} else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
+				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
+			}
+		} else if (sch->type == SCTP_CID_HEARTBEAT_ACK) {
 			if (ct->proto.sctp.vtag[dir] == 0) {
 				pr_debug("Setting vtag %x for dir %d\n",
 					 sh->vtag, dir);
 				ct->proto.sctp.vtag[dir] = sh->vtag;
 			} else if (sh->vtag != ct->proto.sctp.vtag[dir]) {
-				pr_debug("Verification tag check failed\n");
-				goto out_unlock;
+				if (test_bit(SCTP_CID_DATA, map) || ignore)
+					goto out_unlock;
+
+				if ((ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) == 0 ||
+				    ct->proto.sctp.last_dir == dir)
+					goto out_unlock;
+
+				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
+				ct->proto.sctp.vtag[dir] = sh->vtag;
+				ct->proto.sctp.vtag[!dir] = 0;
+			} else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
+				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
 			}
 		}
 
@@ -470,6 +497,10 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 	}
 	spin_unlock_bh(&ct->lock);
 
+	/* allow but do not refresh timeout */
+	if (ignore)
+		return NF_ACCEPT;
+
 	timeouts = nf_ct_timeout_lookup(ct);
 	if (!timeouts)
 		timeouts = nf_sctp_pernet(nf_ct_net(ct))->timeouts;
-- 
2.26.2

