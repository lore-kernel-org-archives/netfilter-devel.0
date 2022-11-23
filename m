Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523B4C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbiKWQod (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239044AbiKWQoc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:32 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F9B922EA
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qZE5Y3m8KBTr5X0Ylr5tHDPh90uNcPS/2dVw9tbuakg=; b=IZL3rGDSQpycaQubr0W2YsGR8e
        /KBzTJiO0Hg49Q5Ho7CDnHHzVBuXewQK9irM/TEAtC6imgSxLyeorXY9ypLxJJrDIq+X++Mh7TcBw
        0jqy+NLroccGDopHBl2RXAWb0uGLbvuhqg2McpUVXuP20GudYOC39uSMzsWB5+kULnItNEulzr8Ry
        TWlkog0UJgKve4aR42aEei0/+l7Z4gem0KBMKBfhVzsnSmVAAYfAU+CYRhDFMx/vkOY1U8IG6AeDN
        qRUJLXom/AKppdFRw31myURVNcPuRz7fjO6DBuAXi6MtF9uKVE3RkFNrpU+5DfY+4zeky7X/ZX2dr
        IRgxlrZQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsrO-0003xJ-Ns
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 11/13] extensions: libebt_log: Add comment to clarify xlate callback
Date:   Wed, 23 Nov 2022 17:43:48 +0100
Message-Id: <20221123164350.10502-12-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Several log flags are ignored by the function. Add a comment explaining
why this is correct.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_log.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/extensions/libebt_log.c b/extensions/libebt_log.c
index 47708d79310e0..13c7fafecb11e 100644
--- a/extensions/libebt_log.c
+++ b/extensions/libebt_log.c
@@ -191,6 +191,8 @@ static int brlog_xlate(struct xt_xlate *xl,
 	if (loginfo->loglevel != LOG_DEFAULT_LEVEL)
 		xt_xlate_add(xl, " level %s", eight_priority[loginfo->loglevel].c_name);
 
+	/* ebt_log always decodes MAC header, nft_log always decodes upper header -
+	 * so set flags ether and ignore EBT_LOG_IP, EBT_LOG_ARP and EBT_LOG_IP6 */
 	xt_xlate_add(xl, " flags ether ");
 
 	return 1;
-- 
2.38.0

