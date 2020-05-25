Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E3EC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 21:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED8372071C
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 21:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389354AbgEYVy1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 17:54:27 -0400
Received: from correo.us.es ([193.147.175.20]:47298 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgEYVy1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 17:54:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 82C54F8D4A
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 23:54:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75645DA711
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 23:54:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6AD12DA70F; Mon, 25 May 2020 23:54:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B115DA702;
        Mon, 25 May 2020 23:54:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 May 2020 23:54:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3FDFC42EE38E;
        Mon, 25 May 2020 23:54:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/5] Netfilter fixes for net
Date:   Mon, 25 May 2020 23:54:15 +0200
Message-Id: <20200525215420.2290-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Set VLAN tag in tcp reset/icmp unreachable packets to reject
   connections in the bridge family, from Michael Braun.

2) Incorrect subcounter flag update in ipset, from Phil Sutter.

3) Possible buffer overflow in the pptp conntrack helper, based
   on patch from Dan Carpenter.

4) Restore userspace conntrack helper hook logic that broke after
   hook consolidation rework.

5) Unbreak userspace conntrack helper registration via
   nfnetlink_cthelper.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 98790bbac4db1697212ce9462ec35ca09c4a2810:

  Merge tag 'efi-urgent-2020-05-24' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2020-05-24 10:24:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 703acd70f2496537457186211c2f03e792409e68:

  netfilter: nfnetlink_cthelper: unbreak userspace helper support (2020-05-25 20:39:14 +0200)

----------------------------------------------------------------
Michael Braun (1):
      netfilter: nft_reject_bridge: enable reject with bridge vlan

Pablo Neira Ayuso (3):
      netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code
      netfilter: conntrack: make conntrack userspace helpers work again
      netfilter: nfnetlink_cthelper: unbreak userspace helper support

Phil Sutter (1):
      netfilter: ipset: Fix subcounter update skip

 include/linux/netfilter/nf_conntrack_pptp.h |  2 +-
 net/bridge/netfilter/nft_reject_bridge.c    |  6 +++
 net/ipv4/netfilter/nf_nat_pptp.c            |  7 +--
 net/netfilter/ipset/ip_set_list_set.c       |  2 +-
 net/netfilter/nf_conntrack_core.c           | 78 ++++++++++++++++++++++++++---
 net/netfilter/nf_conntrack_pptp.c           | 62 +++++++++++++----------
 net/netfilter/nfnetlink_cthelper.c          |  3 +-
 7 files changed, 119 insertions(+), 41 deletions(-)
