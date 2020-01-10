Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946D6C33CA2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2282072E
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="sKWS6i8T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgAJMiI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:38:08 -0500
Received: from kadath.azazel.net ([81.187.231.250]:39852 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgAJMiH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 07:38:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pwk1rhPnuX9ooq8oYJNQC6PkbwFRP7EPWSZa7jXT7q4=; b=sKWS6i8T+Q5rBC3WLjRGBYowpl
        dDCrGK7Pt5LcXaVCfo/L4+liTLX71eOrNbvE23S2M55LOmTQUwWoj8ccYoBMz3WQzWmf3TDjXmZag
        pXTX+iWL8t3PTeeCLYnp+bnB0vDe2HOg5TMHqtJvzL6JdigE/N8z8Qx2BFDg73GmCIwH9U++G+ooo
        icpB3Inf5mUx3GR87TPo0hU0gz3wQuOWy8+zMSDFbJOaJmCBAsJBOT8tIADvfv9HV2QnYxOUv80FE
        yKTXVEm6u6EV6GP5lEd2dcj1rwp8U2wbKy9r9AQew69T3syNwY3PB8mZr2KDE59cMm3zOGouWPOjX
        ZrhBMRDQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iptYE-0003im-LI
        for netfilter-devel@vger.kernel.org; Fri, 10 Jan 2020 12:38:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/7] bitwise shift support
Date:   Fri, 10 Jan 2020 12:37:59 +0000
Message-Id: <20200110123806.106546-1-jeremy@azazel.net>
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

This patch-set adds support for bitwise shift operations to nft.  There
are a few preliminary patches containing miscellaneous fixes as well.

Jeremy Sowden (7):
  Update gitignore.
  src: white-space fixes.
  netlink_delinearize: fix typo.
  netlink_delinearize: remove commented out pr_debug statement.
  parser: add parenthesized statement expressions.
  netlink: add support for handling shift expressions.
  tests: shell: add bit-shift tests.

 .gitignore                                    |  9 ++++
 include/linux/netfilter/nf_tables.h           |  4 ++
 src/evaluate.c                                | 11 +++--
 src/netlink_delinearize.c                     | 25 +++++++++--
 src/netlink_linearize.c                       | 44 +++++++++++++++++--
 src/parser_bison.y                            | 25 ++++++-----
 tests/shell/testcases/chains/0040mark_shift_0 | 11 +++++
 tests/shell/testcases/chains/0040mark_shift_1 | 11 +++++
 .../chains/dumps/0040mark_shift_0.nft         |  6 +++
 .../chains/dumps/0040mark_shift_1.nft         |  6 +++
 10 files changed, 126 insertions(+), 26 deletions(-)
 create mode 100755 tests/shell/testcases/chains/0040mark_shift_0
 create mode 100755 tests/shell/testcases/chains/0040mark_shift_1
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_shift_1.nft

-- 
2.24.1

