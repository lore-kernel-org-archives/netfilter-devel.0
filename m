Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A509C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiJLPT3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiJLPTD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:19:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8575E0719
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3VeGInfRAtmbD4jFgirHULsgvH07ZvMNx8/9sS/QVMM=; b=URkLslV3jEzLy38Rot30RzYJZ6
        tOtTmfGVfcJ7iYdyqJDH+G30KNXJ9JuSbAL0AJ77CYtwzuOzAuX0EYZWFJ9lItW9t6bsv9f0pxE2X
        VSa5LTw7WA/3Cptr4QqIaj9rztUNwa2Ks3yp4aFI9rB1q03LIU3mrNOvBLb1aQxMEMYCm+uEC+8gj
        YSvf3xCmHSqp91P6d7Kxj1Zv/moGD1D/s1zB3197Cago7OaR+EkMveldsg/uh+I+dJvLG47zofBFg
        ItrnK01mwwbgoVDBAW0cHfbVznOFdETgBeFZ/Y8s5jhe40wpG/f8Y2oEKwIXX/CQX2xJ6vCeBa60w
        yCwECYsQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidVb-0002pr-7o; Wed, 12 Oct 2022 17:18:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 00/12] Speed up iptables-test.py
Date:   Wed, 12 Oct 2022 17:17:50 +0200
Message-Id: <20221012151802.11339-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes since v1:
- Add fallout NFQUEUE patch 1
- Adjust iptables-test.py enhancement as suggested by Jan, details in
  patch 2
- Avoid changing what extensions print, this is a separate discussion -
  instead update expected output accordingly

Original cover letter text:

I had this in mind for a while now and finally got around to do it: When
testing an extensions/*.t file with iptables-tests.py, act in a "batch"
mode applying all rules at once and checking the expected output in one
go, thereby reducing the overhead per test file to a single
iptables-restore and iptables-save call each. This was a bit optimistic,
but the result is still significant - on my rather slow testing VM, a
full iptables-tests.py run completes in ~7min instead of ~30min (yes,
it's slow).

See patch 1 for the implementation details. As a side-effect, rule
existence checking became much stricter, so the remaining patches in
this series deal with eliminating those differences:

* Patch 2 avoids having to add '-j CONTINUE' to almost all ebtables
  rules.
* Patches 3-10 adjust expected output to reality, mostly adding content
  the script didn't care about since the old 'output.find(<rule>)'
  worked fine as long as the output *started* like '<rule>'.
* Patch 11 Changes output by omitting an obvious default value, so a
  real functional change.
* Patch 12 drops another default value (from NFQUEUE target) I'm not
  sure we should keep.

So patches are roughly sorted by my confidence in correctness. Please
have (at least) a close look at the last two, I don't want to break
iptables for anyone just to keep test files small.

Phil Sutter (12):
  extensions: NFQUEUE: Document queue-balance limitation
  tests: iptables-test: Implement fast test mode
  tests: iptables-test: Cover for obligatory -j CONTINUE in ebtables
  tests: *.t: Fix expected output for simple calls
  tests: *.t: Fix for hexadecimal output
  tests: libebt_redirect.t: Plain redirect prints with trailing
    whitespace
  tests: libxt_length.t: Fix odd use-case output
  tests: libxt_recent.t: Add missing default values
  tests: libxt_tos.t, libxt_TOS.t: Add missing masks in output
  tests: libebt_vlan.t: Drop trailing whitespace from rules
  tests: libxt_connlimit.t: Add missing default values
  tests: *.t: Add missing all-one's netmasks to expected output

 extensions/libebt_log.t      |   2 +-
 extensions/libebt_nflog.t    |   2 +-
 extensions/libebt_redirect.t |   2 +-
 extensions/libebt_vlan.t     |   4 +-
 extensions/libip6t_NETMAP.t  |   2 +-
 extensions/libip6t_REJECT.t  |   2 +-
 extensions/libipt_NETMAP.t   |   2 +-
 extensions/libipt_REJECT.t   |   2 +-
 extensions/libxt_CONNMARK.t  |   8 +-
 extensions/libxt_DSCP.t      |   2 +-
 extensions/libxt_MARK.t      |   4 +-
 extensions/libxt_NFQUEUE.c   |   2 +-
 extensions/libxt_NFQUEUE.man |   2 +
 extensions/libxt_NFQUEUE.t   |   7 +-
 extensions/libxt_TOS.t       |  12 +--
 extensions/libxt_connlimit.t |  12 +--
 extensions/libxt_connmark.t  |   4 +-
 extensions/libxt_dscp.t      |   2 +-
 extensions/libxt_length.t    |   2 +-
 extensions/libxt_mark.t      |   2 +-
 extensions/libxt_recent.t    |   4 +-
 extensions/libxt_tos.t       |   8 +-
 iptables-test.py             | 163 ++++++++++++++++++++++++++++++++++-
 23 files changed, 207 insertions(+), 45 deletions(-)

-- 
2.34.1

