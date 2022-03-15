Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB37C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 13:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348639AbiCON1v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 09:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiCON1u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 09:27:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294FD3464B
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 06:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=p9UOxez9TPbBI5cmkzjKTLHNk6mj5nWyX8OgaZxFt+M=; b=T30YDlVW2H4fssNNPjp1vXctb/
        IRV9tl+DoJlq92PM9cRTqhXM455+/C8kT5yNIG6kppW1dMfJtXpElqCM6+iKQpPPXu7ZDbJ12q5yW
        2ixSfL4PhwYkMOBNlD/ygXaqE5C1eIRxmc4gMr5UKh4/6ppPvKS92u8T12QP3zuurqXTj7wwgWueO
        OnFJZLLVw9XLBCkJoxvP9lqi7PjU/jNPZEgvvqT+N2/rag3QyeRXiLYZmLlM1XmRwvYVj5W7nJRJl
        gdyUiFTVfhncs255rrdrLWdoR047oByBcQEnNN+qMP939ec01tw46Kc2rrR+jAEIkDYTjgkF/JeSC
        LwItkhZQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nU7C9-0000rt-KT; Tue, 15 Mar 2022 14:26:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Etienne <champetier.etienne@gmail.com>
Subject: [iptables PATCH 0/5] Fixes for static builds
Date:   Tue, 15 Mar 2022 14:26:14 +0100
Message-Id: <20220315132619.20256-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series formally submits a slightly modified version of the patch
attached to nfbz#1593 in patch 3. In addition to that:

Patch 1 is pure collateral and unrelated to the remaining series.

Patch 2 simplifies the compile-time conditional init-calls a bit. Done
before the actual fix to avoid adding #ifdefs only to remove them again
in the same series.

Patch 3 Fixes static builds of arp- and ebtables-nft, kindly provided by
Ettiene and slightly adjusted by me.

Patch 4 holds a mini-review of the resulting init_extensions*() call
sites.

Patch 5 fixes shell testsuite for use with static builds.

Etienne (1):
  xtables: Call init_extensions{,a,b}() for static builds

Phil Sutter (4):
  libxtables: Fix for warning in xtables_ipmask_to_numeric
  Simplify static build extension loading
  nft: Review static extension loading
  tests: shell: Fix 0004-return-codes_0 for static builds

 include/xtables.h                                  |  9 +++++++++
 iptables/ip6tables-standalone.c                    |  3 ---
 iptables/iptables-restore.c                        |  4 ----
 iptables/iptables-save.c                           |  4 ----
 iptables/iptables-standalone.c                     |  2 --
 .../shell/testcases/iptables/0004-return-codes_0   |  2 +-
 iptables/xtables-arp.c                             |  4 +---
 iptables/xtables-eb.c                              |  4 +---
 iptables/xtables-monitor.c                         |  4 ++--
 iptables/xtables-restore.c                         | 10 ++++++----
 iptables/xtables-save.c                            | 10 ++++++----
 iptables/xtables-standalone.c                      | 10 ++++++----
 iptables/xtables-translate.c                       | 14 ++++++++------
 libxtables/xtables.c                               |  2 +-
 14 files changed, 41 insertions(+), 41 deletions(-)

-- 
2.34.1

