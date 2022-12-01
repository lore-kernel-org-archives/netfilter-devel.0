Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3D8C47089
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 16:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiLAQkb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 11:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiLAQkF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 11:40:05 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52048B3938
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 08:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=afD81jE2Lu/Lj/zNdEbw9XHsk1ukTgb2KzDJeOlVGbU=; b=jbSjX3tH1Ycsg3iDK1AUljC9Zz
        98UP3JDzWoKNn90fEA+QpKPeArgR/3+OGXjwEmoaXdR93myDFhZ6cmGnZ+nBi+5YZEYfgF7sx/A/i
        1EHbf3wet8PF1zO/auoyHPJl5+kQYSwDjiFJoL4ae7qL2JJfXeiF8Hss3CJYK8W0T2ioAcpWPgcu8
        c3fAwHcWZHE1jCazHKTaCm1oP7/ZP1kRrYSlWtRRzG9VSyVa/sbpzoCExCDWocMybUYqOOD1cnPEK
        oIcHQCCYJNGYuvP1LbSvzqhYMot13UfLeLDqCXMAlzFWqfvB96Wy9xyLrazy/N+9A9eDd1Bbv5zOh
        aEtIKJ9w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0mbM-0002Ya-OY; Thu, 01 Dec 2022 17:39:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 0/7] tests: xlate: generic.txlate to pass replay test
Date:   Thu,  1 Dec 2022 17:39:09 +0100
Message-Id: <20221201163916.30808-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of dumping the ruleset with xtables-save and creating yet
another string comparison mess by searching the output, use --check
command to leverage iptables' internal rule comparison functionality
when checking that the nftables-created rule parses correctly as the
source of the translation (patch 2).

There was a rub with the above, namely ebtables not supporting --check
in the first place. Gladly the implementation is pretty simple (patch
1) with one caveat: '-C' itself is not available so add the long option
only.

The remaining patches deal with translation details (mostly around
wildcard interface names) until generic.txlate finally passes the replay
test.

Phil Sutter (7):
  ebtables: Implement --check command
  tests: xlate: Use --check to verify replay
  nft: Fix for comparing ifname matches against nft-generated ones
  nft: Fix match generator for '! -i +'
  nft: Recognize INVAL/D interface name
  xtables-translate: Fix for interfaces with asterisk mid-string
  ebtables: Fix MAC address match translation

 extensions/generic.txlate    | 16 ++++++-------
 iptables/nft-bridge.c        |  6 ++---
 iptables/nft-shared.c        | 27 ++++++++++++++++++++-
 iptables/xtables-eb.c        | 12 +++++++---
 iptables/xtables-translate.c |  4 +++-
 xlate-test.py                | 46 ++++++++++++++----------------------
 6 files changed, 67 insertions(+), 44 deletions(-)

-- 
2.38.0

