Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DATE_IN_PAST_24_48,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AFEC10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 06:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76A512082A
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 06:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1Pg6nj6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfDIGfe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 02:35:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44402 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfDIGfd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 02:35:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id y13so9078759pfm.11
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Apr 2019 23:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JFYxyPDDtspumkweNlVuezz1JvJCwBQxRjB9a8aVYgo=;
        b=m1Pg6nj6aHjbwCOee7jeH0sxqr99yOt2OwloBl1IyrDr8Y89oa3t2xGanhq2wa/xKG
         S4VJ4XiOf6GuT5tOzFLp8TkSFsDhXxg/MMXDfiavH4oWk1E+2NKbGEqXgCxrCJmA4K9m
         02kz+6WOSNFYcFi+dceZb4aVN0EqWUUs5YsRUm24IdaHoHa0op7SZIHPiYE8a5NfkJRZ
         Gt2wl/spH4vddxdS7BNM85g1F5xGzuQfU+/rRz2meLNAnCBTKsUWLWEsQSVt+0OmW6PX
         jHkEFnx8T3lB7c5fXSo34XQ7qSlfJN0pKGMvMNR93nO42j0xRK42jkvG4O4ZPslbx9KO
         Abpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JFYxyPDDtspumkweNlVuezz1JvJCwBQxRjB9a8aVYgo=;
        b=IkxH4uxFTQYJWeMQJVjhmDX9MIk2ErsGDBh2s1mvit79hMjXNXDZOebWbnKw14fokY
         5k5A2ME//VW/tYcXJmlvjLbFb034HpE9hwZjNgrIWnwtrCFbIrJt2xlTNDX58Gh5wUpW
         2E+jqGMca60zFmf3hJjwtd5du95ab38P48rkPJMLThdvd5dXAFOQEXHoWMwfI4UhPfXv
         jR6be4pKnVirbb5+Fj01B5neIekOxpBB9avHEEGFwJvN9okyO7G2V5hBkN+d+bvFSgR3
         gohXl47dMge0NCNzAcSGG6KOn6Bt/Qtui8cMQ9EObT7aFpnyFNzUUY+Wss5hrblk1zwe
         Uc0A==
X-Gm-Message-State: APjAAAWHThq7FzL1Nqn+57+uiR87jR3H92rO9VhHz3X6skbazKPe7lXl
        vY9eCBKbl2C7iED5f3QJdzo=
X-Google-Smtp-Source: APXvYqyWc8tvLZlhfChqKFUvLcIejfQbDLuSOv8tKoORRQgjYHekck88U1s663BT2gp33cBMgYjp4Q==
X-Received: by 2002:aa7:8208:: with SMTP id k8mr35197638pfi.69.1554791732789;
        Mon, 08 Apr 2019 23:35:32 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id t64sm73152000pfa.86.2019.04.08.23.35.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 23:35:32 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH] netfilter: conntrack: limit sysctl setting for boolean options
Date:   Sun,  7 Apr 2019 08:14:20 -0700
Message-Id: <1554650060-34568-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We use the zero and one to limit the boolean options setting.
After this patch we only set 0 or 1 to boolean options for nf
conntrack sysctl.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 include/net/netns/conntrack.h           |  6 ++---
 net/netfilter/nf_conntrack_standalone.c | 48 ++++++++++++++++++++++-----------
 2 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index f19b531..806454e 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -24,9 +24,9 @@ struct nf_generic_net {
 
 struct nf_tcp_net {
 	unsigned int timeouts[TCP_CONNTRACK_TIMEOUT_MAX];
-	unsigned int tcp_loose;
-	unsigned int tcp_be_liberal;
-	unsigned int tcp_max_retrans;
+	int tcp_loose;
+	int tcp_be_liberal;
+	int tcp_max_retrans;
 };
 
 enum udp_conntrack {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index c2ae14c..e0d392c 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -511,6 +511,8 @@ static void nf_conntrack_standalone_fini_proc(struct net *net)
 /* Log invalid packets of a given protocol */
 static int log_invalid_proto_min __read_mostly;
 static int log_invalid_proto_max __read_mostly = 255;
+static int zero;
+static int one = 1;
 
 /* size the user *wants to set */
 static unsigned int nf_conntrack_htable_size_user __read_mostly;
@@ -624,9 +626,11 @@ enum nf_ct_sysctl_index {
 	[NF_SYSCTL_CT_CHECKSUM] = {
 		.procname	= "nf_conntrack_checksum",
 		.data		= &init_net.ct.sysctl_checksum,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 	[NF_SYSCTL_CT_LOG_INVALID] = {
 		.procname	= "nf_conntrack_log_invalid",
@@ -647,33 +651,41 @@ enum nf_ct_sysctl_index {
 	[NF_SYSCTL_CT_ACCT] = {
 		.procname	= "nf_conntrack_acct",
 		.data		= &init_net.ct.sysctl_acct,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 	[NF_SYSCTL_CT_HELPER] = {
 		.procname	= "nf_conntrack_helper",
 		.data		= &init_net.ct.sysctl_auto_assign_helper,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	[NF_SYSCTL_CT_EVENTS] = {
 		.procname	= "nf_conntrack_events",
 		.data		= &init_net.ct.sysctl_events,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 #endif
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 	[NF_SYSCTL_CT_TIMESTAMP] = {
 		.procname	= "nf_conntrack_timestamp",
 		.data		= &init_net.ct.sysctl_tstamp,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 #endif
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC] = {
@@ -744,15 +756,19 @@ enum nf_ct_sysctl_index {
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LOOSE] = {
 		.procname	= "nf_conntrack_tcp_loose",
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LIBERAL] = {
 		.procname       = "nf_conntrack_tcp_be_liberal",
-		.maxlen         = sizeof(unsigned int),
+		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS] = {
 		.procname	= "nf_conntrack_tcp_max_retrans",
@@ -887,7 +903,9 @@ enum nf_ct_sysctl_index {
 		.procname	= "nf_conntrack_dccp_loose",
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 #endif
 #ifdef CONFIG_NF_CT_PROTO_GRE
-- 
1.8.3.1

