Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873D3C54EAA
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Jan 2023 12:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbjAZMYd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Jan 2023 07:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237173AbjAZMYb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2023 07:24:31 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EBD6ACA3
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2023 04:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R1Os1Uh6IkC174KqTyrg/nkujzrAfucjMRhLF4seaF4=; b=XqRJBTolPTVUNFQhs5ZOVxSJHv
        OEmhUk7+nLkggJKQ+1P5YpShY3XzlQJ/73yl8BUoo1xL4i+VbDU74P1kk+dEuQTbN/7WL1L60xTVl
        DwF9CeGYpIef6L98o3I76UtEnHJ0nLAQmWpSGY9NvXPXGYaDTVinRwrtS2y/HoFJe9Gf9hWTIGToa
        pR+1wLUckx1haAebDed/E//+MILvTsqc2KtAeWszdOlonJoD8yBHzjM0h3rECfU2dX7kznbVW4Zze
        L6RSMJGKFqZyFV9ecX6y/LD9qfKbFt+9LWmmJauKNXjS5jiua4LY3A5IIDcsxcoa4KBoU6KNOxAEP
        /hslf0xg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pL1Ir-00057s-5K
        for netfilter-devel@vger.kernel.org; Thu, 26 Jan 2023 13:24:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/7] Small ebtables-translate review + extras
Date:   Thu, 26 Jan 2023 13:23:59 +0100
Message-Id: <20230126122406.23288-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The initial goal was to fix the apparent problem of ebtables-translate
printing 'counter' statement in wrong position, namely after the
verdict. Turns out this happened when targets were used "implicitly",
i.e. without requesting them via '-j'. Since ebtables-nft loaded all
extensions (including targets) upfront, a syntax like:

| # ebtables-nft -A FORWARD --mark-set 1

was accepted and valid. The 'mark' target in this case was added to
iptables_command_state's 'match_list' as if it was a watcher.

Legacy ebtables does not allow this syntax, also it becomes hard for
users to realize why two targets can't be used in the same rule. So
reject this (in patch 2) and implicitly fix the case of 'counter'
statement in wrong position.

Fixing the above caused some fallout: Patch 1 fixes error reporting of
unknown arguments (or missing mandatory parameters) in all tools, patch
7 extends xlate-test.py to conveniently run for all libebt_*.txlate
files (for instance).

The remaining patches 3 to 6 contain cleanups of xtables-eb-translate.c
in comparison to xtables-eb.c, also kind of preparing for a merge of the
two largely identical parsers (at least).

Phil Sutter (7):
  Proper fix for "unknown argument" error message
  ebtables: Refuse unselected targets' options
  ebtables-translate: Drop exec_style
  ebtables-translate: Use OPT_* from xshared.h
  ebtables-translate: Ignore '-j CONTINUE'
  ebtables-translate: Print flush command after parsing is finished
  tests: xlate: Support testing multiple individual files

 extensions/libebt_dnat.txlate                 | 12 ++--
 extensions/libebt_log.c                       |  1 +
 extensions/libebt_mark.txlate                 | 16 ++---
 extensions/libebt_nflog.c                     |  1 +
 extensions/libebt_snat.txlate                 |  8 +--
 include/xtables.h                             |  1 +
 .../ebtables/0002-ebtables-save-restore_0     |  4 +-
 .../testcases/iptables/0009-unknown-arg_0     | 31 ++++++++++
 iptables/xshared.c                            |  9 ++-
 iptables/xtables-eb-translate.c               | 61 +++++++------------
 iptables/xtables-eb.c                         | 46 +++++++-------
 xlate-test.py                                 | 21 ++++---
 12 files changed, 115 insertions(+), 96 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/iptables/0009-unknown-arg_0

-- 
2.38.0

