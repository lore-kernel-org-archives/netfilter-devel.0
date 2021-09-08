Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC28C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 12:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3DCA6113D
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 12:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348442AbhIHMaB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Sep 2021 08:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346096AbhIHMaA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 08:30:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC783C061575
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Sep 2021 05:28:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mNwh8-0004b2-LM; Wed, 08 Sep 2021 14:28:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/5] netfilter: conntrack: make zone id part of conntrack hash
Date:   Wed,  8 Sep 2021 14:28:33 +0200
Message-Id: <20210908122839.7526-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch set makes the zone id part of the conntrack hash again.

First patch is a followup to
d7e7747ac5c2496c9,
"netfilter: refuse insertion if chain has grown too large".

Instead of a fixed-size limit, allow for some slack in the drop
limit.  This makes it harder to extract information about hash
table collisions/bucket overflows.

Second patch makes the zone id part of the tuple hash again.
This was removed six years ago to allow split-zone support.

Last two patches add test cases for zone support with colliding
tuples. First test case emulates split zones, where NAT is responsible
to expose the overlapping networks and provide unique source ports via
nat port translation.

Second test case exercises overlapping tuples in distinct zones.

Expectation is that all connection succeed (first self test) and
that all insertions work (second self test).

Florian Westphal (5):
  netfilter: conntrack: make connection tracking table less predictable
  netfilter: conntrack: include zone id in tuple hash again
  netfilter: nat: include zone id in nat table hash again
  selftests: netfilter: add selftest for directional zone support
  selftests: netfilter: add zone stress test with colliding tuples

 net/netfilter/nf_conntrack_core.c             |  84 +++--
 net/netfilter/nf_nat_core.c                   |  17 +-
 .../selftests/netfilter/nft_nat_zones.sh      | 309 ++++++++++++++++++
 .../selftests/netfilter/nft_zones_many.sh     | 156 +++++++++
 4 files changed, 540 insertions(+), 26 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_nat_zones.sh
 create mode 100755 tools/testing/selftests/netfilter/nft_zones_many.sh

-- 
2.32.0

