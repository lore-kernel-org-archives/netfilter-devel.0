Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E77C4361B
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 22:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD92D238A0
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 22:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388454AbgLIWTI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 17:19:08 -0500
Received: from correo.us.es ([193.147.175.20]:32960 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388308AbgLIWTE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 17:19:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 203CCD2DA06
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 23:18:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11174DA704
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 23:18:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 06A66DA8F4; Wed,  9 Dec 2020 23:18:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA6C7DA704;
        Wed,  9 Dec 2020 23:18:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Dec 2020 23:18:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7943C4265A5A;
        Wed,  9 Dec 2020 23:18:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Wed,  9 Dec 2020 23:18:06 +0100
Message-Id: <20201209221810.32504-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jakub, David,

The following patchset contains Netfilter fixes for net:

1) Switch to RCU in x_tables to fix possible NULL pointer dereference,
   from Subash Abhinov Kasiviswanathan.

2) Fix netlink dump of dynset timeouts later than 23 days.

3) Add comment for the indirect serialization of the nft commit mutex
   with rtnl_mutex.

4) Remove bogus check for confirmed conntrack when matching on the
   conntrack ID, from Brett Mastbergen.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 819f56bad110cb27a8be3232467986e2baebe069:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec (2020-12-07 18:29:54 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 2d94b20b95b009eec1a267dcf026b01af627c0cd:

  netfilter: nft_ct: Remove confirmation check for NFT_CT_ID (2020-12-09 10:31:58 +0100)

----------------------------------------------------------------
Brett Mastbergen (1):
      netfilter: nft_ct: Remove confirmation check for NFT_CT_ID

Pablo Neira Ayuso (2):
      netfilter: nft_dynset: fix timeouts later than 23 days
      netfilter: nftables: comment indirect serialization of commit_mutex with rtnl_mutex

Subash Abhinov Kasiviswanathan (1):
      netfilter: x_tables: Switch synchronization to RCU

 include/linux/netfilter/x_tables.h |  5 +++-
 include/net/netfilter/nf_tables.h  |  4 ++++
 net/ipv4/netfilter/arp_tables.c    | 14 +++++------
 net/ipv4/netfilter/ip_tables.c     | 14 +++++------
 net/ipv6/netfilter/ip6_tables.c    | 14 +++++------
 net/netfilter/nf_tables_api.c      |  8 +++++--
 net/netfilter/nft_ct.c             |  2 --
 net/netfilter/nft_dynset.c         |  8 ++++---
 net/netfilter/x_tables.c           | 49 ++++++++++++--------------------------
 9 files changed, 55 insertions(+), 63 deletions(-)
