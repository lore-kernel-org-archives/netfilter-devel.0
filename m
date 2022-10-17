Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E82C43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiJQLEF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiJQLDn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:03:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCE8A113E
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:03:41 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v5 0/7] nf_tables inner tunnel header match support
Date:   Mon, 17 Oct 2022 13:03:28 +0200
Message-Id: <20221017110335.742076-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is version 5 for this patchset.

The inner expression provides a packet parser for the tunneled packet
which uses a userspace description of the expected inner headers. Then,
the inner expression (only payload and meta supported at this stage) is
used to match on the inner header protocol fields, using the new link,
network and transport offsets as well as inner metadata.

This patchset adds support for VxLAN, Geneve, GRE and IPIP.

Changes in this v5:

Patch #1 skip if GRE_ROUTING flag is set
Patch #2 no changes
Patch #3 use absolute inner offsets
         restrict tunnel header offset to GRE and UDP.
         set ctx->llproto to outer ethertype to fix NFT_META_PROTOCOL semantics.
Patch #4 no changes
Patch #5 no changes
Patch #6 no changes
Patch #7 new in the series: set tunnel header offset to GRE header.

Pablo Neira Ayuso (7):
  netfilter: nft_payload: access GRE payload via inner offset
  netfilter: nft_payload: access ipip payload for inner offset
  netfilter: nft_inner: support for inner tunnel header matching
  netfilter: nft_inner: add percpu inner context
  netfilter: nft_meta: add inner match support
  netfilter: nft_inner: add geneve support
  netfilter: nft_inner: set tunnel offset to GRE header offset

 include/net/netfilter/nf_tables.h        |   6 +
 include/net/netfilter/nf_tables_core.h   |  25 ++
 include/net/netfilter/nft_meta.h         |   6 +
 include/uapi/linux/netfilter/nf_tables.h |  27 ++
 net/netfilter/Makefile                   |   3 +-
 net/netfilter/nf_tables_api.c            |  37 +++
 net/netfilter/nf_tables_core.c           |   1 +
 net/netfilter/nft_inner.c                | 384 +++++++++++++++++++++++
 net/netfilter/nft_meta.c                 |  62 ++++
 net/netfilter/nft_payload.c              | 124 +++++++-
 10 files changed, 673 insertions(+), 2 deletions(-)
 create mode 100644 net/netfilter/nft_inner.c

--
2.30.2

