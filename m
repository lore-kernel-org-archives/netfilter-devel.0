Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3780C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Apr 2022 21:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbiDXV70 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239692AbiDXV7Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Apr 2022 17:59:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5247D393E1
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2022 14:56:21 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables 0/7] support for dynamic register allocation
Date:   Sun, 24 Apr 2022 23:56:06 +0200
Message-Id: <20220424215613.106165-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset is composed of:

- Fix for bitwise expression to not assume NFT_REG_1 as destination
  register.

- Add native meta mark match support.

- Dynamic register allocation to leverage infrastructure available
  since Linux kernel 5.18-rc. See patch 7/7 for details.

Pablo Neira Ayuso (7):
  nft-shared: update context register for bitwise expression
  nft: pass struct nft_xt_ctx to parse_meta()
  nft: native mark matching support
  nft: pass handle to helper functions to build netlink payload
  nft: prepare for dynamic register allocation
  nft: split gen_payload() to allocate register and initialize expression
  nft: support for dynamic register allocation

 iptables/Makefile.am                          |   2 +-
 iptables/nft-arp.c                            |  42 ++--
 iptables/nft-bridge.c                         |  42 ++--
 iptables/nft-ipv4.c                           |  22 +-
 iptables/nft-ipv6.c                           |  12 +-
 iptables/nft-regs.c                           | 191 ++++++++++++++++++
 iptables/nft-regs.h                           |   9 +
 iptables/nft-shared.c                         | 162 ++++++++++-----
 iptables/nft-shared.h                         |  32 +--
 iptables/nft.c                                | 125 ++++++++----
 iptables/nft.h                                |  25 +++
 .../nft-only/0009-needless-bitwise_0          | 180 ++++++++---------
 12 files changed, 599 insertions(+), 245 deletions(-)
 create mode 100644 iptables/nft-regs.c
 create mode 100644 iptables/nft-regs.h

-- 
2.30.2

