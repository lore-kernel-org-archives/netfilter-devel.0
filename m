Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9406C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhLPM7N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 07:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237049AbhLPM7N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 07:59:13 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90E9C06173F
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 04:59:12 -0800 (PST)
Received: from localhost ([::1]:58978 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mxqLn-00045Z-6i; Thu, 16 Dec 2021 13:59:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 0/6] Some more code de-duplication
Date:   Thu, 16 Dec 2021 13:58:34 +0100
Message-Id: <20211216125840.385-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No change in patches 1 to 3 and 6.

Patch 4 is new: Extend program_version field with variant string instead
of introducing a separate field. This made patch 5 a bit smaller, due to
less differences between basic_exit_err() and xtables_exit_error().

Phil Sutter (6):
  xshared: Share print_match_save() between legacy ip*tables
  xshared: Share a common printhelp function
  xshared: Share exit_tryhelp()
  xtables_globals: Embed variant name in .program_version
  libxtables: Extend basic_exit_err()
  iptables-*-restore: Drop pointless line reference

 iptables/ip6tables.c        | 157 ++----------------------------------
 iptables/iptables-restore.c |   2 +-
 iptables/iptables-save.c    |   2 +-
 iptables/iptables.c         | 157 ++----------------------------------
 iptables/xshared.c          | 143 ++++++++++++++++++++++++++++++++
 iptables/xshared.h          |   5 ++
 iptables/xtables-arp.c      |   4 +-
 iptables/xtables-eb.c       |  10 +--
 iptables/xtables-restore.c  |   2 +-
 iptables/xtables-save.c     |   2 +-
 iptables/xtables.c          | 135 +++----------------------------
 libxtables/xtables.c        |  12 +++
 12 files changed, 194 insertions(+), 437 deletions(-)

-- 
2.33.0

