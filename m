Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278E9C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEB862075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfDORAg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:36 -0400
Received: from mail.us.es ([193.147.175.20]:50418 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbfDORAg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F01B31C442A
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA991DA708
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CFDEEDA704; Mon, 15 Apr 2019 19:00:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B164CDA708;
        Mon, 15 Apr 2019 19:00:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 851484265A31;
        Mon, 15 Apr 2019 19:00:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/22] Netfilter/IPVS updates for net-next
Date:   Mon, 15 Apr 2019 19:00:06 +0200
Message-Id: <20190415170028.3470-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

The following patchset contains Netfilter updates for net-next:

1) Remove the broute pseudo hook, implement this from the bridge
   prerouting hook instead. Now broute becomes real table in ebtables,
   from Florian Westphal. This also includes a size reduction patch for the
   bridge control buffer area via squashing boolean into bitfields and
   a selftest.

2) Add OS passive fingerprint version matching, from Fernando Fernandez.

3) Support for gue encapsulation for IPVS, from Jacky Hu.

4) Add support for NAT to the inet family, from Florian Westphal.
   This includes support for masquerade, redirect and nat extensions.

5) Skip interface lookup in flowtable, use device in the dst object.

6) Add jiffies64_to_msecs() and use it, from Li RongQing.

7) Remove unused parameter in nf_tables_set_desc_parse(), from Colin Ian King.

8) Statify several functions, patches from YueHaibing and Florian Westphal.

9) Add an optimized version of nf_inet_addr_cmp(), from Li RongQing.

10) Merge route extension to core, also from Florian.

11) Use IS_ENABLED(CONFIG_NF_NAT) instead of NF_NAT_NEEDED, from Florian.

12) Merge ip/ip6 masquerade extensions, from Florian. This includes
    netdevice notifier unification.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit ed514fc5615d7688b7c227a76863e98a92fb0d54:

  cxgb4: Don't return EAGAIN when TCAM is full. (2019-04-08 10:01:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to dc2f4189dcd2c87e211d30d9524ae8ebe19af577:

  bridge: only include nf_queue.h if needed (2019-04-15 18:47:36 +0200)

----------------------------------------------------------------
Colin Ian King (1):
      netfilter: nf_tables: remove unused parameter ctx

Fernando Fernandez Mancera (1):
      netfilter: nft_osf: Add version option support

Florian Westphal (14):
      netfilter: nat: add inet family nat support
      netfilter: nf_tables: merge route type into core
      netfilter: replace NF_NAT_NEEDED with IS_ENABLED(CONFIG_NF_NAT)
      netfilter: nft_masq: add inet support
      netfilter: nft_redir: add inet support
      kselftests: extend nft_nat with inet family based nat hooks
      netfilter: make two functions static
      netfilter: nf_nat: merge ip/ip6 masquerade headers
      netfilter: x_tables: merge ip and ipv6 masquerade modules
      netfilter: nf_nat_masquerade: unify ipv4/6 notifier registration
      selftests: netfilter: add ebtables broute test case
      bridge: reduce size of input cb to 16 bytes
      bridge: netfilter: unroll NF_HOOK helper in bridge input path
      bridge: broute: make broute a real ebtables table

Jacky Hu (1):
      ipvs: allow tunneling with gue encapsulation

Li RongQing (2):
      time: Introduce jiffies64_to_msecs()
      netfilter: optimize nf_inet_addr_cmp

Pablo Neira Ayuso (1):
      netfilter: nf_flowtable: skip device lookup from interface index

Stephen Rothwell (1):
      bridge: only include nf_queue.h if needed

YueHaibing (1):
      netfilter: nft_redir: Make nft_redir_dump static

 include/linux/if_bridge.h                          |   3 -
 include/linux/jiffies.h                            |   1 +
 include/linux/netfilter.h                          |   9 +-
 include/linux/netfilter/nfnetlink_osf.h            |  11 +-
 include/linux/netfilter/x_tables.h                 |   1 -
 include/linux/netfilter_ipv6.h                     |  15 ++
 include/net/ip_vs.h                                |   5 +
 include/net/netfilter/ipv4/nf_nat_masquerade.h     |  15 --
 include/net/netfilter/ipv6/nf_nat_masquerade.h     |  11 --
 include/net/netfilter/nf_conntrack_expect.h        |   2 +-
 include/net/netfilter/nf_nat.h                     |   7 +-
 include/net/netfilter/nf_nat_masquerade.h          |  19 +++
 include/net/netfilter/nf_queue.h                   |   3 +
 include/net/netfilter/nf_tables.h                  |   4 +-
 include/uapi/linux/ip_vs.h                         |  11 ++
 include/uapi/linux/netfilter/nf_tables.h           |   6 +
 kernel/time/time.c                                 |  10 ++
 net/bridge/br_arp_nd_proxy.c                       |  18 +--
 net/bridge/br_input.c                              |  77 +++++++---
 net/bridge/br_private.h                            |  15 +-
 net/bridge/netfilter/ebtable_broute.c              |  63 +++++---
 net/bridge/netfilter/ebtables.c                    |   7 +-
 net/ipv4/netfilter/Kconfig                         |  20 +--
 net/ipv4/netfilter/Makefile                        |   2 -
 net/ipv4/netfilter/nft_chain_route_ipv4.c          |  89 -----------
 net/ipv6/netfilter/Kconfig                         |  19 +--
 net/ipv6/netfilter/Makefile                        |   2 -
 net/ipv6/netfilter/ip6t_MASQUERADE.c               |  81 ----------
 net/ipv6/netfilter/nft_chain_route_ipv6.c          |  91 -----------
 net/netfilter/Kconfig                              |  19 ++-
 net/netfilter/Makefile                             |   4 +-
 net/netfilter/core.c                               |   1 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |  35 ++++-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  84 +++++++++-
 net/netfilter/nf_conntrack_expect.c                |   2 +-
 net/netfilter/nf_conntrack_netlink.c               |  16 +-
 net/netfilter/nf_conntrack_sip.c                   |   2 +-
 net/netfilter/nf_flow_table_ip.c                   |  10 +-
 net/netfilter/nf_internals.h                       |   3 -
 net/netfilter/nf_nat_core.c                        |  16 +-
 net/netfilter/nf_nat_masquerade.c                  | 104 +++++--------
 net/netfilter/nf_nat_proto.c                       |  59 ++++---
 net/netfilter/nf_queue.c                           |   1 +
 net/netfilter/nf_tables_api.c                      |  16 +-
 net/netfilter/nfnetlink_osf.c                      |  14 +-
 net/netfilter/nft_chain_nat.c                      |  36 +++++
 net/netfilter/nft_chain_route.c                    | 169 +++++++++++++++++++++
 net/netfilter/nft_masq.c                           |  83 ++++++++--
 net/netfilter/nft_nat.c                            |  58 ++++++-
 net/netfilter/nft_osf.c                            |  30 +++-
 net/netfilter/nft_redir.c                          |  63 +++++++-
 net/netfilter/x_tables.c                           |   3 +-
 .../ipt_MASQUERADE.c => netfilter/xt_MASQUERADE.c} |  84 ++++++----
 net/openvswitch/conntrack.c                        |  18 +--
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../testing/selftests/netfilter/bridge_brouter.sh  | 146 ++++++++++++++++++
 tools/testing/selftests/netfilter/nft_nat.sh       | 130 +++++++++++-----
 57 files changed, 1187 insertions(+), 638 deletions(-)
 delete mode 100644 include/net/netfilter/ipv4/nf_nat_masquerade.h
 delete mode 100644 include/net/netfilter/ipv6/nf_nat_masquerade.h
 create mode 100644 include/net/netfilter/nf_nat_masquerade.h
 delete mode 100644 net/ipv4/netfilter/nft_chain_route_ipv4.c
 delete mode 100644 net/ipv6/netfilter/ip6t_MASQUERADE.c
 delete mode 100644 net/ipv6/netfilter/nft_chain_route_ipv6.c
 create mode 100644 net/netfilter/nft_chain_route.c
 rename net/{ipv4/netfilter/ipt_MASQUERADE.c => netfilter/xt_MASQUERADE.c} (52%)
 create mode 100755 tools/testing/selftests/netfilter/bridge_brouter.sh
