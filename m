Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B689C61DA7
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343888AbjKVMyu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbjKVMyr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:47 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1D1D56
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wccWgTav6JuaCwbJTxR6C5/TryIyFFIxqjSJPMtACBU=; b=Jpv3g5Gu8PQu6SaQ7FBdSTc8qw
        Gg6fz8NTVA2Rni+AO1YKi1Fb50JD5m6jK09MpIKpEjCVIzvzOMr6RuNjfjGXySpXFAbrr2yKaOOjZ
        74ozbYhyIThzvcSCO+EkfeG/48MJwkbVnuc1lIJ66frJJwIU2tSgQ4PVulSq0GamIwbeXBkKPtcD6
        kPKPgFimLcX1Gq0PvyQeajX6Gq2dSFF65dGT66bezTCwOrMp6PiHkjtAa5AHmsih7BFIgRBCvn3/c
        99boTJ0ZvsIysju6Z5NOwSlBXaOVZffTyc1sQ4ncSv2kUEtIIB5xnT0jrZbmHE+8AcM1VRd8xtOZU
        p4iBadMQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkU-0005SD-Lr
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/12] Misc fixes (more or less)
Date:   Wed, 22 Nov 2023 14:02:10 +0100
Message-ID: <20231122130222.29453-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is early fallout from working on a merge of ebtables commandline
parsers with the shared one. It is a mix of actual bug fixes, small
improvements and an implementaion of --change-counters command for
ebtables-nft.

Phil Sutter (12):
  Makefile: Install arptables-translate link and man page
  nft-bridge: nft_bridge_add() uses wrong flags
  xshared: struct xt_cmd_parse::xlate is unused
  xshared: All variants support -v, update OPTSTRING_COMMON
  xshared: Drop needless assignment in --help case
  xshared: Drop pointless CMD_REPLACE check
  tests: xlate: Print failing command line
  ebtables: Drop append_entry() wrapper
  ebtables: Make ebt_load_match_extensions() static
  ebtables: Align line number formatting with legacy
  xshared: do_parse: Ignore '-j CONTINUE'
  ebtables: Implement --change-counters command

 iptables/Makefile.am                          |  11 +-
 iptables/nft-bridge.c                         |   6 +-
 iptables/nft-bridge.h                         |   1 -
 iptables/nft-cmd.c                            |  20 ++++
 iptables/nft-cmd.h                            |  12 +++
 iptables/nft.c                                |  65 +++++++++++
 iptables/nft.h                                |   1 +
 .../testcases/ebtables/0010-change-counters_0 |  45 ++++++++
 iptables/xshared.c                            |  11 +-
 iptables/xshared.h                            |   9 +-
 iptables/xtables-eb.c                         | 102 ++++++++++--------
 iptables/xtables-translate.8                  |  12 ++-
 iptables/xtables-translate.c                  |   1 -
 xlate-test.py                                 |   5 +-
 14 files changed, 229 insertions(+), 72 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0010-change-counters_0

-- 
2.41.0

