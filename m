Return-Path: <SRS0=mmf4=EG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF87C388F9
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Oct 2020 18:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E446C206A5
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Oct 2020 18:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgJaSOq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 31 Oct 2020 14:14:46 -0400
Received: from correo.us.es ([193.147.175.20]:48000 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgJaSOp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 31 Oct 2020 14:14:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 49BDA7B54F
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2020 19:14:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3ADA7DA78A
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2020 19:14:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 30596DA73F; Sat, 31 Oct 2020 19:14:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2FAEDA722;
        Sat, 31 Oct 2020 19:14:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 31 Oct 2020 19:14:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id CCF5E42EF42B;
        Sat, 31 Oct 2020 19:14:40 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net 0/5] Netfilter fixes for net
Date:   Sat, 31 Oct 2020 19:14:32 +0100
Message-Id: <20201031181437.12472-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Incorrect netlink report logic in flowtable and genID.

2) Add a selftest to check that wireguard passes the right sk
   to ip_route_me_harder, from Jason A. Donenfeld.

3) Pass the actual sk to ip_route_me_harder(), also from Jason.

4) Missing expression validation of updates via nft --check.

5) Update byte and packet counters regardless of whether they
   match, from Stefano Brivio.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 07e0887302450a62f51dba72df6afb5fabb23d1c:

  Merge tag 'fallthrough-fixes-clang-5.10-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux (2020-10-29 13:02:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 7d10e62c2ff8e084c136c94d32d9a94de4d31248:

  netfilter: ipset: Update byte and packet counters regardless of whether they match (2020-10-31 11:11:11 +0100)

----------------------------------------------------------------
Jason A. Donenfeld (2):
      wireguard: selftests: check that route_me_harder packets use the right sk
      netfilter: use actual socket sk rather than skb sk when routing harder

Pablo Neira Ayuso (2):
      netfilter: nftables: fix netlink report logic in flowtable and genid
      netfilter: nf_tables: missing validation from the abort path

Stefano Brivio (1):
      netfilter: ipset: Update byte and packet counters regardless of whether they match

 include/linux/netfilter/nfnetlink.h                |  9 ++++++++-
 include/linux/netfilter_ipv4.h                     |  2 +-
 include/linux/netfilter_ipv6.h                     | 10 +++++-----
 net/ipv4/netfilter.c                               |  8 +++++---
 net/ipv4/netfilter/iptable_mangle.c                |  2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |  2 +-
 net/ipv6/netfilter.c                               |  6 +++---
 net/ipv6/netfilter/ip6table_mangle.c               |  2 +-
 net/netfilter/ipset/ip_set_core.c                  |  3 ++-
 net/netfilter/ipvs/ip_vs_core.c                    |  4 ++--
 net/netfilter/nf_nat_proto.c                       |  4 ++--
 net/netfilter/nf_synproxy_core.c                   |  2 +-
 net/netfilter/nf_tables_api.c                      | 19 ++++++++++++-------
 net/netfilter/nfnetlink.c                          | 22 ++++++++++++++++++----
 net/netfilter/nft_chain_route.c                    |  4 ++--
 net/netfilter/utils.c                              |  4 ++--
 tools/testing/selftests/wireguard/netns.sh         |  8 ++++++++
 .../testing/selftests/wireguard/qemu/kernel.config |  2 ++
 18 files changed, 76 insertions(+), 37 deletions(-)
