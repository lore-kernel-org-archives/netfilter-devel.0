Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3E4C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 22:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiJEWho (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJEWho (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 18:37:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67EC163F31
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 15:37:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 0/6] nf_tables inner tunnel header match support
Date:   Thu,  6 Oct 2022 00:37:34 +0200
Message-Id: <20221005223740.22991-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is version 2 for this patchset.

The inner expression provides a packet parser for the tunneled packet
which uses a userspace description of the expected inner headers. Then,
the inner expression (only payload and meta supported at this stage) is
used to match on the inner header protocol fields, using the new link,
network and transport offsets as well as inner metadata.

This patchset adds support for VxLAN, Geneve, GRE and IPIP. More tunnel
protocol can be supported via userspace updates only.

Changes in this v2:

Patch #1 interpret GRE flags to handle variable GRE header size.
Patch #2 no changes in IPIP support.
Patch #3 add nft_inner_parse_tunhdr() helper function to prepare
         for caching the inner offset in percpu area.
Patch #4 add NFT_PKTINFO_INNER_FULL flag and percpu area to cache
         the inner link, network and transport offsets. So the inner
         offsets are calculated one for the inner header type specified
         by userspace.
Patch #5 no changes in meta inner support.
Patch #6 add geneve support, this is required because it has optional
         TLV area which needs to be considered to accordingly calculate
         the inner link layer offset.

Thanks.

Pablo Neira Ayuso (6):
  netfilter: nft_payload: access GRE payload via inner offset
  netfilter: nft_payload: access ipip payload for inner offset
  netfilter: nft_inner: support for inner tunnel header matching
  netfilter: nft_inner: add percpu inner context
  netfilter: nft_meta: add inner match support
  netfilter: nft_inner: add geneve support

 include/net/netfilter/nf_tables.h        |   6 +
 include/net/netfilter/nf_tables_core.h   |  25 ++
 include/net/netfilter/nft_meta.h         |   6 +
 include/uapi/linux/netfilter/nf_tables.h |  27 ++
 net/netfilter/Makefile                   |   3 +-
 net/netfilter/nf_tables_api.c            |  37 +++
 net/netfilter/nf_tables_core.c           |   1 +
 net/netfilter/nft_inner.c                | 366 +++++++++++++++++++++++
 net/netfilter/nft_meta.c                 |  62 ++++
 net/netfilter/nft_payload.c              | 114 ++++++-
 10 files changed, 645 insertions(+), 2 deletions(-)
 create mode 100644 net/netfilter/nft_inner.c

--
2.30.2

