Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848A0C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhLUThR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241808AbhLUThQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:37:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11E4C061746
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oT0g2ALv9VUa76qPxkp4xSinyBvsogWRaI6o+zh+rUE=; b=iK5S7I84hDBTgQ9WAaO3iiAVrI
        pl9iEjEzuQoWSjQuXTape1zb1Lg1NoeSoQxu/uRMzWsgmFCYQItRR77v02Ie/UOjgLVFOhTMib1Q6
        ygj0WwZQEZfsL/6Tv4BB/pJ6zHQwNRh9UtLOWX7V/trgYn4P3JaNH4yw0xZ5oRshbCz8GhIOH8eoO
        Nrm5Ds2jpdqmToGqZdhqcTVm6ReXOjaXprsQu6w+UfI4HH6wUkw863RD9PLjm0s53u9PRkrrIkiNy
        IseSgVfGYtONpXcIwnt4eLVyXbjwyoW/R7Iprwfxrx2DC8fqQ23AsJIiH9jIAc9/CVJSMPO7nCqnn
        r9wMQgWQ==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwj-0019T9-Fa
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 00/11] Store multiple payload dependencies
Date:   Tue, 21 Dec 2021 19:36:46 +0000
Message-Id: <20211221193657.430866-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first patch in this set fixes a cut-and-paste error in an inet
Python test payload which leads to test-failures.  However, even with
this fix in place, the test-case still fails:

  inet/sets.t: WARNING: line 24: 'add rule inet test-inet input ip saddr . ip daddr . tcp dport @set3 accept': 'ip saddr . ip daddr . tcp dport @set3 accept' mismatches 'meta nfproto ipv4 ip saddr . ip daddr . tcp dport @set3 accept'
  inet/sets.t: WARNING: line 24: 'add rule bridge test-inet input ip saddr . ip daddr . tcp dport @set3 accept': 'ip saddr . ip daddr . tcp dport @set3 accept' mismatches 'meta protocol ip ip saddr . ip daddr . tcp dport @set3 accept'
  inet/sets.t: WARNING: line 24: 'add rule netdev test-netdev ingress ip saddr . ip daddr . tcp dport @set3 accept': 'ip saddr . ip daddr . tcp dport @set3 accept' mismatches 'meta protocol ip ip saddr . ip daddr . tcp dport @set3 accept'
  inet/sets.t: WARNING: line 24: 'add rule netdev test-netdev egress ip saddr . ip daddr . tcp dport @set3 accept': 'ip saddr . ip daddr . tcp dport @set3 accept' mismatches 'meta protocol ip ip saddr . ip daddr . tcp dport @set3 accept'

The expected output does not include the initial protocol matches.
Since the netdev and bridge families express these matches differently
from how inet does it, it is not possible simply to add the correct
output to the test-case, e.g.:

  -ip saddr . ip daddr . tcp dport @set3 accept;ok
  +ip saddr . ip daddr . tcp dport @set3 accept;ok;meta nfproto ipv4 ip saddr . ip daddr . tcp dport @set3 accept

and so my initial approach was to split the test-case, moving the netdev
and bridge tests into their respective directories.

However, the protocol matches are redundant and on further thought it
seemed like a better idea to improve the code that performs payload-
dependency elimination.  That is the purpose of this patch-set.

Here's the netlink dump for the test:

  [ meta load nfproto => reg 1 ]
  [ cmp eq reg 1 0x00000002 ]
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ payload load 4b @ network header + 16 => reg 9 ]
  [ payload load 2b @ transport header + 2 => reg 10 ]
  [ lookup reg 1 set set3 ]
  [ immediate reg 0 accept ]

The reason the `meta nfproto` match is not eliminated is that it is
overwritten in the dependency context by the `meta l4proto` match before
we get to the `ip saddr` and `ip daddr` expressions which would have
caused it to be eliminated.  By contrast, the `meta l4proto` match _is_
eliminated because it is still present in the context we get to the `tcp
dport` expression.  Therefore, this patch-set extends the payload-
dependency context to store not just a single dependency, but one per
protocol layer.

Patches 1-3 fix mistakes in Python test-cases.  Patches 4-8 do a bit of
tidying and make some preliminary changes.  Patch 9 adds the extra
dependencies.  Patches 10 & 11 remove redundant protocol matches which
are now eliminated from test-cases.

At the end of this series all tests pass.

Jeremy Sowden (11):
  tests: py: fix inet/sets.t netdev payload
  tests: py: fix inet/ip.t payloads
  tests: py: fix inet/ip_tcp.t test
  netlink_delinearize: fix typo
  src: remove arithmetic on booleans
  src: reduce indentation
  src: simplify logic governing storing payload dependencies
  src: add a helper that returns a payload dependency for a particular
    base
  src: store more than one payload dependency
  tests: py: remove redundant payload expressions
  tests: shell: remove redundant payload expressions

 include/payload.h                             | 15 ++--
 src/netlink.c                                 | 21 ++---
 src/netlink_delinearize.c                     | 53 +++++------
 src/payload.c                                 | 90 +++++++++++++------
 tests/py/inet/icmpX.t                         |  2 +-
 tests/py/inet/icmpX.t.json.output             |  9 --
 tests/py/inet/ip.t.payload.bridge             |  2 +-
 tests/py/inet/ip.t.payload.netdev             |  2 +-
 tests/py/inet/ip_tcp.t                        |  4 +-
 tests/py/inet/ip_tcp.t.json.output            | 12 +++
 tests/py/inet/sets.t.json                     | 11 ---
 tests/py/inet/sets.t.payload.netdev           |  6 +-
 .../testcases/maps/dumps/0010concat_map_0.nft |  2 +-
 .../testcases/maps/dumps/nat_addr_port.nft    |  8 +-
 14 files changed, 129 insertions(+), 108 deletions(-)

-- 
2.34.1

