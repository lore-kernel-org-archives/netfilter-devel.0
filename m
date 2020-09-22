Return-Path: <SRS0=MXnI=C7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7756C2D0E2
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Sep 2020 22:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC56221EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Sep 2020 22:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIVWm1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Sep 2020 18:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVWm1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Sep 2020 18:42:27 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB1CC061755
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2020 15:42:27 -0700 (PDT)
Received: from localhost ([::1]:52100 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kKqzR-0007WR-Sf; Wed, 23 Sep 2020 00:42:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: [iptables PATCH 0/3] libxtables: Fix for pointless socket() calls
Date:   Wed, 23 Sep 2020 00:53:38 +0200
Message-Id: <20200922225341.8976-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The motivation for this series was a bug report claiming a near 100%
slowdown of iptables-restore when passed a large number of rules
containing conntrack match between two kernel versions. Turns out the
curlprit kernel change was within SELinux and in fact a performance
optimization, namely an introduced hash table mapping from security
context string to SID. This hash table insert, which happened for each
new socket, slowed iptables-restore down considerably.

The actual problem exposed by the above was that iptables-restore opens
a surprisingly large number of sockets when restoring said ruleset. This
stems from bugs in extension compatibility checks done during extension
registration (actually, "full registration").

One of the problems was that incompatible older revsions of an extension
never were never dropped from the pending list, and thus retried for
each rule using the extension. Coincidently, conntrack revision 0
matches this criteria.

Another problem was a (likely) accidental recursion of
xtables_fully_register_pending_*() via xtables_find_*(). In combination
with incompatible match revisions stuck in pending list, this caused
even more extra compatibility checks.

Solve all these problems by making pending extension lists sorted by
(descending) revision number. If at least one revision was compatible
with the kernel, any following incompatible ones may safely be dropped.
This should on one hand get rid of the repeated compatibility checks
while on the other maintain the presumptions stated in commit
3b2530ce7a0d6 ("xtables: Do not register matches/targets with
incompatible revision").

Patch 1 establishes the needed sorting in pending extension lists,
patch 2 then simplifies xtables_fully_register_pending_*() functions.
Patch 3 is strictly speaking not necessary but nice to have as it
streamlines array-based extension registrators with the extension
sorting.

Phil Sutter (3):
  libxtables: Make sure extensions register in revision order
  libxtables: Simplify pending extension registration
  libxtables: Register multiple extensions in ascending order

 libxtables/xtables.c | 206 +++++++++++++++++++++----------------------
 1 file changed, 99 insertions(+), 107 deletions(-)

-- 
2.28.0

