Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0171C33CB7
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 19:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC5962082E
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 19:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgAaTYf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 14:24:35 -0500
Received: from correo.us.es ([193.147.175.20]:36790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgAaTYf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 14:24:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B7C7FC5F7
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 20:24:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A4F1DA702
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 20:24:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7FCEBDA705; Fri, 31 Jan 2020 20:24:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F588DA702;
        Fri, 31 Jan 2020 20:24:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jan 2020 20:24:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6BD8942EFB80;
        Fri, 31 Jan 2020 20:24:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/6] Netfilter fixes for net
Date:   Fri, 31 Jan 2020 20:24:22 +0100
Message-Id: <20200131192428.167274-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix suspicious RCU usage in ipset, from Jozsef Kadlecsik.

2) Use kvcalloc, from Joe Perches.

3) Flush flowtable hardware workqueue after garbage collection run,
   from Paul Blakey.

4) Missing flowtable hardware workqueue flush from nf_flow_table_free(),
   also from Paul.

5) Restore NF_FLOW_HW_DEAD in flow_offload_work_del(), from Paul.

6) Flowtable documentation fixes, from Matteo Croce.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 44efc78d0e464ce70b45b165c005f8bedc17952e:

  net: mvneta: fix XDP support if sw bm is used as fallback (2020-01-29 13:57:59 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 78e06cf430934fc3768c342cbebdd1013dcd6fa7:

  netfilter: nf_flowtable: fix documentation (2020-01-31 19:31:42 +0100)

----------------------------------------------------------------
Joe Perches (1):
      netfilter: Use kvcalloc

Kadlecsik József (1):
      netfilter: ipset: fix suspicious RCU usage in find_set_and_id

Matteo Croce (1):
      netfilter: nf_flowtable: fix documentation

Paul Blakey (3):
      netfilter: flowtable: Fix hardware flush order on nf_flow_table_cleanup
      netfilter: flowtable: Fix missing flush hardware on table free
      netfilter: flowtable: Fix setting forgotten NF_FLOW_HW_DEAD flag

 Documentation/networking/nf_flowtable.txt |  2 +-
 net/netfilter/ipset/ip_set_core.c         | 41 ++++++++++++++++---------------
 net/netfilter/nf_conntrack_core.c         |  3 +--
 net/netfilter/nf_flow_table_core.c        |  3 ++-
 net/netfilter/nf_flow_table_offload.c     |  1 +
 net/netfilter/x_tables.c                  |  4 +--
 6 files changed, 28 insertions(+), 26 deletions(-)
