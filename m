Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBA9C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 14:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiFTO5c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 10:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242820AbiFTO5J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 10:57:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C1325294
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 07:17:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o3IDg-00052N-AD; Mon, 20 Jun 2022 16:17:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/2] netfilter: fix two nf_dup bugs with egress hook
Date:   Mon, 20 Jun 2022 16:17:29 +0200
Message-Id: <20220620141731.7362-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We need to be more careful now that nf_dup is exposed to new
egress hook.

When called from egress hook, we need to skip push of mac header,
this is only ok for ingress invocation.

Also add a  recursion counter to prevent re-entry into the expression.

Florian Westphal (2):
  netfilter: nf_dup_netdev: do not push mac header a second time
  netfilter: nf_dup_netdev: add and use recursion counter

 net/netfilter/nf_dup_netdev.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

-- 
2.35.1

