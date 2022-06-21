Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBD7C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jun 2022 10:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347043AbiFUKva (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jun 2022 06:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiFUKvM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jun 2022 06:51:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA62E027
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 03:51:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o3bTP-0002bM-Ov; Tue, 21 Jun 2022 12:51:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: conntrack sparse annotations
Date:   Tue, 21 Jun 2022 12:50:54 +0200
Message-Id: <20220621105057.24394-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series reduces the number of generated sparse warnings
in the netfilter codebase.

In some cases its just due to a missing '__rcu' annotation
of the base pointer, but in some other cases there is a
direct access to a __rcu annotated base pointer.

Florian Westphal (3):
  netfilter: nf_conntrack: add missing __rcu annotations
  netfilter: nf_conntrack: use rcu accessors where needed
  netfilter: h323: merge nat hook pointers into one

 include/linux/netfilter/nf_conntrack_h323.h  | 109 ++++----
 include/linux/netfilter/nf_conntrack_sip.h   |   2 +-
 include/net/netfilter/nf_conntrack_timeout.h |   2 +-
 net/ipv4/netfilter/nf_nat_h323.c             |  42 +--
 net/netfilter/nf_conntrack_broadcast.c       |   6 +-
 net/netfilter/nf_conntrack_h323_main.c       | 259 +++++++------------
 net/netfilter/nf_conntrack_helper.c          |   2 +-
 net/netfilter/nf_conntrack_netlink.c         |   9 +-
 net/netfilter/nf_conntrack_pptp.c            |   2 +-
 net/netfilter/nf_conntrack_sip.c             |   9 +-
 net/netfilter/nf_conntrack_timeout.c         |  18 +-
 net/netfilter/nfnetlink_cthelper.c           |  10 +-
 net/netfilter/xt_CT.c                        |  23 +-
 13 files changed, 230 insertions(+), 263 deletions(-)

-- 
2.35.1

