Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44D0C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 13:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiDYNS5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 09:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiDYNS4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 09:18:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6533817E0A
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 06:15:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1niyZC-00045B-Ej; Mon, 25 Apr 2022 15:15:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: conntrack: avoid eache extension allocation
Date:   Mon, 25 Apr 2022 15:15:40 +0200
Message-Id: <20220425131544.27860-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch series changes ecache infra to no longer allocate the
extension by default.

After this series, the default behaviour is to allocate the
extension if either a conntrack template has been set to configure event
masks via nft/iptables ruleset, the syctl 'nf_conntrack_events' is set
to 1, or if a userspace program has subscribed to one of the ctnetlink
event groups.

This has advantages in case the events are not used:
1. Conntrack allocation/free avoids extra kmalloc/kfree call.
2. nf_confirm hook doesn't perform an indirect call into ctnetlink
   only to discover that there is nothing to do.

Florian Westphal (4):
  netfilter: nfnetlink: allow to detect if ctnetlink listeners exist
  netfilter: conntrack: un-inline nf_ct_ecache_ext_add
  netfilter: conntrack: add nf_conntrack_events autodetect mode
  netfilter: prefer extension check to pointer check

 .../networking/nf_conntrack-sysctl.rst        |  5 +-
 include/net/netfilter/nf_conntrack_core.h     |  2 +-
 include/net/netfilter/nf_conntrack_ecache.h   | 49 ++++++-------------
 include/net/netns/conntrack.h                 |  1 +
 net/netfilter/nf_conntrack_core.c             | 15 ++++--
 net/netfilter/nf_conntrack_ecache.c           | 39 ++++++++++++++-
 net/netfilter/nf_conntrack_standalone.c       |  2 +-
 net/netfilter/nfnetlink.c                     | 40 +++++++++++++--
 8 files changed, 108 insertions(+), 45 deletions(-)

-- 
2.35.1

