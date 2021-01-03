Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3814BC43331
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Jan 2021 19:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E672078D
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Jan 2021 19:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbhACTaJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Jan 2021 14:30:09 -0500
Received: from correo.us.es ([193.147.175.20]:40756 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbhACTaI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Jan 2021 14:30:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C864117721
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2021 20:28:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EF24DA722
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2021 20:28:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7434EDA84D; Sun,  3 Jan 2021 20:28:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4609DDA722;
        Sun,  3 Jan 2021 20:28:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 03 Jan 2021 20:28:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 15981426CC84;
        Sun,  3 Jan 2021 20:28:49 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Sun,  3 Jan 2021 20:29:17 +0100
Message-Id: <20210103192920.18639-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jakub, David,

The following patchset contains Netfilter fixes for net:

1) Missing sanitization of rateest userspace string, bug has been
   triggered by syzbot, patch from Florian Westphal.

2) Report EOPNOTSUPP on missing set features in nft_dynset, otherwise
   error reporting to userspace via EINVAL is misleading since this is
   reserved for malformed netlink requests.

3) New binaries with old kernels might silently accept several set
   element expressions. New binaries set on the NFT_SET_EXPR and
   NFT_DYNSET_F_EXPR flags to request for several expressions per
   element, hence old kernels which do not support for this bail out
   with EOPNOTSUPP.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

P.S: Best wishes for 2021.

----------------------------------------------------------------

The following changes since commit 1f45dc22066797479072978feeada0852502e180:

  ibmvnic: continue fatal error reset after passive init (2020-12-23 12:56:10 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to b4e70d8dd9ea6bd5d5fb3122586f652326ca09cd:

  netfilter: nftables: add set expression flags (2020-12-28 10:50:26 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: xt_RATEEST: reject non-null terminated string from userspace

Pablo Neira Ayuso (2):
      netfilter: nft_dynset: report EOPNOTSUPP on missing set feature
      netfilter: nftables: add set expression flags

 include/uapi/linux/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c            |  6 +++++-
 net/netfilter/nft_dynset.c               | 15 ++++++++++-----
 net/netfilter/xt_RATEEST.c               |  3 +++
 4 files changed, 21 insertions(+), 6 deletions(-)
