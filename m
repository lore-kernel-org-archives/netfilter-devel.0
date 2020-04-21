Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE353C55182
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 10:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C914E20663
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 10:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgDUKiL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 06:38:11 -0400
Received: from correo.us.es ([193.147.175.20]:50994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgDUKiJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 06:38:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A88ACFB44A
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 12:38:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B28FFA4F4
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 12:38:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 90AA220674; Tue, 21 Apr 2020 12:38:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B37DEFC553;
        Tue, 21 Apr 2020 12:38:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Apr 2020 12:38:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8477142EF42B;
        Tue, 21 Apr 2020 12:38:03 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/2] Netfilter fixes for net
Date:   Tue, 21 Apr 2020 12:37:57 +0200
Message-Id: <20200421103759.959074-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) flow_block_cb memleak in nf_flow_table_offload_del_cb(), from Roi Dayan.

2) Fix error path handling in nf_nat_inet_register_fn(), from Hillf Danton.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 82f35276c64ff720de11fba31fd6369b45647a2e:

  Merge tag 'wireless-drivers-2020-04-14' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers (2020-04-14 13:07:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to b4faef1739dd1f3b3981b8bf173a2266ea86b1eb:

  netfilter: nat: fix error handling upon registering inet hook (2020-04-19 14:59:31 +0200)

----------------------------------------------------------------
Hillf Danton (1):
      netfilter: nat: fix error handling upon registering inet hook

Roi Dayan (1):
      netfilter: flowtable: Free block_cb when being deleted

 net/netfilter/nf_flow_table_core.c | 6 ++++--
 net/netfilter/nf_nat_proto.c       | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)
