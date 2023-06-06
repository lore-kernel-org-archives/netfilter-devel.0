Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67E5C7EE37
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 22:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240162AbjFFW7E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240134AbjFFW67 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 18:58:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 506551717;
        Tue,  6 Jun 2023 15:58:56 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 0/5] Netfilter fixes for net
Date:   Wed,  7 Jun 2023 00:58:46 +0200
Message-Id: <20230606225851.67394-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Missing nul-check in basechain hook netlink dump path, from Gavrilov Ilia.

2) Fix bitwise register tracking, from Jeremy Sowden.

3) Null pointer dereference when accessing conntrack helper,
   from Tijs Van Buggenhout.

4) Add schedule point to ipset's call_ad, from Kuniyuki Iwashima.

5) Incorrect boundary check when building chain blob.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-06-07

Thanks.

----------------------------------------------------------------

The following changes since commit 9025944fddfed5966c8f102f1fe921ab3aee2c12:

  net: fec: add dma_wmb to ensure correct descriptor values (2023-05-19 09:17:53 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-06-07

for you to fetch changes up to 08e42a0d3ad30f276f9597b591f975971a1b0fcf:

  netfilter: nf_tables: out-of-bound check in chain blob (2023-06-07 00:43:44 +0200)

----------------------------------------------------------------
netfilter pull request 23-06-07

----------------------------------------------------------------
Gavrilov Ilia (1):
      netfilter: nf_tables: Add null check for nla_nest_start_noflag() in nft_dump_basechain_hook()

Jeremy Sowden (1):
      netfilter: nft_bitwise: fix register tracking

Kuniyuki Iwashima (1):
      netfilter: ipset: Add schedule point in call_ad().

Pablo Neira Ayuso (1):
      netfilter: nf_tables: out-of-bound check in chain blob

Tijs Van Buggenhout (1):
      netfilter: conntrack: fix NULL pointer dereference in nf_confirm_cthelper

 net/netfilter/ipset/ip_set_core.c | 8 ++++++++
 net/netfilter/nf_conntrack_core.c | 3 +++
 net/netfilter/nf_tables_api.c     | 4 +++-
 net/netfilter/nft_bitwise.c       | 2 +-
 4 files changed, 15 insertions(+), 2 deletions(-)
