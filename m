Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CA8C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 22:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0DFB64DDF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 22:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhBIWQ2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 17:16:28 -0500
Received: from correo.us.es ([193.147.175.20]:40674 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233809AbhBIWIH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 17:08:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C307EB632D
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 22:35:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B02CCDA78F
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 22:35:17 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4ECCDA78B; Tue,  9 Feb 2021 22:35:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55E95DA722;
        Tue,  9 Feb 2021 22:35:15 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Feb 2021 22:35:15 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1E3DD42DC6DD;
        Tue,  9 Feb 2021 22:35:15 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Tue,  9 Feb 2021 22:35:09 +0100
Message-Id: <20210209213511.23298-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) nf_conntrack_tuple_taken() needs to recheck zone for
   NAT clash resolution, from Florian Westphal.

2) Restore support for stateful expressions when set definition
   specifies no stateful expressions.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit ce7536bc7398e2ae552d2fabb7e0e371a9f1fe46:

  vsock/virtio: update credit only if socket is not closed (2021-02-08 13:27:46 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 664899e85c1312e51d2761e7f8b2f25d053e8489:

  netfilter: nftables: relax check for stateful expressions in set definition (2021-02-09 00:50:14 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: skip identical origin tuple in same zone only

Pablo Neira Ayuso (1):
      netfilter: nftables: relax check for stateful expressions in set definition

 net/netfilter/nf_conntrack_core.c |  3 ++-
 net/netfilter/nf_tables_api.c     | 28 +++++++++++++++-------------
 2 files changed, 17 insertions(+), 14 deletions(-)
