Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C10C76194
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 01:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6CD622389
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 01:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbfGWBXQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 21:23:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45252 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfGWBXP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 21:23:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so41236209wre.12
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 18:23:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WZU7Jdw+Za8incNJbIujsUd2IOXhC/sdGHLUcurCpXQ=;
        b=dSthTIJTEnE04dAIH4fn8rWCB4c/Z5cbOZLkWjksNdsiuc0Ua4IPQ2a91QofdEA1bH
         XI3gtcG2owbUEMGCGN1CRFBK4x+0S0t0rySGa3SxKulkyn+RGL95TJwHxFcb17r9qXms
         N7nfoqmuQh6FSwbkKoGIMUBobZQHgdkW+FTpDr24vsZSO9qeWNXfSDOGknb1FYYSB++Q
         otiajVg5BVyRS46kncWoixq6UqDJKHrJzw3m39hQbx7gMx68vou7Lw/DujmIQm3AIlZU
         58ZMihl9CdpcbG91lG12sm58/kdT9nb6X52QAuehJo4aICj8Lble3Npqb2+JzRzDSmDS
         1qhQ==
X-Gm-Message-State: APjAAAXhIjI033bN0m7Sk3WsPIXuJ95lAZbp4symZEXaG0+1QbRveWho
        UFLGPVLulB82llpqaVlV0s5HUQ==
X-Google-Smtp-Source: APXvYqw6MqaxdOJaVGoaJo1c7G78C3DB4nyV97RY1PR2+fqWaKurkxVjls7r/PsI13hDNxjqzg628w==
X-Received: by 2002:a5d:630c:: with SMTP id i12mr72191361wru.312.1563844993487;
        Mon, 22 Jul 2019 18:23:13 -0700 (PDT)
Received: from mcroce-redhat.redhat.com (host21-50-dynamic.21-87-r.retail.telecomitalia.it. [87.21.50.21])
        by smtp.gmail.com with ESMTPSA id c9sm35196753wml.41.2019.07.22.18.23.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 18:23:12 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next] netfilter: conntrack: use shared sysctl constants
Date:   Tue, 23 Jul 2019 03:23:03 +0200
Message-Id: <20190723012303.2221-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use shared sysctl variables for zero and one constants, as in commit
eec4844fae7c ("proc/sysctl: add shared variables for range check")

Fixes: 8f14c99c7eda ("netfilter: conntrack: limit sysctl setting for boolean options")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/netfilter/nf_conntrack_standalone.c | 34 ++++++++++++-------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e0d392cb3075..d97f4ea47cf3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -511,8 +511,6 @@ static void nf_conntrack_standalone_fini_proc(struct net *net)
 /* Log invalid packets of a given protocol */
 static int log_invalid_proto_min __read_mostly;
 static int log_invalid_proto_max __read_mostly = 255;
-static int zero;
-static int one = 1;
 
 /* size the user *wants to set */
 static unsigned int nf_conntrack_htable_size_user __read_mostly;
@@ -629,8 +627,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_LOG_INVALID] = {
 		.procname	= "nf_conntrack_log_invalid",
@@ -654,8 +652,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_HELPER] = {
 		.procname	= "nf_conntrack_helper",
@@ -663,8 +661,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	[NF_SYSCTL_CT_EVENTS] = {
@@ -673,8 +671,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #endif
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
@@ -684,8 +682,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #endif
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC] = {
@@ -759,16 +757,16 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LIBERAL] = {
 		.procname       = "nf_conntrack_tcp_be_liberal",
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS] = {
 		.procname	= "nf_conntrack_tcp_max_retrans",
@@ -904,8 +902,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #endif
 #ifdef CONFIG_NF_CT_PROTO_GRE
-- 
2.21.0

