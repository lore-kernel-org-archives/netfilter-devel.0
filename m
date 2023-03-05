Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1A6C6FA9E
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCEKaK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjCEKaG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:30:06 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A519D503
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sYYd8+bI0241RdVDOIY+NxmQtr2PqmJbh0y7ndtGXQM=; b=iEfEdqn7lWbaKOlCRZXM+Cszr5
        /dD/yYOgjlPlU8m4+5pgQqYAwFP0iPUmrqKhqEGbMp1ciUikPb/e4H6aZ1iRQa5ENTMy7fzqC+Cw9
        FnxKlcq4n+SVNYtmASoEB8dbxmiMLgwQ0khx9XKRS2UAO1IR/NA68x5eZpjTPKcymOq6j/hN4u0Qq
        hpF0cpt3iB0EXuTbWUSMVW0xR1J2H6SoHpwu2gaWfojHc39nXzs5y7GBTrmFTVleEilG/RdkBAfVe
        xXcrov3Y4qVSAslMFkvbYSUQUQiIAiKOup6dtP7p5v0PtKsaaBs6woOfIzaz7UG6EyQHfaoC9gbqU
        34cqKQoQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlcu-00DzC0-7a
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:30:00 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables 0/8] Support for shifted port-ranges in NAT
Date:   Sun,  5 Mar 2023 10:14:10 +0000
Message-Id: <20230305101418.2233910-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support for shifted port-ranges was added to iptables for DNAT in 2018.
This allows one to redirect packets intended for one port to another in
a range in such a way that the new port chosen has the same offset in
the range as the original port had from a specified base value.

For example, by using the base value 2000, one could redirect packets
intended for 10.0.0.1:2000-3000 to 10.10.0.1:12000-13000 so that the old
and new ports were at the same offset in their respective ranges, i.e.:

  10.0.0.1:2345 -> 10.10.0.1:12345

This patch-set adds support for doing likewise to nftables.  In contrast
to iptables, this works for `snat`, `redirect` and `masquerade`
statements as well as well as `dnat`.

Patches 1-3 add support for shifted ranges to the NAT statements.
Patches 4-5 add JSON support for shifted ranges.
Patches 6-7 update the NAT documentation to cover shifted ranges.
Patch 8 adds some Python test-cases for shifted ranges.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=970672
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1501

libnftnl & kernel patch-sets to follow.

Jeremy Sowden (8):
  nat: add support for shifted port-ranges
  masq: add support for shifted port-ranges
  redir: add support for shifted port-ranges
  json: formatting fixes
  json: add support for shifted nat port-ranges
  doc: correct NAT statement description
  doc: add shifted port-ranges to nat statements
  test: py: add tests for shifted nat port-ranges

 doc/statements.txt                    | 11 +++-
 include/statement.h                   |  1 +
 src/evaluate.c                        | 10 +++
 src/json.c                            |  4 ++
 src/netlink_delinearize.c             | 48 +++++++++++++-
 src/netlink_linearize.c               | 29 ++++++---
 src/parser_bison.y                    | 55 +++++++++++++++-
 src/parser_json.c                     | 49 ++++++++-------
 src/statement.c                       |  4 ++
 tests/py/inet/dnat.t                  |  3 +
 tests/py/inet/dnat.t.json             | 91 +++++++++++++++++++++++++++
 tests/py/inet/dnat.t.payload          | 33 ++++++++++
 tests/py/inet/snat.t                  |  3 +
 tests/py/inet/snat.t.json             | 91 +++++++++++++++++++++++++++
 tests/py/inet/snat.t.payload          | 34 ++++++++++
 tests/py/ip/masquerade.t              |  1 +
 tests/py/ip/masquerade.t.json         | 26 ++++++++
 tests/py/ip/masquerade.t.payload      |  8 +++
 tests/py/ip/redirect.t                |  1 +
 tests/py/ip/redirect.t.json           | 26 ++++++++
 tests/py/ip/redirect.t.payload        |  8 +++
 tests/py/ip6/masquerade.t             |  1 +
 tests/py/ip6/masquerade.t.json        | 25 ++++++++
 tests/py/ip6/masquerade.t.payload.ip6 |  8 +++
 tests/py/ip6/redirect.t               |  1 +
 tests/py/ip6/redirect.t.json          | 26 ++++++++
 tests/py/ip6/redirect.t.payload.ip6   |  8 +++
 27 files changed, 569 insertions(+), 36 deletions(-)

-- 
2.39.2

