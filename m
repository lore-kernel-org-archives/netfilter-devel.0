Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4A7C282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 21:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C531D21773
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 21:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388224AbfEWVf4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 17:35:56 -0400
Received: from mail.us.es ([193.147.175.20]:46928 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388229AbfEWVf4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 17:35:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7684DDA707
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 23:35:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66A52DA709
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 23:35:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5C4E0DA706; Thu, 23 May 2019 23:35:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49F8ADA707;
        Thu, 23 May 2019 23:35:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 May 2019 23:35:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1D66E4265A32;
        Thu, 23 May 2019 23:35:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/11] Netfilter/IPVS fixes for net
Date:   Thu, 23 May 2019 23:35:36 +0200
Message-Id: <20190523213547.15523-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for your net tree:

1) Fix crash when dumping rules after conversion to RCU,
   from Florian Westphal.

2) Fix incorrect hook reinjection from nf_queue in case NF_REPEAT,
   from Jagdish Motwani.

3) Fix check for route existence in fib extension, from Phil Sutter.

4) Fix use after free in ip_vs_in() hook, from YueHaibing.

5) Check for veth existence from netfilter selftests,
   from Jeffrin Jose T.

6) Checksum corruption in UDP NAT helpers due to typo,
   from Florian Westphal.

7) Pass up packets to classic forwarding path regardless of
   IPv4 DF bit, patch for the flowtable infrastructure from Florian.

8) Set liberal TCP tracking for flows that are placed in the
   flowtable, in case they need to go back to classic forwarding path,
   also from Florian.

9) Don't add flow with sequence adjustment to flowtable, from Florian.

10) Skip IPv4 options from IPv6 datapath in flowtable, from Florian.

11) Add selftest for the flowtable infrastructure, from Florian.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit ee8a2b95b737d5989efeb477d5a1ef5e6955b830:

  Merge branch 'mlxsw-Two-port-module-fixes' (2019-05-18 13:13:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 2de03b45236f3af1800755614fd434d347adf046:

  selftests: netfilter: add flowtable test script (2019-05-22 10:56:11 +0200)

----------------------------------------------------------------
Florian Westphal (7):
      netfilter: nf_tables: fix oops during rule dump
      netfilter: nat: fix udp checksum corruption
      netfilter: nf_flow_table: ignore DF bit setting
      netfilter: nft_flow_offload: set liberal tracking mode for tcp
      netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment
      netfilter: nft_flow_offload: IPCB is only valid for ipv4 family
      selftests: netfilter: add flowtable test script

Jagdish Motwani (1):
      netfilter: nf_queue: fix reinject verdict handling

Jeffrin Jose T (1):
      selftests: netfilter: missing error check when setting up veth interface

Phil Sutter (1):
      netfilter: nft_fib: Fix existence check support

YueHaibing (1):
      ipvs: Fix use-after-free in ip_vs_in

 include/net/netfilter/nft_fib.h                    |   2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |  23 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |  16 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   2 +-
 net/netfilter/nf_flow_table_ip.c                   |   3 +-
 net/netfilter/nf_nat_helper.c                      |   2 +-
 net/netfilter/nf_queue.c                           |   1 +
 net/netfilter/nf_tables_api.c                      |  20 +-
 net/netfilter/nft_fib.c                            |   6 +-
 net/netfilter/nft_flow_offload.c                   |  31 +-
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh | 324 +++++++++++++++++++++
 tools/testing/selftests/netfilter/nft_nat.sh       |   6 +-
 13 files changed, 375 insertions(+), 63 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_flowtable.sh
