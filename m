Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5480C31E5D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A501208C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfFQWma (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:42:30 -0400
Received: from mail.us.es ([193.147.175.20]:36164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfFQWma (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 18:42:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2655ABEBA3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 00:42:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1485ADA708
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 00:42:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0937EDA707; Tue, 18 Jun 2019 00:42:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11911DA701;
        Tue, 18 Jun 2019 00:42:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 00:42:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CBA6A4265A2F;
        Tue, 18 Jun 2019 00:42:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/3] Netfilter fixes for net
Date:   Tue, 18 Jun 2019 00:42:20 +0200
Message-Id: <20190617224223.1004-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

1) Module autoload for masquerade and redirection does not work.

2) Leak in unqueued packets in nf_ct_frag6_queue(). Ignore duplicated
   fragments, pretend they are placed into the queue. Patches from
   Guillaume Nault.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 100f6d8e09905c59be45b6316f8f369c0be1b2d8:

  net: correct zerocopy refcnt with udp MSG_MORE (2019-05-30 15:54:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 8a3dca632538c550930ce8bafa8c906b130d35cf:

  netfilter: ipv6: nf_defrag: accept duplicate fragments again (2019-06-07 14:49:01 +0200)

----------------------------------------------------------------
Guillaume Nault (2):
      netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments
      netfilter: ipv6: nf_defrag: accept duplicate fragments again

Pablo Neira Ayuso (1):
      netfilter: nf_tables: fix module autoload with inet family

 net/ipv6/netfilter/nf_conntrack_reasm.c | 22 ++++++++++++----------
 net/netfilter/nft_masq.c                |  3 +--
 net/netfilter/nft_redir.c               |  3 +--
 3 files changed, 14 insertions(+), 14 deletions(-)
