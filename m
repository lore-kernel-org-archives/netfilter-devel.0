Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22358C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Oct 2022 09:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiJGJQc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Oct 2022 05:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJGJQS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2022 05:16:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 363FE9F758
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Oct 2022 02:16:17 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 0/6] nf_tables inner tunnel header match support
Date:   Fri,  7 Oct 2022 11:16:08 +0200
Message-Id: <20221007091614.339582-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is version 3 for this patchset.

The inner expression provides a packet parser for the tunneled packet
which uses a userspace description of the expected inner headers. Then,
the inner expression (only payload and meta supported at this stage) is
used to match on the inner header protocol fields, using the new link,
network and transport offsets as well as inner metadata.

This patchset adds support for VxLAN, Geneve, GRE and IPIP. More tunnel
protocol can be supported via userspace updates only.

Changes in this v3:

Patch #1 handle GREv0 and GREv1 (PPTP) and variable size header depending
         on flags.
Patch #2 no changes
Patch #3 no changes
Patch #4 update existing percpu tunnel context only if header parser fully
         succeeds, to not leave tunnel context in inconsistent state.
Patch #5 no changes.
Patch #6 no changes.

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
 net/netfilter/nft_inner.c                | 368 +++++++++++++++++++++++
 net/netfilter/nft_meta.c                 |  62 ++++
 net/netfilter/nft_payload.c              | 130 +++++++-
 10 files changed, 663 insertions(+), 2 deletions(-)
 create mode 100644 net/netfilter/nft_inner.c

--
2.30.2

