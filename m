Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DD0C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242287AbiDINyi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 09:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242264AbiDINya (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 09:54:30 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542839D4DC
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OgpJDcCU7PgEp884+TVVv67RiRD5Y7PLQVzwNdahVmU=; b=TgbOLkZtK727zprlQJs0i0+H8U
        mWJ6HwKMAutVbKE/zohWjaQWPUkdycTW1vpxp8Yadamm2uULwVX7xEigcYMpr0BnYQXaV9TOeXjuB
        veEFOwg+3p9F6dRVv8k2L9UkOEt8EdMTPJjP2RCJKO+AsKG/bx+xr6fcdsq91FbdKh64RPgWg40W8
        hVza22hh4O3Jg3ymGaEtu1KqWtbhcAaVq+ld3ibVUWRp4NbqETP+4+x9/IDhVWvkvuYx7ncntzEUN
        xltxSKncZ93kHcxIU2atf1j4hdjnbc3F7VRYXCLbQ7XXBeL3xAtRXx02Qg+yWrB5u6tUy+V8L7oNI
        hxc21fWw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ndBVj-00CMwq-M1
        for netfilter-devel@vger.kernel.org; Sat, 09 Apr 2022 14:52:19 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nf-next PATCH v3 0/3] netfilter: bitwise: support boolean operations with variable RHS operands
Date:   Sat,  9 Apr 2022 14:52:10 +0100
Message-Id: <20220409135213.1450058-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently bitwise boolean operations (AND, OR and XOR) can only have one
variable operand.  They are converted in user space into mask-and-xor
operations on one register and two immediate values which are evaluated
by the kernel.  We add support for evaluating these operations directly
in kernel space on one register and either an immediate value or a
second register.

We also add support for keeping track of the bit-length of boolean
expressions since this can be useful to user space during
delinearization.

* Patch 1 adds support for keeping track of the bit-length of
  boolean expressions.
* Patch 2 renames functions and an enum constant related to the current
  mask-and-xor implementation in anticipation of adding support for
  directly evaluating AND, OR and XOR operations.
* Patch 3 adds support for directly evaluating AND, OR and XOR
  operations.

Changes since v2

  * Increase size of `nbits` to `u16` and correct checking of maximum
    value (`U8_MAX * BITS_PER_BYTE`).

Changes since v1

  * Patch 1 was new.
  * In v1, all boolean operations were still expected to be
    mask-and-xor operations, but the mask and xor values could be
    passed in registers.

Jeremy Sowden (3):
  netfilter: bitwise: keep track of bit-length of expressions
  netfilter: bitwise: rename some boolean operation functions
  netfilter: bitwise: add support for doing AND, OR and XOR directly

 include/uapi/linux/netfilter/nf_tables.h |  21 ++-
 net/netfilter/nft_bitwise.c              | 174 +++++++++++++++++++----
 2 files changed, 166 insertions(+), 29 deletions(-)

-- 
2.35.1

