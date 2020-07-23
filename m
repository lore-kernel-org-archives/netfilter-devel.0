Return-Path: <SRS0=/ZNS=BC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C701BC433E8
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 22:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4EC5206E3
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 22:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgGWWfR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jul 2020 18:35:17 -0400
Received: from correo.us.es ([193.147.175.20]:58070 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgGWWfR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jul 2020 18:35:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DE793F2589
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jul 2020 00:35:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0D23DA789
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jul 2020 00:35:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C5B64DA78E; Fri, 24 Jul 2020 00:35:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0BCCDA78C;
        Fri, 24 Jul 2020 00:35:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 Jul 2020 00:35:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7F3FC4265A2F;
        Fri, 24 Jul 2020 00:35:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/2] Netfilter/IPVS fixes for net
Date:   Fri, 24 Jul 2020 00:35:06 +0200
Message-Id: <20200723223508.17038-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Fix NAT hook deletion when table is dormant, from Florian Westphal.

2) Fix IPVS sync stalls, from guodeqing.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 1d61e21852d3161f234b9656797669fe185c251b:

  qed: Disable "MFW indication via attention" SPAM every 5 minutes (2020-07-14 15:15:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 8210e344ccb798c672ab237b1a4f241bda08909b:

  ipvs: fix the connection sync failed in some cases (2020-07-22 01:21:34 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nf_tables: fix nat hook table deletion

guodeqing (1):
      ipvs: fix the connection sync failed in some cases

 net/netfilter/ipvs/ip_vs_sync.c | 12 ++++++++----
 net/netfilter/nf_tables_api.c   | 41 ++++++++++++++---------------------------
 2 files changed, 22 insertions(+), 31 deletions(-)
