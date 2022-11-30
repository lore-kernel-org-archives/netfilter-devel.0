Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94FAC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 09:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbiK3JdM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 04:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiK3JcS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 04:32:18 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0C169DD3
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 01:32:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p0JRi-00030Z-9w; Wed, 30 Nov 2022 10:32:02 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 iptables-nft 0/3] remove escape_quotes support
Date:   Wed, 30 Nov 2022 10:31:51 +0100
Message-Id: <20221130093154.29004-1-fw@strlen.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes since v3:
- replace strcmp(s, "") with s[0], do not escape '
- handle multiline expectations

Changes since v2:
- first patch keeps the struct members for ABI sake
- get rid of patch 3, with Phils recent change the core eats
  trailing whitespace itself without need to "fix" the extensions.
- add a patch that removes the intermediate shell step during
   "xtables-test.py -R".

Instead of escaping '"' for sake of the ability to do copy&paste from
xtables-translate without the shell removing those "" again,
unconditionally put the entire command line (except "nft") in ''.

This allows to get rid of all quotes logic.  This logic was also
incomplete because some shells also try to make sense of raw { or [.

Patch 3 changes xtables-test.py to feed the nft -f input
via stin without the shell.

Florian Westphal (3):
  xlate: get rid of escape_quotes
  extensions: change expected output for new format
  xlate-test: avoid shell entanglements

 extensions/generic.txlate            | 56 ++++++++++++++--------------
 extensions/libebt_dnat.txlate        |  6 +--
 extensions/libebt_ip.txlate          | 18 ++++-----
 extensions/libebt_ip6.txlate         | 20 +++++-----
 extensions/libebt_limit.txlate       |  6 +--
 extensions/libebt_log.c              |  8 +---
 extensions/libebt_log.txlate         | 10 ++---
 extensions/libebt_mark.txlate        |  8 ++--
 extensions/libebt_mark_m.txlate      | 10 ++---
 extensions/libebt_nflog.c            |  8 +---
 extensions/libebt_nflog.txlate       |  8 ++--
 extensions/libebt_pkttype.txlate     | 14 +++----
 extensions/libebt_snat.txlate        |  4 +-
 extensions/libebt_vlan.txlate        |  8 ++--
 extensions/libip6t_LOG.txlate        |  6 +--
 extensions/libip6t_MASQUERADE.txlate | 12 +++---
 extensions/libip6t_REJECT.txlate     |  6 +--
 extensions/libip6t_SNAT.txlate       |  8 ++--
 extensions/libip6t_ah.txlate         | 12 +++---
 extensions/libip6t_frag.txlate       | 12 +++---
 extensions/libip6t_hbh.txlate        |  4 +-
 extensions/libip6t_hl.txlate         |  4 +-
 extensions/libip6t_icmp6.txlate      |  6 +--
 extensions/libip6t_mh.txlate         |  4 +-
 extensions/libip6t_rt.txlate         | 10 ++---
 extensions/libipt_LOG.txlate         |  4 +-
 extensions/libipt_MASQUERADE.txlate  | 12 +++---
 extensions/libipt_REJECT.txlate      |  6 +--
 extensions/libipt_SNAT.txlate        | 10 ++---
 extensions/libipt_ah.txlate          |  6 +--
 extensions/libipt_icmp.txlate        |  8 ++--
 extensions/libipt_realm.txlate       |  8 ++--
 extensions/libipt_ttl.txlate         |  4 +-
 extensions/libxt_AUDIT.txlate        |  6 +--
 extensions/libxt_CLASSIFY.txlate     |  6 +--
 extensions/libxt_CONNMARK.txlate     | 16 ++++----
 extensions/libxt_DNAT.txlate         | 24 ++++++------
 extensions/libxt_DSCP.txlate         |  4 +-
 extensions/libxt_LOG.c               | 10 ++---
 extensions/libxt_MARK.txlate         | 18 ++++-----
 extensions/libxt_NFLOG.c             | 12 ++----
 extensions/libxt_NFLOG.txlate        | 10 ++---
 extensions/libxt_NFQUEUE.txlate      |  6 +--
 extensions/libxt_NOTRACK.txlate      |  2 +-
 extensions/libxt_REDIRECT.txlate     | 20 +++++-----
 extensions/libxt_SYNPROXY.txlate     |  2 +-
 extensions/libxt_TCPMSS.txlate       |  4 +-
 extensions/libxt_TEE.txlate          |  8 ++--
 extensions/libxt_TOS.txlate          | 18 ++++-----
 extensions/libxt_TRACE.txlate        |  2 +-
 extensions/libxt_addrtype.txlate     |  8 ++--
 extensions/libxt_cgroup.txlate       |  4 +-
 extensions/libxt_cluster.txlate      | 18 ++++-----
 extensions/libxt_comment.c           |  7 +---
 extensions/libxt_comment.txlate      |  6 +--
 extensions/libxt_connbytes.txlate    | 10 ++---
 extensions/libxt_connlabel.txlate    |  4 +-
 extensions/libxt_connlimit.txlate    | 16 ++++----
 extensions/libxt_connmark.txlate     | 10 ++---
 extensions/libxt_conntrack.txlate    | 40 ++++++++++----------
 extensions/libxt_cpu.txlate          |  4 +-
 extensions/libxt_dccp.txlate         | 14 +++----
 extensions/libxt_devgroup.txlate     | 12 +++---
 extensions/libxt_dscp.txlate         |  4 +-
 extensions/libxt_ecn.txlate          | 20 +++++-----
 extensions/libxt_esp.txlate          |  8 ++--
 extensions/libxt_hashlimit.txlate    |  4 +-
 extensions/libxt_helper.c            |  8 +---
 extensions/libxt_helper.txlate       |  4 +-
 extensions/libxt_ipcomp.txlate       |  4 +-
 extensions/libxt_iprange.txlate      | 10 ++---
 extensions/libxt_length.txlate       |  8 ++--
 extensions/libxt_limit.txlate        |  6 +--
 extensions/libxt_mac.txlate          |  4 +-
 extensions/libxt_mark.txlate         |  4 +-
 extensions/libxt_multiport.txlate    | 10 ++---
 extensions/libxt_owner.txlate        |  6 +--
 extensions/libxt_pkttype.txlate      |  6 +--
 extensions/libxt_policy.txlate       |  4 +-
 extensions/libxt_quota.txlate        |  4 +-
 extensions/libxt_rpfilter.txlate     |  6 +--
 extensions/libxt_sctp.txlate         | 30 +++++++--------
 extensions/libxt_statistic.txlate    |  4 +-
 extensions/libxt_tcp.txlate          | 22 +++++------
 extensions/libxt_tcpmss.txlate       |  8 ++--
 extensions/libxt_time.txlate         | 18 ++++-----
 extensions/libxt_udp.txlate          |  8 ++--
 include/xtables.h                    |  4 +-
 iptables/nft-bridge.c                |  2 -
 iptables/xtables-eb-translate.c      | 12 +++---
 iptables/xtables-translate.c         | 22 +++++------
 xlate-test.py                        | 18 ++++-----
 92 files changed, 443 insertions(+), 472 deletions(-)

-- 
2.38.1

