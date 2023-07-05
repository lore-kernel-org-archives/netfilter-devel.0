Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC92AEB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 23:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjGEXEQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 19:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjGEXEP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 19:04:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAA7E102;
        Wed,  5 Jul 2023 16:04:14 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/6] Netfilter fixes for net
Date:   Thu,  6 Jul 2023 01:04:00 +0200
Message-Id: <20230705230406.52201-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix missing overflow use refcount checks in nf_tables.

2) Do not set IPS_ASSURED for IPS_NAT_CLASH entries in GRE tracker,
   from Florian Westphal.

3) Bail out if nf_ct_helper_hash is NULL before registering helper,
   from Florent Revest.

4) Use siphash() instead siphash_4u64() to fix performance regression,
   also from Florian.

5) Do not allow to add rules to removed chains via ID,
   from Thadeu Lima de Souza Cascardo.

6) Fix oob read access in byteorder expression, also from Thadeu.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-07-06

Thanks.

----------------------------------------------------------------

The following changes since commit c451410ca7e3d8eeb31d141fc20c200e21754ba4:

  Merge branch 'mptcp-fixes' (2023-07-05 10:51:14 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-07-06

for you to fetch changes up to caf3ef7468f7534771b5c44cd8dbd6f7f87c2cbd:

  netfilter: nf_tables: prevent OOB access in nft_byteorder_eval (2023-07-06 00:53:14 +0200)

----------------------------------------------------------------
netfilter pull request 23-07-06

----------------------------------------------------------------
Florent Revest (1):
      netfilter: conntrack: Avoid nf_ct_helper_hash uses after free

Florian Westphal (2):
      netfilter: conntrack: gre: don't set assured flag for clash entries
      netfilter: conntrack: don't fold port numbers into addresses before hashing

Pablo Neira Ayuso (1):
      netfilter: nf_tables: report use refcount overflow

Thadeu Lima de Souza Cascardo (2):
      netfilter: nf_tables: do not ignore genmask when looking up chain by id
      netfilter: nf_tables: prevent OOB access in nft_byteorder_eval

 include/net/netfilter/nf_conntrack_tuple.h |   3 +
 include/net/netfilter/nf_tables.h          |  31 ++++-
 net/netfilter/nf_conntrack_core.c          |  20 ++--
 net/netfilter/nf_conntrack_helper.c        |   4 +
 net/netfilter/nf_conntrack_proto_gre.c     |  10 +-
 net/netfilter/nf_tables_api.c              | 174 ++++++++++++++++++-----------
 net/netfilter/nft_byteorder.c              |  14 +--
 net/netfilter/nft_flow_offload.c           |   6 +-
 net/netfilter/nft_immediate.c              |   8 +-
 net/netfilter/nft_objref.c                 |   8 +-
 10 files changed, 178 insertions(+), 100 deletions(-)
