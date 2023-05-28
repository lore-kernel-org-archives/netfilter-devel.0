Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00DDC77B7E
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 13:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjE1NxU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 09:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjE1NxT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 09:53:19 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FAABD
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 06:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OtlgP32djsa3caJehEzsmoy1YicZskzspXWy4Snex8g=; b=g2C6Z2erdE0lzGzAEhDZc+oSCk
        KAtmFgs00gdHGqkIBDF8wk27h+Qo2NwI7sUFMrEVXb51B6geQqt/fo/eMfb/DH0AbiMqMBZporZWo
        FEuTkx1Qqa/2/BLVLX7ReXSQZ3M+BwVSCRy/kjupKZwS6ph5iowbAe518EutWKjvzdbL8Aenx67wy
        VwOHLCmwqPJ1syVv2HfAPzo3FBb+TsvMiTOW2igDsS334x7pyQ9jaCSwr8Pwc8YjwdZ2zwavX5tyB
        RQpVxxKCvoXi5TzqyIxDy9F2rplhwaLrM0FCjHXHOUfN7MEXnnFZjSLo/bkmAl+COxTFhF7MEMigB
        7rsRu16g==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gpf-008Wbs-3M
        for netfilter-devel@vger.kernel.org; Sun, 28 May 2023 14:53:15 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v4 0/2] netfilter: bitwise: support boolean operations with variable RHS operands
Date:   Sun, 28 May 2023 14:52:57 +0100
Message-Id: <20230528135259.1218169-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently bitwise boolean operations (AND, OR and XOR) can only have one
variable operand.  They are converted in user space into mask-and-xor
operations on one register and two immediate values which are evaluated
by the kernel.  We add support for evaluating these operations directly
in kernel space on one register and either an immediate value or a
second register.

* Patch 1 renames functions and an enum constant related to the current
  mask-and-xor implementation in anticipation of adding support for
  directly evaluating AND, OR and XOR operations.
* Patch 2 adds support for directly evaluating AND, OR and XOR
  operations.

Changes since v3

  * The patch to keep track of the bit-length of boolean
    expressions is no longer needed and has been dropped.

Changes since v2

  * Increase size of `nbits` to `u16` and correct checking of maximum
    value (`U8_MAX * BITS_PER_BYTE`).

Changes since v1

  * New patch added to keep track of the bit-length of boolean
    expressions.
  * In v1, all boolean operations were still expected to be
    mask-and-xor operations, but the mask and xor values could be
    passed in registers.

Jeremy Sowden (2):
  netfilter: bitwise: rename some boolean operation functions
  netfilter: bitwise: add support for doing AND, OR and XOR directly

 include/uapi/linux/netfilter/nf_tables.h |  19 ++-
 net/netfilter/nft_bitwise.c              | 164 +++++++++++++++++++----
 2 files changed, 154 insertions(+), 29 deletions(-)

-- 
2.39.2

