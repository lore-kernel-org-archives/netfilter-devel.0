Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB78C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Nov 2022 13:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiKGNJB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Nov 2022 08:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiKGNJA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2022 08:09:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB23193C8
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Nov 2022 05:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ONzzm1UZMzXilSikcTfeFsVaa16oOatbYJXZ7ldMxwA=; b=doJPh4xYz37vYwQZ3HQgXRRhT2
        9WGRpkoCx25OPZG11aen8EH9yoZeVVnJwZmuL4KTamaCJiiXzcLbnrgM5sWWWct/5EhUqqHhtkC4G
        Z71p3Lm7R6nwNszkPbVqc738F6v6LKRryj3x596G4eF4XHbu/uwOvShNItGmpkifNBwKvgMYAmQnw
        LMPL3ne4ABw7o9oOL0EzaR66dHXL1FtuiIhWEasZzTs0PB7Elidy3AXJLbS+e1xGdx85VfMVFU+RI
        FJ4EDo1oidWhWyTog7uDHohjlI+FZrLomqQuzJhy1Tj0d8xmud5MyMA8/+AyP5Vcd5AaLpC1GvHHR
        bB1SnXGg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1os1s2-0002hN-3f
        for netfilter-devel@vger.kernel.org; Mon, 07 Nov 2022 14:08:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/3] Extend xlate-test to replay results
Date:   Mon,  7 Nov 2022 14:08:40 +0100
Message-Id: <20221107130843.8024-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If nftables has libxtables support, it will utilize the .xlate callbacks
to print compat expressions in native nftables syntax. Users may miss
the fact that what they're seeing is not the reality and assume they may
manipulate (including store and reload) the ruleset using nftables. This
wasn't a big deal if iptables-nft understood all the translations
libxtables offers.

To start catching up on this, add an optional replay mode to
xlate-test.py checking if what was translated is correctly parsed back
into the original input (or at least a semantical equivalent).

Patches 1 and 2 are prep work, patch 3 has the gory details.

Phil Sutter (3):
  tests: xlate-test: Cleanup file reading loop
  tests: xlate-test.py: Introduce run_proc()
  tests: xlate-test: Replay results for reverse direction testing

 xlate-test.py | 212 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 184 insertions(+), 28 deletions(-)

-- 
2.38.0

