Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82319C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 590142087C
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfCKWun (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:50:43 -0400
Received: from mail.us.es ([193.147.175.20]:34546 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbfCKWun (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 18:50:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7E0E20991B
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 23:50:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B43C5DA86A
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 23:50:41 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A9C1FDA864; Mon, 11 Mar 2019 23:50:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D28D6DA846;
        Mon, 11 Mar 2019 23:50:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 Mar 2019 23:50:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A82D74265A2F;
        Mon, 11 Mar 2019 23:50:39 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/5] Netfilter fixes for net
Date:   Mon, 11 Mar 2019 23:50:30 +0100
Message-Id: <20190311225035.21250-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for your net tree:

1) Fix list corruption in device notifier in the masquerade
   infrastructure, from Florian Westphal.

2) Fix double-free of sets and use-after-free when deleting elements.

3) Don't bogusly return EBUSY when removing a set after flush command.

4) Use-after-free in dynamically allocate operations.

5) Don't report a new ruleset generation to userspace if transaction
   list is empty, this invalidates the userspace cache innecessarily.
   From Florian Westphal.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 1e027960edfaa6a43f9ca31081729b716598112b:

  net/hsr: fix possible crash in add_timer() (2019-03-07 11:02:08 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to b8b27498659c65034032af79842913844a6cc79a:

  netfilter: nf_tables: return immediately on empty commit (2019-03-11 20:01:20 +0100)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nat: don't register device notifier twice
      netfilter: nf_tables: return immediately on empty commit

Pablo Neira Ayuso (3):
      netfilter: nf_tables: fix set double-free in abort path
      netfilter: nf_tables: bogus EBUSY when deleting set after flush
      netfilter: nf_tables: use-after-free in dynamic operations

 include/net/netfilter/nf_tables.h | 12 ++++++---
 net/netfilter/nf_nat_masquerade.c | 35 +++++++++++++------------
 net/netfilter/nf_tables_api.c     | 54 +++++++++++++++++++++++++++++++++------
 net/netfilter/nft_dynset.c        | 13 +++++++---
 net/netfilter/nft_lookup.c        | 13 +++++++---
 net/netfilter/nft_objref.c        | 13 +++++++---
 6 files changed, 100 insertions(+), 40 deletions(-)
