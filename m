Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AEAC04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 11:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7474320859
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 11:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfE0Lgz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 07:36:55 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:34812 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfE0Lgz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 07:36:55 -0400
Received: from localhost ([::1]:47898 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVDvx-0005oQ-V4; Mon, 27 May 2019 13:36:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: [nft PATCH v4 0/2] JSON schema for nftables.py
Date:   Mon, 27 May 2019 13:36:40 +0200
Message-Id: <20190527113642.8434-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Round four of JSON validation enhancement.

Changes since v3:
- Drop "id" property in schema.json for now.

Changes since v2:
- Make enhancement to nftables module Python3 compliant.
- Complain in nft-test.py if --schema was given without --json.

Changes since v1:
- Fix patch 2 commit message, thanks to Jones Desougi who reported the
  inconsistency.

Changes since RFC:
- Import builtin traceback module unconditionally.

Phil Sutter (2):
  py: Implement JSON validation in nftables module
  tests/py: Support JSON validation

 py/Makefile.am       |  2 +-
 py/nftables.py       | 29 +++++++++++++++++++++++++++++
 py/schema.json       | 16 ++++++++++++++++
 py/setup.py          |  1 +
 tests/py/nft-test.py | 25 ++++++++++++++++++++++++-
 5 files changed, 71 insertions(+), 2 deletions(-)
 create mode 100644 py/schema.json

-- 
2.21.0

