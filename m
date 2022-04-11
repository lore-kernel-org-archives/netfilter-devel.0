Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43E0C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Apr 2022 11:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbiDKLDs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Apr 2022 07:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiDKLDr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Apr 2022 07:03:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E38CC47
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Apr 2022 04:01:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndrnW-0000Hy-Th; Mon, 11 Apr 2022 13:01:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 00/10] netfilter: conntrack: remove percpu lists
Date:   Mon, 11 Apr 2022 13:01:15 +0200
Message-Id: <20220411110125.4854-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series removes the unconfirmed and dying percpu lists.

Dying list is replaced by pernet list, only used when reliable event
delivery mode was requested.

Unconfirmed list is replaced by a generation id for the conntrack
extesions, to detect when pointers to external objects (timeout policy,
helper, ...) has gone stale.

An alternative to the genid would be to always take references on
such external objects, let me know if that is the preferred solution.

Changes in v4:
- drop patch to move to global event_cb in netlink
- this allows to drop the preceding nfnl patch
- drop cttimeout rcu patch, its not required
- amend commit message in patch 3 to mention need to move
  IPS_CONFIRMED bit setting.

Changes in v3:
- fix build bugs reported by kbuild robot
- add patch #16

Florian Westphal (10):
  netfilter: ecache: use dedicated list for event redelivery
  netfilter: conntrack: include ecache dying list in dumps
  netfilter: conntrack: remove the percpu dying list
  netfilter: cttimeout: decouple unlink and free on netns destruction
  netfilter: remove nf_ct_unconfirmed_destroy helper
  netfilter: extensions: introduce extension genid count
  netfilter: cttimeout: decouple unlink and free on netns destruction
  netfilter: conntrack: remove __nf_ct_unconfirmed_destroy
  netfilter: conntrack: remove unconfirmed list
  netfilter: conntrack: avoid unconditional local_bh_disable

 include/net/netfilter/nf_conntrack.h         |   7 +-
 include/net/netfilter/nf_conntrack_ecache.h  |   4 +-
 include/net/netfilter/nf_conntrack_extend.h  |  31 +--
 include/net/netfilter/nf_conntrack_labels.h  |  10 +-
 include/net/netfilter/nf_conntrack_timeout.h |   8 -
 include/net/netns/conntrack.h                |   7 -
 net/netfilter/nf_conntrack_core.c            | 230 ++++++++-----------
 net/netfilter/nf_conntrack_ecache.c          | 127 +++++-----
 net/netfilter/nf_conntrack_extend.c          |  32 ++-
 net/netfilter/nf_conntrack_helper.c          |   5 -
 net/netfilter/nf_conntrack_netlink.c         |  76 +++---
 net/netfilter/nfnetlink_cttimeout.c          |  47 +++-
 12 files changed, 298 insertions(+), 286 deletions(-)

-- 
2.35.1

