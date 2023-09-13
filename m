Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFF9EE0211
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 21:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjIMV6Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjIMV6P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 17:58:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 459871981;
        Wed, 13 Sep 2023 14:58:11 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/9] Netfilter fixes for net
Date:   Wed, 13 Sep 2023 23:57:51 +0200
Message-Id: <20230913215800.107269-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Do not permit to remove rules from chain binding, otherwise
   double rule release is possible, triggering UaF. This rule
   deletion support does not make sense and userspace does not use
   this. Problem exists since the introduction of chain binding support.

2) rbtree GC worker only collects the elements that have expired.
   This operation is not destructive, therefore, turn write into
   read spinlock to avoid datapath contention due to GC worker run.
   This was not fixed in the recent GC fix batch in the 6.5 cycle.

3) pipapo set backend performs sync GC, therefore, catchall elements
   must use sync GC queue variant. This bug was introduced in the
   6.5 cycle with the recent GC fixes.

4) Stop GC run if memory allocation fails in pipapo set backend,
   otherwise access to NULL pointer to GC transaction object might
   occur. This bug was introduced in the 6.5 cycle with the recent
   GC fixes.

5) rhash GC run uses an iterator that might hit EAGAIN to rewind,
   triggering double-collection of the same element. This bug was
   introduced in the 6.5 cycle with the recent GC fixes.

6) Do not permit to remove elements in anonymous sets, this type of
   sets are populated once and then bound to rules. This fix is
   similar to the chain binding patch coming first in this batch.
   API permits since the very beginning but it has no use case from
   userspace.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-09-13

Thanks.

----------------------------------------------------------------

The following changes since commit 1b36955cc048c8ff6ba448dbf4be0e52f59f2963:

  net: enetc: distinguish error from valid pointers in enetc_fixup_clear_rss_rfs() (2023-09-07 11:19:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-09-13

for you to fetch changes up to e8dbde59ca3fe925d0105bfb380e8429928b16dd:

  selftests: netfilter: Test nf_tables audit logging (2023-09-13 21:57:50 +0200)

----------------------------------------------------------------
netfilter pull request 23-09-13

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: fix extension size table

Pablo Neira Ayuso (6):
      netfilter: nf_tables: disallow rule removal from chain binding
      netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention
      netfilter: nft_set_pipapo: call nft_trans_gc_queue_sync() in catchall GC
      netfilter: nft_set_pipapo: stop GC iteration if GC transaction allocation fails
      netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration
      netfilter: nf_tables: disallow element removal on anonymous sets

Phil Sutter (2):
      netfilter: nf_tables: Fix entries val in rule reset audit log
      selftests: netfilter: Test nf_tables audit logging

 include/net/netfilter/nf_tables.h                 |   5 +-
 net/netfilter/nf_conntrack_extend.c               |   4 +-
 net/netfilter/nf_tables_api.c                     |  65 ++++++---
 net/netfilter/nft_set_hash.c                      |  11 +-
 net/netfilter/nft_set_pipapo.c                    |   4 +-
 net/netfilter/nft_set_rbtree.c                    |   8 +-
 tools/testing/selftests/netfilter/.gitignore      |   1 +
 tools/testing/selftests/netfilter/Makefile        |   4 +-
 tools/testing/selftests/netfilter/audit_logread.c | 165 ++++++++++++++++++++++
 tools/testing/selftests/netfilter/config          |   1 +
 tools/testing/selftests/netfilter/nft_audit.sh    | 108 ++++++++++++++
 11 files changed, 338 insertions(+), 38 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/audit_logread.c
 create mode 100755 tools/testing/selftests/netfilter/nft_audit.sh
