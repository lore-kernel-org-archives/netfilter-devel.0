Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81ECC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 12:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiATMHK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 07:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiATMHJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 07:07:09 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D069C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 04:07:09 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nAWDb-0002kA-PG; Thu, 20 Jan 2022 13:07:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: conntrack: remove extension register api
Date:   Thu, 20 Jan 2022 13:06:58 +0100
Message-Id: <20220120120702.15939-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This starts to simplify the extension infra. Should have no impact
on functionality.

Extension IDs already need compile-time allocation, the dynamic
registration isn't necessary, just place the sizes in the extension
core and handle the only instance of the ->destroy hook manually.

Also avoids the ->destroy hook invocation during ct destruction if
the conntrack wasn't added to the bysource hash list.

Florian Westphal (4):
  netfilter: conntrack: make all extensions 8-byte alignned
  netfilter: conntrack: move extension sizes into core
  netfilter: conntrack: hande ->destroy hook via nat_ops instead
  netfilter: conntrack: remove extension register api

 include/linux/netfilter.h                     |   1 +
 include/net/netfilter/nf_conntrack_acct.h     |   1 -
 include/net/netfilter/nf_conntrack_ecache.h   |  13 --
 include/net/netfilter/nf_conntrack_extend.h   |  18 +--
 include/net/netfilter/nf_conntrack_labels.h   |   3 -
 include/net/netfilter/nf_conntrack_seqadj.h   |   3 -
 include/net/netfilter/nf_conntrack_timeout.h  |  12 --
 .../net/netfilter/nf_conntrack_timestamp.h    |  13 --
 net/netfilter/nf_conntrack_acct.c             |  19 ---
 net/netfilter/nf_conntrack_core.c             |  94 ++-----------
 net/netfilter/nf_conntrack_ecache.c           |  24 +---
 net/netfilter/nf_conntrack_extend.c           | 132 ++++++++++--------
 net/netfilter/nf_conntrack_helper.c           |  17 ---
 net/netfilter/nf_conntrack_labels.c           |  20 +--
 net/netfilter/nf_conntrack_seqadj.c           |  16 ---
 net/netfilter/nf_conntrack_timeout.c          |  19 ---
 net/netfilter/nf_conntrack_timestamp.c        |  20 ---
 net/netfilter/nf_nat_core.c                   |  28 +---
 net/netfilter/nf_synproxy_core.c              |  24 +---
 net/sched/act_ct.c                            |  13 --
 20 files changed, 95 insertions(+), 395 deletions(-)

-- 
2.34.1

