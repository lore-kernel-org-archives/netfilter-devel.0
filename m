Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5C4C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 12:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbhLOMUf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 07:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242338AbhLOMUf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 07:20:35 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F61BC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2021 04:20:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mxTGq-0001gS-1i; Wed, 15 Dec 2021 13:20:32 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/2] nat: force port remap to prevent shadowing well-known ports
Date:   Wed, 15 Dec 2021 13:20:24 +0100
Message-Id: <20211215122026.20850-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

this patchset updates the v1 of the port remap change to not remap
locally originating connections.

This is done by adding a bit in nf_conn for LOCAL_OUT tracked entries.

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

