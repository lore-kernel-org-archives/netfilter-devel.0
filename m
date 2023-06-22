Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0FCEB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jun 2023 15:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjFVPrC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jun 2023 11:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjFVPrB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jun 2023 11:47:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26C0EA
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jun 2023 08:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3OsvYCFMzeDTXvFRYLDY76xutjCnhRzznovrsqz0TjU=; b=Ghlmh97t/1k6ZiMyISxZBZcAUZ
        vRaRCSdNmb27f5h5NJp1VSg/WRdepGmqWIK+bYYnF9M0BMPfkMRtCrRmZEBwHl9T2KCQkvSHkDylw
        2iVCsaB8WYGQuHHrijf3fbjvsz+jhha64JCPYZiq5jQCk0UwAF7GIqHqBBdiXWEgjsFmaUqluWye3
        kdw33sVTSp87h3WDOiYdNHn3+k59Gk0HV8HMzQeaKwr2X/jiSU/OHDuEj5qQDtOpDn0zHrc+hDn63
        HnJkYYholE47F93KzuRaeNc7ED4Zk0z/EhIm4CbeoLxPR2HIyaCc2sBLrK7ZejIMbrZDvGae7m2z+
        iowJV0nQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qCMWR-0001sd-3B; Thu, 22 Jun 2023 17:46:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/4] cli: Make valgrind (kind of) happy
Date:   Thu, 22 Jun 2023 17:46:30 +0200
Message-Id: <20230622154634.25862-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following series is more or less a v2 of my previous single patch
adding nft_ctx_free() calls to cli.c, following a different path:
Eliminate any program exit points from cli.c so nft context deinit at
end of main() happens. This is nicer design as said function allocates
the context in the first place.

Patch 1 is minor cleanup, patch 2 updates main() to free the context in
all cases, too and patch 3 then changes CLI code as described above.
Patch 4 extends shell testsuite by a '-V' (valgrind) mode as present in
iptables' shell testsuite already which wraps all calls to $NFT by
valgrind and collects non-empty logs.

Sadly, I could not eliminate all valgrind complaints because each of the
three CLI backends leaves allocated memory in place at exit. None seem
to have sufficient deinit functions, except linenoise - but that code
runs only for terminals put in raw mode.

Phil Sutter (4):
  main: Make 'buf' variable branch-local
  main: Call nft_ctx_free() before exiting
  cli: Make cli_init() return to caller
  tests: shell: Introduce valgrind mode

 include/cli.h            |  2 +-
 src/cli.c                | 63 ++++++++++++++++++++++++++--------------
 src/main.c               | 42 +++++++++++++++------------
 tests/shell/run-tests.sh | 47 ++++++++++++++++++++++++++++++
 4 files changed, 113 insertions(+), 41 deletions(-)

-- 
2.40.0

