Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37702C4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiK3TON (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3TOL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 14:14:11 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942E25E9E4
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 11:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VOeOeaGayBlY4bLDlvUQ605kJFStTTdDrOEtyZ8+KEc=; b=Tr4MZS2hxfgqpjVIvxAfEPUAGO
        SNvsKVacn2g8PT0nWdzVfGYU2D9zxNrwBGRVSleQ6pj5wQYOkUJRu4uADrljkHNsrbvJRSJLNIu93
        ez8ajPwBl/BDfPinUykDvAi8uNgIJH228Yu5ZLlr3X2bN7k8cBfT4zkCWVhXvGiKligsSnkfWmZTp
        fBzbu9P41WGBzFy8WXFhmLXBGCAF3u+2CGFfjfWrSVbEJH7SUtVjw1ncCOOsUQF5csMqN/T8kPJcM
        V2G3Q0pHPLrrZfmTXDS1ZOkfJWhrFjW5o+MugFyvGEJKzYYchKHhwbyHqbV7arZMTFHOWTFOfXnsj
        GwW7KvPw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0SX3-0001AU-17
        for netfilter-devel@vger.kernel.org; Wed, 30 Nov 2022 20:14:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/9] Fix for shell testsuite '-V' option
Date:   Wed, 30 Nov 2022 20:13:36 +0100
Message-Id: <20221130191345.14543-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When running the testsuite in "valgrind mode", numerous cases of lost
memory and still reachable at program exit are reported. Address them
all plus libiptc's access of uninitialized memory.

Phil Sutter (9):
  tests: shell: Fix valgrind mode for 0008-unprivileged_0
  iptables-restore: Free handle with --test also
  iptables-xml: Free allocated chain strings
  nft: Plug memleak in nft_rule_zero_counters()
  iptables: Plug memleaks in print_firewall()
  xtables: Introduce xtables_clear_iptables_command_state()
  iptables: Properly clear iptables_command_state object
  xshared: Free data after printing help
  libiptc: Eliminate garbage access

 iptables/ip6tables.c              |  9 +++++++--
 iptables/iptables-restore.c       |  4 ++--
 iptables/iptables-xml.c           | 10 +++++-----
 iptables/iptables.c               |  9 +++++++--
 iptables/nft-arp.c                |  4 ++--
 iptables/nft-ipv4.c               |  4 ++--
 iptables/nft-ipv6.c               |  4 ++--
 iptables/nft-shared.c             | 14 --------------
 iptables/nft-shared.h             |  1 -
 iptables/nft.c                    |  5 +++--
 iptables/tests/shell/run-tests.sh |  3 ++-
 iptables/xshared.c                | 20 ++++++++++++++++++++
 iptables/xshared.h                |  2 ++
 iptables/xtables-translate.c      |  2 +-
 iptables/xtables.c                |  2 +-
 libiptc/libiptc.c                 |  4 ++--
 16 files changed, 58 insertions(+), 39 deletions(-)

-- 
2.38.0

