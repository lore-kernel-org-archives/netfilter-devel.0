Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEE4C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Nov 2022 17:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiKQRqE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Nov 2022 12:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiKQRqD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Nov 2022 12:46:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938A4663E7
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Nov 2022 09:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Hp4ouM3AjJIfSBlZLGxwUTSTNLmemka8PFaYP0uradI=; b=TnECmCRZvjcqR1PBewH/KUg85H
        nqBQXHlQQZmYscYplBdNt4plm9LrYetl8UjL6KPDMP7onBvvKQor5oPb8FJzb6GPAqNrfHQF3T2Dg
        A7ugWwIe/IMoeZKWksUfK0niovLgHiV3kbEim8YRxnpM4hcPvhH/WOWNaLABsPDgPTJG3Ts4cjyJx
        YN/gFlDniTdzAO028pwOb1j4I4Q91jRRAVBeuu81Flgt5R1UXlZCJuroAF4CF7iTBi3RbeU57BW/A
        nrf3r7vbvMR7eoRn8Y9UhqJ+NpKoVaSIeoC/cOOseHz2Lf80nbxtkI8BGKhvVFhQFNodHzAPsSwYX
        lptgWcRQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ovixX-0001jm-Bm; Thu, 17 Nov 2022 18:45:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 0/4] xt: Implement dump and restore support
Date:   Thu, 17 Nov 2022 18:45:42 +0100
Message-Id: <20221117174546.21715-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If nft can't translate a compat expression, dump it in a format that can
be restored later without losing data, thereby keeping the ruleset
intact.

Patch 1 is preparation (more or less), patch 2 has the gory details,
patch 3 is a minor code refactoring that's almost unrelated and patch 4
further sanitizes behaviour now that there's a reliable fallback in
place.

Changes since v1:
- Use patch 3 to also improve the error printing if extension lookup
  fails.
- New patch 4.

Phil Sutter (4):
  xt: Delay libxtables access until translation
  xt: Implement dump and restore support
  xt: Put match/target translation into own functions
  xt: Detect xlate callback failure

 configure.ac              |  12 +-
 doc/libnftables-json.adoc |  15 +-
 doc/statements.txt        |  17 ++
 include/base64.h          |  17 ++
 include/json.h            |   2 +
 include/parser.h          |   1 +
 include/statement.h       |   9 +-
 include/xt.h              |   4 +
 src/Makefile.am           |   3 +-
 src/base64.c              | 170 ++++++++++++++++++++
 src/evaluate.c            |   1 +
 src/json.c                |  25 ++-
 src/netlink_linearize.c   |  32 ++++
 src/parser_bison.y        |  28 ++++
 src/parser_json.c         |  36 +++++
 src/scanner.l             |  14 ++
 src/statement.c           |   1 +
 src/xt.c                  | 317 ++++++++++++++++++++++----------------
 18 files changed, 558 insertions(+), 146 deletions(-)
 create mode 100644 include/base64.h
 create mode 100644 src/base64.c

-- 
2.38.0

