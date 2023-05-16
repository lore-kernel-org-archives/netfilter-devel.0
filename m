Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C092CC7EE25
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 15:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjEPPGk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 May 2023 11:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjEPPGk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2023 11:06:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A4F38683;
        Tue, 16 May 2023 08:06:24 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,4.19 0/9] stable fixes for 4.19
Date:   Tue, 16 May 2023 17:06:04 +0200
Message-Id: <20230516150613.4566-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

This is a batch of -stable backport fixes for 4.19. This batch includes
dependency patches which are not currently in the 4.19 branch.

The following list shows the backported patches, I am using original
commit IDs for reference:

1) 4f16d25c68ec ("netfilter: nftables: add nft_parse_register_load() and use it")

2) 345023b0db31 ("netfilter: nftables: add nft_parse_register_store() and use it")

3) 08a01c11a5bb ("netfilter: nftables: statify nft_parse_register()")

4) 6e1acfa387b9 ("netfilter: nf_tables: validate registers coming from userspace.")

5) 20a1452c3542 ("netfilter: nf_tables: add nft_setelem_parse_key()")

6) fdb9c405e35b ("netfilter: nf_tables: allow up to 64 bytes in the set element data area")

7) 7e6bc1f6cabc ("netfilter: nf_tables: stricter validation of element data")

8) 5a2f3dc31811 ("netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on NFT_SET_OBJECT flag")

9) 36d5b2913219 ("netfilter: nf_tables: do not allow RULE_ID to refer to another chain")

Patches #1, #2, #3, #5, #6 are dependencies.

Please apply,
Thanks,

Pablo Neira Ayuso (9):
  netfilter: nftables: add nft_parse_register_load() and use it
  netfilter: nftables: add nft_parse_register_store() and use it
  netfilter: nftables: statify nft_parse_register()
  netfilter: nf_tables: validate registers coming from userspace.
  netfilter: nf_tables: add nft_setelem_parse_key()
  netfilter: nf_tables: allow up to 64 bytes in the set element data area
  netfilter: nf_tables: stricter validation of element data
  netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on NFT_SET_OBJECT flag
  netfilter: nf_tables: do not allow RULE_ID to refer to another chain

 include/net/netfilter/nf_tables.h      |  15 +-
 include/net/netfilter/nf_tables_core.h |   9 +-
 include/net/netfilter/nft_fib.h        |   2 +-
 include/net/netfilter/nft_masq.h       |   4 +-
 include/net/netfilter/nft_redir.h      |   4 +-
 net/ipv4/netfilter/nft_dup_ipv4.c      |  18 +-
 net/ipv6/netfilter/nft_dup_ipv6.c      |  18 +-
 net/netfilter/nf_tables_api.c          | 228 ++++++++++++++++---------
 net/netfilter/nft_bitwise.c            |  14 +-
 net/netfilter/nft_byteorder.c          |  14 +-
 net/netfilter/nft_cmp.c                |   8 +-
 net/netfilter/nft_ct.c                 |  12 +-
 net/netfilter/nft_dup_netdev.c         |   6 +-
 net/netfilter/nft_dynset.c             |  12 +-
 net/netfilter/nft_exthdr.c             |  14 +-
 net/netfilter/nft_fib.c                |   5 +-
 net/netfilter/nft_fwd_netdev.c         |  18 +-
 net/netfilter/nft_hash.c               |  25 ++-
 net/netfilter/nft_immediate.c          |   6 +-
 net/netfilter/nft_lookup.c             |  14 +-
 net/netfilter/nft_masq.c               |  14 +-
 net/netfilter/nft_meta.c               |  12 +-
 net/netfilter/nft_nat.c                |  35 ++--
 net/netfilter/nft_numgen.c             |  15 +-
 net/netfilter/nft_objref.c             |   6 +-
 net/netfilter/nft_osf.c                |   8 +-
 net/netfilter/nft_payload.c            |  10 +-
 net/netfilter/nft_queue.c              |  12 +-
 net/netfilter/nft_range.c              |   6 +-
 net/netfilter/nft_redir.c              |  14 +-
 net/netfilter/nft_rt.c                 |   7 +-
 net/netfilter/nft_socket.c             |   7 +-
 net/netfilter/nft_tproxy.c             |  14 +-
 net/netfilter/nft_tunnel.c             |   8 +-
 34 files changed, 328 insertions(+), 286 deletions(-)

-- 
2.30.2

