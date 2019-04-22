Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852E0C10F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55A78206A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfDVUsJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:48:09 -0400
Received: from mail.us.es ([193.147.175.20]:46676 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727601AbfDVUsJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 16:48:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0052B443822
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E498BDA703
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DA29FDA709; Mon, 22 Apr 2019 22:48:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B42C5DA703;
        Mon, 22 Apr 2019 22:48:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 22:48:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 849654265A32;
        Mon, 22 Apr 2019 22:48:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/10] Netfilter/IPVS fixes for net
Date:   Mon, 22 Apr 2019 22:47:51 +0200
Message-Id: <20190422204801.26321-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for your net tree:

1) Add a selftest for icmp packet too big errors with conntrack, from
   Florian Westphal.

2) Validate inner header in ICMP error message does not lie to us
   in conntrack, also from Florian.

3) Initialize ct->timeout to calm down KASAN, from Alexander Potapenko.

4) Skip ICMP error messages from tunnels in IPVS, from Julian Anastasov.

5) Use a hash to expose conntrack and expectation ID, from Florian Westphal.

6) Prevent shift wrap in nft_chain_parse_hook(), from Dan Carpenter.

7) Fix broken ICMP ID randomization with NAT, also from Florian.

8) Remove WARN_ON in ebtables compat that is reached via syzkaller,
   from Florian Westphal.

9) Fix broken timestamps since fb420d5d91c1 ("tcp/fq: move back to
   CLOCK_MONOTONIC"), from Florian.

10) Fix logging of invalid packets in conntrack, from Andrei Vagin.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit ed0de45a1008991fdaa27a0152befcb74d126a8b:

  ipv4: recompile ip options in ipv4_link_failure (2019-04-12 17:23:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to d48668052b2603b6262459625c86108c493588dd:

  netfilter: fix nf_l4proto_log_invalid to log invalid packets (2019-04-22 10:38:50 +0200)

----------------------------------------------------------------
Alexander Potapenko (1):
      netfilter: conntrack: initialize ct->timeout

Andrei Vagin (1):
      netfilter: fix nf_l4proto_log_invalid to log invalid packets

Dan Carpenter (1):
      netfilter: nf_tables: prevent shift wrap in nft_chain_parse_hook()

Florian Westphal (6):
      selftests: netfilter: check icmp pkttoobig errors are set as related
      netfilter: conntrack: don't set related state for different outer address
      netfilter: ctnetlink: don't use conntrack/expect object addresses as id
      netfilter: nat: fix icmp id randomization
      netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON
      netfilter: never get/set skb->tstamp

Julian Anastasov (1):
      ipvs: do not schedule icmp errors from tunnels

 include/net/netfilter/nf_conntrack.h               |   2 +
 include/net/netfilter/nf_conntrack_l4proto.h       |   6 +
 net/bridge/netfilter/ebtables.c                    |   3 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   2 +-
 net/netfilter/nf_conntrack_core.c                  |  43 +++-
 net/netfilter/nf_conntrack_netlink.c               |  34 ++-
 net/netfilter/nf_conntrack_proto.c                 |   2 +-
 net/netfilter/nf_conntrack_proto_icmp.c            |  93 +++++--
 net/netfilter/nf_conntrack_proto_icmpv6.c          |  52 +---
 net/netfilter/nf_nat_core.c                        |  11 +-
 net/netfilter/nf_tables_api.c                      |   2 +-
 net/netfilter/nfnetlink_log.c                      |   2 +-
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/netfilter/xt_time.c                            |  23 +-
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../selftests/netfilter/conntrack_icmp_related.sh  | 283 +++++++++++++++++++++
 tools/testing/selftests/netfilter/nft_nat.sh       |  36 ++-
 17 files changed, 493 insertions(+), 105 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/conntrack_icmp_related.sh
