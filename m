Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E32C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Dec 2021 18:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbhLMSI0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 13:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbhLMSI0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 13:08:26 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA20C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Dec 2021 10:08:25 -0800 (PST)
Received: from localhost ([::1]:58964 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mwpkN-0004Iy-FV; Mon, 13 Dec 2021 19:08:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 0/6] Some more code de-duplication
Date:   Mon, 13 Dec 2021 19:07:41 +0100
Message-Id: <20211213180747.20707-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No change in patches 1, 2, 4 and 6 since v1.

Patch 3 moves exit_tryhelp() into xshared.c instead of libxtables. Since
basic_exit_err() can't call it from there, its body is merged into the
latter in patch 5. Since both functions overlap in parts, this is just
about two printf() calls.

Phil Sutter (6):
  xshared: Share print_match_save() between legacy ip*tables
  xshared: Share a common printhelp function
  xshared: Share exit_tryhelp()
  xtables_globals: Introduce program_variant
  libxtables: Extend basic_exit_err()
  iptables-*-restore: Drop pointless line reference

 include/xtables.h      |   2 +-
 iptables/ip6tables.c   | 154 ++---------------------------------------
 iptables/iptables.c    | 154 ++---------------------------------------
 iptables/xshared.c     | 143 ++++++++++++++++++++++++++++++++++++++
 iptables/xshared.h     |   5 ++
 iptables/xtables-arp.c |   3 +-
 iptables/xtables-eb.c  |   7 +-
 iptables/xtables.c     | 132 +++--------------------------------
 libxtables/xtables.c   |  20 +++++-
 9 files changed, 194 insertions(+), 426 deletions(-)

-- 
2.33.0

