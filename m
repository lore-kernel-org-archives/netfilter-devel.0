Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5449CEE4993
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 15:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbjHVPnw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237296AbjHVPnv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 11:43:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDF2CCB;
        Tue, 22 Aug 2023 08:43:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qYTXg-0003EH-TZ; Tue, 22 Aug 2023 17:43:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 00/10] netfilter updates for net-next
Date:   Tue, 22 Aug 2023 17:43:21 +0200
Message-ID: <20230822154336.12888-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

This batch contains a few updates for your *net-next* tree.
First patch resolves a fortify warning by wrapping the to-be-copied
members via struct_group.

Second patch replaces array[0] with array[] in ebtables uapi.
Both changes from GONG Ruiqi.

The largest chunk is replacement of strncpy with strscpy_pad()
in netfilter, from Justin Stitt.

Last patch, from myself, aborts ruleset validation if a fatal
signal is pending, this speeds up process exit.

The following changes since commit 43c2817225fce05701f062a996255007481935e2:

  net: remove unnecessary input parameter 'how' in ifdown function (2023-08-22 13:19:02 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-23-08-22

for you to fetch changes up to 169384fbe8513185499bcbb817d198e6a63eb37e:

  netfilter: nf_tables: allow loop termination for pending fatal signal (2023-08-22 15:14:32 +0200)

----------------------------------------------------------------
nf-next pull request 2023-08-22

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nf_tables: allow loop termination for pending fatal signal

GONG, Ruiqi (2):
      netfilter: ebtables: fix fortify warnings in size_entry_mwt()
      netfilter: ebtables: replace zero-length array members

Justin Stitt (7):
      netfilter: ipset: refactor deprecated strncpy
      netfilter: nf_tables: refactor deprecated strncpy
      netfilter: nf_tables: refactor deprecated strncpy
      netfilter: nft_osf: refactor deprecated strncpy
      netfilter: nft_meta: refactor deprecated strncpy
      netfilter: x_tables: refactor deprecated strncpy
      netfilter: xtables: refactor deprecated strncpy

 include/uapi/linux/netfilter_bridge/ebtables.h | 22 ++++++++++++----------
 net/bridge/netfilter/ebtables.c                |  3 +--
 net/netfilter/ipset/ip_set_core.c              | 10 +++++-----
 net/netfilter/nf_tables_api.c                  |  6 ++++++
 net/netfilter/nft_ct.c                         |  2 +-
 net/netfilter/nft_fib.c                        |  2 +-
 net/netfilter/nft_meta.c                       |  6 +++---
 net/netfilter/nft_osf.c                        |  6 +++---
 net/netfilter/x_tables.c                       |  5 ++---
 net/netfilter/xt_repldata.h                    |  2 +-
 10 files changed, 35 insertions(+), 29 deletions(-)
