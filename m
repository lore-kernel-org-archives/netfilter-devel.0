Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C60AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 00:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241434AbhLIA0l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 19:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238328AbhLIA0l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 19:26:41 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EF5C061746
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Dec 2021 16:23:08 -0800 (PST)
Received: from localhost ([::1]:58536 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mv7DF-0004sg-Kx; Thu, 09 Dec 2021 01:23:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/6] Some more code de-duplication
Date:   Thu,  9 Dec 2021 01:22:51 +0100
Message-Id: <20211209002257.21467-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 merges a common function in legacy ip*tables, the remaining
ones deal with help printing:

Patch 2 merges the three almost identical copies of iptables help text
into a single function.

Patches 3, 4 and 5 extend libxtables enough to provide a default
exit_err callback which all ip*tables may use as-is.

Patch 6 removes duplicated info from output in a specific error
condition. The benefit here is mostly that there are four spots less
which make use of that global 'line' variable.

Phil Sutter (6):
  xshared: Share print_match_save() between legacy ip*tables
  xshared: Share a common printhelp function
  libxtables: Add xtables_exit_tryhelp()
  xtables_globals: Introduce program_variant
  libxtables: Extend basic_exit_err()
  iptables-*-restore: Drop pointless line reference

 include/xtables.h      |   3 +-
 iptables/ip6tables.c   | 154 ++---------------------------------------
 iptables/iptables.c    | 154 ++---------------------------------------
 iptables/xshared.c     | 133 +++++++++++++++++++++++++++++++++++
 iptables/xshared.h     |   4 ++
 iptables/xtables-arp.c |   3 +-
 iptables/xtables-eb.c  |   7 +-
 iptables/xtables.c     | 132 +++--------------------------------
 libxtables/xtables.c   |  26 ++++++-
 9 files changed, 190 insertions(+), 426 deletions(-)

-- 
2.33.0

