Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B1CC07E94
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 11:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63A2561423
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 11:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFDLmg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Jun 2021 07:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhFDLmg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 07:42:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62367C06174A
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 04:40:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lp8C0-0004v2-Fh; Fri, 04 Jun 2021 13:40:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/4] nftables: convert single-elem anon sets to compare operation
Date:   Fri,  4 Jun 2021 13:40:39 +0200
Message-Id: <20210604114043.4153-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Auto-translate 'match { bar }' to 'match bar'.  Doing this causes tons
of failures in the python test suite, so first remove all test cases
that use this pattern.

This is fine because all of these tests are redundant.
A new test is added to cover the auto-removal.

This also includes cases where the set must not be auto-converted.

Florian Westphal (4):
  tests: ct: prefer normal cmp
  tests: remove redundant test cases
  evaluate: remove anon sets with exactly one element
  tests: add test case for removal of anon sets with only a single element

 src/evaluate.c                                |  21 +-
 tests/py/any/meta.t                           |   4 -
 tests/py/any/meta.t.json                      |  40 --
 tests/py/any/meta.t.payload                   |  38 --
 tests/py/arp/arp.t                            |   6 -
 tests/py/arp/arp.t.json                       | 120 ------
 tests/py/arp/arp.t.payload                    |  48 ---
 tests/py/arp/arp.t.payload.netdev             |  60 ---
 tests/py/inet/ah.t                            |   8 -
 tests/py/inet/ah.t.json                       | 160 -------
 tests/py/inet/ah.t.payload                    |  80 ----
 tests/py/inet/comp.t                          |   4 -
 tests/py/inet/comp.t.json                     |  80 ----
 tests/py/inet/comp.t.payload                  |  40 --
 tests/py/inet/ct.t                            |   2 +-
 tests/py/inet/ct.t.json                       |   8 +-
 tests/py/inet/ct.t.payload                    |   7 +-
 tests/py/inet/dccp.t                          |   5 -
 tests/py/inet/dccp.t.json                     | 100 -----
 tests/py/inet/dccp.t.payload                  |  50 ---
 tests/py/inet/esp.t                           |   5 -
 tests/py/inet/esp.t.json                      |  80 ----
 tests/py/inet/esp.t.payload                   |  40 --
 tests/py/inet/sctp.t                          |   8 -
 tests/py/inet/sctp.t.json                     | 160 -------
 tests/py/inet/sctp.t.payload                  |  80 ----
 tests/py/inet/tcp.t                           |  16 -
 tests/py/inet/tcp.t.json                      | 280 ------------
 tests/py/inet/tcp.t.payload                   | 140 ------
 tests/py/inet/udp.t                           |   8 -
 tests/py/inet/udp.t.json                      | 166 -------
 tests/py/inet/udp.t.payload                   |  82 ----
 tests/py/inet/udplite.t                       |   8 -
 tests/py/inet/udplite.t.json                  | 126 ------
 tests/py/inet/udplite.t.payload               |  62 ---
 tests/py/ip/icmp.t                            |  14 -
 tests/py/ip/icmp.t.json                       | 407 ------------------
 tests/py/ip/icmp.t.payload.ip                 | 174 --------
 tests/py/ip/igmp.t                            |   2 -
 tests/py/ip/igmp.t.json                       |  50 ---
 tests/py/ip/igmp.t.payload                    |  20 -
 tests/py/ip/ip.t                              |  12 -
 tests/py/ip/ip.t.json                         | 240 -----------
 tests/py/ip/ip.t.payload                      |  96 -----
 tests/py/ip/ip.t.payload.bridge               | 120 ------
 tests/py/ip/ip.t.payload.inet                 | 120 ------
 tests/py/ip/ip.t.payload.netdev               | 120 ------
 tests/py/ip6/dst.t                            |   5 -
 tests/py/ip6/dst.t.json                       |  81 ----
 tests/py/ip6/dst.t.payload.inet               |  41 --
 tests/py/ip6/dst.t.payload.ip6                |  34 --
 tests/py/ip6/frag.t                           |   6 -
 tests/py/ip6/frag.t.payload.inet              |  62 ---
 tests/py/ip6/frag.t.payload.ip6               |  50 ---
 tests/py/ip6/hbh.t                            |   4 -
 tests/py/ip6/hbh.t.json                       |  80 ----
 tests/py/ip6/hbh.t.payload.inet               |  40 --
 tests/py/ip6/hbh.t.payload.ip6                |  32 --
 tests/py/ip6/icmpv6.t                         |  12 -
 tests/py/ip6/icmpv6.t.json                    | 240 -----------
 tests/py/ip6/icmpv6.t.payload.ip6             | 148 -------
 tests/py/ip6/ip6.t                            |   8 -
 tests/py/ip6/ip6.t.json                       | 122 ------
 tests/py/ip6/ip6.t.payload.inet               |  82 ----
 tests/py/ip6/ip6.t.payload.ip6                |  66 ---
 tests/py/ip6/mh.t                             |   8 -
 tests/py/ip6/mh.t.json                        | 162 -------
 tests/py/ip6/mh.t.payload.inet                |  81 ----
 tests/py/ip6/mh.t.payload.ip6                 |  65 ---
 tests/py/ip6/rt.t                             |   8 -
 tests/py/ip6/rt.t.json                        | 160 -------
 tests/py/ip6/rt.t.payload.inet                |  80 ----
 tests/py/ip6/rt.t.payload.ip6                 |  64 ---
 .../optimizations/dumps/single_anon_set.nft   |  15 +
 .../dumps/single_anon_set.nft.input           |  35 ++
 .../testcases/optimizations/single_anon_set   |  13 +
 .../shell/testcases/sets/dumps/0053echo_0.nft |   2 +-
 77 files changed, 88 insertions(+), 5235 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
 create mode 100755 tests/shell/testcases/optimizations/single_anon_set

-- 
2.26.3

