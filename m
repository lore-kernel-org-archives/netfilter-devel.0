Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9025FC001E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Aug 2023 09:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbjHOJxH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 05:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbjHOJw4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 05:52:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C336E3
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Aug 2023 02:52:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qVqjK-0004yw-Mo; Tue, 15 Aug 2023 11:52:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/2] netfilter: nf_nat: fix yet another bizarre early demux corner case
Date:   Tue, 15 Aug 2023 11:52:39 +0200
Message-ID: <20230815095245.9386-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is another corner case where early demux can end up assigning
the wrong socket to skb->sk.

This extends the existing workaround in nf_nat and the test case
to demonstrate the problem.

Florian Westphal (2):
  netfilter: nf_nat: undo erroneous tcp edemux lookup after port clash
  selftests: netfilter: test nat source port clash resolution
    interaction with tcp early demux

 net/netfilter/nf_nat_proto.c                  | 63 ++++++++++++++++++-
 .../selftests/netfilter/nf_nat_edemux.sh      | 46 +++++++++++---
 2 files changed, 97 insertions(+), 12 deletions(-)

-- 
2.41.0

