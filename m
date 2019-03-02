Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37620C43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0955B2087E
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfCBSfJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:35:09 -0500
Received: from mail.us.es ([193.147.175.20]:35718 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfCBSfJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:35:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F0B871361A8
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA4C6DA86A
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CF7A4DA864; Sat,  2 Mar 2019 19:35:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFF74DA844;
        Sat,  2 Mar 2019 19:35:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:35:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 536014265A2F;
        Sat,  2 Mar 2019 19:35:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/29] Netfilter/IPVS updates for net-next
Date:   Sat,  2 Mar 2019 19:34:28 +0100
Message-Id: <20190302183457.3079-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS updates for net-next:

1) Add .release_ops to properly unroll .select_ops, use it from nft_compat.
   After this change, we can remove list of extensions too to simplify this
   codebase.

2) Update amanda conntrack helper to support v3.4, from Florian Tham.

3) Get rid of the obsolete BUGPRINT macro in ebtables, from
   Florian Westphal.

4) Merge IPv4 and IPv6 masquerading infrastructure into one single module.
   From Florian Westphal.

5) Patchset to remove nf_nat_l3proto structure to get rid of
   indirections, from Florian Westphal.

6) Skip unnecessary conntrack timeout updates in case the value is
   still the same, also from Florian Westphal.

7) Remove unnecessary 'fall through' comments in empty switch cases,
   from Li RongQing.

8) Fix lookup to fixed size hashtable sets on big endian with 32-bit keys.

9) Incorrect logic to deactivate path of fixed size hashtable sets,
   element was being tested to self.

10) Remove nft_hash_key(), the bitmap set is always selected for 16-bit
    keys.

11) Use boolean whenever possible in IPVS codebase, from Andrea Claudi.

12) Enter close state in conntrack if RST matches exact sequence number,
    from Florian Westphal.

13) Initialize dst_cache in tunnel extension, from wenxu.

14) Pass protocol as u16 to xt_check_match and xt_check_target, from
    Li RongQing.

15) SCTP header is granted to be in a linear area from IPVS NAT handler,
    from Xin Long.

16) Don't steal packets coming from slave VRF device from the
    ip_sabotage_in() path, from David Ahern.

17) Fix unsafe update of basechain stats, from Li RongQing.

18) Make sure CONNTRACK_LOCKS is power of 2 to let compiler optimize
    modulo operation as bitwise AND, from Li RongQing.

19) Use device_attribute instead of internal definition in the IDLETIMER
    target, from Sami Tolvanen.

20) Merge redir, masq and IPv4/IPv6 NAT chain types, from Florian Westphal.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit ff8285f81822dc8f528b36b6c5c8ab132367e92d:

  net: sched: pie: fix 64-bit division (2019-02-26 18:55:38 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to db8ab38880e06dedbfc879e75f5b0ddc495f4eb6:

  netfilter: nf_tables: merge ipv4 and ipv6 nat chain types (2019-03-01 14:36:59 +0100)

----------------------------------------------------------------
Andrea Claudi (1):
      ipvs: change some data types from int to bool

David Ahern (1):
      netfilter: bridge: Don't sabotage nf_hook calls for an l3mdev slave

Florian Tham (1):
      netfilter: nf_conntrack_amanda: add support for STATE streams

Florian Westphal (15):
      netfilter: ebtables: remove BUGPRINT messages
      netfilter: nat: merge ipv4 and ipv6 masquerade functionality
      netfilter: nat: move nlattr parse and xfrm session decode to core
      netfilter: nat: merge nf_nat_ipv4,6 into nat core
      netfilter: nat: remove nf_nat_l4proto.h
      netfilter: nat: remove l3 manip_pkt hook
      netfilter: nat: remove csum_update hook
      netfilter: nat: remove csum_recalc hook
      netfilter: nat: remove l3proto struct
      netfilter: nat: remove nf_nat_l3proto.h and nf_nat_core.h
      netfilter: conntrack: avoid same-timeout update
      netfilter: conntrack: tcp: only close if RST matches exact sequence
      netfilter: nf_tables: nat: merge nft_redir protocol specific modules
      netfilter: nf_tables: nat: merge nft_masq protocol specific modules
      netfilter: nf_tables: merge ipv4 and ipv6 nat chain types

Li RongQing (4):
      netfilter: remove unneeded switch fall-through
      netfilter: convert the proto argument from u8 to u16
      netfilter: nf_tables: check the result of dereferencing base_chain->stats
      netfilter: nf_conntrack: ensure that CONNTRACK_LOCKS is power of 2

Pablo Neira Ayuso (4):
      netfilter: nft_compat: use .release_ops and remove list of extension
      netfilter: nft_set_hash: fix lookups with fixed size hash on big endian
      netfilter: nft_set_hash: bogus element self comparison from deactivation path
      netfilter: nft_set_hash: remove nft_hash_key()

Sami Tolvanen (1):
      netfilter: xt_IDLETIMER: fix sysfs callback function type

Xin Long (1):
      ipvs: get sctphdr by sctphoff in sctp_csum_check

wenxu (1):
      netfilter: nft_tunnel: Add dst_cache support

 include/linux/netfilter/x_tables.h                 |   4 +-
 include/net/netfilter/nf_conntrack.h               |  10 +-
 include/net/netfilter/nf_nat.h                     |  45 +-
 include/net/netfilter/nf_nat_core.h                |  29 -
 include/net/netfilter/nf_nat_l3proto.h             |  50 --
 include/net/netfilter/nf_nat_l4proto.h             |  16 -
 include/net/netfilter/nf_tables.h                  |   3 +
 include/net/netfilter/nft_masq.h                   |  22 -
 include/net/netfilter/nft_redir.h                  |  22 -
 net/bridge/br_netfilter_hooks.c                    |   3 +-
 net/bridge/netfilter/ebtables.c                    | 137 ++--
 net/ipv4/netfilter/Kconfig                         |  50 +-
 net/ipv4/netfilter/Makefile                        |   7 -
 net/ipv4/netfilter/iptable_nat.c                   |   8 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c           | 388 -----------
 net/ipv4/netfilter/nft_chain_nat_ipv4.c            |  87 ---
 net/ipv4/netfilter/nft_masq_ipv4.c                 |  90 ---
 net/ipv4/netfilter/nft_redir_ipv4.c                |  82 ---
 net/ipv6/netfilter/Kconfig                         |  48 +-
 net/ipv6/netfilter/Makefile                        |   7 -
 net/ipv6/netfilter/ip6table_nat.c                  |   8 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c           | 427 ------------
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c        | 240 -------
 net/ipv6/netfilter/nft_chain_nat_ipv6.c            |  85 ---
 net/ipv6/netfilter/nft_masq_ipv6.c                 |  91 ---
 net/ipv6/netfilter/nft_redir_ipv6.c                |  83 ---
 net/netfilter/Kconfig                              |  14 +-
 net/netfilter/Makefile                             |   3 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |  12 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |   4 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   7 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   8 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |   8 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   4 +-
 net/netfilter/nf_conntrack_amanda.c                |   9 +-
 net/netfilter/nf_conntrack_core.c                  |  11 +-
 net/netfilter/nf_conntrack_netlink.c               |   2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  50 +-
 net/netfilter/nf_nat_core.c                        | 196 ++++--
 net/netfilter/nf_nat_helper.c                      |  15 +-
 .../nf_nat_masquerade.c}                           | 208 +++++-
 net/netfilter/nf_nat_proto.c                       | 744 ++++++++++++++++++++-
 net/netfilter/nf_tables_api.c                      |   7 +-
 net/netfilter/nf_tables_core.c                     |  15 +-
 net/netfilter/nft_chain_nat.c                      | 108 +++
 net/netfilter/nft_compat.c                         | 281 ++------
 net/netfilter/nft_masq.c                           | 180 ++++-
 net/netfilter/nft_nat.c                            |   2 -
 net/netfilter/nft_redir.c                          | 154 ++++-
 net/netfilter/nft_set_hash.c                       |  38 +-
 net/netfilter/nft_tunnel.c                         |   7 +
 net/netfilter/x_tables.c                           |   4 +-
 net/netfilter/xt_IDLETIMER.c                       |  14 +-
 net/netfilter/xt_nat.c                             |   2 +-
 net/openvswitch/Kconfig                            |   2 -
 net/openvswitch/conntrack.c                        |  12 +-
 tools/testing/selftests/net/config                 |   3 +-
 57 files changed, 1747 insertions(+), 2419 deletions(-)
 delete mode 100644 include/net/netfilter/nf_nat_core.h
 delete mode 100644 include/net/netfilter/nf_nat_l3proto.h
 delete mode 100644 include/net/netfilter/nf_nat_l4proto.h
 delete mode 100644 include/net/netfilter/nft_masq.h
 delete mode 100644 include/net/netfilter/nft_redir.h
 delete mode 100644 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
 delete mode 100644 net/ipv4/netfilter/nft_chain_nat_ipv4.c
 delete mode 100644 net/ipv4/netfilter/nft_masq_ipv4.c
 delete mode 100644 net/ipv4/netfilter/nft_redir_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
 delete mode 100644 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
 delete mode 100644 net/ipv6/netfilter/nft_chain_nat_ipv6.c
 delete mode 100644 net/ipv6/netfilter/nft_masq_ipv6.c
 delete mode 100644 net/ipv6/netfilter/nft_redir_ipv6.c
 rename net/{ipv4/netfilter/nf_nat_masquerade_ipv4.c => netfilter/nf_nat_masquerade.c} (51%)
 create mode 100644 net/netfilter/nft_chain_nat.c

