Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B797FC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 22:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJEWsk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJEWsh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 18:48:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9565560525
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 15:48:36 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/2] gre and ipip tunnel support
Date:   Thu,  6 Oct 2022 00:48:31 +0200
Message-Id: <20221005224833.24056-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset adds support for gre and ipip tunnels, including support
for matching inner header fields.

First patch is larger because it adds the NFT_META_L4PROTO dependency
logic to restrict matches to IPPROTO_GRE. The second patch is
significantly smaller, because previous patches adding VxLAN and GRE
already provided the necessary infrastructure to add IPIP with minimal
updates.

No tests and documentation updates in this v1.

Pablo Neira Ayuso (2):
  src: add gre support
  src: add ipip support

 include/linux/netfilter/nf_tables.h |  1 +
 include/payload.h                   |  2 ++
 include/proto.h                     | 15 ++++++++
 src/evaluate.c                      | 40 ++++++++++++++++------
 src/netlink_delinearize.c           | 45 ++++++++++++++++++++++++
 src/parser_bison.y                  | 53 +++++++++++++++++++++++++++--
 src/payload.c                       | 47 +++++++++++++++++++++++++
 src/proto.c                         | 45 ++++++++++++++++++++++++
 src/scanner.l                       |  3 ++
 9 files changed, 237 insertions(+), 14 deletions(-)

--
2.30.2

