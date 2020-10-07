Return-Path: <SRS0=fUKQ=DO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8EDC3279D
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 00:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31BDB20739
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 00:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgJGAKt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 20:10:49 -0400
Received: from correo.us.es ([193.147.175.20]:46964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgJGAKh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 20:10:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE2841F0CE8
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2020 02:10:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1D1DDA78D
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2020 02:10:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 972F4DA78A; Wed,  7 Oct 2020 02:10:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84224DA704;
        Wed,  7 Oct 2020 02:10:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 07 Oct 2020 02:10:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 5A10142EF42A;
        Wed,  7 Oct 2020 02:10:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/4] Netfilter fixes for net
Date:   Wed,  7 Oct 2020 02:10:23 +0200
Message-Id: <20201007001027.2530-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter selftests fixes from
Fabian Frederick:

1) Extend selftest nft_meta.sh to check for meta cpu.

2) Fix selftest nft_meta.sh error reporting.

3) Fix shellcheck warnings in selftest nft_meta.sh.

4) Extend selftest nft_meta.sh to check for meta time.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you!

----------------------------------------------------------------

The following changes since commit 25b8ab916dd7a1f490b603d68c7765c06f9ed9e1:

  Merge tag 'mac80211-for-net-2020-09-21' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211 (2020-09-21 14:54:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 48d072c4e8cdb542ade06727c31d7851bcc40a89:

  selftests: netfilter: add time counter check (2020-09-30 11:49:18 +0200)

----------------------------------------------------------------
Fabian Frederick (4):
      selftests: netfilter: add cpu counter check
      selftests: netfilter: fix nft_meta.sh error reporting
      selftests: netfilter: remove unused cnt and simplify command testing
      selftests: netfilter: add time counter check

 tools/testing/selftests/netfilter/nft_meta.sh | 32 +++++++++++++++++++++------
 1 file changed, 25 insertions(+), 7 deletions(-)
