Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23808C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJFA24 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJFA2z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:28:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5ED82D19
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CT5bKDJQjIUQmUwx8dGEa7o5BNPSGSvIL9P+3m7/iGQ=; b=bfyTxC2LdffvL61SExoxzA40f4
        /0QKP2EjS876YXkPRqW24NZIvcNFT3X2Fq+QFLhDCnpqanSaSIhCpYKlOh8kTG2EvJEdHXApnhGrT
        uua9ANHvnpb7WNxWYlGBRM0a2z7uH8HhuefJ606plHHWOxctC3ShUNwnzRBCSw4FnpL1sKcBJUqQa
        EXvP27XlkRKO6L/sn9P1FPXaZBOFs3L7fmZh0L+oNVI/9mOZJeOUnVbxqmbdaeXfalQnWVdLYeDaL
        mS9Lyb4k1mrk1y15fVeghnPxeXTR0qkiEBfR6NWc/EAPXUlSTNk+mWAZYw+OQNXrctPYpLJu7fkXw
        Mj9rY6RA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEkq-0001yg-BK; Thu, 06 Oct 2022 02:28:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 00/12] Speed up iptables-tests.py
Date:   Thu,  6 Oct 2022 02:27:50 +0200
Message-Id: <20221006002802.4917-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
  tests: libxt_connlimit.t: Add missing --connlimit-saddr
  extensions: Do not print all-one's netmasks
  extensions: NFQUEUE: Do not print default queue number 0

 extensions/libebt_log.t      |   2 +-
 extensions/libebt_nflog.t    |   2 +-
 extensions/libebt_redirect.t |   2 +-
 extensions/libebt_vlan.t     |   4 +-
 extensions/libip6t_NETMAP.c  |   2 +-
 extensions/libip6t_REJECT.t  |   2 +-
 extensions/libipt_NETMAP.c   |   2 +-
 extensions/libipt_REJECT.t   |   2 +-
 extensions/libxt_CONNMARK.c  |  32 ++++--
 extensions/libxt_CONNMARK.t  |   4 +-
 extensions/libxt_DSCP.t      |   2 +-
 extensions/libxt_MARK.c      |   4 +-
 extensions/libxt_MARK.t      |   2 +-
 extensions/libxt_NFQUEUE.c   |  27 ++---
 extensions/libxt_NFQUEUE.t   |   4 +-
 extensions/libxt_TOS.t       |  12 +--
 extensions/libxt_connlimit.c |   8 +-
 extensions/libxt_connlimit.t |  20 ++--
 extensions/libxt_connmark.t  |   4 +-
 extensions/libxt_dscp.t      |   2 +-
 extensions/libxt_length.t    |   2 +-
 extensions/libxt_mark.t      |   2 +-
 extensions/libxt_recent.c    |  45 ++++----
 extensions/libxt_recent.t    |  14 +--
 extensions/libxt_tos.t       |   8 +-
 iptables-test.py             | 200 ++++++++++++++++++++++++++++++++++-
 26 files changed, 317 insertions(+), 93 deletions(-)

-- 
2.34.1

