Return-Path: <SRS0=AsZf=DI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A0AC4727E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Oct 2020 16:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B982E2072E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Oct 2020 16:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbgJAQkG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Oct 2020 12:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731917AbgJAQkG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Oct 2020 12:40:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C39C0613D0
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2020 09:40:06 -0700 (PDT)
Received: from localhost ([::1]:48002 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kO1ci-0004N2-JP; Thu, 01 Oct 2020 18:40:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [net-next PATCH 0/2] netfilter: Improve inverted IP prefix matches
Date:   Thu,  1 Oct 2020 18:57:42 +0200
Message-Id: <20201001165744.25466-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following two patches improve packet throughput in a test setup
sending UDP packets (using iperf3) between two netns. The ruleset used
on receiver side is like this:

| *filter
| :test - [0:0]
| -A INPUT -j test
| -A INPUT -j ACCEPT
| -A test ! -s 10.0.0.0/10 -j DROP # this line repeats 10000 times
| COMMIT

These are the generated VM instructions for each rule:

| [ payload load 4b @ network header + 12 => reg 1 ]
| [ bitwise reg 1 = (reg=1 & 0x0000c0ff ) ^ 0x00000000 ]
| [ cmp eq reg 1 0x0000000a ]
| [ counter pkts 0 bytes 0 ]
| [ immediate reg 0 drop ]

Both sender and receiver reside within 10/10 network, iperf3 is just
used to fill the (virtual) wire:

| iperf3 -c 10.0.0.2 -u -b 10G -t 1000

On receiver side, "packets received" counter of 'netstat -su' is
monitored to calculate throughput. Averaging over about a minute, these
are the figures:

legacy:			~10000pkt/s
nft (base):		~3000pkt/s
nft (patch1):		~4000pkt/s
nft (patch1+2):		~5200pkt/s

In summary, this increases nftables throughput for this specific test
case from 1/3 of legacy iptables to 1/2.

Phil Sutter (2):
  net: netfilter: Enable fast nft_cmp for inverted matches
  net: netfilter: Implement fast bitwise expression

 include/net/netfilter/nf_tables_core.h |  11 ++
 net/netfilter/nf_tables_core.c         |  15 ++-
 net/netfilter/nft_bitwise.c            | 141 +++++++++++++++++++++++--
 net/netfilter/nft_cmp.c                |  10 +-
 4 files changed, 164 insertions(+), 13 deletions(-)

-- 
2.28.0

