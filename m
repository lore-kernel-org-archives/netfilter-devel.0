Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E62C32792
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Aug 2022 12:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiHPMSW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Aug 2022 08:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbiHPMSE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Aug 2022 08:18:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463BA95A2;
        Tue, 16 Aug 2022 05:15:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oNvTm-0000oK-FB; Tue, 16 Aug 2022 14:15:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/2] testing: selftests: nft_flowtable.sh: unbreak test script
Date:   Tue, 16 Aug 2022 14:15:20 +0200
Message-Id: <20220816121522.14278-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_flowtable.sh fails most of the time since
2738d9d963bd1f0 ("netfilter: flowtable: move dst_check to packet path").
Arguably the test scripts way of detecting 'offloaded' vs 'offload
failed' was always flaky/broken.

These patches fix this up:
1. first patch moves to random netns names so we don't trip
   over existing 'ns1' name (too generic...).
2. second patch reworks the 'offload appears to be non-working'
   by means of packet counters.

Because counters are only incremented when a packet is handled
by the classic forward path, check that the counter is lower than
a given threshold (25% of file size).

Florian Westphal (2):
  testing: selftests: nft_flowtable.sh: use random netns names
  testing: selftests: nft_flowtable.sh: rework test to detect offload
    failure

 .../selftests/netfilter/nft_flowtable.sh      | 377 ++++++++++--------
 1 file changed, 207 insertions(+), 170 deletions(-)

-- 
2.35.1

