Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A60C47083
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 12:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D90F260233
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 12:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhFBMqU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 08:46:20 -0400
Received: from mail.netfilter.org ([217.70.188.207]:41562 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhFBMqS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 08:46:18 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id EEFEA64156;
        Wed,  2 Jun 2021 14:43:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Wed,  2 Jun 2021 14:44:28 +0200
Message-Id: <20210602124430.10863-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Do not allow to add conntrack helper extension for confirmed
   conntracks in the nf_tables ct expectation support.

2) Fix bogus EBUSY in nfnetlink_cthelper when NFCTH_PRIV_DATA_LEN
   is passed on userspace helper updates.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you!

----------------------------------------------------------------

The following changes since commit b000372627ce9dbbe641dafbf40db0718276ab77:

  MAINTAINERS: nfc mailing lists are subscribers-only (2021-06-01 17:09:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 8971ee8b087750a23f3cd4dc55bff2d0303fd267:

  netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches (2021-06-02 12:43:50 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nft_ct: skip expectations for confirmed conntrack
      netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches

 net/netfilter/nfnetlink_cthelper.c | 8 ++++++--
 net/netfilter/nft_ct.c             | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)
