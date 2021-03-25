Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F8AC433E4
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 030A761A1E
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCYR0Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 13:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhCYR0B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 13:26:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009C7C06174A
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Mar 2021 10:26:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lPTk7-0004rc-Kj; Thu, 25 Mar 2021 18:25:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     phil@nwl.cc, Florian Westphal <fw@strlen.de>
Subject: [PATCH 8/8] netfilter: nft_log: perform module load from nf_tables
Date:   Thu, 25 Mar 2021 18:25:12 +0100
Message-Id: <20210325172512.17729-9-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210325172512.17729-1-fw@strlen.de>
References: <20210325172512.17729-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

modprobe calls from the nf_logger_find_get() API causes deadlock in very
special cases because they occur with the nf_tables transaction mutex held.

In the specific case of nf_log, deadlock is via:

 A nf_tables -> transaction mutex -> nft_log -> modprobe -> nf_log_syslog \
	    -> pernet_ops rwsem -> wait for C
 B netlink event -> rtnl_mutex -> nf_tables transaction mutex -> wait for A
 C close() -> ip6mr_sk_done -> rtnl_mutex -> wait for B

Earlier patch added NFLOG/xt_LOG module softdeps to avoid the need to load
the backend module during a transaction.

For nft_log we would have to add a softdep for both nfnetlink_log or
nf_log_syslog, since we do not know in advance which of the two backends
are going to be configured.

This defers the modprobe op until after the transaction mutex is released.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  5 +++++
 net/netfilter/nf_log.c            |  3 ---
 net/netfilter/nf_tables_api.c     |  5 +++--
 net/netfilter/nft_log.c           | 20 +++++++++++++++++++-
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5aaced6bf13e..6f26a38d1766 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1559,4 +1559,9 @@ void nf_tables_trans_destroy_flush_work(void);
 int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
 __be64 nf_jiffies64_to_msecs(u64 input);
 
+#ifdef CONFIG_MODULES
+__printf(2, 3) int nft_request_module(struct net *net, const char *fmt, ...);
+#else
+static inline int nft_request_module(struct net *net, const char *fmt, ...) { return -ENOENT; }
+#endif
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index eaa8181f5ef7..edee7fa944c1 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -170,9 +170,6 @@ int nf_logger_find_get(int pf, enum nf_log_type type)
 		return 0;
 	}
 
-	if (rcu_access_pointer(loggers[pf][type]) == NULL)
-		request_module("nf-logger-%u-%u", pf, type);
-
 	rcu_read_lock();
 	logger = rcu_dereference(loggers[pf][type]);
 	if (logger == NULL)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f57f1a6ba96f..0569aaecec04 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -586,8 +586,8 @@ struct nft_module_request {
 };
 
 #ifdef CONFIG_MODULES
-static __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
-					     ...)
+__printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
+				      ...)
 {
 	char module_name[MODULE_NAME_LEN];
 	struct nft_module_request *req;
@@ -620,6 +620,7 @@ static __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
 
 	return -EAGAIN;
 }
+EXPORT_SYMBOL_GPL(nft_request_module);
 #endif
 
 static void lockdep_nfnl_nft_mutex_not_held(void)
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index a06a46b039c5..54f6c2035e84 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -128,6 +128,20 @@ static const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
 	[NFTA_LOG_FLAGS]	= { .type = NLA_U32 },
 };
 
+static int nft_log_modprobe(struct net *net, enum nf_log_type t)
+{
+	switch (t) {
+	case NF_LOG_TYPE_LOG:
+		return nft_request_module(net, "%s", "nf_log_syslog");
+	case NF_LOG_TYPE_ULOG:
+		return nft_request_module(net, "%s", "nfnetlink_log");
+	case NF_LOG_TYPE_MAX:
+		break;
+	}
+
+	return -ENOENT;
+}
+
 static int nft_log_init(const struct nft_ctx *ctx,
 			const struct nft_expr *expr,
 			const struct nlattr * const tb[])
@@ -197,8 +211,12 @@ static int nft_log_init(const struct nft_ctx *ctx,
 		return 0;
 
 	err = nf_logger_find_get(ctx->family, li->type);
-	if (err < 0)
+	if (err < 0) {
+		if (nft_log_modprobe(ctx->net, li->type) == -EAGAIN)
+			err = -EAGAIN;
+
 		goto err1;
+	}
 
 	return 0;
 
-- 
2.26.3

