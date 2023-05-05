Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD55CC77B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 18:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjEESfX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 14:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjEESfW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 14:35:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911DB15EDD
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 11:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QdUzim34NcWGbUTdrAQUFQCWEFaOHjv4V6fwdxrpqvg=; b=f0L2VMuY1mXzGslSJmCJCBHJE6
        wtH4ZAUiN0hbi9zW0kTGGr/2c2bBQU6pseMyoVSSltfpkNgujvITBaRnk1tmGKT4moV5Bl/pBhN0A
        dpD8ka5xnIX15Ugt2FVl6+KWlU2NzQ6l/630RhQQC6aMjKGMlsbwmR2pPycAEW+TIDD2D2/0n/Qac
        fBpIM9Oii8QqGsSZvOfauWg54F5IjQj4ebmGhZ03VTsZIl1bwrL8fwtTBGSerA+UBWlVPxMgJt0GK
        oXoT//gZc9swAs/hnPEzYPmUd7fRKzPPTvMr37SKH6a4C9YlFZC6HGGYa85MKR/sF4AMRAZ5y1kTz
        +QPgMFlg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pv0H0-0004Qd-7G; Fri, 05 May 2023 20:35:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Garver <e@erig.me>, danw@redhat.com, aauren@gmail.com
Subject: [iptables PATCH 0/4] Implement a best-effort forward compat solution
Date:   Fri,  5 May 2023 20:34:42 +0200
Message-Id: <20230505183446.28822-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of adding a second, compatible rule-representation to kernel for
consumption by older user space, follow a much simpler route by
implementing a compat-mode into current *tables-nft which avoids any of
the later internal changes which may prevent an old iptables-nft from
parsing a kernel's rule correctly.

Patch 1 is just prep work, patch 2 adds the core logic, patch 3 exposes
it to CLI and patch 4 finally adds some testing.

This should resolve nfbz#1632[1], albeit requiring adjustments in how
users call iptables.

[1] https://bugzilla.netfilter.org/show_bug.cgi?id=1632
Phil Sutter (4):
  nft: Pass nft_handle to add_{target,action}()
  nft: Introduce and use bool nft_handle::compat
  Add --compat option to *tables-nft and *-nft-restore commands
  tests: Test compat mode

 iptables-test.py                              | 19 ++++--
 iptables/nft-arp.c                            |  2 +-
 iptables/nft-bridge.c                         |  9 +--
 iptables/nft-ipv4.c                           |  2 +-
 iptables/nft-ipv6.c                           |  2 +-
 iptables/nft-shared.c                         |  2 +-
 iptables/nft.c                                | 15 +++--
 iptables/nft.h                                |  5 +-
 .../testcases/nft-only/0011-compat-mode_0     | 61 +++++++++++++++++++
 iptables/xshared.c                            |  7 ++-
 iptables/xshared.h                            |  1 +
 iptables/xtables-arp.c                        |  1 +
 iptables/xtables-eb.c                         |  7 ++-
 iptables/xtables-restore.c                    | 17 +++++-
 iptables/xtables.c                            |  2 +
 15 files changed, 129 insertions(+), 23 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0011-compat-mode_0

-- 
2.40.0

