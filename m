Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7340C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 May 2022 22:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245346AbiESWCY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 May 2022 18:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235605AbiESWCT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 May 2022 18:02:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD7DAF68B6;
        Thu, 19 May 2022 15:02:18 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 08/11] netfilter: nfnetlink: fix warn in nfnetlink_unbind
Date:   Fri, 20 May 2022 00:02:03 +0200
Message-Id: <20220519220206.722153-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220519220206.722153-1-pablo@netfilter.org>
References: <20220519220206.722153-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

