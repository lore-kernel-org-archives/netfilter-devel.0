Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E252C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbiDDMGd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236650AbiDDMGa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:06:30 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D696035A90
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=79oRVI1rTrSNjoPjbWj6MPGsynjCSJpXI4lOooFVxWE=; b=Gb0V7lbMcGGIrI/7yFRM1Jq1Sf
        l3xPxipH2vJZByfifmATeDELWUrLvWhtFXXpbxrJtxM4/mnO0SAP+UC+QwboKgjv8iBzO9UOf2PPM
        BauVVg/GGvCgm56wlG38iV0PO8ns8czHnoD0A3FEUg5FihsbFkvdIZymRWS1KX6Io2omrP+ZEPi2h
        WPgZ/ffecKf9UPgW17ZqWTqLCUKVt6K8nLcPwciBuL7+dE34azu7gJ5vk0yQ2xshNn1WXBCtpmDQ6
        o4RBKj6ai2bB8QWSBnd22bYlfe8nA+xc2Gn93ccwhh4lwX1vV7YvPzrFER+puEjd5mV4O5lebqdCm
        OoHlSx9w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLRe-007FLB-B6
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:04:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nf-next PATCH v2 0/5] netfilter: bitwise: support boolean operations with variable RHS operands
Date:   Mon,  4 Apr 2022 13:04:12 +0100
Message-Id: <20220404120417.188410-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I've resurrected the work I started a couple of years ago.

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
* Patches 2 & 3 make some small unrelated improvements.
* Patch 4 renames functions and an enum constant related to the current
  mask-and-xor implementation in anticipation of adding support for
  directly evaluating AND, OR and XOR operations.
* Patch 5 adds support for directly evaluating AND, OR and XOR
  operations.

Changes since v1

  * Patch 1 is new.
  * In v1, all boolean operations were still expected to be
    mask-and-xor operations, but the mask and xor values could be
    passed in registers.

Jeremy Sowden (5):
  netfilter: bitwise: keep track of bit-length of expressions
  netfilter: bitwise: replace hard-coded size with `sizeof` expression
  netfilter: bitwise: improve error goto labels
  netfilter: bitwise: rename some boolean operation functions
  netfilter: bitwise: add support for doing AND, OR and XOR directly

 include/uapi/linux/netfilter/nf_tables.h |  21 ++-
 net/netfilter/nft_bitwise.c              | 178 +++++++++++++++++++----
 2 files changed, 164 insertions(+), 35 deletions(-)

-- 
2.35.1

