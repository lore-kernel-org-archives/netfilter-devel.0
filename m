Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFECCC35671
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 13:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B29D020828
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 13:12:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="aYiMfw2g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgBXNMD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:12:03 -0500
Received: from kadath.azazel.net ([81.187.231.250]:58254 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgBXNMD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 08:12:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dBW9w1b0RbQ7jcStfI3bQioLwz+YytHSWCcxLyIHW1M=; b=aYiMfw2g8h3cHK6HkcmM9q07uf
        8y+vNiCNairdYwRuMBz/3zfJolUt0YCp1NEiRMSK72lP7xMzafi43aLAE5SvW1/F9ELbWvcI5+jbu
        JyvoIgV97i4Eh7sIrk7IaTOJClJCqOv37HNHk0/o23ZzYwZHC/RB7r+muuKSTEzQ0Eu/VYiYGc76E
        6vD2b9e6vy6T9xS8R+HkyjaWGVrXG4A++GfM5y+XW0JJ2tGjPDmfkDMeLIaYeLKRftXf3D9zdy1W3
        KZfkIB3MhITf/ZeZ6FLqwJs5eU9JUjP/FIaRceLCfgwQ9zSTnx1u7CdRQIRt3rhVRUKO8wKY+WYGa
        UfIKVg1g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j6DWj-0001wB-NI; Mon, 24 Feb 2020 13:12:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 0/3] bitwise: support for passing mask and xor via registers
Date:   Mon, 24 Feb 2020 13:11:58 +0000
Message-Id: <20200224131201.512755-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel supports passing mask and xor values for bitwise boolean
operations via registers.  These are mutually exclusive with the
existing data attributes: e.g., setting both NFTA_EXPR_BITWISE_MASK and
NFTA_EXPR_BITWISE_MREG is an error.  Add support to libnftnl.

The first patch fixes a typo, the second updates the UAPI header and
the last contains the implementation.

Jeremy Sowden (3):
  tests: bitwise: fix error message.
  include: update nf_tables.h.
  bitwise: add support for passing mask and xor via registers.

 include/libnftnl/expr.h             |  2 +
 include/linux/netfilter/nf_tables.h |  4 ++
 src/expr/bitwise.c                  | 60 ++++++++++++++++++++++---
 tests/nft-expr_bitwise-test.c       | 70 +++++++++++++++++++----------
 4 files changed, 106 insertions(+), 30 deletions(-)

-- 
2.25.0

