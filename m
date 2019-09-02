Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48976C3A5AA
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18CD621883
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ni6Vwzlt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfIBXGz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:06:55 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43578 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbfIBXGz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DfFStlnovg2PB9/NUiHGSusipJljR7m0gkrSlfMdPoM=; b=ni6Vwzltmmqqc448uLha2bOHAE
        KDsnPPfWiU0pBQdSwz6GwANDn3RxITVVTBiix+gS8vAwjOWO8/mQrTIs/RW80dJMgfjEn/iEYDcrM
        hm62xLC24Bv/e22DMpYeRz42dK59r+mFAR84k5WmKzaQ/kdmyIBrnOKd+ZNclC/Nd47MMxXOPtcU8
        0IG0ySmZRBVQ2lUaz5r1ng/VaQQLWWd2YsaMElKS97eoKZ4VmfYyeV3rhL8SwHL/UVjmI5Vb/+LT9
        fGljTVxzNuWZePIlgFeGTyx1REdfr8z61209OFL+vk/fr3jXKPHUDCqlAWmf9hPxtcaGs9sQlwN49
        aYD1dfBQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPO-0004la-ES; Tue, 03 Sep 2019 00:06:50 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 00/30] Add config option checks to netfilter headers.
Date:   Tue,  3 Sep 2019 00:06:20 +0100
Message-Id: <20190902230650.14621-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
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

This patch-series represents an attempt to provide a more comprehensive
solution by identifying the config options relevant to each header and
adding the appropriate conditionals to it where they do not already
exist.  In the majority of cases, a particular header is only included
by files tied to a particular config option, whether CONFIG_NETFILTER or
something more specific, and the whole of it can be wrapped in one
conditional.

For historical reasons, there are some headers which include their uapi
siblings and are themselves included elsewhere only for stuff in the
uapi headers.  Rather than change all those include directives, I have
chosen to leave the uapi include directives outside the conditionals.

The patch series is structured as follows.

  1-2)

    Addition of header guards.  The first of these, by Masahiro Yamada,
    is already in the nf tree; I've put it here to ensure that all the
    later changes apply cleanly on top of it.

  3-8)

    Some miscellaneous fixes.

  9-12)

    Addition and removal of include directives.

  13-14)

    Removal of some headers.

  15-17)

    Moving code between headers.

  18)

    Refactoring of some inline functions.

  19)

    Replacement of some `if defined(...)` instances with `if IS_ENABLED(...)`.

  20-26)

    Addition of conditionals to sections of code, mostly in headers.

  27-29)

    Addition of new config options for use in later conditionals.

  30)

    Wrapping of entire headers in one conditional each, removing
    existing ones wrapping smaller sections of code.

    I wasn't quite sure how to present this last change-set.  In the
    branch I've been using for development, I have the headers grouped
    into a commit per config-option, but that would have meant an addi-
    tional 44 patches, so I squashed them all before sending the series,
    although it has resulted in a 2,000-line patch that touches 78
    files.

Changes since v1:

  * fixes for build errors reported by the kbuild test robot;
  * corrected placement of new NF_TPROXY config option.

Jeremy Sowden (29):
  netfilter: add include guard to nf_conntrack_labels.h.
  netfilter: fix include guard comment.
  netfilter: add GPL-2.0 SPDX ID's to a couple of headers.
  netfilter: remove trailing white-space.
  netfilter: fix Kconfig formatting error.
  netfilter: remove stray semicolons.
  netfilter: remove unused function declarations.
  netfilter: remove unused includes.
  netfilter: include the right header in nf_conntrack_zones.h.
  netfilter: fix inclusions of <linux/netfilter/nf_nat.h>.
  netfilter: added missing includes.
  netfilter: inline three headers.
  netfilter: remove superfluous header.
  netfilter: move inline function to a more appropriate header.
  netfilter: move code between synproxy headers.
  netfilter: move struct definition function to a more appropriate
    header.
  netfilter: use consistent style when defining inline functions in
    nf_conntrack_ecache.h.
  netfilter: replace defined(CONFIG...) || defined(CONFIG...MODULE) with
    IS_ENABLED(CONFIG...).
  netfilter: wrap union nf_conntrack_proto members in
    CONFIG_NF_CT_PROTO_* check.
  netfilter: wrap inline synproxy function in CONFIG_NETFILTER_SYNPROXY
    check.
  netfilter: wrap inline timeout function in CONFIG_NETFILTER_TIMEOUT
    check.
  netfilter: wrap some nat-related conntrack code in a CONFIG_NF_NAT
    check.
  netfilter: wrap some ipv6 tables code in a CONFIG_NF_TABLES_IPV6
    check.
  netfilter: wrap some conntrack code in a CONFIG_NF_CONNTRACK check.
  netfilter: add CONFIG_NETFILTER check to linux/netfilter.h.
  netfilter: add NF_TPROXY config option.
  netfilter: add IP_SET_BITMAP config option.
  netfilter: add IP_SET_HASH config option.
  netfilter: wrap headers in CONFIG checks.

Masahiro Yamada (1):
  netfilter: add include guard to nf_conntrack_h323_types.h

 include/linux/netfilter.h                     | 16 +++-
 include/linux/netfilter/ipset/ip_set.h        |  7 +-
 include/linux/netfilter/ipset/ip_set_bitmap.h |  4 +
 .../linux/netfilter/ipset/ip_set_getport.h    |  6 +-
 include/linux/netfilter/ipset/ip_set_hash.h   |  3 +
 include/linux/netfilter/ipset/ip_set_list.h   |  3 +
 include/linux/netfilter/ipset/pfxlen.h        |  4 +
 include/linux/netfilter/nf_conntrack_amanda.h |  6 ++
 include/linux/netfilter/nf_conntrack_common.h |  4 +
 include/linux/netfilter/nf_conntrack_dccp.h   |  4 +
 include/linux/netfilter/nf_conntrack_ftp.h    |  8 +-
 include/linux/netfilter/nf_conntrack_h323.h   |  4 +
 .../linux/netfilter/nf_conntrack_h323_asn1.h  |  4 +
 .../linux/netfilter/nf_conntrack_h323_types.h |  9 ++
 include/linux/netfilter/nf_conntrack_irc.h    |  4 +
 include/linux/netfilter/nf_conntrack_pptp.h   |  4 +
 .../linux/netfilter/nf_conntrack_proto_gre.h  |  6 ++
 include/linux/netfilter/nf_conntrack_sane.h   |  5 +
 include/linux/netfilter/nf_conntrack_sctp.h   |  5 +
 include/linux/netfilter/nf_conntrack_sip.h    |  4 +
 include/linux/netfilter/nf_conntrack_snmp.h   |  4 +
 include/linux/netfilter/nf_conntrack_tcp.h    |  3 +
 include/linux/netfilter/nf_conntrack_tftp.h   |  4 +
 .../netfilter/nf_conntrack_zones_common.h     |  8 ++
 include/linux/netfilter/nfnetlink.h           |  7 +-
 include/linux/netfilter/nfnetlink_acct.h      |  6 ++
 include/linux/netfilter/nfnetlink_osf.h       |  4 +
 include/linux/netfilter/x_tables.h            | 15 ++-
 include/linux/netfilter/xt_hashlimit.h        | 11 ---
 include/linux/netfilter/xt_physdev.h          |  8 --
 include/linux/netfilter_arp/arp_tables.h      |  8 +-
 include/linux/netfilter_bridge/ebt_802_3.h    | 12 ---
 include/linux/netfilter_bridge/ebtables.h     | 10 +-
 include/linux/netfilter_ipv4.h                |  7 +-
 include/linux/netfilter_ipv4/ip_tables.h      | 17 ++--
 include/linux/netfilter_ipv6.h                | 31 ++++--
 include/linux/netfilter_ipv6/ip6_tables.h     | 28 ++----
 include/net/netfilter/br_netfilter.h          | 14 +--
 .../net/netfilter/ipv4/nf_conntrack_ipv4.h    |  4 +
 include/net/netfilter/ipv4/nf_defrag_ipv4.h   |  4 +
 include/net/netfilter/ipv4/nf_dup_ipv4.h      |  4 +
 include/net/netfilter/ipv4/nf_reject.h        |  4 +
 .../net/netfilter/ipv6/nf_conntrack_icmpv6.h  | 21 -----
 .../net/netfilter/ipv6/nf_conntrack_ipv6.h    |  4 +
 include/net/netfilter/ipv6/nf_defrag_ipv6.h   |  4 +
 include/net/netfilter/ipv6/nf_dup_ipv6.h      |  4 +
 include/net/netfilter/ipv6/nf_reject.h        |  4 +
 include/net/netfilter/nf_conntrack.h          | 21 ++---
 include/net/netfilter/nf_conntrack_acct.h     | 19 ++--
 include/net/netfilter/nf_conntrack_bridge.h   | 11 +--
 include/net/netfilter/nf_conntrack_core.h     | 22 +++--
 include/net/netfilter/nf_conntrack_count.h    |  4 +
 include/net/netfilter/nf_conntrack_ecache.h   | 94 ++++++++++++-------
 include/net/netfilter/nf_conntrack_expect.h   |  8 +-
 include/net/netfilter/nf_conntrack_extend.h   |  8 +-
 include/net/netfilter/nf_conntrack_helper.h   |  6 ++
 include/net/netfilter/nf_conntrack_l4proto.h  |  7 +-
 include/net/netfilter/nf_conntrack_labels.h   | 15 ++-
 include/net/netfilter/nf_conntrack_seqadj.h   |  4 +
 include/net/netfilter/nf_conntrack_synproxy.h | 43 +--------
 include/net/netfilter/nf_conntrack_timeout.h  |  8 ++
 .../net/netfilter/nf_conntrack_timestamp.h    |  6 +-
 include/net/netfilter/nf_conntrack_tuple.h    |  8 +-
 include/net/netfilter/nf_conntrack_zones.h    |  3 +-
 include/net/netfilter/nf_dup_netdev.h         |  4 +
 include/net/netfilter/nf_flow_table.h         | 10 +-
 include/net/netfilter/nf_log.h                |  4 +
 include/net/netfilter/nf_nat.h                | 26 ++---
 include/net/netfilter/nf_nat_helper.h         |  5 +
 include/net/netfilter/nf_nat_masquerade.h     |  5 +
 include/net/netfilter/nf_nat_redirect.h       |  4 +
 include/net/netfilter/nf_queue.h              |  8 +-
 include/net/netfilter/nf_reject.h             |  4 +
 include/net/netfilter/nf_socket.h             |  4 +
 include/net/netfilter/nf_synproxy.h           | 46 ++++++++-
 include/net/netfilter/nf_tables.h             | 17 +---
 include/net/netfilter/nf_tables_core.h        |  5 +
 include/net/netfilter/nf_tables_ipv4.h        |  4 +
 include/net/netfilter/nf_tables_ipv6.h        | 10 +-
 include/net/netfilter/nf_tables_offload.h     |  4 +
 include/net/netfilter/nf_tproxy.h             |  4 +
 include/net/netfilter/nft_fib.h               |  5 +
 include/net/netfilter/nft_meta.h              |  4 +
 include/net/netfilter/nft_reject.h            |  4 +
 include/net/netfilter/xt_rateest.h            |  4 +
 net/bridge/netfilter/ebt_802_3.c              |  8 +-
 net/bridge/netfilter/nf_conntrack_bridge.c    | 15 ++-
 net/ipv4/netfilter/Kconfig                    |  9 +-
 net/ipv4/netfilter/Makefile                   |  2 +-
 net/ipv6/netfilter.c                          |  4 +-
 net/ipv6/netfilter/Kconfig                    |  1 +
 net/ipv6/netfilter/ip6t_ipv6header.c          |  4 +-
 net/ipv6/netfilter/nf_log_ipv6.c              |  4 +-
 net/ipv6/netfilter/nf_socket_ipv6.c           |  1 -
 net/netfilter/Kconfig                         | 11 ++-
 net/netfilter/Makefile                        |  2 +-
 net/netfilter/ipset/Kconfig                   | 21 +++++
 net/netfilter/nf_conntrack_core.c             |  4 +
 net/netfilter/nf_conntrack_ecache.c           |  1 +
 net/netfilter/nf_conntrack_expect.c           |  2 +
 net/netfilter/nf_conntrack_helper.c           |  5 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c     |  1 -
 net/netfilter/nf_conntrack_timeout.c          |  1 +
 net/netfilter/nf_flow_table_core.c            |  1 +
 net/netfilter/nf_nat_core.c                   |  6 +-
 net/netfilter/nft_chain_filter.c              |  4 +
 net/netfilter/nft_flow_offload.c              |  3 +-
 net/netfilter/xt_connlimit.c                  |  2 +
 net/netfilter/xt_hashlimit.c                  |  7 +-
 net/netfilter/xt_physdev.c                    |  6 +-
 net/sched/act_ct.c                            |  2 +-
 111 files changed, 628 insertions(+), 327 deletions(-)
 delete mode 100644 include/linux/netfilter/xt_hashlimit.h
 delete mode 100644 include/linux/netfilter/xt_physdev.h
 delete mode 100644 include/linux/netfilter_bridge/ebt_802_3.h
 delete mode 100644 include/net/netfilter/ipv6/nf_conntrack_icmpv6.h

-- 
2.23.0.rc1

