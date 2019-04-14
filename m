Return-Path: <SRS0=kfn4=SQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA73C10F13
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Apr 2019 22:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6971E20818
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Apr 2019 22:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfDNWsr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Apr 2019 18:48:47 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48440 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbfDNWsr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Apr 2019 18:48:47 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hFnvZ-0006Za-NQ; Mon, 15 Apr 2019 00:48:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON
Date:   Mon, 15 Apr 2019 00:43:00 +0200
Message-Id: <20190414224300.21300-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It means userspace gave us a ruleset where there is some other
data after the ebtables target but before the beginning of the next rule.

Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
Reported-by: syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index eb15891f8b9f..3cad01ac64e4 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2032,7 +2032,8 @@ static int ebt_size_mwt(struct compat_ebt_entry_mwt *match32,
 		if (match_kern)
 			match_kern->match_size = ret;
 
-		if (WARN_ON(type == EBT_COMPAT_TARGET && size_left))
+		/* rule should have no remaining data after target */
+		if (type == EBT_COMPAT_TARGET && size_left)
 			return -EINVAL;
 
 		match32 = (struct compat_ebt_entry_mwt *) buf;
-- 
2.21.0

