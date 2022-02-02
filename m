Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273AEC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Feb 2022 11:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbiBBLBD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Feb 2022 06:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiBBLBD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Feb 2022 06:01:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B37C061714
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Feb 2022 03:01:03 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nFDNk-00029r-NI; Wed, 02 Feb 2022 12:01:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pham Thanh Tuyen <phamtyn@gmail.com>
Subject: [PATCH nf] netfilter: ctnetlink: disable helper autoassign
Date:   Wed,  2 Feb 2022 12:00:56 +0100
Message-Id: <20220202110056.22574-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When userspace, e.g. conntrackd, inserts an entry with a specified helper,
its possible that the helper is lost immediately after its added:

ctnetlink_create_conntrack
  -> nf_ct_helper_ext_add + assign helper
    -> ctnetlink_setup_nat
      -> ctnetlink_parse_nat_setup
         -> parse_nat_setup -> nfnetlink_parse_nat_setup
	                       -> nf_nat_setup_info
                                 -> nf_conntrack_alter_reply
                                   -> __nf_ct_try_assign_helper

... and __nf_ct_try_assign_helper will zero the helper again.

Set IPS_HELPER bit to bypass auto-assign logic, its unwanted, just like
when helper is assigned via ruleset.

Dropped old 'not strictly necessary' comment, it referred to use of
rcu_assign_pointer() before it got replaced by RCU_INIT_POINTER().

NB: Fixes tag intentionally incorrect, this extends the referenced commit,
but this change won't build without IPS_HELPER introduced there.

Fixes: 6714cf5465d280 ("netfilter: nf_conntrack: fix explicit helper attachment and NAT")
Reported-by: Pham Thanh Tuyen <phamtyn@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h | 2 +-
 net/netfilter/nf_conntrack_netlink.c               | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 4b3395082d15..26071021e986 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -106,7 +106,7 @@ enum ip_conntrack_status {
 	IPS_NAT_CLASH = IPS_UNTRACKED,
 #endif
 
-	/* Conntrack got a helper explicitly attached via CT target. */
+	/* Conntrack got a helper explicitly attached (ruleset, ctnetlink). */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ac438370f94a..7032402ffd33 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2311,7 +2311,8 @@ ctnetlink_create_conntrack(struct net *net,
 			if (helper->from_nlattr)
 				helper->from_nlattr(helpinfo, ct);
 
-			/* not in hash table yet so not strictly necessary */
+			/* disable helper auto-assignment for this entry */
+			ct->status |= IPS_HELPER;
 			RCU_INIT_POINTER(help->helper, helper);
 		}
 	} else {
-- 
2.34.1

