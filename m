Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7227DC433E6
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 15:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C62864E40
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 15:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhBBPWx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 10:22:53 -0500
Received: from correo.us.es ([193.147.175.20]:49658 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233600AbhBBPWp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 10:22:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 53019D2B03
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Feb 2021 16:22:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47180DA789
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Feb 2021 16:22:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3CB85DA78A; Tue,  2 Feb 2021 16:22:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05409DA789;
        Tue,  2 Feb 2021 16:22:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 02 Feb 2021 16:22:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id DBCC3426CC85;
        Tue,  2 Feb 2021 16:21:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Tue,  2 Feb 2021 16:21:52 +0100
Message-Id: <20210202152156.25979-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Honor stateful expressions defined in the set from the dynset
   extension. The set definition provides a stateful expression
   that must be used by the dynset expression in case it is specified.

2) Missing timeout extension in the set element in the dynset
   extension leads to inconsistent ruleset listing, not allowing
   the user to restore timeout and expiration on ruleset reload.

3) Do not dump the stateful expression from the dynset extension
   if it coming from the set definition.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit c8a8ead01736419a14c3106e1f26a79d74fc84c7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf (2021-01-12 20:25:29 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to ce5379963b2884e9d23bea0c5674a7251414c84b:

  netfilter: nft_dynset: dump expressions when set definition contains no expressions (2021-01-16 19:54:42 +0100)

----------------------------------------------------------------
Pablo Neira Ayuso (3):
      netfilter: nft_dynset: honor stateful expressions in set definition
      netfilter: nft_dynset: add timeout extension to template
      netfilter: nft_dynset: dump expressions when set definition contains no expressions

 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     |  5 ++---
 net/netfilter/nft_dynset.c        | 41 +++++++++++++++++++++++++--------------
 3 files changed, 30 insertions(+), 18 deletions(-)
