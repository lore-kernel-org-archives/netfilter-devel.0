Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C8BC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 16:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiBXQpZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 11:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiBXQpY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 11:45:24 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6157F14FFFF
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 08:44:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nNHEZ-0005e6-HD; Thu, 24 Feb 2022 17:44:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/7] netfilter: remove pcpu dying list
Date:   Thu, 24 Feb 2022 17:44:39 +0100
Message-Id: <20220224164446.23208-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

v2: fix EXPORT_SYMBOL_GPL related build failure in patch 6.
No other changes.

This is part 1 of a series that aims to remove both the unconfirmed
and dying lists.

This moves the dying list into the ecache infrastructure.
Entries are placed on this list only if the delivery of the destroy
event has failed (which implies that at least one userspace listener
did request redelivery).

The percpu dying list is removed in the last patch as it has no
functionality anymore.  This avoids the extra spinlock for conntrack
removal.

Florian Westphal (7):
  nfnetlink: handle already-released nl socket
  netfilter: ctnetlink: make ecache event cb global again
  netfilter: ecache: move to separate structure
  netfilter: ecache: use dedicated list for event redelivery
  netfilter: conntrack: split inner loop of list dumping to own function
  netfilter: conntrack: include ecache dying list in dumps
  netfilter: conntrack: remove the percpu dying list

 include/net/netfilter/nf_conntrack.h        |   9 +-
 include/net/netfilter/nf_conntrack_ecache.h |  21 +--
 include/net/netns/conntrack.h               |   2 -
 net/netfilter/nf_conntrack_core.c           |  60 ++++---
 net/netfilter/nf_conntrack_ecache.c         | 172 +++++++++-----------
 net/netfilter/nf_conntrack_netlink.c        | 150 +++++++++--------
 net/netfilter/nfnetlink.c                   |  62 +++++--
 7 files changed, 256 insertions(+), 220 deletions(-)

-- 
2.34.1

