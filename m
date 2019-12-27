Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A877C2D0CE
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 633A3206F4
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577469537;
	bh=oBkHsDvgkstaVNNnbYEpO4N/JGbrsZczsZ3CbOKCSQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YeAcYffUG+uZfYuUEDwpMZebx+dfRbET2RMmzVG2k8rHNFcbIDQ/EU7y3IgupWvYU
	 RYRVUiRVVUhdGCvbtvcOvalIyVjjTMSpOZ7FzWd6eRzJiSm5s8sH1f8qM6BCeJbJJc
	 l4jFhTmAY/A5xN+RUMyTPlo6dGYESW/J6SVzt34Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbfL0R6u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 12:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727313AbfL0RlO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1820222C4;
        Fri, 27 Dec 2019 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468473;
        bh=oBkHsDvgkstaVNNnbYEpO4N/JGbrsZczsZ3CbOKCSQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SD31pG16fBdh1CFG3pBljlrcIHfjA9U+jPMMTEa9SQVbEQNoRpFAhda17/9dUSGnh
         Ktql4uHCdFE5A/6Sf76epxE6PBlL4972Dr/ikTFs+4T0wgAWOlIvxIGNi6i1/DxGvB
         0M1gxGBCVHJzTpW4mgVArylwvty1fuZIY+gIShgc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 014/187] netfilter: ctnetlink: netns exit must wait for callbacks
Date:   Fri, 27 Dec 2019 12:38:02 -0500
Message-Id: <20191227174055.4923-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 18a110b022a5c02e7dc9f6109d0bd93e58ac6ebb ]

Curtis Taylor and Jon Maxwell reported and debugged a crash on 3.10
based kernel.

Crash occurs in ctnetlink_conntrack_events because net->nfnl socket is
NULL.  The nfnl socket was set to NULL by netns destruction running on
another cpu.

The exiting network namespace calls the relevant destructors in the
following order:

1. ctnetlink_net_exit_batch

This nulls out the event callback pointer in struct netns.

2. nfnetlink_net_exit_batch

This nulls net->nfnl socket and frees it.

3. nf_conntrack_cleanup_net_list

This removes all remaining conntrack entries.

This is order is correct. The only explanation for the crash so ar is:

cpu1: conntrack is dying, eviction occurs:
 -> nf_ct_delete()
   -> nf_conntrack_event_report \
     -> nf_conntrack_eventmask_report
       -> notify->fcn() (== ctnetlink_conntrack_events).

cpu1: a. fetches rcu protected pointer to obtain ctnetlink event callback.
      b. gets interrupted.
 cpu2: runs netns exit handlers:
     a runs ctnetlink destructor, event cb pointer set to NULL.
     b runs nfnetlink destructor, nfnl socket is closed and set to NULL.
cpu1: c. resumes and trips over NULL net->nfnl.

Problem appears to be that ctnetlink_net_exit_batch only prevents future
callers of nf_conntrack_eventmask_report() from obtaining the callback.
It doesn't wait of other cpus that might have already obtained the
callbacks address.

I don't see anything in upstream kernels that would prevent similar
crash: We need to wait for all cpus to have exited the event callback.

Fixes: 9592a5c01e79dbc59eb56fa ("netfilter: ctnetlink: netns support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e2d13cd18875..aa8adf930b3c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3602,6 +3602,9 @@ static void __net_exit ctnetlink_net_exit_batch(struct list_head *net_exit_list)
 
 	list_for_each_entry(net, net_exit_list, exit_list)
 		ctnetlink_net_exit(net);
+
+	/* wait for other cpus until they are done with ctnl_notifiers */
+	synchronize_rcu();
 }
 
 static struct pernet_operations ctnetlink_net_ops = {
-- 
2.20.1

