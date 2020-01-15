Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9078C32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 21:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AA3C2081E
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 21:32:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="UFIs91XV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgAOVcS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 16:32:18 -0500
Received: from kadath.azazel.net ([81.187.231.250]:56822 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgAOVcR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 16:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TiHdDUfY/9T7waFTHmL3/8Q1/iSUyN83wIi+HFIjw+8=; b=UFIs91XV9eSH5WKixercwTCxbQ
        NzfrpD/3zp9qUBtEBWjlt0jYjJYg/HiCPw77iIkw33FUBKd+E0tnogc64KAbbAVeYd+X3YhLsEdlu
        RghYbUVyTvKAx7FtH4/VF6ht5ot+S7Eiu5IMFHlpHK17xMaz19EFK70wlAyy6rvg9SWqCqaZjqeZH
        TDC8Akvy4exxWo7zl26z/NZqSfZl8rV1Jt4OoZSad45UkJ7E8SoQwvuKf7v+iVvSNaffLrq9Lb5qY
        7jHVOMxregi8jBj4pnOVtlMTWvxiZIVCxeKLBBaWdunHH5INuP03IIjn0eh7q8z4unnDFsnVGoCag
        V/SzJk7g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irqGu-0008BP-Ph; Wed, 15 Jan 2020 21:32:16 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Date:   Wed, 15 Jan 2020 21:32:06 +0000
Message-Id: <20200115213216.77493-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The connmark xtables extension supports bit-shifts.  Add support for
shifts to nft_bitwise in order to allow nftables to do likewise, e.g.:

  nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
  nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8

Changes since v3:

  * the length of shift values sent by nft may be less than sizeof(u32).

Changes since v2:

  * convert NFTA_BITWISE_DATA from u32 to nft_data;
  * add check that shift value is not too large;
  * use BITS_PER_TYPE to get the size of u32, rather than hard-coding it
    when evaluating shifts.

Changes since v1:

  * more white-space fixes;
  * move bitwise op enum to UAPI;
  * add NFTA_BITWISE_OP and NFTA_BITWISE_DATA;
  * remove NFTA_BITWISE_LSHIFT and NFTA_BITWISE_RSHIFT;
  * add helpers for initializaing, evaluating and dumping different
    types of operation.

Jeremy Sowden (10):
  netfilter: nf_tables: white-space fixes.
  netfilter: bitwise: remove NULL comparisons from attribute checks.
  netfilter: bitwise: replace gotos with returns.
  netfilter: bitwise: add NFTA_BITWISE_OP attribute.
  netfilter: bitwise: add helper for initializing boolean operations.
  netfilter: bitwise: add helper for evaluating boolean operations.
  netfilter: bitwise: add helper for dumping boolean operations.
  netfilter: bitwise: only offload boolean operations.
  netfilter: bitwise: add NFTA_BITWISE_DATA attribute.
  netfilter: bitwise: add support for shifts.

 include/uapi/linux/netfilter/nf_tables.h |  24 ++-
 net/netfilter/nft_bitwise.c              | 217 ++++++++++++++++++-----
 net/netfilter/nft_set_bitmap.c           |   4 +-
 net/netfilter/nft_set_hash.c             |   2 +-
 4 files changed, 200 insertions(+), 47 deletions(-)

-- 
2.24.1

