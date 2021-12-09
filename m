Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C7CC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 16:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbhLIQnI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 11:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbhLIQnI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 11:43:08 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32A5C061746
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 08:39:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mvMSC-0007lN-9y; Thu, 09 Dec 2021 17:39:32 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Vitaly Zuevsky <vzuevsky@ns1.com>
Subject: [PATCH nf] netfilter: ctnetlink: remove expired entries first
Date:   Thu,  9 Dec 2021 17:39:26 +0100
Message-Id: <20211209163926.25563-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When dumping conntrack table to userspace via ctnetlink, check if the ct has
already expired before doing any of the 'skip' checks.

This expires dead entries faster.
/proc handler also removes outdated entries first.

Reported-by: Vitaly Zuevsky <vzuevsky@ns1.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Vitaly, I suspect this might be related to the issue you reported,
 I suspect we skip the NAT-clash entries instead of evicting them from
 ctnetlink path too.

 net/netfilter/nf_conntrack_netlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 81d03acf68d4..ec4164c32d27 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1195,8 +1195,6 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 		}
 		hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[cb->args[0]],
 					   hnnode) {
-			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
-				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
 				if (i < ARRAY_SIZE(nf_ct_evict) &&
@@ -1208,6 +1206,9 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			if (!net_eq(net, nf_ct_net(ct)))
 				continue;
 
+			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
+				continue;
+
 			if (cb->args[1]) {
 				if (ct != last)
 					continue;
-- 
2.32.0

