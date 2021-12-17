Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 294F2C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 08:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhLQIxO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 03:53:14 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60478 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbhLQIxM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 03:53:12 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1BE0C605C3;
        Fri, 17 Dec 2021 09:50:41 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Fri, 17 Dec 2021 09:53:00 +0100
Message-Id: <20211217085303.363401-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix UAF in set catch-all element, from Eric Dumazet.

2) Fix MAC mangling for multicast/loopback traffic in nfnetlink_queue
   and nfnetlink_log, from Ignacy Gawędzki.

3) Remove expired entries from ctnetlink dump path regardless the tuple
   direction, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 1d1c950faa81e1c287c9e14f307f845b190eb578:

  Merge tag 'wireless-drivers-2021-12-15' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers (2021-12-15 14:43:07 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 76f12e632a15a20c8de3532d64a0708cf0e32f11:

  netfilter: ctnetlink: remove expired entries first (2021-12-16 14:10:52 +0100)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: nf_tables: fix use-after-free in nft_set_catchall_destroy()

Florian Westphal (1):
      netfilter: ctnetlink: remove expired entries first

Ignacy Gawędzki (1):
      netfilter: fix regression in looped (broad|multi)cast's MAC handling

 net/netfilter/nf_conntrack_netlink.c | 5 +++--
 net/netfilter/nf_tables_api.c        | 4 ++--
 net/netfilter/nfnetlink_log.c        | 3 ++-
 net/netfilter/nfnetlink_queue.c      | 3 ++-
 4 files changed, 9 insertions(+), 6 deletions(-)
