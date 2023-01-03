Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EBCC4708E
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Jan 2023 12:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237610AbjACMrb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Jan 2023 07:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237616AbjACMr0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Jan 2023 07:47:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C01BF7
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2023 04:47:25 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pCghO-0003tL-El; Tue, 03 Jan 2023 13:47:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: nf_tables: extend retpoline workarounds
Date:   Tue,  3 Jan 2023 13:47:14 +0100
Message-Id: <20230103124717.8178-1-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- Skip the retpoline if-else cascade if the cpu is recent enough to not
  need the retpoline thunk.

- add objref and 'ct state' to the builtin-call list.
  This means that 'ct state established,related accept' works without
  an indirect call.

Florian Westphal (3):
  netfilter: nf_tables: add static key to skip retpoline workarounds
  netfilter: nf_tables: avoid retpoline overhead for objref calls
  netfilter: nf_tables: avoid retpoline overhead for some ct expression
    calls

 include/net/netfilter/nf_tables_core.h | 16 ++++++++
 net/netfilter/Makefile                 |  6 +++
 net/netfilter/nf_tables_core.c         | 35 +++++++++++++++-
 net/netfilter/nft_ct.c                 | 39 ++++++++++++------
 net/netfilter/nft_ct_fast.c            | 56 ++++++++++++++++++++++++++
 net/netfilter/nft_objref.c             | 12 +++---
 6 files changed, 145 insertions(+), 19 deletions(-)
 create mode 100644 net/netfilter/nft_ct_fast.c

-- 
2.38.2

