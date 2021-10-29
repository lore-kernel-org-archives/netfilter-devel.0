Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2A6C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Oct 2021 20:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5971861075
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Oct 2021 20:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhJ2Umz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Oct 2021 16:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhJ2Umr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 16:42:47 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C63C061766
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Oct 2021 13:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TFBH5NYDgdObM1+sYwFQWIWZZqYTJTeyMihjktMVDPc=; b=QuMTksyhpo2Ibx8DK6NtJZREqY
        pWpLSpHDnLNBIxXlcGStJrj9fyi5s4+Own+JuiWghRUCj1UKrAcFeSR4Mo9t4Ne3+qiUOtLB6Agk3
        skj7dGEI7aKAEhyMu6U65rmdI18nZw8NxNutfCNi+dXGAY4kK9MKq8bTITa8hdbm7V8OTcc3foDp/
        rnETDik0HXp8DCiXgSU6sX9L4czesHCZsoXpLQFPtgd0Ly7/HA4OiXz7InaEcvPJGM35peFRKKp2J
        LltNVnEwbaU5Hu8mGwfsD3xEHEgim/bC/nZS7hsvNNwaFBejYCrOJn/C6/hFe1ztjXzfE//mEomBY
        2I14z2QA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgYfa-009Imx-Ut; Fri, 29 Oct 2021 21:40:10 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 0/3] parser: refactor and extend limit rate rules
Date:   Fri, 29 Oct 2021 21:40:06 +0100
Message-Id: <20211029204009.954315-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first two patches introduce new rules to deduplicate the code for
parsing `limit rate` expressions and make it easier to extend the
syntax.

The third patch extends the syntax to handle expressions like `limit
rate 1 mbytes / second`, which are not currently supported.

Changes since v1:

 * add patches 1 & 2 in order to simplify the new rule added in patch 3.

Jeremy Sowden (3):
  parser: add new `limit_bytes` rule
  parser: add `limit_rate_pkts` and `limit_rate_bytes` rules
  parser: extend limit syntax

 include/datatype.h           |   4 +
 src/parser_bison.y           | 141 ++++++++++++++++++-----------------
 tests/py/any/limit.t         |   5 ++
 tests/py/any/limit.t.json    |  39 ++++++++++
 tests/py/any/limit.t.payload |  13 ++++
 5 files changed, 134 insertions(+), 68 deletions(-)

-- 
2.33.0

