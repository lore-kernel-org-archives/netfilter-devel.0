Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1ACC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Dec 2021 18:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhLKSze (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Dec 2021 13:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbhLKSzc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Dec 2021 13:55:32 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D36DC0617A1
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Dec 2021 10:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3N+NmhDM+PW7FGrILlUaURosiqYY77g+r22SGNMDR7M=; b=TJx7QHxD7AAnr53AtiLyqEJlWH
        j/GP73yxKtrM2uEjdEyTDgwlWganhNO46ixeflM35H+tgYQcMqOc94H6CplYCfSAmTAwqSATlzGyx
        JZuxJmZPqd/OzLgW+tMKBAsxYknBWzaK4+vnnjOb6sBXMFDUDk0wCnaddi4EmHh5AgVYSkD/FVQeX
        wf16S7VMjh7HLqGnOU00bU8qJ8/L/6M0WpiStRk7Yh3rtXROC4J3FzrVgJJwNqQYyGqd+tCUxI32i
        LcWIGkxu9pXfyEFDQWVTgPQRaKdTVOJQQn763jISxrjqmJNN9iNLWlURyVe9Tws/TH1fZuTJl63we
        fLsTl/zw==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mw7Wr-004cqg-SE
        for netfilter-devel@vger.kernel.org; Sat, 11 Dec 2021 18:55:29 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 0/3] inet reject statement fix
Date:   Sat, 11 Dec 2021 18:55:22 +0000
Message-Id: <20211211185525.20527-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first two patches contain small improvements that I noticed while
looking into a Debian bug-report.  The third contains a fix for the
reported bug, that `inet` `reject` rules of the form:

  table inet filter {
    chain input {
      type filter hook input priority filter;
      ether saddr aa:bb:cc:dd:ee:ff ip daddr 192.168.0.1 reject
    }
  }

fail with:

  BUG: unsupported familynft: evaluate.c:2766:stmt_evaluate_reject_inet_family: Assertion `0' failed.
  Aborted

Here's the bug-report:

  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1001360

Jeremy Sowden (3):
  proto: short-circuit loops over upper protocols
  evaluate: correct typo's
  evaluate: reject: support ethernet as L2 protcol for inet table

 src/evaluate.c                      | 11 +++++++---
 src/proto.c                         | 10 ++++++---
 tests/py/inet/reject.t              |  2 ++
 tests/py/inet/reject.t.json         | 34 +++++++++++++++++++++++++++++
 tests/py/inet/reject.t.payload.inet | 10 +++++++++
 5 files changed, 61 insertions(+), 6 deletions(-)

-- 
2.33.0

