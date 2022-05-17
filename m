Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947F0C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 19:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348534AbiEQTVX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 15:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241252AbiEQTVW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 15:21:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4342842ED0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 12:21:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nr2ku-0003RN-9J; Tue, 17 May 2022 21:21:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+4903218f7fba0a2d6226@syzkaller.appspotmail.com,
        syzbot+afd2d80e495f96049571@syzkaller.appspotmail.com
Subject: [PATCH nf-next] netfilter: nfnetlink: fix warn in nfnetlink_unbind
Date:   Tue, 17 May 2022 21:21:11 +0200
Message-Id: <20220517192111.2080-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot reports following warn:
WARNING: CPU: 0 PID: 3600 at net/netfilter/nfnetlink.c:703 nfnetlink_unbind+0x357/0x3b0 net/netfilter/nfnetlink.c:694

The syzbot generated program does this:

socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER) = 3
setsockopt(3, SOL_NETLINK, NETLINK_DROP_MEMBERSHIP, [1], 4) = 0

... which triggers 'WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == 0)' check.

Instead of counting, just enable reporting for every bind request
and check if we still have listeners on unbind.

While at it, also add the needed bounds check on nfnl_group2type[]
access.

Reported-by: <syzbot+4903218f7fba0a2d6226@syzkaller.appspotmail.com>
Reported-by: <syzbot+afd2d80e495f96049571@syzkaller.appspotmail.com>
Fixes: 2794cdb0b97b ("netfilter: nfnetlink: allow to detect if ctnetlink listeners exist")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index ad3bbe34ca88..2f7c477fc9e7 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -45,7 +45,6 @@ MODULE_DESCRIPTION("Netfilter messages via netlink socket");
 static unsigned int nfnetlink_pernet_id __read_mostly;
 
 struct nfnl_net {
-	unsigned int ctnetlink_listeners;
 	struct sock *nfnl;
 };
 
@@ -673,18 +672,8 @@ static int nfnetlink_bind(struct net *net, int group)
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	if (type == NFNL_SUBSYS_CTNETLINK) {
-		struct nfnl_net *nfnlnet = nfnl_pernet(net);
-
 		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
-
-		if (WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == UINT_MAX)) {
-			nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
-			return -EOVERFLOW;
-		}
-
-		nfnlnet->ctnetlink_listeners++;
-		if (nfnlnet->ctnetlink_listeners == 1)
-			WRITE_ONCE(net->ct.ctnetlink_has_listener, true);
+		WRITE_ONCE(net->ct.ctnetlink_has_listener, true);
 		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 	}
 #endif
@@ -694,15 +683,12 @@ static int nfnetlink_bind(struct net *net, int group)
 static void nfnetlink_unbind(struct net *net, int group)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	int type = nfnl_group2type[group];
-
-	if (type == NFNL_SUBSYS_CTNETLINK) {
-		struct nfnl_net *nfnlnet = nfnl_pernet(net);
+	if (group <= NFNLGRP_NONE || group > NFNLGRP_MAX)
+		return;
 
+	if (nfnl_group2type[group] == NFNL_SUBSYS_CTNETLINK) {
 		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
-		WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == 0);
-		nfnlnet->ctnetlink_listeners--;
-		if (nfnlnet->ctnetlink_listeners == 0)
+		if (!nfnetlink_has_listeners(net, group))
 			WRITE_ONCE(net->ct.ctnetlink_has_listener, false);
 		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 	}
-- 
2.35.1

