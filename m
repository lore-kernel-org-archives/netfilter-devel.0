Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6A7C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Jul 2022 19:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiGBTKe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Jul 2022 15:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGBTKe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Jul 2022 15:10:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EFD1E00A;
        Sat,  2 Jul 2022 12:10:33 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Sat,  2 Jul 2022 21:10:26 +0200
Message-Id: <20220702191029.238563-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Insufficient validation of element datatype and length in
   nft_setelem_parse_data(). At least commit 7d7402642eaf updates
   maximum element data area up to 64 bytes when only 16 bytes
   where supported at the time. Support for larger element size
   came later in fdb9c405e35b though. Picking this older commit
   as Fixes: tag to be safe than sorry.

2) Memleak in pipapo destroy path, reproducible when transaction
   in aborted. This is already triggering in the existing netfilter
   test infrastructure since more recent new tests are covering this
   path.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit f8ebb3ac881b17712e1d5967c97ab1806b16d3d6:

  net: usb: ax88179_178a: Fix packet receiving (2022-06-30 10:41:57 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 9827a0e6e23bf43003cd3d5b7fb11baf59a35e1e:

  netfilter: nft_set_pipapo: release elements in clone from abort path (2022-07-02 21:04:19 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nf_tables: stricter validation of element data
      netfilter: nft_set_pipapo: release elements in clone from abort path

 net/netfilter/nf_tables_api.c  |  9 +++++++-
 net/netfilter/nft_set_pipapo.c | 48 +++++++++++++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 16 deletions(-)
