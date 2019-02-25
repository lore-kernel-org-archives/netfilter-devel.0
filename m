Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F8AC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 12:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49A3F217F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 12:33:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cRJPjJWD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfBZMdI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:33:08 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43342 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfBZMdH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 07:33:07 -0500
Received: by mail-pf1-f193.google.com with SMTP id q17so6176910pfh.10
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Feb 2019 04:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JFYxyPDDtspumkweNlVuezz1JvJCwBQxRjB9a8aVYgo=;
        b=cRJPjJWDDmHF+A1xQsaAXKVIuPhMrOtqhqxat/iXzxHapOv0b1ZeutO4m35oB3VslT
         LRbGKz+fsI5AvsmcjYzzCKHsCN/u6CY63CgA2i60vS+4vRTZbya6+q0WbbJJjw6qO6sU
         IbTF3lzaZAECEuwz1eNTH1nAWpE4lhmjRgrj2QPksY2JjGxv7lcQM4KGbZ2j1CUlA6Nw
         QooCGDe5mlB94Jgv+zNz8imVsoucR9cRViUh2Lzx4BvOLL+lN+b/+nhij5tWwIJdMeBV
         k5I4uobt5Ald1WZlkKu41PksTZ9+Wbju6X8rr6ZW63n76fRw47k7zD1cMKnPYb/MrXSn
         rziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JFYxyPDDtspumkweNlVuezz1JvJCwBQxRjB9a8aVYgo=;
        b=H2ZkeKyJadyTwJzUGM3yeyW5ZteACrp/tZi1LyjhvyVdQu6uGaZTUvpw7KiywKEfEe
         DWHOHAO2EH94nxbXyK9WGi4L3L8mk2SikBYCtzkfXaqzmn9XZMWgpwPWHrfECp9mI4Po
         C3HsExLLF+1D7Etl4eemktNjN0zDJY6ukCgeMSThRbKLmEn7NFwhnfGD7Fe7HwUbv9tR
         r0nakXqk1MXksLem1U6qNo0Y7ijWlBQy/ARMGFBKmUUiLbxD/OUeD6mCMgIxWsUR99Ka
         7h0XXl1CSMRb/UIy2Ptge81FMqiPugKs7/f/zBYdpXtzVO9ljOic4QC+lM1uKb2rWLSA
         5RFg==
X-Gm-Message-State: AHQUAuYkmF1w9jvlAtCH4z179KFfvzp3aAqXtNVV65VKwJQl27LgJ68E
        ydEeKDTkEQIeZYFEDE863GwN0VQl
X-Google-Smtp-Source: AHgI3IZRpx+R4SajmGTtlWth+gTzGtlFm1UMROiDh+2pgnqVNj7oDZG3cWsNOwef4Ps8ZXuSC7Plmw==
X-Received: by 2002:a65:508b:: with SMTP id r11mr4379147pgp.242.1551184386790;
        Tue, 26 Feb 2019 04:33:06 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id 23sm25953443pft.187.2019.02.26.04.33.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 04:33:06 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netfilter-devel@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH] netfilter: conntrack: limit sysctl setting for boolean options
Date:   Mon, 25 Feb 2019 15:31:53 -0800
Message-Id: <1551137513-25153-1-git-send-email-xiangxia.m.yue@gmail.com>
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

