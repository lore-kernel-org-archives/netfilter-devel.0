Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0CBC47089
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 May 2021 09:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DDD76117A
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 May 2021 09:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhEZJd2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 May 2021 05:33:28 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49788 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbhEZJdW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 May 2021 05:33:22 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9D236218CC
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2021 09:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622021085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=hVpYXCCTVSQI9yW3uMnP7SaIqy535/VoNRubHJR5fBM=;
        b=XMgd3J8tgODUJB64SxN8+m9W7B6cIB0nT3n9BFwgcKiKwtQLHfSQ7fiIJwhd7anH1eV3KI
        b6WziACyA7fHKKP0TGCQCScENYdcxp+416xXV5q+yUkHhTGVo2Ntmou/jjickDggeYMImg
        zCkiCEllOFf4Xow3s5AJYKfKkjaHkmM=
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id 78CF311A98
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2021 09:24:45 +0000 (UTC)
Date:   Wed, 26 May 2021 11:24:44 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: conntrack: add new sysctl to disable RST check
Message-ID: <20210526092444.lca726ghsrli5fpx@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a new sysctl tcp_ignore_invalid_rst to disable marking
out of segments RSTs as INVALID.

Signed-off-by: Ali Abdallah <aabdallah@suse.de>
---
 Documentation/networking/nf_conntrack-sysctl.rst |  6 ++++++
 include/net/netns/conntrack.h                    |  1 +
 net/netfilter/nf_conntrack_proto_tcp.c           |  6 +++++-
 net/netfilter/nf_conntrack_standalone.c          | 10 ++++++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 11a9b76786cb..45f5a9690172 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -110,6 +110,12 @@ nf_conntrack_tcp_be_liberal - BOOLEAN
 	Be conservative in what you do, be liberal in what you accept from others.
 	If it's non-zero, we mark only out of window RST segments as INVALID.
 
+nf_conntrack_tcp_ignore_invalid_rst - BOOLEAN
+	- 0 - disabled (default)
+	- not 0 - enabled
+
+	If it's non-zero, we don't mark out of window RST segments as INVALID.
+
 nf_conntrack_tcp_loose - BOOLEAN
 	- 0 - disabled
 	- not 0 - enabled (default)
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index ad0a95c2335e..473acd7cce9c 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -27,6 +27,7 @@ struct nf_tcp_net {
 	u8 tcp_loose;
 	u8 tcp_be_liberal;
 	u8 tcp_max_retrans;
+	u8 tcp_ignore_invalid_rst;
 };
 
 enum udp_conntrack {
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 34e22416a721..1a5e77b05514 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1032,7 +1032,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		if (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET) {
 			u32 seq = ntohl(th->seq);
 
-			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack)) {
+			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack) &&
+			    !tn->tcp_ignore_invalid_rst) {
 				/* Invalid RST  */
 				spin_unlock_bh(&ct->lock);
 				nf_ct_l4proto_log_invalid(skb, ct, "invalid rst");
@@ -1436,6 +1437,9 @@ void nf_conntrack_tcp_init_net(struct net *net)
 	 */
 	tn->tcp_be_liberal = 0;
 
+	/* If it's non-zero, we turn off RST sequence number check */
+	tn->tcp_ignore_invalid_rst = 0;
+
 	/* Max number of the retransmitted packets without receiving an (acceptable)
 	 * ACK from the destination. If this number is reached, a shorter timer
 	 * will be started.
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index aaa55246d0ca..9341be6b142f 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -577,6 +577,7 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_UNACK,
 	NF_SYSCTL_CT_PROTO_TCP_LOOSE,
 	NF_SYSCTL_CT_PROTO_TCP_LIBERAL,
+	NF_SYSCTL_CT_PROTO_TCP_IGNORE_INVALID_RST,
 	NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM,
@@ -778,6 +779,14 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
+	[NF_SYSCTL_CT_PROTO_TCP_IGNORE_INVALID_RST] = {
+		.procname	= "nf_conntrack_tcp_ignore_invalid_rst",
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	[NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS] = {
 		.procname	= "nf_conntrack_tcp_max_retrans",
 		.maxlen		= sizeof(u8),
@@ -970,6 +979,7 @@ static void nf_conntrack_standalone_init_tcp_sysctl(struct net *net,
 	XASSIGN(LOOSE, &tn->tcp_loose);
 	XASSIGN(LIBERAL, &tn->tcp_be_liberal);
 	XASSIGN(MAX_RETRANS, &tn->tcp_max_retrans);
+	XASSIGN(IGNORE_INVALID_RST, &tn->tcp_ignore_invalid_rst);
 #undef XASSIGN
 }
 
-- 
2.26.2
