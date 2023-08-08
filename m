Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02874C04A6A
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 17:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjHHRwX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjHHRvT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 13:51:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2544A9EC7;
        Tue,  8 Aug 2023 09:23:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qTM2G-0000Jr-0x; Tue, 08 Aug 2023 14:42:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/5] netfilter updates for net-next
Date:   Tue,  8 Aug 2023 14:41:43 +0200
Message-ID: <20230808124159.19046-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

This batch contains a few updates for your *net-next* tree.
First 4 Patches, from Yue Haibing, remove unused prototypes in
various netfilter headers.

Last patch makes nfnetlink_log to always include a packet timestamp, up
to now it was only included if the skb had assigned previously.
From Maciej Żenczykowski.


The following changes since commit b98a5aa7e4c20d6e4d9062ee0f0156ff3ad300fa:

  Merge branch 'net-remove-redundant-initialization-owner' (2023-08-07 19:18:30 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-2023-08-08

for you to fetch changes up to 1d85594fd3e7e39e63b53b1bdc2d89db43b6ecd5:

  netfilter: nfnetlink_log: always add a timestamp (2023-08-08 13:03:36 +0200)

----------------------------------------------------------------
nf-next pull request 2023-08-08

----------------------------------------------------------------
Maciej Żenczykowski (1):
      netfilter: nfnetlink_log: always add a timestamp

Yue Haibing (4):
      netfilter: gre: Remove unused function declaration nf_ct_gre_keymap_flush()
      netfilter: helper: Remove unused function declarations
      netfilter: conntrack: Remove unused function declarations
      netfilter: h323: Remove unused function declarations

 include/linux/netfilter/nf_conntrack_h323.h      | 4 ----
 include/linux/netfilter/nf_conntrack_proto_gre.h | 1 -
 include/net/netfilter/nf_conntrack.h             | 4 ----
 include/net/netfilter/nf_conntrack_acct.h        | 2 --
 include/net/netfilter/nf_conntrack_helper.h      | 3 ---
 include/net/netfilter/nf_conntrack_labels.h      | 1 -
 net/netfilter/nfnetlink_log.c                    | 6 ++----
 7 files changed, 2 insertions(+), 19 deletions(-)
