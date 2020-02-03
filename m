Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC79C33CAC
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE8F020721
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="gL1IMJf1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgBCLUY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 06:20:24 -0500
Received: from kadath.azazel.net ([81.187.231.250]:33244 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbgBCLUY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 06:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VoG6/xs1s+XgB2CwIGw1qDyQ0h5VMXJEulgzvk8y280=; b=gL1IMJf1lUVK66ZYAK186Q3HKm
        AadHqSMOfnbpi/ZG3WM4CUi8QN8HYJ4awMfz1cUp3CtfqvSHIgKOUrwc/EITQQ/zlsOfIUV2cY7mb
        snWwqn1VSFPPzGafniQjJqFsjkeZYkSmHZZBgcEwJFHPSpoB9VQ0hXwIlQ08+vUSJEGz8RT+Jz9R6
        l2P0HZFOgKNBGBpjJySKL0UkpyJD/1k3C4Dc8xY/Gr79VcLfEwz3Cm3ZdSdFaE7CpE+oH6700dlxC
        rV+qavwjL/+to1/Q7Fe5LxNpNFOaPBmyNF0a/YLg2xQeHDFURKalZ7ExLIlFqYwdrceRtQ2peTsI4
        CEf0Bm8A==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iyZmB-0007Br-4W
        for netfilter-devel@vger.kernel.org; Mon, 03 Feb 2020 11:20:23 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v4 0/6] Remaining bitwise-shift-related changes
Date:   Mon,  3 Feb 2020 11:20:17 +0000
Message-Id: <20200203112023.646840-1-jeremy@azazel.net>
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

While most of the v3 bitwise-shift patches were applied, a couple of the
tidy-up ones and the new tests in the bitwise-shift series needed a bit
more work.  This version introduces some new changes: a patch renaming a
variable and a couple adding some Python tests.

Changes since v3:

  * the second, fifth and sixth patches are new;
  * the commit message of the third patch has been expanded;
  * one of the shell tests has been amended to include a parenthesized
    statement expression.

Jeremy Sowden (6):
  parser: add parenthesized statement expressions.
  evaluate: correct variable name.
  evaluate: change shift byte-order to host-endian.
  tests: shell: add bit-shift tests.
  tests: py: add missing JSON output.
  tests: py: add bit-shift tests.

 src/evaluate.c                                | 14 ++---
 src/parser_bison.y                            | 25 ++++-----
 tests/py/any/ct.t                             |  1 +
 tests/py/any/ct.t.json                        | 51 +++++++++++++++++++
 tests/py/any/ct.t.payload                     | 22 ++++++++
 tests/py/inet/meta.t                          |  1 +
 tests/py/inet/meta.t.json                     | 22 ++++++++
 tests/py/inet/meta.t.payload                  |  6 +++
 tests/py/ip/meta.t.json                       | 35 +++++++++++++
 tests/py/ip6/meta.t.json                      | 35 +++++++++++++
 tests/shell/testcases/chains/0040mark_shift_0 | 11 ++++
 tests/shell/testcases/chains/0040mark_shift_1 | 11 ++++
 .../chains/dumps/0040mark_shift_0.nft         |  6 +++
 .../chains/dumps/0040mark_shift_1.nft         |  6 +++
 14 files changed, 227 insertions(+), 19 deletions(-)
 create mode 100755 tests/shell/testcases/chains/0040mark_shift_0
 create mode 100755 tests/shell/testcases/chains/0040mark_shift_1
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_shift_1.nft

-- 
2.24.1

