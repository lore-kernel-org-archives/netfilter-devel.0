Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E3BC32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 22:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiI1WdC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 18:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiI1WdB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 18:33:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0169F543F0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 15:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7FvEwTCt9PZ+huxw1mDmNpN6zZDjCz7y9RI7gjI0ATQ=; b=ZHIDn98QIJVYOKy6j+iG2hEPlF
        Nto5ZlUnyiembHZVdmPDxuGiWx3vzELRTVCu/7vMeMOUUjxhFxu9gRsOkG4w9ulCfkuSMj0sPK7tK
        7e3nIbwtefynlBkN8hWE5I8i/4vylFrf5nZTEOXom7T2ltgMlbOtummO9JgmqQx3nDxXHV8pVKtjg
        vSSIw2xyIMVm0iUddNkmsIZlmn+/xh5h4VbB1SlPkofputt1hES5rADLuKaQzJgz1i9p5z+fo5ZfM
        xkmTxW4BeN4QmmCP8YlM342PwRVDBHESncZs8pgKuOs0rFZ2Rey21EjH6Z6xjS+jeO92t3poYhsPR
        CohONBag==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1odfbt-0005IQ-8E; Thu, 29 Sep 2022 00:32:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] monitor: Sanitize startup race condition
Date:   Thu, 29 Sep 2022 00:32:48 +0200
Message-Id: <20220928223248.25933-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

During startup, 'nft monitor' first fetches the current ruleset and then
keeps this cache up to date based on received events. This is racey, as
any ruleset changes in between the initial fetch and the socket opening
are not recognized.

This script demonstrates the problem:

| #!/bin/bash
|
| while true; do
| 	nft flush ruleset
| 	iptables-nft -A FORWARD
| done &
| maniploop=$!
|
| trap "kill $maniploop; kill \$!; wait" EXIT
|
| while true; do
| 	nft monitor rules >/dev/null &
| 	sleep 0.2
| 	kill $!
| done

If the table add event is missed, the rule add event callback fails to
deserialize the rule and calls abort().

Avoid the inconvenient program exit by returning NULL from
netlink_delinearize_rule() instead of aborting and make callers check
the return value.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c               | 1 +
 src/monitor.c             | 5 +++++
 src/netlink_delinearize.c | 5 ++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index f790f995e07b0..85de970f76448 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -598,6 +598,7 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *data)
 
 	netlink_dump_rule(nlr, ctx);
 	rule = netlink_delinearize_rule(ctx, nlr);
+	assert(rule);
 	list_add_tail(&rule->list, &ctx->list);
 
 	return 0;
diff --git a/src/monitor.c b/src/monitor.c
index 7fa92ebfb0f3a..a6b30a18cfd25 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -551,6 +551,10 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 
 	nlr = netlink_rule_alloc(nlh);
 	r = netlink_delinearize_rule(monh->ctx, nlr);
+	if (!r) {
+		fprintf(stderr, "W: Received event for an unknown table.\n");
+		goto out_free_nlr;
+	}
 	nlr_for_each_set(nlr, rule_map_decompose_cb, NULL,
 			 &monh->ctx->nft->cache);
 	cmd = netlink_msg2cmd(type, nlh->nlmsg_flags);
@@ -587,6 +591,7 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 		break;
 	}
 	rule_free(r);
+out_free_nlr:
 	nftnl_rule_free(nlr);
 	return MNL_CB_OK;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0da6cc78f94fa..e8b9724cbac94 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -3195,7 +3195,10 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	pctx->rule = rule_alloc(&netlink_location, &h);
 	pctx->table = table_cache_find(&ctx->nft->cache.table_cache,
 				       h.table.name, h.family);
-	assert(pctx->table != NULL);
+	if (!pctx->table) {
+		errno = ENOENT;
+		return NULL;
+	}
 
 	pctx->rule->comment = nftnl_rule_get_comment(nlr);
 
-- 
2.34.1

