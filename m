Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8DD8C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C4F611EE
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhKFVA7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVA6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:00:58 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CE6C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:58:17 -0700 (PDT)
Received: from localhost ([::1]:58758 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSlT-00046Q-L5; Sat, 06 Nov 2021 21:58:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/10] Share more code with legacy
Date:   Sat,  6 Nov 2021 21:57:46 +0100
Message-Id: <20211106205756.14529-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series populates xshared.c with more code for use by both nft and
legacy variants. A prerequisite for this is to change how output
separating whitespace is printed (the old space before or after arg
issue). Patch 2 does this and paves the way for patches 3-8. Patches 9
and 10 finish with a bit of cleanup.

Phil Sutter (10):
  xshared: Merge and share parse_chain()
  nft: Change whitespace printing in save_rule callback
  xshared: Share print_iface() function
  xshared: Share save_rule_details() with legacy
  xshared: Share save_ipv{4,6}_addr() with legacy
  xshared: Share print_rule_details() with legacy
  xshared: Share print_fragment() with legacy
  xshared: Share print_header() with legacy iptables
  nft-shared: Drop unused function print_proto()
  xshared: Make load_proto() static

 iptables/ip6tables.c  | 197 ++++-------------------------------
 iptables/iptables.c   | 210 ++++----------------------------------
 iptables/nft-arp.c    |   8 +-
 iptables/nft-bridge.c |  12 ++-
 iptables/nft-ipv4.c   |  75 ++------------
 iptables/nft-ipv6.c   |  37 ++-----
 iptables/nft-shared.c | 155 ++--------------------------
 iptables/nft-shared.h |  18 +---
 iptables/nft.c        |  10 +-
 iptables/xshared.c    | 231 +++++++++++++++++++++++++++++++++++++++++-
 iptables/xshared.h    |  22 +++-
 iptables/xtables.c    |   9 +-
 12 files changed, 337 insertions(+), 647 deletions(-)

-- 
2.33.0

