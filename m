Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDF1C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CC54217D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfI0OFo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 10:05:44 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:50042 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfI0OFo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 10:05:44 -0400
Received: from localhost ([::1]:34900 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDqsQ-0006xy-TX; Fri, 27 Sep 2019 16:05:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 00/12] Implement among match support
Date:   Fri, 27 Sep 2019 16:04:21 +0200
Message-Id: <20190927140433.9504-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes since v1:
- Rebased onto my performance improvements patch series.
- Aligned set caching routines with changes in above series.
- Fixed patch ordering so builds are not broken intermittently.
- Replaced magic numbers by defines or offsetof() statements. Note that
  I did not move any defines into libnftnl; the remaining ones are for
  values in sets' key_type attribute which neither libnftnl nor kernel
  care about. Setting that is merely for compatibility with nft tool.

This series ultimately adds among match support to ebtables-nft. The
implementation merely shares the user interface with legacy one,
internally the code is distinct: libebt_among.c does not make use of the
wormhash data structure but a much simpler one for "temporary" storage
of data until being converted into an anonymous set and associated
lookup expression.

Patches 1 to 5 implement required changes and are rather boring by
themselves: When converting an nftnl rule to iptables command state,
cache access is required (to lookup set references).

Patch 6 simplifies things a bit with the above in place.

Patches 7 to 11 implement anonymous set support.

Patch 12 then adds the actual among match implementation for
ebtables-nft.

Phil Sutter (12):
  nft: family_ops: Pass nft_handle to 'add' callback
  nft: family_ops: Pass nft_handle to 'rule_find' callback
  nft: family_ops: Pass nft_handle to 'print_rule' callback
  nft: family_ops: Pass nft_handle to 'rule_to_cs' callback
  nft: Keep nft_handle pointer in nft_xt_ctx
  nft: Eliminate pointless calls to nft_family_ops_lookup()
  nft: Fetch sets when updating rule cache
  nft: Support NFT_COMPAT_SET_ADD
  nft: Bore up nft_parse_payload()
  nft: Embed rule's table name in nft_xt_ctx
  nft: Support parsing lookup expression
  nft: bridge: Rudimental among extension support

 extensions/libebt_among.c  | 278 ++++++++++++++++++++
 extensions/libebt_among.t  |  16 ++
 iptables/ebtables-nft.8    |  66 ++---
 iptables/nft-arp.c         |  13 +-
 iptables/nft-bridge.c      | 244 +++++++++++++++++-
 iptables/nft-bridge.h      |  21 ++
 iptables/nft-ipv4.c        |  10 +-
 iptables/nft-ipv6.c        |  10 +-
 iptables/nft-shared.c      |  70 +++---
 iptables/nft-shared.h      |  26 +-
 iptables/nft.c             | 502 +++++++++++++++++++++++++++++++++----
 iptables/nft.h             |  14 +-
 iptables/xtables-eb.c      |   1 +
 iptables/xtables-monitor.c |  17 +-
 iptables/xtables-save.c    |   3 +
 15 files changed, 1135 insertions(+), 156 deletions(-)
 create mode 100644 extensions/libebt_among.c
 create mode 100644 extensions/libebt_among.t

-- 
2.23.0

