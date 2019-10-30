Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66658CA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EEF02087E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfJ3R2E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:28:04 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45168 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbfJ3R2D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 13:28:03 -0400
Received: from localhost ([::1]:58258 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iPrlK-0007pN-Nr; Wed, 30 Oct 2019 18:28:02 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 00/12] Implement among match support
Date:   Wed, 30 Oct 2019 18:26:49 +0100
Message-Id: <20191030172701.5892-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes since v2:
- Rebased onto current master branch. With cache levels being upstream,
  no dependencies on unfinished work remains.
- Integrate sets caching into cache level infrastructure.
- Fixed temporary build breakage within series.
- Larger review of last patch containing the actual among match
  extension.

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
  nft: Introduce NFT_CL_SETS cache level
  nft: Support NFT_COMPAT_SET_ADD
  nft: Bore up nft_parse_payload()
  nft: Embed rule's table name in nft_xt_ctx
  nft: Support parsing lookup expression
  nft: bridge: Rudimental among extension support

 extensions/libebt_among.c  | 243 +++++++++++++++++++++++++++++++++
 extensions/libebt_among.t  |  16 +++
 iptables/ebtables-nft.8    |  66 ++++-----
 iptables/nft-arp.c         |  13 +-
 iptables/nft-bridge.c      | 232 ++++++++++++++++++++++++++++++--
 iptables/nft-bridge.h      |  56 ++++++++
 iptables/nft-cache.c       | 205 ++++++++++++++++++++++++++--
 iptables/nft-cache.h       |   2 +
 iptables/nft-ipv4.c        |  10 +-
 iptables/nft-ipv6.c        |  10 +-
 iptables/nft-shared.c      |  70 +++++-----
 iptables/nft-shared.h      |  26 ++--
 iptables/nft.c             | 269 ++++++++++++++++++++++++++++++++-----
 iptables/nft.h             |   8 +-
 iptables/xtables-eb.c      |   1 +
 iptables/xtables-monitor.c |  17 ++-
 iptables/xtables-save.c    |   3 +
 17 files changed, 1101 insertions(+), 146 deletions(-)
 create mode 100644 extensions/libebt_among.c
 create mode 100644 extensions/libebt_among.t

-- 
2.23.0

