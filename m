Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE687C04A94
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Aug 2023 22:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjHLWJo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjHLWJn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Aug 2023 18:09:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4DD91704;
        Sat, 12 Aug 2023 15:09:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,4.14 0/1] netfilter stable fix for 4.14
Date:   Sun, 13 Aug 2023 00:09:40 +0200
Message-Id: <20230812220941.56747-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

This is a backport of:

  1689f25924ad ("netfilter: nf_tables: report use refcount overflow")

for -stable 4.14.

Please, apply.

Thanks.

Pablo Neira Ayuso (1):
  netfilter: nf_tables: report use refcount overflow

 include/net/netfilter/nf_tables.h |  27 +++++-
 net/netfilter/nf_tables_api.c     | 143 +++++++++++++++++++-----------
 net/netfilter/nft_objref.c        |   8 +-
 3 files changed, 119 insertions(+), 59 deletions(-)

--
2.30.2

