Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928F2C7EE2C
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 15:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbjEPPQP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 May 2023 11:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbjEPPQN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2023 11:16:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E85240ED;
        Tue, 16 May 2023 08:16:10 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,4.14 0/8] more stable fixes for 4.14
Date:   Tue, 16 May 2023 17:15:58 +0200
Message-Id: <20230516151606.4892-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

This is second round of -stable backport fixes for 4.14. This batch
includes dependency patches which are not currently in the 4.14 branch.

The following list shows the backported patches, I am using original
commit IDs for reference:

1) 08a01c11a5bb ("netfilter: nftables: statify nft_parse_register()")

2) 6e1acfa387b9 ("netfilter: nf_tables: validate registers coming from userspace.")

3) 20a1452c3542 ("netfilter: nf_tables: add nft_setelem_parse_key()")

4) fdb9c405e35b ("netfilter: nf_tables: allow up to 64 bytes in the set element data area")

5) 7e6bc1f6cabc ("netfilter: nf_tables: stricter validation of element data")

6) 215a31f19ded ("netfilter: nft_dynset: do not reject set updates with NFT_SET_EVAL")

7) 36d5b2913219 ("netfilter: nf_tables: do not allow RULE_ID to refer to another chain")

8) 470ee20e069a ("netfilter: nf_tables: do not allow SET_ID to refer to another table")

Patches #1, #3 and #4 are dependencies.

Please, apply.
Thanks.

Pablo Neira Ayuso (8):
  netfilter: nftables: statify nft_parse_register()
  netfilter: nf_tables: validate registers coming from userspace.
  netfilter: nf_tables: add nft_setelem_parse_key()
  netfilter: nf_tables: allow up to 64 bytes in the set element data area
  netfilter: nf_tables: stricter validation of element data
  netfilter: nft_dynset: do not reject set updates with NFT_SET_EVAL
  netfilter: nf_tables: do not allow RULE_ID to refer to another chain
  netfilter: nf_tables: do not allow SET_ID to refer to another table

 include/net/netfilter/nf_tables.h        |   7 +-
 include/uapi/linux/netfilter/nf_tables.h |   2 +-
 net/netfilter/nf_tables_api.c            | 157 ++++++++++++++---------
 net/netfilter/nft_dynset.c               |   4 +-
 4 files changed, 104 insertions(+), 66 deletions(-)

-- 
2.30.2

