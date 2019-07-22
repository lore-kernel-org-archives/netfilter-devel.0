Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9513C76190
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C321C21901
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:59:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="giNjK6+V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbfGVQ7n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 12:59:43 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39680 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbfGVQ7n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 12:59:43 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 0A86E1A0D42
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 09:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563814783; bh=hoX071IgfrjzGw/OUFK21Wb2RTFW9gaa6AajWIG4Vko=;
        h=From:To:Cc:Subject:Date:From;
        b=giNjK6+Vkz7xC7N2CZQRdtQy6G4TdxCFozJ30ClG9vYezDgKg2Rx8BdfFUZHFR/1I
         Ko4fTNGYh4vZRNzrY8RAna/boz03viLyTzo4MYXUGHoYEq0/SuU3oQ+0i7WhTYMda/
         XCCQSK4rFf5nODnTY1Ei9i0etA7F/hFQFykifcWU=
X-Riseup-User-ID: 4797931AFE86E48EC78DD77039B850996F45C870DC07CBBE967FB8ADF0DFFE3C
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 3E2202221C2;
        Mon, 22 Jul 2019 09:59:42 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 0/2 nft v2] Introduce variables in chain priority and policy
Date:   Mon, 22 Jul 2019 18:59:29 +0200
Message-Id: <20190722165931.6738-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch series introduces the use of variables in chain priority and policy
specification. It also contains tests for invalid cases.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1172

Fernando Fernandez Mancera (2):
  src: allow variables in the chain priority specification
  src: allow variable in chain policy

 include/datatype.h                            |  1 +
 include/rule.h                                | 10 +-
 src/datatype.c                                | 26 ++++++
 src/evaluate.c                                | 92 +++++++++++++++++--
 src/json.c                                    |  5 +-
 src/mnl.c                                     |  9 +-
 src/netlink.c                                 |  8 +-
 src/parser_bison.y                            | 46 ++++++++--
 src/parser_json.c                             | 17 +++-
 src/rule.c                                    | 17 +++-
 .../testcases/nft-f/0021priority_variable_0   | 17 ++++
 .../testcases/nft-f/0022priority_variable_0   | 17 ++++
 .../testcases/nft-f/0023priority_variable_1   | 18 ++++
 .../testcases/nft-f/0024priority_variable_1   | 18 ++++
 .../testcases/nft-f/0025policy_variable_0     | 17 ++++
 .../testcases/nft-f/0026policy_variable_0     | 17 ++++
 .../testcases/nft-f/0027policy_variable_1     | 18 ++++
 .../testcases/nft-f/0028policy_variable_1     | 18 ++++
 .../nft-f/dumps/0021priority_variable_0.nft   |  5 +
 .../nft-f/dumps/0022priority_variable_0.nft   |  5 +
 .../nft-f/dumps/0025policy_variable_0.nft     |  5 +
 .../nft-f/dumps/0026policy_variable_0.nft     |  5 +
 22 files changed, 351 insertions(+), 40 deletions(-)
 mode change 100644 => 100755 src/evaluate.c
 create mode 100755 tests/shell/testcases/nft-f/0021priority_variable_0
 create mode 100755 tests/shell/testcases/nft-f/0022priority_variable_0
 create mode 100755 tests/shell/testcases/nft-f/0023priority_variable_1
 create mode 100755 tests/shell/testcases/nft-f/0024priority_variable_1
 create mode 100755 tests/shell/testcases/nft-f/0025policy_variable_0
 create mode 100755 tests/shell/testcases/nft-f/0026policy_variable_0
 create mode 100755 tests/shell/testcases/nft-f/0027policy_variable_1
 create mode 100755 tests/shell/testcases/nft-f/0028policy_variable_1
 create mode 100644 tests/shell/testcases/nft-f/dumps/0021priority_variable_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0022priority_variable_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0025policy_variable_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft

-- 
2.20.1

