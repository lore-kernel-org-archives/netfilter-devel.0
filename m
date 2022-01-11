Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6049EC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 15:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243955AbiAKPFD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 10:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243891AbiAKPFD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 10:05:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BFAC06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 07:05:03 -0800 (PST)
Received: from localhost ([::1]:59128 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n7Ihp-0007WY-4c; Tue, 11 Jan 2022 16:05:01 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 00/11] Share do_parse() between nft and legacy
Date:   Tue, 11 Jan 2022 16:04:18 +0100
Message-Id: <20220111150429.29110-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 removes remains of an unused (and otherwise dropped) feature,
yet the change is necessary for the following ones. Patches 2-6 prepare
for patch 7 which moves do_parse() to xshared.c. Patches 8 and 9 prepare
for use of do_parse() from legacy code, Patches 10 and 11 finally drop
legacy ip(6)tables' rule parsing code.

Changes since v1:
- Introduce struct xt_cmd_parse_ops in patch 6
- Adjust patches 10 and 11 accordingly

Phil Sutter (11):
  xtables: Drop xtables' family on demand feature
  xtables: Pull table validity check out of do_parse()
  xtables: Move struct nft_xt_cmd_parse to xshared.h
  xtables: Pass xtables_args to check_empty_interface()
  xtables: Pass xtables_args to check_inverse()
  xtables: Do not pass nft_handle to do_parse()
  xshared: Move do_parse to shared space
  xshared: Store parsed wait and wait_interval in xtables_args
  nft: Move proto_parse and post_parse callbacks to xshared
  iptables: Use xtables' do_parse() function
  ip6tables: Use the shared do_parse, too

 iptables/ip6tables.c            | 502 ++---------------------
 iptables/iptables.c             | 487 ++---------------------
 iptables/nft-arp.c              |   2 +-
 iptables/nft-bridge.c           |   1 -
 iptables/nft-ipv4.c             |  61 +--
 iptables/nft-ipv6.c             |  78 +---
 iptables/nft-shared.h           |  54 +--
 iptables/xshared.c              | 684 ++++++++++++++++++++++++++++++++
 iptables/xshared.h              |  70 ++++
 iptables/xtables-eb-translate.c |   4 +-
 iptables/xtables-translate.c    |  12 +-
 iptables/xtables.c              | 572 +-------------------------
 12 files changed, 853 insertions(+), 1674 deletions(-)

-- 
2.34.1

