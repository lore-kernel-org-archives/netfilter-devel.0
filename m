Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DD7EB64DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 11:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjFZLFT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 07:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjFZLFR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 07:05:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FFAD8F;
        Mon, 26 Jun 2023 04:05:14 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     stable@vger.kernel.org, carnil@debian.org
Subject: [PATCH -stable,5.10 0/3] stable fixes for 5.10
Date:   Mon, 26 Jun 2023 13:05:03 +0200
Message-Id: <20230626110506.76630-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

The following batch contains Netfilter fixes for 5.10.

Patches 1 and 2 you can manually cherry-pick them:

1) 08a01c11a5bb ("netfilter: nftables: statify nft_parse_register()")
2) 98494660a286 ("netfilter: nf_tables: validate registers coming from userspace.")

Patch 3 is a backport:

3) 99e73e80d3df ("netfilter: nf_tables: hold mutex on netns pre_exit path")

Thanks.

Pablo Neira Ayuso (3):
  netfilter: nftables: statify nft_parse_register()
  netfilter: nf_tables: validate registers coming from userspace.
  netfilter: nf_tables: hold mutex on netns pre_exit path

 include/net/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c     | 34 +++++++++++++++++--------------
 2 files changed, 19 insertions(+), 16 deletions(-)

-- 
2.30.2

