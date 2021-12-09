Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3E5C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 15:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhLIPPP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 10:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbhLIPPO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 10:15:14 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11683C061746
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 07:11:41 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mvL57-00077a-Az; Thu, 09 Dec 2021 16:11:37 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH 0/2 nft] mptcp: add mptcp subtype mnemonics
Date:   Thu,  9 Dec 2021 16:11:29 +0100
Message-Id: <20211209151131.22618-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows use of mnemonics, e.g.

tcp option mptcp subtype mp-capable

The new datatype is phony: on kernel-side its represented as
TYPE_INTEGER.
It can only be used a set key via the 'typeof' expression.

This avoids bloating the (finite) list of data types just to
handle the extra symbol table.

 include/datatype.h                                 |  5 +++-
 src/expression.c                                   | 34 ++++++++++++++++++++++
 src/tcpopt.c                                       | 30 ++++++++++++++++++-
 tests/py/any/tcpopt.t                              |  6 ++--
 tests/py/any/tcpopt.t.json                         |  2 +-
 tests/py/any/tcpopt.t.json.output                  | 31 ++++++++++++++++++++
 tests/py/any/tcpopt.t.payload                      | 12 ++++----
 tests/shell/testcases/sets/dumps/typeof_sets_0.nft |  9 ++++++
 tests/shell/testcases/sets/typeof_sets_0           |  9 ++++++
 9 files changed, 126 insertions(+), 12 deletions(-)


