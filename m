Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCAAC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242323AbiBSNaj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbiBSNai (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:38 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B20588B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=swIXooav+i9sF523CGSCxtacLw/o3fllBcI4sOGwgpk=; b=KDPSCxK/x363TbWa/x9rHgmOGQ
        UbLQYKE4ziYkQgFFoOYqqIqMGUFXzlHn+HpPKu61weK+7rWYya5heqj0SOGWAdfNfYQslfDII46eN
        GxLLhQJpk5dPK+dUSPS0a0FaBcrkqu+QVuW4QpGiGyKFj4RobVr09F2Nn2S/ZFO3NrIkiCEP0ioB+
        K8FnPYGeZ/13uR0qP/W6kgKOWhjyF/dtnJv2e/yFwmEoHxbAmo/ZWGsb1dwqlpHR7+B7HO8G8PKWl
        k4I0WK4pDv0mljG6mS/mY6eq4kG+yqC7HwSi41SVjlwZ9hVDRCVO0MBxmGonh7PSbjTYEWjK2x87N
        HPTraprQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPoY-0002dY-G1; Sat, 19 Feb 2022 14:30:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 00/26] scanner: Some fixes, many new scopes
Date:   Sat, 19 Feb 2022 14:27:48 +0100
Message-Id: <20220219132814.30823-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 adds a test for 'ct count' statement, patches 2 and 3 fix some
keywords' scope, bulk scope introduction in the remaining ones.

Phil Sutter (26):
  tests: py: Test connlimit statement
  scanner: Move 'maps' keyword into list cmd scope
  scanner: Some time units are only used in limit scope
  scanner: rt: Move seg-left keyword into scope
  scanner: icmp{,v6}: Move to own scope
  scanner: igmp: Move to own scope
  scanner: tcp: Move to own scope
  scanner: synproxy: Move to own scope
  scanner: comp: Move to own scope.
  scanner: udp{,lite}: Move to own scope
  scanner: dccp, th: Move to own scopes
  scanner: osf: Move to own scope
  scanner: ah, esp: Move to own scopes
  scanner: dst, frag, hbh, mh: Move to own scopes
  scanner: type: Move to own scope
  scanner: rt: Extend scope over rt0, rt2 and srh
  scanner: monitor: Move to own Scope
  scanner: reset: move to own Scope
  scanner: import, export: Move to own scopes
  scanner: reject: Move to own scope
  scanner: flags: move to own scope
  scanner: policy: move to own scope
  scanner: nat: Move to own scope
  scanner: at: Move to own scope
  scanner: meta: Move to own scope
  scanner: dup, fwd, tproxy: Move to own scopes

 include/parser.h          |  29 +++
 src/parser_bison.y        | 263 +++++++++++++++------------
 src/scanner.l             | 361 ++++++++++++++++++++++++--------------
 tests/py/any/ct.t         |   3 +
 tests/py/any/ct.t.json    |  19 ++
 tests/py/any/ct.t.payload |   8 +
 6 files changed, 436 insertions(+), 247 deletions(-)

-- 
2.34.1

