Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CA8C83F15
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 23:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237140AbjH3X7p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 19:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241959AbjH3X7o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 19:59:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71C04CD6;
        Wed, 30 Aug 2023 16:59:41 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/5] Netfilter fixes for net
Date:   Thu, 31 Aug 2023 01:59:30 +0200
Message-Id: <20230830235935.465690-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix mangling of TCP options with non-linear skbuff, from Xiao Liang.

2) OOB read in xt_sctp due to missing sanitization of array length field.
   From Wander Lairson Costa.

3) OOB read in xt_u32 due to missing sanitization of array length field.
   Also from Wander Lairson Costa.

All of them above, always broken for several releases.

4) Missing audit log for set element reset command, from Phil Sutter.

5) Missing audit log for rule reset command, also from Phil.

These audit log support are missing in 6.5.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-08-31

Thanks.

----------------------------------------------------------------

The following changes since commit bd6c11bc43c496cddfc6cf603b5d45365606dbd5:

  Merge tag 'net-next-6.6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2023-08-29 11:33:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-08-31

for you to fetch changes up to ea078ae9108e25fc881c84369f7c03931d22e555:

  netfilter: nf_tables: Audit log rule reset (2023-08-31 01:29:28 +0200)

----------------------------------------------------------------
netfilter pull request 23-08-31

----------------------------------------------------------------
Phil Sutter (2):
      netfilter: nf_tables: Audit log setelem reset
      netfilter: nf_tables: Audit log rule reset

Wander Lairson Costa (2):
      netfilter: xt_sctp: validate the flag_info count
      netfilter: xt_u32: validate user space input

Xiao Liang (1):
      netfilter: nft_exthdr: Fix non-linear header modification

 include/linux/audit.h         |  2 ++
 kernel/auditsc.c              |  2 ++
 net/netfilter/nf_tables_api.c | 49 ++++++++++++++++++++++++++++++++++++++++---
 net/netfilter/nft_exthdr.c    | 20 +++++++-----------
 net/netfilter/xt_sctp.c       |  2 ++
 net/netfilter/xt_u32.c        | 21 +++++++++++++++++++
 6 files changed, 81 insertions(+), 15 deletions(-)
