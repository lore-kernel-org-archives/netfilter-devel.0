Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CAAC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Feb 2022 16:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiBLQ7B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Feb 2022 11:59:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiBLQ7B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Feb 2022 11:59:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF312409F
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Feb 2022 08:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fymNo3Q+PGrmF1MIMhuXwlek8EtmGMn1L3vWb9ZD9to=; b=CN6ikRj+R/FuKKN1CFbhaG5HpM
        +ZU69EmHtND4LK8biAZl3gFpq8GaVAcWEvrXVqd09JxzVUPbNhzzjdX8hF3LbO6LOaJN8rEZdkYND
        zT9bXYx9LpPTq04UrCMhLPSUOgbLfGnyOnrPQk5q5maXvgFBc6Dw8KiDwpvvPNjDsk3anCXLX+h5n
        2nfk/KVY6rPk0XTK1AZzmSjcyt25BDQZwBQw+/lqybiNcc0aDCqWu8CpytwCsxQIDYZjHcirg29GZ
        2t/S9iS29TkYWIMHwKYCgiwpusruvWkFEswLvk6ruVCQUwxHqDSlLNVIP63lCxODArJ73rGse//Rm
        EZvXnQDQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nIvjZ-001xVU-4g
        for netfilter-devel@vger.kernel.org; Sat, 12 Feb 2022 16:58:53 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [iptables PATCH 0/4] Re-enable NFLOG tests
Date:   Sat, 12 Feb 2022 16:58:28 +0000
Message-Id: <20220212165832.2452695-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some of the NFLOG tests were disabled when iptables-nft was changed to
use nft's nflog implementation, because nft doesn't support
`--nflog-range`.  This patch-set builds on Phil's recent work to support
different test results for -legacy and -nft in order to re-enable those
tests.

* Patch 1 renames a variable.
* Patches 2 & 3 add support for a new test result where the iptables
  command succeeds, but dumping the rule does not give the expected
  output.
* Patch 4 re-enables the tests.

Jeremy Sowden (4):
  tests: iptables-test: rename variable
  tests: add `NOMATCH` test result
  tests: support explicit variant test result
  tests: NFLOG: enable `--nflog-range` tests

 extensions/libxt_NFLOG.t | 12 +++----
 iptables-test.py         | 72 ++++++++++++++++++++++++++--------------
 2 files changed, 53 insertions(+), 31 deletions(-)

-- 
2.34.1

