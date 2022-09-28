Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98ECFC32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 22:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiI1WGb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 18:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiI1WGa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 18:06:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33A4883041
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 15:06:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/2] nf_tables inner tunnel header match support
Date:   Thu, 29 Sep 2022 00:06:24 +0200
Message-Id: <20220928220626.1286-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset adds support for matching on inner header fields that are
usually encapsulated by tunnel protocols.

The inner expression provides a packet parser for the tunneled packet
which uses a userspace description of the expected inner headers. Then,
the inner expression (only payload and meta supported at this stage) is
used to match on the inner header protocol fields, using the new link,
network and transport offsets as well as inner metadata.

This patchset adds support for VxLAN, more tunnel protocol can be
supported via userspace updates only.

The existing userspace nftables codebase is used to match on inner
ethernet link layer, IPv4/IPv6 header and transport header fields. This
patchset generalizes protocol tracking for outer and inner headers
existing codebase.

As an example, the bytecode that nft generates using this new expression
looks like this:

# nft --debug=netlink add rule netdev x y udp dport 4789 vxlan ip saddr 1.2.3.4
netdev x y
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000011 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp eq reg 1 0x0000b512 ]
  [ inner type 1 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
  [ cmp eq reg 1 0x00000008 ]
  [ inner type 1 hdrsize 8 flags f [ payload load 4b @ network header + 12 => reg 1 ] ]
  [ cmp eq reg 1 0x04030201 ]

Use of tunnel protocol inner header fields in set/maps and concatenations is
also supported.

Pablo Neira Ayuso (2):
  netfilter: nft_inner: support for inner tunnel header matching
  netfilter: nft_meta: add inner match support

 include/net/netfilter/nf_tables.h        |   5 +
 include/net/netfilter/nf_tables_core.h   |  24 ++
 include/net/netfilter/nft_meta.h         |   6 +
 include/uapi/linux/netfilter/nf_tables.h |  26 ++
 net/netfilter/Makefile                   |   3 +-
 net/netfilter/nf_tables_api.c            |  37 +++
 net/netfilter/nf_tables_core.c           |   1 +
 net/netfilter/nft_inner.c                | 320 +++++++++++++++++++++++
 net/netfilter/nft_meta.c                 |  65 +++++
 net/netfilter/nft_payload.c              |  89 ++++++-
 10 files changed, 574 insertions(+), 2 deletions(-)
 create mode 100644 net/netfilter/nft_inner.c

-- 
2.30.2

