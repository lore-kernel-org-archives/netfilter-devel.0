Return-Path: <SRS0=lJQT=5J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFEEC10DCE
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 22:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E328208CA
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 22:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgCXWd0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 18:33:26 -0400
Received: from correo.us.es ([193.147.175.20]:34596 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgCXWc2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 18:32:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 866DFFB376
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 23:31:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 765D5DA840
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 23:31:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6C06FDA7B2; Tue, 24 Mar 2020 23:31:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F7D3DA390;
        Tue, 24 Mar 2020 23:31:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 24 Mar 2020 23:31:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 57D9042EF42C;
        Tue, 24 Mar 2020 23:31:47 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/7] Netfilter fixes for net
Date:   Tue, 24 Mar 2020 23:32:13 +0100
Message-Id: <20200324223220.12119-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) A new selftest for nf_queue, from Florian Westphal. This test
   covers two recent fixes: 07f8e4d0fddb ("tcp: also NULL skb->dev
   when copy was needed") and b738a185beaa ("tcp: ensure skb->dev is
   NULL before leaving TCP stack").

2) The fwd action breaks with ifb. For safety in next extensions,
   make sure the fwd action only runs from ingress until it is extended
   to be used from a different hook.

3) The pipapo set type now reports EEXIST in case of subrange overlaps.
   Update the rbtree set to validate range overlaps, so far this
   validation is only done only from userspace. From Stefano Brivio.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 749f6f6843115b424680f1aada3c0dd613ad807c:

  net: phy: dp83867: w/a for fld detect threshold bootstrapping issue (2020-03-21 20:09:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to a64d558d8cf98424cc5eb9ae6631782cd8bf789c:

  selftests: netfilter: add nfqueue test case (2020-03-24 20:00:12 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      selftests: netfilter: add nfqueue test case

Pablo Neira Ayuso (3):
      netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
      netfilter: nft_fwd_netdev: validate family and chain type
      netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress

Stefano Brivio (3):
      netfilter: nft_set_pipapo: Separate partial and complete overlap cases on insertion
      netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
      netfilter: nft_set_rbtree: Detect partial overlaps on insertion

 net/netfilter/nf_tables_api.c                  |   5 +
 net/netfilter/nft_fwd_netdev.c                 |  13 +
 net/netfilter/nft_set_pipapo.c                 |  34 ++-
 net/netfilter/nft_set_rbtree.c                 |  87 +++++-
 tools/testing/selftests/netfilter/Makefile     |   6 +-
 tools/testing/selftests/netfilter/config       |   6 +
 tools/testing/selftests/netfilter/nf-queue.c   | 352 +++++++++++++++++++++++++
 tools/testing/selftests/netfilter/nft_queue.sh | 332 +++++++++++++++++++++++
 8 files changed, 818 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/nf-queue.c
 create mode 100755 tools/testing/selftests/netfilter/nft_queue.sh
