Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2FCC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 10:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbhLQKaI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 05:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbhLQKaG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 05:30:06 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE4CC06173F
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 02:30:05 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1myAV1-0005qM-I5; Fri, 17 Dec 2021 11:30:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 0/2] nat: force port remap to prevent shadowing well-known ports
Date:   Fri, 17 Dec 2021 11:29:55 +0100
Message-Id: <20211217102957.2999-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is a resend of the port remap change with auto-exception for
locally originating connections.

This is done by adding a bit in nf_conn for LOCAL_OUT tracked entries.

Patch 1/2 is same as in v2.
Patch 2/2 is same as v3.
v3 only contained patch 2/2 by mistake.

Florian Westphal (2):
  netfilter: conntrack: tag conntracks picked up in local out hook
  netfilter: nat: force port remap to prevent shadowing well-known ports

 include/net/netfilter/nf_conntrack.h         |  1 +
 net/netfilter/nf_conntrack_core.c            |  3 ++
 net/netfilter/nf_nat_core.c                  | 43 ++++++++++++++++++--
 tools/testing/selftests/netfilter/nft_nat.sh |  5 ++-
 4 files changed, 47 insertions(+), 5 deletions(-)

-- 
2.32.0

