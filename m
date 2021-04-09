Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7DDC433B4
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Apr 2021 13:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED882610A4
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Apr 2021 13:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhDINbr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 09:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbhDINbq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 09:31:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1654C061760
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Apr 2021 06:31:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lUrES-0006l4-Hs; Fri, 09 Apr 2021 15:31:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/5] netfilter: conntrack: convert sysctls to u8
Date:   Fri,  9 Apr 2021 15:30:59 +0200
Message-Id: <20210409133059.17963-6-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210409133059.17963-1-fw@strlen.de>
References: <20210409133059.17963-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

log_invalid sysctl allows values of 0 to 255 inclusive so we no longer
need a range check: the min/max values can be removed.

This also removes all member variables that were moved to net_generic
data in previous patches.

This reduces size of netns_ct struct by one cache line.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netns/conntrack.h           | 23 ++++++--------
 net/netfilter/nf_conntrack_proto_tcp.c  | 34 ++++++++++----------
 net/netfilter/nf_conntrack_standalone.c | 42 +++++++++++--------------
 3 files changed, 45 insertions(+), 54 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index e5f664d69ead..ad0a95c2335e 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -24,9 +24,9 @@ struct nf_generic_net {
 
 struct nf_tcp_net {
 	unsigned int timeouts[TCP_CONNTRACK_TIMEOUT_MAX];
-	int tcp_loose;
-	int tcp_be_liberal;
-	int tcp_max_retrans;
+	u8 tcp_loose;
+	u8 tcp_be_liberal;
+	u8 tcp_max_retrans;
 };
 
 enum udp_conntrack {
@@ -45,7 +45,7 @@ struct nf_icmp_net {
 
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 struct nf_dccp_net {
-	int dccp_loose;
+	u8 dccp_loose;
 	unsigned int dccp_timeout[CT_DCCP_MAX + 1];
 };
 #endif
@@ -93,18 +93,15 @@ struct ct_pcpu {
 };
 
 struct netns_ct {
-	atomic_t		count;
-	unsigned int		expect_count;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	bool ecache_dwork_pending;
 #endif
-	bool			auto_assign_helper_warned;
-	unsigned int		sysctl_log_invalid; /* Log invalid packets */
-	int			sysctl_events;
-	int			sysctl_acct;
-	int			sysctl_auto_assign_helper;
-	int			sysctl_tstamp;
-	int			sysctl_checksum;
+	u8			sysctl_log_invalid; /* Log invalid packets */
+	u8			sysctl_events;
+	u8			sysctl_acct;
+	u8			sysctl_auto_assign_helper;
+	u8			sysctl_tstamp;
+	u8			sysctl_checksum;
 
 	struct ct_pcpu __percpu *pcpu_lists;
 	struct ip_conntrack_stat __percpu *stat;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ec23330687a5..318b8f723349 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -31,20 +31,6 @@
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
-/* "Be conservative in what you do,
-    be liberal in what you accept from others."
-    If it's non-zero, we mark only out of window RST segments as INVALID. */
-static int nf_ct_tcp_be_liberal __read_mostly = 0;
-
-/* If it is set to zero, we disable picking up already established
-   connections. */
-static int nf_ct_tcp_loose __read_mostly = 1;
-
-/* Max number of the retransmitted packets without receiving an (acceptable)
-   ACK from the destination. If this number is reached, a shorter timer
-   will be started. */
-static int nf_ct_tcp_max_retrans __read_mostly = 3;
-
   /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
      closely.  They're more complex. --RR */
 
@@ -1436,9 +1422,23 @@ void nf_conntrack_tcp_init_net(struct net *net)
 	 * ->timeouts[0] contains 'new' timeout, like udp or icmp.
 	 */
 	tn->timeouts[0] = tcp_timeouts[TCP_CONNTRACK_SYN_SENT];
-	tn->tcp_loose = nf_ct_tcp_loose;
-	tn->tcp_be_liberal = nf_ct_tcp_be_liberal;
-	tn->tcp_max_retrans = nf_ct_tcp_max_retrans;
+
+	/* If it is set to zero, we disable picking up already established
+	 * connections.
+	 */
+	tn->tcp_loose = 1;
+
+	/* "Be conservative in what you do,
+	 *  be liberal in what you accept from others."
+	 * If it's non-zero, we mark only out of window RST segments as INVALID.
+	 */
+	tn->tcp_be_liberal = 0;
+
+	/* Max number of the retransmitted packets without receiving an (acceptable)
+	 * ACK from the destination. If this number is reached, a shorter timer
+	 * will be started.
+	 */
+	tn->tcp_max_retrans = 3;
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp =
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3f87a71717a2..00ab1666d11c 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -522,10 +522,6 @@ static void nf_conntrack_standalone_fini_proc(struct net *net)
 /* Sysctl support */
 
 #ifdef CONFIG_SYSCTL
-/* Log invalid packets of a given protocol */
-static int log_invalid_proto_min __read_mostly;
-static int log_invalid_proto_max __read_mostly = 255;
-
 /* size the user *wants to set */
 static unsigned int nf_conntrack_htable_size_user __read_mostly;
 
@@ -640,20 +636,18 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_CHECKSUM] = {
 		.procname	= "nf_conntrack_checksum",
 		.data		= &init_net.ct.sysctl_checksum,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_LOG_INVALID] = {
 		.procname	= "nf_conntrack_log_invalid",
 		.data		= &init_net.ct.sysctl_log_invalid,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &log_invalid_proto_min,
-		.extra2		= &log_invalid_proto_max,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	[NF_SYSCTL_CT_EXPECT_MAX] = {
 		.procname	= "nf_conntrack_expect_max",
@@ -665,9 +659,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_ACCT] = {
 		.procname	= "nf_conntrack_acct",
 		.data		= &init_net.ct.sysctl_acct,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
@@ -683,9 +677,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_EVENTS] = {
 		.procname	= "nf_conntrack_events",
 		.data		= &init_net.ct.sysctl_events,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
@@ -694,9 +688,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_TIMESTAMP] = {
 		.procname	= "nf_conntrack_timestamp",
 		.data		= &init_net.ct.sysctl_tstamp,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
@@ -769,25 +763,25 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LOOSE] = {
 		.procname	= "nf_conntrack_tcp_loose",
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LIBERAL] = {
 		.procname       = "nf_conntrack_tcp_be_liberal",
-		.maxlen         = sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode           = 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS] = {
 		.procname	= "nf_conntrack_tcp_max_retrans",
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP] = {
 		.procname	= "nf_conntrack_udp_timeout",
@@ -914,9 +908,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_PROTO_DCCP_LOOSE] = {
 		.procname	= "nf_conntrack_dccp_loose",
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
-- 
2.26.3

