Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98F7C47083
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A31613B8
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhFBP0g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 11:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhFBP0f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 11:26:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9583AC061574
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 08:24:52 -0700 (PDT)
Received: from localhost ([::1]:43130 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1loSjj-0007QS-28; Wed, 02 Jun 2021 17:24:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/9] Fix a bunch of static analyzer warnings
Date:   Wed,  2 Jun 2021 17:23:54 +0200
Message-Id: <20210602152403.5689-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These fixes vary in severity, ranging from unused variables to memleaks.

Phil Sutter (9):
  libxtables: Drop leftover variable in xtables_numeric_to_ip6addr()
  extensions: libebt_ip6: Drop unused variables
  libxtables: Fix memleak in xtopt_parse_hostmask()
  nft: Avoid memleak in error path of nft_cmd_new()
  nft: Avoid buffer size warnings copying iface names
  iptables-apply: Drop unused variable
  extensions: libebt_ip6: Use xtables_ip6parse_any()
  libxtables: Introduce xtables_strdup() and use it everywhere
  extensions: libxt_string: Avoid buffer size warning for strncpy()

 extensions/libebt_ip.c          |  3 +-
 extensions/libebt_ip6.c         | 78 +++++----------------------------
 extensions/libebt_stp.c         |  3 +-
 extensions/libip6t_DNAT.c       |  4 +-
 extensions/libip6t_SNAT.c       |  4 +-
 extensions/libip6t_dst.c        |  8 ++--
 extensions/libip6t_hbh.c        |  7 ++-
 extensions/libip6t_ipv6header.c |  2 +-
 extensions/libip6t_mh.c         |  2 +-
 extensions/libip6t_rt.c         |  7 ++-
 extensions/libipt_DNAT.c        |  8 +---
 extensions/libipt_SNAT.c        |  4 +-
 extensions/libxt_dccp.c         |  2 +-
 extensions/libxt_hashlimit.c    |  5 +--
 extensions/libxt_iprange.c      |  4 +-
 extensions/libxt_multiport.c    |  6 +--
 extensions/libxt_sctp.c         |  4 +-
 extensions/libxt_set.h          |  4 +-
 extensions/libxt_string.c       |  2 +-
 extensions/libxt_tcp.c          |  4 +-
 include/xtables.h               |  1 +
 iptables/iptables-apply         |  1 -
 iptables/iptables-xml.c         |  4 +-
 iptables/nft-cache.c            |  4 +-
 iptables/nft-cmd.c              | 17 ++++---
 iptables/nft-ipv4.c             |  4 +-
 iptables/nft-ipv6.c             |  4 +-
 iptables/xshared.c              |  2 +-
 libxtables/xtables.c            | 15 ++++++-
 libxtables/xtoptions.c          | 15 ++-----
 30 files changed, 80 insertions(+), 148 deletions(-)

-- 
2.31.1

