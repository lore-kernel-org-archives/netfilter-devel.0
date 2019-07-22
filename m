Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A055C7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C414218EA
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="WL6seZI1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbfGVQC5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 12:02:57 -0400
Received: from mx1.riseup.net ([198.252.153.129]:47718 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbfGVQC5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 12:02:57 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 49A7E1A4B97
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 09:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563811377; bh=zeFKOju8ctGmzbwsBf8IHuuPAxevvO5O/YNEnfxPckg=;
        h=From:To:Cc:Subject:Date:From;
        b=WL6seZI1ZrNUFpMNLkaWY6aX401x9aVcmnvXCSzyxkRHmJ+YORFfQkP0Z/xUSmdA/
         KYBbZZ3fei+ZXpC0C9iLytgGTPfruKI0xvEutrihcXMjgK+9DwYMDSjypM07VJw8+j
         AZ1rbGMBgPG9oR7q410mwiPAZiNdozOhxXKQezp4=
X-Riseup-User-ID: 4EDAB559420E00F37B4DCA06C397177FF20BB03C3AFEA0D80F85D6AED09821AA
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 5DB33120986;
        Mon, 22 Jul 2019 09:02:56 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 0/2 nft] Introduce variables in chain priority and policy
Date:   Mon, 22 Jul 2019 18:02:35 +0200
Message-Id: <20190722160236.12516-1-ffmancera@riseup.net>
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
 src/parser_bison.y                            | 45 +++++++--
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
 22 files changed, 350 insertions(+), 40 deletions(-)
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

