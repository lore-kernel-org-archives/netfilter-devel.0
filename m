Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7255CC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 11:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiKULYo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 06:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiKULYN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 06:24:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC5EBE874
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 03:19:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ox4py-0002Pc-SQ; Mon, 21 Nov 2022 12:19:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables-nft RFC 0/5] update iptables-nft dissector
Date:   Mon, 21 Nov 2022 12:19:27 +0100
Message-Id: <20221121111932.18222-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is n RFC patchset to demonstrate some of the issues
of the xlate-replay mode.

I'm planning to push
 nft-shared: dump errors on stdout to garble output
 xlate-test: extra-escape of '"' for replay mode
 nft: check for unknown meta keys

but not the other changes, at least not yet.

I will try to extend the test script to move beyond
strcmp, see last patch in series:
manually reordering all test files appears to be too error-prone.

Florian Westphal (5):
  nft-shared: dump errors on stdout to garble output
  iptables-nft: do not refuse to decode table with unsupported
    expressions
  nft: check for unknown meta keys
  xlate-test: extra-escape of '"' for replay mode
  generic.xlate: make one replay test case work

 extensions/generic.txlate |  2 +-
 iptables/nft-arp.c        |  9 ++++--
 iptables/nft-bridge.c     |  6 +++-
 iptables/nft-ipv4.c       |  7 +++--
 iptables/nft-ipv6.c       |  7 +++--
 iptables/nft-shared.c     |  6 +++-
 iptables/nft.c            | 66 ++-------------------------------------
 iptables/nft.h            |  2 --
 iptables/xtables-save.c   |  6 +---
 xlate-test.py             |  2 +-
 10 files changed, 31 insertions(+), 82 deletions(-)

-- 
2.37.4

