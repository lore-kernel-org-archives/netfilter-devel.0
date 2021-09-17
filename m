Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EEEC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 16:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D5960EFF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 16:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhIQQvv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 12:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbhIQQvv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 12:51:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B685C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 09:50:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mRH4E-00034z-Lw; Fri, 17 Sep 2021 18:50:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>
Subject: [PATCH nf] netfilter: log: work around missing softdep backend module
Date:   Fri, 17 Sep 2021 18:50:17 +0200
Message-Id: <20210917165017.3636-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

iptables/nftables has two types of log modules:

1. backend, e.g. nf_log_syslog, which implement the functionality
2. frontend, e.g. xt_LOG or nft_log, which call the functionality
   provided by backend based on nf_tables or xtables rule set.

Problem is that the request_module() call to load the backed in
nf_logger_find_get() might happen with nftables transaction mutex held
in case the call path is via nf_tables/nft_compat.

This can cause deadlocks (see 'Fixes' tags for details).

The chosen solution as to let modprobe deal with this by adding 'pre: '
soft dep tag to xt_LOG (to load the syslog backend) and xt_NFLOG (to
load nflog backend).

Eric reports that this breaks on systems with older modprobe that
doesn't support softdeps.

Another, similar issue occurs when someone either insmods xt_(NF)LOG
directly or unloads the backend module (possible if no log frontend
is in use): because the frontend module is already loaded, modprobe is
not invoked again so the softdep isn't evaluated.

Add a workaround: If nf_logger_find_get() returns -ENOENT and call
is not via nft_compat, load the backend explicitly and try again.

Else, let nft_compat ask for deferred request_module via nf_tables
infra.

Softdeps are kept in-place, so with newer modprobe the dependencies
are resolved from userspace.

Fixes: cefa31a9d461 ("netfilter: nft_log: perform module load from nf_tables")
Fixes: a38b5b56d6f4 ("netfilter: nf_log: add module softdeps")
Reported-and-tested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 A bit ugly, but it should fix the bug.

 I can get iptables (legacy and nft) to fail by:
 modprobe xt_LOG
 rmmod nf_log_syslog
 iptables -o nono -j LOG

 ... as modprobe isn't called again, so softdep has no effect.

 After this change, both iptables-nft and iptables-legacy flavours
 work for me again.

 net/netfilter/nft_compat.c | 17 ++++++++++++++++-
 net/netfilter/xt_LOG.c     | 10 +++++++++-
 net/netfilter/xt_NFLOG.c   | 10 +++++++++-
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 272bcdb1392d..f69cc73c5813 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_arp/arp_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_log.h>
 
 /* Used for matches where *info is larger than X byte */
 #define NFT_MATCH_LARGE_THRESH	192
@@ -257,8 +258,22 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	nft_compat_wait_for_destructors();
 
 	ret = xt_check_target(&par, size, proto, inv);
-	if (ret < 0)
+	if (ret < 0) {
+		if (ret == -ENOENT) {
+			const char *modname = NULL;
+
+			if (strcmp(target->name, "LOG") == 0)
+				modname = "nf_log_syslog";
+			else if (strcmp(target->name, "NFLOG") == 0)
+				modname = "nfnetlink_log";
+
+			if (modname &&
+			    nft_request_module(ctx->net, "%s", modname) == -EAGAIN)
+				return -EAGAIN;
+		}
+
 		return ret;
+	}
 
 	/* The standard target cannot be used */
 	if (!target->target)
diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index 2ff75f7637b0..f39244f9c0ed 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -44,6 +44,7 @@ log_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int log_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_log_info *loginfo = par->targinfo;
+	int ret;
 
 	if (par->family != NFPROTO_IPV4 && par->family != NFPROTO_IPV6)
 		return -EINVAL;
@@ -58,7 +59,14 @@ static int log_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 	}
 
-	return nf_logger_find_get(par->family, NF_LOG_TYPE_LOG);
+	ret = nf_logger_find_get(par->family, NF_LOG_TYPE_LOG);
+	if (ret != 0 && !par->nft_compat) {
+		request_module("%s", "nf_log_syslog");
+
+		ret = nf_logger_find_get(par->family, NF_LOG_TYPE_LOG);
+	}
+
+	return ret;
 }
 
 static void log_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index fb5793208059..e660c3710a10 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -42,13 +42,21 @@ nflog_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int nflog_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_nflog_info *info = par->targinfo;
+	int ret;
 
 	if (info->flags & ~XT_NFLOG_MASK)
 		return -EINVAL;
 	if (info->prefix[sizeof(info->prefix) - 1] != '\0')
 		return -EINVAL;
 
-	return nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
+	ret = nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
+	if (ret != 0 && !par->nft_compat) {
+		request_module("%s", "nfnetlink_log");
+
+		ret = nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
+	}
+
+	return ret;
 }
 
 static void nflog_tg_destroy(const struct xt_tgdtor_param *par)
-- 
2.32.0

