Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D9A2C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 10:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359259AbiDLKtE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356873AbiDLKpk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 06:45:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64FA813E84;
        Tue, 12 Apr 2022 02:42:54 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3C1D0608FA;
        Tue, 12 Apr 2022 11:38:49 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Tue, 12 Apr 2022 11:42:44 +0200
Message-Id: <20220412094246.448055-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix cgroupv2 from the input path, from Florian Westphal.

2) Fix incorrect return value of nft_parse_register(), from Antoine Tenart.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit e8a64bbaaad1f6548cec5508297bc6d45e8ab69e:

  net/sched: taprio: Check if socket flags are valid (2022-04-11 10:51:00 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 6c6f9f31ecd47dce1d0dafca4bec8805f9bc97cd:

  netfilter: nf_tables: nft_parse_register can return a negative value (2022-04-12 11:36:37 +0200)

----------------------------------------------------------------
Antoine Tenart (1):
      netfilter: nf_tables: nft_parse_register can return a negative value

Florian Westphal (1):
      netfilter: nft_socket: make cgroup match work in input too

 net/netfilter/nf_tables_api.c | 2 +-
 net/netfilter/nft_socket.c    | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)
