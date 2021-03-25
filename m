Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DCCC433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D662061A2A
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCYR0Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 13:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhCYRZ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 13:25:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF0DC06174A
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Mar 2021 10:25:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lPTk3-0004rD-7v; Thu, 25 Mar 2021 18:25:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     phil@nwl.cc, Florian Westphal <fw@strlen.de>
Subject: [PATCH 7/8] netfilter: nf_log: add module softdeps
Date:   Thu, 25 Mar 2021 18:25:11 +0100
Message-Id: <20210325172512.17729-8-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210325172512.17729-1-fw@strlen.de>
References: <20210325172512.17729-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

xt_LOG has no direct dependency on the syslog-based logger, it relies
on the nf_log core to probe the requested backend.

Now that all syslog-based loggers reside in the same module, we can
just add a soft dependency on nf_log_syslog and let modprobe take
care of it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_LOG.c   | 1 +
 net/netfilter/xt_NFLOG.c | 1 +
 net/netfilter/xt_TRACE.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index a1e79b517c01..2ff75f7637b0 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -108,3 +108,4 @@ MODULE_AUTHOR("Jan Rekorajski <baggins@pld.org.pl>");
 MODULE_DESCRIPTION("Xtables: IPv4/IPv6 packet logging");
 MODULE_ALIAS("ipt_LOG");
 MODULE_ALIAS("ip6t_LOG");
+MODULE_SOFTDEP("pre: nf_log_syslog");
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 6e83ce3000db..fb5793208059 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -79,3 +79,4 @@ static void __exit nflog_tg_exit(void)
 
 module_init(nflog_tg_init);
 module_exit(nflog_tg_exit);
+MODULE_SOFTDEP("pre: nfnetlink_log");
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index 349ab5609b1b..5582dce98cae 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -52,3 +52,4 @@ static void __exit trace_tg_exit(void)
 
 module_init(trace_tg_init);
 module_exit(trace_tg_exit);
+MODULE_SOFTDEP("pre: nf_log_syslog");
-- 
2.26.3

