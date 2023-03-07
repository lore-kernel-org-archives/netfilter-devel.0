Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E46C6FD1B
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 13:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjCGN6k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 08:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCGN6j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 08:58:39 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D9C74DF3
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 05:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=60oZkiga/2LwulyuE0EnPIOyPA0Gq8YwO21kqAYpZb0=; b=GBfGuzleOF8gOW+J/QEicsW+HB
        YtxVirU5bKtMZXTe0TsjkIHVx9tERl4WxUDQaM1v2xLOyuwhfNfUsQH1lJ88r4UX8OaSKFqpIm86J
        0USRpwmdXi8u8Elmir3kXC4LeirprhvhTnJeOmSICTSCrf9hwxXCzkS6zFmgiHpJPyoXa3/V9I//r
        mvqw0iXRgfPCu2PJKMMlFg0XwApiCEGRnV5FzBNJ5+glLsjS7o2RjYrco+sSHMMhpxPxpWvF413ht
        yeykDey7tfxkdkSkOePZL5b1TdEuM7DeBqO+cl98zdY8WWrwc6a4c+stf+a3I9em5cx4qQha8f41H
        gM6y0z0g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pZXps-00059K-LP; Tue, 07 Mar 2023 14:58:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ipset PATCH 0/4] Some testsuite improvements
Date:   Tue,  7 Mar 2023 14:58:08 +0100
Message-Id: <20230307135812.25993-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 fixes the reason why xlate testuite failed for me - it was
simply not testing the right binary. Make it adhere to what the regular
testsuite does by calling the built ipset tool instead of the installed
one.

Patch 2 is just bonus, the idea for it came from a "does this even work"
sanity check while debugging the above.

Patch 3 fixes for missing 'netmask' tool on my system. Not entirely
satisfying though, there's no 'sendip', either (but the testsuite may
run without).

Patch 4 avoids a spurious testsuite failure for me. Not sure if it's a
good solution or will just move the spurious failure to others' systems.

Phil Sutter (4):
  tests: xlate: Test built binary by default
  tests: xlate: Make test input valid
  tests: cidr.sh: Add ipcalc fallback
  tests: hash:ip,port.t: 'vrrp' is printed as 'carp'

 tests/cidr.sh               | 32 ++++++++++++++++++++++++++++----
 tests/hash:ip,port.t.list2  |  2 +-
 tests/xlate/ipset-translate |  1 +
 tests/xlate/runtest.sh      | 14 ++++++++++----
 tests/xlate/xlate.t         |  6 +++---
 tests/xlate/xlate.t.nft     |  4 ++--
 6 files changed, 45 insertions(+), 14 deletions(-)
 create mode 120000 tests/xlate/ipset-translate

-- 
2.38.0

