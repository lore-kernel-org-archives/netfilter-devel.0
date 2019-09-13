Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5ABC4CEC8
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDEE820CC7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="dnllXEjz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbfIMIN0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:13:26 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60594 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbfIMINY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KgfaFTpd3/dacxLwUXFeaNOMNfnxFrDtCLSuEGTLs6A=; b=dnllXEjzPI53OiI5x3JkCi+AOn
        ZLqjjyjaLA0fYjFDgwcQI/KX+pPMPHMseHBoA9ap1QvbE2T11AUC1WWiTCTxWQ9XPSpPNJZKzc1uM
        nbG0FGAvgwMPs0T4Zk3383jtHCUs/hmjjR88btYMc2UTn7t5PtOaSNHr1bCs0gUGqfln57dE7gSBw
        YnXnvq33Cd+z4a+O42VeW7OmMLvFaUtMiDKZ5Od5JeaUSIE1wLe+pkCx2lo+CpxdPKh8sLtXd+ZPg
        9n9tB9LZDbVcThMa3Ly7rW49ki3I0GpmjgpXgcwHHGFRvZo16MAdhyoD3ONexsoH0NUKF8/A8YwvV
        NwHcih9A==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghj-0005yL-1C; Fri, 13 Sep 2019 09:13:19 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 00/18] Remove config option checks from netfilter headers.
Date:   Fri, 13 Sep 2019 09:13:00 +0100
Message-Id: <20190913081318.16071-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In a previous patch-series [0], I removed all netfilter headers from the
blacklist of headers which could not be compiled standalone.  I did so
by fixing the specific compilation failures of the headers in the list,
usually by adding a preprocessor conditional to check whether a particu-
lar config option was enabled and disable some function definition or
struct member which depended on that option.  While this was effective,
it was not wholly satisfactory since it left a scattering of seemingly
random ifdefs throughout the headers.

0 - https://lore.kernel.org/netfilter-devel/20190813113657.GB4840@azazel.net/T/

The reason why these ad-hoc conditionals were necessary is that there
were inconsistencies in how existing checks were used to disable code
when particular options were turned off.  For example, a header A.h
might define a struct S which was only available if a particular config
option C was enabled, but A.h might be included by header B.h, which
defined a struct T with a struct S member without checking for C.  If
A.h and B.h were included in X.c, which was only compiled if C was
enabled, everything worked as expected; however, trying to compile B.h
standalone when C was disabled would result in a compilation failure.

In the previous versions of this patch-series, I attempted to provide a
more comprehensive solution by identifying the config options relevant
to each header and adding the appropriate conditionals to it where they
do not already exist.  However, based on feedback and looking at some
other examples, it became apparent that a better approach was to
endeavour to fix the inconsistencies that made the new config checks
necessary, with a view to removing as many of them as possible.

Changes since v2:

  * squashed several of the earlier patches;
  * dropped the SPDX patch;
  * dropped most of the later patches adding config checks;
  * added a patch fixing the paramter type of a stub function.
  * added a number of new patches removing config checks.

Changes since v1:

  * fixes for build errors reported by the kbuild test robot;
  * corrected placement of new NF_TPROXY config option.

Jeremy Sowden (18):
  netfilter: fix include guards.
  netfilter: fix coding-style errors.
  netfilter: remove unused function declarations.
  netfilter: inline three headers.
  netfilter: update include directives.
  netfilter: remove nf_conntrack_icmpv6.h header.
  netfilter: move inline function to a more appropriate header.
  netfilter: move code between synproxy headers.
  netfilter: move struct definition function to a more appropriate
    header.
  netfilter: use consistent style when defining inline functions in
    nf_conntrack_ecache.h.
  netfilter: replace defined(CONFIG...) || defined(CONFIG...MODULE) with
    IS_ENABLED(CONFIG...).
  netfilter: wrap two inline functions in config checks.
  netfilter: update stub br_nf_pre_routing_ipv6 parameter to `void
    *priv`.
  netfilter: move nf_conntrack code to linux/nf_conntrack_common.h.
  netfilter: remove CONFIG_NF_CONNTRACK check from nf_conntrack_acct.h.
  netfilter: remove CONFIG_NETFILTER checks from headers.
  netfilter: remove CONFIG_NF_CONNTRACK checks from
    nf_conntrack_zones.h.
  netfilter: remove two unused functions from nf_conntrack_timestamp.h.

 include/linux/netfilter.h                     |  4 +-
 .../linux/netfilter/ipset/ip_set_getport.h    |  2 +-
 include/linux/netfilter/nf_conntrack_common.h | 20 +++++
 include/linux/netfilter/x_tables.h            |  8 +-
 include/linux/netfilter/xt_hashlimit.h        | 11 ---
 include/linux/netfilter/xt_physdev.h          |  8 --
 include/linux/netfilter_arp/arp_tables.h      |  2 -
 include/linux/netfilter_bridge.h              |  7 ++
 include/linux/netfilter_bridge/ebt_802_3.h    | 12 ---
 include/linux/netfilter_bridge/ebtables.h     |  3 +-
 include/linux/netfilter_ipv4/ip_tables.h      |  9 +-
 include/linux/netfilter_ipv6.h                | 28 +++++--
 include/linux/netfilter_ipv6/ip6_tables.h     | 20 +----
 include/linux/skbuff.h                        | 32 ++++---
 include/net/netfilter/br_netfilter.h          |  4 +-
 .../net/netfilter/ipv6/nf_conntrack_icmpv6.h  | 21 -----
 include/net/netfilter/nf_conntrack.h          | 25 ++----
 include/net/netfilter/nf_conntrack_acct.h     |  4 +-
 include/net/netfilter/nf_conntrack_bridge.h   | 11 +--
 include/net/netfilter/nf_conntrack_core.h     |  8 +-
 include/net/netfilter/nf_conntrack_ecache.h   | 84 +++++++++++--------
 include/net/netfilter/nf_conntrack_expect.h   |  2 +-
 include/net/netfilter/nf_conntrack_extend.h   |  2 +-
 include/net/netfilter/nf_conntrack_l4proto.h  | 16 ++--
 include/net/netfilter/nf_conntrack_labels.h   | 11 ++-
 include/net/netfilter/nf_conntrack_synproxy.h | 41 +--------
 include/net/netfilter/nf_conntrack_timeout.h  |  4 +
 .../net/netfilter/nf_conntrack_timestamp.h    | 16 ----
 include/net/netfilter/nf_conntrack_tuple.h    |  4 +-
 include/net/netfilter/nf_conntrack_zones.h    |  6 +-
 include/net/netfilter/nf_flow_table.h         |  6 +-
 include/net/netfilter/nf_nat.h                | 21 ++---
 include/net/netfilter/nf_nat_masquerade.h     |  1 +
 include/net/netfilter/nf_queue.h              |  4 -
 include/net/netfilter/nf_synproxy.h           | 44 +++++++++-
 include/net/netfilter/nf_tables.h             |  8 --
 net/bridge/netfilter/ebt_802_3.c              |  8 +-
 net/bridge/netfilter/nf_conntrack_bridge.c    | 15 ++--
 net/ipv4/netfilter/Kconfig                    |  8 +-
 net/ipv4/netfilter/Makefile                   |  2 +-
 net/ipv6/netfilter.c                          |  4 +-
 net/ipv6/netfilter/ip6t_ipv6header.c          |  4 +-
 net/ipv6/netfilter/nf_log_ipv6.c              |  4 +-
 net/ipv6/netfilter/nf_socket_ipv6.c           |  1 -
 net/netfilter/Kconfig                         |  8 +-
 net/netfilter/Makefile                        |  2 +-
 net/netfilter/nf_conntrack_ecache.c           |  1 +
 net/netfilter/nf_conntrack_expect.c           |  2 +
 net/netfilter/nf_conntrack_helper.c           |  5 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c     |  1 -
 net/netfilter/nf_conntrack_standalone.c       |  1 -
 net/netfilter/nf_conntrack_timeout.c          |  1 +
 net/netfilter/nf_flow_table_core.c            |  1 +
 net/netfilter/nf_nat_core.c                   |  6 +-
 net/netfilter/nft_flow_offload.c              |  3 +-
 net/netfilter/xt_connlimit.c                  |  2 +
 net/netfilter/xt_hashlimit.c                  |  7 +-
 net/netfilter/xt_physdev.c                    |  5 +-
 net/sched/act_ct.c                            |  2 +-
 59 files changed, 265 insertions(+), 337 deletions(-)
 delete mode 100644 include/linux/netfilter/xt_hashlimit.h
 delete mode 100644 include/linux/netfilter/xt_physdev.h
 delete mode 100644 include/linux/netfilter_bridge/ebt_802_3.h
 delete mode 100644 include/net/netfilter/ipv6/nf_conntrack_icmpv6.h

-- 
2.23.0

