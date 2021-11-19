Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4B8C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE55B6108B
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhKSPb7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 10:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhKSPb7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 10:31:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C9CC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2021 07:28:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mo5os-0005QB-G4; Fri, 19 Nov 2021 16:28:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/8] mptcp subtype option match support
Date:   Fri, 19 Nov 2021 16:28:39 +0100
Message-Id: <20211119152847.18118-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series adds 'tcp option mptcp subtype' matching to nft.

Because the subtype is only 4 bits in size the exthdr
delinearization needs a fixup to remove the binop added by the
evaluation step.

One remaining usablility problem is the lack of mnemonics for the
subtype, i.e. something like:

static const struct symbol_table mptcp_subtype_tbl = {
       .base           = BASE_DECIMAL,
       .symbols        = {
               SYMBOL("mp-capable",    0),
               SYMBOL("mp-join",       1),
               SYMBOL("dss",           2),
               SYMBOL("add-addr",      3),
               SYMBOL("remove-addr",   4),
               SYMBOL("mp-prio",       5),
               SYMBOL("mp-fail",       6),
               SYMBOL("mp-fastclose",  7),
               SYMBOL("mp-tcprst",     8),
               SYMBOL_LIST_END
       },

... but this would need addition of yet another data type.

Use of implicit/context-dependent symbol table would
be preferrable, I will look into this next.

Florian Westphal (8):
  tcpopt: remove KIND keyword
  scanner: add tcp flex scope
  parser: split tcp option rules
  tcpopt: add md5sig, fastopen and mptcp options
  tests: py: add test cases for md5sig, fastopen and mptcp mnemonics
  mptcp: add subtype matching
  exthdr: fix tcpopt_find_template to use length after mask adjustment
  tests: py: add tcp subtype match test cases

 doc/payload-expression.txt    |  29 ++++---
 include/parser.h              |   1 +
 include/tcpopt.h              |  13 ++-
 src/exthdr.c                  |  46 +++++-----
 src/parser_bison.y            | 108 +++++++++++++++++------
 src/scanner.l                 |  22 +++--
 src/tcpopt.c                  |  38 +++++++-
 tests/py/any/tcpopt.t         |  21 +++--
 tests/py/any/tcpopt.t.json    | 159 +++++++++++++++++++++++++---------
 tests/py/any/tcpopt.t.payload |  64 ++++++++++----
 10 files changed, 360 insertions(+), 141 deletions(-)

-- 
2.32.0

