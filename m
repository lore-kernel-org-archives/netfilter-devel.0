Return-Path: <SRS0=cPjr=73=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A211C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81D3E206D7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgFNVxL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jun 2020 17:53:11 -0400
Received: from correo.us.es ([193.147.175.20]:59906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbgFNVxL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jun 2020 17:53:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 728CDB56E5
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jun 2020 23:53:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63EBEDA789
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jun 2020 23:53:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 59758DA78C; Sun, 14 Jun 2020 23:53:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1EB79DA722;
        Sun, 14 Jun 2020 23:53:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 14 Jun 2020 23:53:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E1279426CCBA;
        Sun, 14 Jun 2020 23:53:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/4] Netfilter fixes for net
Date:   Sun, 14 Jun 2020 23:52:57 +0200
Message-Id: <20200614215301.9101-1-pablo@netfilter.org>
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

1) Fix bogus EEXIST on element insertions to the rbtree with timeouts,
   from Stefano Brivio.

2) Preempt BUG splat in the pipapo element insertion path, also from
   Stefano.

3) Release filter from the ctnetlink error path.

4) Release flowtable hooks from the deletion path.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit af7b4801030c07637840191c69eb666917e4135d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-06-07 17:27:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 3003055f50663095472144994dac0339076031a8:

  netfilter: nf_tables: hook list memleak in flowtable deletion (2020-06-12 17:48:21 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: ctnetlink: memleak in filter initialization error path
      netfilter: nf_tables: hook list memleak in flowtable deletion

Stefano Brivio (2):
      netfilter: nft_set_rbtree: Don't account for expired elements on insertion
      netfilter: nft_set_pipapo: Disable preemption before getting per-CPU pointer

 net/netfilter/nf_conntrack_netlink.c | 32 ++++++++++++++++++++++----------
 net/netfilter/nf_tables_api.c        | 31 ++++++++++++++++++++++++-------
 net/netfilter/nft_set_pipapo.c       |  6 +++++-
 net/netfilter/nft_set_rbtree.c       | 21 ++++++++++++++-------
 4 files changed, 65 insertions(+), 25 deletions(-)
