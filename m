Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46382C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 21:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D86621852
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 21:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfBZVN5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 16:13:57 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:48012 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfBZVN5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 16:13:57 -0500
Received: from localhost ([::1]:32870 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1gyk31-0006nh-Vf; Tue, 26 Feb 2019 22:13:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/5] Some fixes for JSON support
Date:   Tue, 26 Feb 2019 22:13:37 +0100
Message-Id: <20190226211342.15125-1-phil@nwl.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first patch is actually a generic libnftables fix, it prevents a
segfault when reporting parser errors.

The remaining fixes were found when trying to parse a ruleset prepared
by firewalld (JSON API usage is WiP there). Seems like increasing test
coverage really is in order.

Phil Sutter (5):
  libnftables: Print errors before freeing commands
  parser_json: Duplicate chain name when parsing jump verdict
  parser_json: Use xstrdup() when parsing rule comment
  json: Fix memleaks in echo support
  parser_json: Respect base chain priority

 src/libnftables.c |  4 ++--
 src/parser_json.c | 34 ++++++++++++++++++++++------------
 2 files changed, 24 insertions(+), 14 deletions(-)

-- 
2.20.1

