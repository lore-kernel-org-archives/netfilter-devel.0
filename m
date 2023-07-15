Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321F8C001B0
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jul 2023 12:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjGOM7w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jul 2023 08:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjGOM7v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jul 2023 08:59:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA3135B5
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jul 2023 05:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JZpDcHr9UbFhwKI8OVs1zoqs/OVnkAkxASjNpQiIzpk=; b=QqUMHmRakTK4yorGyi4RDRbFmi
        LYVw2u2GGIVRG6URjd7yLgJw1toQ1EL0alCXcBKAgxNcR3dF3GxGv5un1wNDP6xCcLqNzEWB6si3H
        WAxYSxb6yDXNqlgh3xf5J4eiR8AT3th7MGd6P2RQ7K3JrDFUw+uc9MJjHiKlNxMsNU9dsUWcGBPn7
        RVZIlpMxo3k+WDjLzGc5g/PhExlBUgn5DBF+H+uvCZRBUvXHkc9rdLBnE48+XLoo83MfrnoYvP0tY
        d3GspRjcnNd35LW4k47mUxUxtrGyDZMKCmaVocDEBaNkBQIxTeks5EQKux3U47MMXiTsNyeSQ2KcA
        WFPDKM5g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qKesG-0002NR-7E; Sat, 15 Jul 2023 14:59:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, igor@gooddata.com
Subject: [iptables PATCH 0/3] Follow-up on dangling set fix
Date:   Sat, 15 Jul 2023 14:59:25 +0200
Message-Id: <20230715125928.18395-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While testing/analyzing the changes in commit 4e95200ded923, I noticed
comparison of rules containing among matches was not behaving right. In
fact, most part of the among match data was ignored when comparing, due
to the way among extension scales its payload. This problem exists since
day 1 of the extension implementation for ebtables-nft. Patch 1 fixes
this by placing a hash of the "invisible" data in well-known space.

Patch 2 is a minor cleanup of commit 4e95200ded923, eliminating some
ineffective function signature changes.

Patch 3 adds set (with element) dumps to debug output.

Note about 4e95200ded923 itself: I don't quite like the approach of
conditionally converting a rule into libnftnl format using only compat
expressions for extensions. I am aware my proposed compatibility mode
does the same, but it's a global switch changing add_match() behaviour
consistently. What the commit above does works only because for rule
comparison, both rules are converted back into iptables_command_state
objects. I'd like to follow an alternative path of delaying the
rule conversion so that it does not happen in nft_cmd_new() but later
from nft_action() (or so). This should eliminate some back-and-forth and
also implicitly fix the case of needless set creation.

Phil Sutter (3):
  extensions: libebt_among: Fix for false positive match comparison
  nft: Do not pass nft_rule_ctx to add_nft_among()
  nft: Include sets in debug output

 extensions/libebt_among.c                     |  1 +
 iptables/nft-bridge.h                         | 16 ++++++++
 iptables/nft-cache.c                          | 10 ++++-
 iptables/nft-ruleparse-bridge.c               |  2 +
 iptables/nft.c                                | 17 +++++---
 .../testcases/ebtables/0009-among-lookup_0    | 39 +++++++++++++++++++
 6 files changed, 78 insertions(+), 7 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0009-among-lookup_0

-- 
2.40.0

