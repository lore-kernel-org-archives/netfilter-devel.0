Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC23FE7B61E
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 14:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242857AbjJDOOX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 10:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242854AbjJDOOW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 10:14:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A60BC1;
        Wed,  4 Oct 2023 07:14:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qo2dd-0002LF-6Q; Wed, 04 Oct 2023 16:14:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 0/6] netfilter patches for net
Date:   Wed,  4 Oct 2023 16:13:44 +0200
Message-ID: <20231004141405.28749-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

The following batch contains netfilter fixes and selftests for the *net* tree.

First patch resolves a regression with vlan header matching, this was
broken since 6.5 release.  From myself.

Second patch fixes an ancient problem with sctp connection tracking in
case INIT_ACK packets are delayed.  This comes with a selftest, both
patches from Xin Long.

Patch 4 extends the existing nftables audit selftest, from
Phil Sutter.

Patch 5, also from Phil, avoids a situation where nftables
would emit an audit record twice. This was broken since 5.13 days.

Patch 6, from myself, avoids spurious insertion failure if we encounter an
overlapping but expired range during element insertion with the
'nft_set_rbtree' backend. This problem exists since 6.2.

The following changes since commit 51e7a66666e0ca9642c59464ef8359f0ac604d41:

  ibmveth: Remove condition to recompute TCP header checksum. (2023-10-04 11:19:57 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-10-04

for you to fetch changes up to 087388278e0f301f4c61ddffb1911d3a180f84b8:

  netfilter: nf_tables: nft_set_rbtree: fix spurious insertion failure (2023-10-04 15:57:28 +0200)

----------------------------------------------------------------
netfilter pull request 2023-10-04

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nft_payload: rebuild vlan header on h_proto access
      netfilter: nf_tables: nft_set_rbtree: fix spurious insertion failure

Phil Sutter (2):
      selftests: netfilter: Extend nft_audit.sh
      netfilter: nf_tables: Deduplicate nft_register_obj audit logs

Xin Long (2):
      netfilter: handle the connecting collision properly in nf_conntrack_proto_sctp
      selftests: netfilter: test for sctp collision processing in nf_conntrack

 include/linux/netfilter/nf_conntrack_sctp.h        |   1 +
 net/netfilter/nf_conntrack_proto_sctp.c            |  43 ++++++--
 net/netfilter/nf_tables_api.c                      |  44 +++++---
 net/netfilter/nft_payload.c                        |  13 ++-
 net/netfilter/nft_set_rbtree.c                     |  46 +++++---
 tools/testing/selftests/netfilter/Makefile         |   5 +-
 .../netfilter/conntrack_sctp_collision.sh          |  89 ++++++++++++++++
 tools/testing/selftests/netfilter/nft_audit.sh     | 117 ++++++++++++++++++---
 tools/testing/selftests/netfilter/sctp_collision.c |  99 +++++++++++++++++
 9 files changed, 395 insertions(+), 62 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/conntrack_sctp_collision.sh
 create mode 100644 tools/testing/selftests/netfilter/sctp_collision.c
