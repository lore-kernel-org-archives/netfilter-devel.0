Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD5D4E92701
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Oct 2023 14:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjJEOHj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjJEOGB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Oct 2023 10:06:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9021693D9
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Oct 2023 01:53:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qoK6g-0007Wf-CG; Thu, 05 Oct 2023 10:53:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, kernel test robot <lkp@intel.com>
Subject: [PATCH nf] netfilter: nfnetlink_log: silence bogus compiler warning
Date:   Thu,  5 Oct 2023 10:53:08 +0200
Message-ID: <20231005085311.21133-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 net/netfilter/nfnetlink_log.c:800:18: warning: variable 'ctinfo' is uninitialized

The warning is bogus, the variable is only used if ct is non-NULL and
always initialised in that case.  Init to 0 too to silence this.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309100514.ndBFebXN-lkp@intel.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 53c9e76473ba..f03f4d4d7d88 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -698,8 +698,8 @@ nfulnl_log_packet(struct net *net,
 	unsigned int plen = 0;
 	struct nfnl_log_net *log = nfnl_log_pernet(net);
 	const struct nfnl_ct_hook *nfnl_ct = NULL;
+	enum ip_conntrack_info ctinfo = 0;
 	struct nf_conn *ct = NULL;
-	enum ip_conntrack_info ctinfo;
 
 	if (li_user && li_user->type == NF_LOG_TYPE_ULOG)
 		li = li_user;
-- 
2.41.0

