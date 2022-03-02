Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E446BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 15:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbiCBPTG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiCBPTE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 10:19:04 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FCE21803
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 07:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lzZPVVEwq4U1DjaQbfzMIJk68TCAsJZWydYWGUBj1BM=; b=To3nSclQvcvltKE2EQlsi0Cqpx
        YKhjd9i8iz/XpWQ039DemzyQ1ax4Sgit7m+BrkOxP9T4/hxWoz1U+SLekddZ3N2vY8RlhCibqqPmT
        4COHAFZftSHgQzi0el9s+hrZ4jC947A5ecDkX7J88Uyz0nKIhy2fHRxUJbKqhn+oNvy8126MlzLzQ
        qrLC9jQwwLDKegZqdr2Eg6ZmVjrp8xptneKYpYoJ8ZS829FxCBWbf2efsJmTRX1He4KNTBr43B9Sz
        NRsFJ7lJwDJAl3js+acJw8ZMPssRlsESo+Snq3s1LiUQ0YUgLuYE0roTCBSjzzWijl59Vivhhp3Cw
        pfBdQ9Lw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nPQk7-00034F-9e; Wed, 02 Mar 2022 16:18:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/4] Speed up iptables-nft-save
Date:   Wed,  2 Mar 2022 16:18:03 +0100
Message-Id: <20220302151807.12185-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

OpenShift tends to create huge rulesets[*] and consequently wonders why
iptables is slow. Anyway, iptables-nft-save really does odd things:

* For each jump target, it checks if such extension exists, despite
  already knowing whether the target is a chain or not. This is solved
  in patch 2, with patch 1 preparing nft_parse_immediate() to make the
  change simpler.

* Every l4proto match causes a call to getprotobynumber() which in turn
  opens /etc/protocols. One could cache the lookups, but preferring the
  builtin fallback list of protocol names and numbers is much simpler.
  Do that in patch 3, aligning said list with /etc/protocols to not
  change output unexpectedly.

[*] I have a "real-life" dump adding 50k chains and 130k rules. Dumping
    it to /dev/null took 45s on my testing VM, with these patches
    applied I'm down to 2.7s.

The last patch is fallout from the above, simplifying family ops
callbacks a bit given that there is only a single *tables_command_state
struct left.

Phil Sutter (4):
  nft: Simplify immediate parsing
  nft: Speed up immediate parsing
  xshared: Prefer xtables_chain_protos lookup over getprotoent
  nft: Don't pass command state opaque to family ops callbacks

 iptables/nft-arp.c    | 32 ++++++------------
 iptables/nft-bridge.c | 55 +++++++++++++------------------
 iptables/nft-ipv4.c   | 40 ++++++++---------------
 iptables/nft-ipv6.c   | 40 ++++++++---------------
 iptables/nft-shared.c | 75 ++++++++++++++++++++-----------------------
 iptables/nft-shared.h | 35 ++++++++++----------
 iptables/nft.c        |  4 +--
 iptables/nft.h        |  2 +-
 iptables/xshared.c    |  8 ++---
 libxtables/xtables.c  | 19 ++++-------
 10 files changed, 126 insertions(+), 184 deletions(-)

-- 
2.34.1

