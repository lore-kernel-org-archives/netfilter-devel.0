Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D808BC32757
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 21:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9119214C6
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 21:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfHNVnz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 17:43:55 -0400
Received: from correo.us.es ([193.147.175.20]:47248 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbfHNVnz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 17:43:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 17EA0C4144
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 23:43:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 098DDADE9
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 23:43:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F35E4A58B; Wed, 14 Aug 2019 23:43:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 051EEDA72F;
        Wed, 14 Aug 2019 23:43:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 23:43:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CBDF44265A2F;
        Wed, 14 Aug 2019 23:43:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/2] Netfilter updates for net-next
Date:   Wed, 14 Aug 2019 23:43:45 +0200
Message-Id: <20190814214347.4940-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next.
This round addresses fallout from previous pull request:

1) Remove #warning from ipt_LOG.h and ip6t_LOG.h headers,
   from Jeremy Sowden.

2) Incorrect parens in memcmp() in nft_bitwise, from Nathan Chancellor.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 5181b473d64ee278f24035ce335b89ddc4520fc0:

  net: phy: realtek: add NBase-T PHY auto-detection (2019-08-14 13:26:08 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 83c156d3ecc0121d27dc2b7f34e829b265c70c4f:

  netfilter: nft_bitwise: Adjust parentheses to fix memcmp size argument (2019-08-14 23:36:45 +0200)

----------------------------------------------------------------
Jeremy Sowden (1):
      netfilter: remove deprecation warnings from uapi headers.

Nathan Chancellor (1):
      netfilter: nft_bitwise: Adjust parentheses to fix memcmp size argument

 include/uapi/linux/netfilter_ipv4/ipt_LOG.h  | 2 --
 include/uapi/linux/netfilter_ipv6/ip6t_LOG.h | 2 --
 net/netfilter/nft_bitwise.c                  | 4 ++--
 3 files changed, 2 insertions(+), 6 deletions(-)
