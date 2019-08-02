Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7619C433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 09:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AE23205F4
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 09:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="CLmFeUjQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfHBJNy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 05:13:54 -0400
Received: from mx1.riseup.net ([198.252.153.129]:52674 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfHBJNy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 05:13:54 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id AC7901A301B
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Aug 2019 02:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1564737233; bh=MorDiK3yKZkpTsgcAJreqICAuMWOkWPLLQobDeCzteI=;
        h=From:To:Cc:Subject:Date:From;
        b=CLmFeUjQ6vTFjE5d1m3zlqGjmf0OgxaF1KoBlx1YEjVKLmanMgr2aIVNLFxHSXJJo
         zYuyH4w2HMC04Znn/kyE3y60HgSJgDfhg9nAIdY9zlQeIRHpTp6RH+cRNEIs4Y5pjX
         KZUxOOQiU2aaZek04qWknmvqb3EXjgWAYVDk2OxM=
X-Riseup-User-ID: E01E1CFFD3DC9D3C8B94D4768B1F773E6D3A891BCFF6C480AEA954D64D7C7E56
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 64BEE223246;
        Fri,  2 Aug 2019 02:13:52 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 0/2 nft v3] Introduce variables in chain priority and policy
Date:   Fri,  2 Aug 2019 11:13:33 +0200
Message-Id: <20190802091335.10778-1-ffmancera@riseup.net>
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

 include/datatype.h                            |  2 +
 include/rule.h                                |  9 +-
 src/datatype.c                                | 55 ++++++++++++
 src/evaluate.c                                | 85 ++++++++++++++++---
 src/json.c                                    | 16 +++-
 src/mnl.c                                     | 22 +++--
 src/netlink.c                                 | 30 +++++--
 src/parser_bison.y                            | 58 ++++++++++---
 src/parser_json.c                             | 28 ++++--
 src/rule.c                                    | 28 +++---
 .../testcases/nft-f/0021priority_variable_0   | 17 ++++
 .../testcases/nft-f/0022priority_variable_0   | 17 ++++
 .../testcases/nft-f/0023priority_variable_1   | 18 ++++
 .../testcases/nft-f/0024priority_variable_1   | 18 ++++
 .../testcases/nft-f/0025policy_variable_0     | 17 ++++
 .../testcases/nft-f/0026policy_variable_0     | 17 ++++
 .../testcases/nft-f/0027policy_variable_1     | 18 ++++
 .../testcases/nft-f/0028policy_variable_1     | 18 ++++
 .../nft-f/dumps/0021priority_variable_0.nft   |  5 ++
 .../nft-f/dumps/0022priority_variable_0.nft   |  5 ++
 .../nft-f/dumps/0025policy_variable_0.nft     |  5 ++
 .../nft-f/dumps/0026policy_variable_0.nft     |  5 ++
 22 files changed, 429 insertions(+), 64 deletions(-)
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

