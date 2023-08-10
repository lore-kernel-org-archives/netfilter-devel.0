Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41E9C04E69
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 18:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbjHJSzJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 14:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbjHJSzI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 14:55:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68722696
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 11:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VE3urI0Cb6x/4dVKlnqw6WAjL54/nuIKXg7vWGedd3I=; b=EumAbSob7n5VNAuilgqNErvZfK
        e6qXP2L1QZZAbrJnywif6zOpMQURA9uaX3o08B0liHtX4jX17z+EBWS+0w2ga8EaHEVGaZvFQ8jR3
        FGnDhVAZjvX4HsPCkaFN8AQw3w6aM1gW6ATOeWsyWqyTG9S02KVRPIxgp2yYVs9V/rH1Cj8QOWdCA
        iKZ1sOP0p+NIoHzUTc1GF+Lkqo2EcQZ6EyE8wr8IZEuujJlsmVYkVjZ+uAjCYRQzdUaDSgzKDYCey
        KXGxmHMFtDjt9UdggRKyVEg5mCkqIpSnhqM7dvDYdfBoPv+pZsllfzOeA13ePNr0rwBUU5LONGyB2
        rinIADWQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qUAoM-0002Yd-5J
        for netfilter-devel@vger.kernel.org; Thu, 10 Aug 2023 20:55:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 0/4] Implement a best-effort forward compat solution
Date:   Thu, 10 Aug 2023 20:54:48 +0200
Message-Id: <20230810185452.24387-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Initial attempts of keeping a compatible version of each rule in the
kernel for being dumped so any old user space will be able to parse it
despite what conversions to native expressions have taken place have
failed: The dump-only bytecode may contain a lookup expression,
therefore requires updating and an extra set and so on. This will be a
nightmare to maintain in kernel. Any alternative to this is not
transparent to old user space which can't be touched in a scenario of
$RANDOM old container has to parse the host's ruleset.

Instead of the above, follow a much simpler route by implementing a
compat-mode into current *tables-nft which avoids any of the later
internal changes which may prevent an old iptables-nft from parsing a
kernel's rule correctly. An up to date host expecting outdated
containers accessing its ruleset may create it in a compatible form,
trading potential performance regressions in for compatibility.

Patch 1 is just prep work, patch 2 adds the core logic, patch 3 exposes
it to CLI and patch 4 finally adds some testing.

This should resolve nfbz#1632[1], albeit requiring adjustments in how
users call iptables.

[1] https://bugzilla.netfilter.org/show_bug.cgi?id=1632

Changes since v1:
- Rebase to current HEAD
- Add missing parser and man page adjustments in patch 3

Phil Sutter (4):
  nft: Pass nft_handle to add_{target,action}()
  nft: Introduce and use bool nft_handle::compat
  Add --compat option to *tables-nft and *-nft-restore commands
  tests: Test compat mode

 iptables-test.py                              | 19 ++++--
 iptables/arptables-nft-restore.8              | 15 +++--
 iptables/arptables-nft.8                      |  8 +++
 iptables/ebtables-nft.8                       |  6 ++
 iptables/iptables-restore.8.in                | 11 +++-
 iptables/iptables.8.in                        |  7 +++
 iptables/nft-arp.c                            |  2 +-
 iptables/nft-bridge.c                         |  9 +--
 iptables/nft-ipv4.c                           |  2 +-
 iptables/nft-ipv6.c                           |  2 +-
 iptables/nft-shared.c                         |  2 +-
 iptables/nft.c                                | 19 +++---
 iptables/nft.h                                |  7 ++-
 .../testcases/nft-only/0011-compat-mode_0     | 63 +++++++++++++++++++
 iptables/xshared.c                            |  7 ++-
 iptables/xshared.h                            |  1 +
 iptables/xtables-arp.c                        |  1 +
 iptables/xtables-eb.c                         |  7 ++-
 iptables/xtables-restore.c                    | 43 +++++++++++--
 iptables/xtables.c                            |  2 +
 20 files changed, 198 insertions(+), 35 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0011-compat-mode_0

-- 
2.40.0

