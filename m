Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6977C4361B
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Dec 2020 12:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC7A23443
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Dec 2020 12:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgLRME7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Dec 2020 07:04:59 -0500
Received: from correo.us.es ([193.147.175.20]:51906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgLRME7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 07:04:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9615EB46F
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2020 13:03:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7911DA84A
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2020 13:03:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ABF64DA852; Fri, 18 Dec 2020 13:03:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 845B7DA78A;
        Fri, 18 Dec 2020 13:03:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 18 Dec 2020 13:03:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4DFD642DF562;
        Fri, 18 Dec 2020 13:03:56 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Fri, 18 Dec 2020 13:04:05 +0100
Message-Id: <20201218120409.3659-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jakub, David,

The following patchset contains Netfilter fixes for net:

1) Incorrect loop in error path of nft_set_elem_expr_clone(),
   from Colin Ian King.

2) Missing xt_table_get_private_protected() to access table
   private data in x_tables, from Subash Abhinov Kasiviswanathan.

3) Possible oops in ipset hash type resize, from Vasily Averin.

4) Fix shift-out-of-bounds in ipset hash type, also from Vasily.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9:

  Merge tag 'staging-5.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging (2020-12-15 14:18:40 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 5c8193f568ae16f3242abad6518dc2ca6c8eef86:

  netfilter: ipset: fix shift-out-of-bounds in htable_bits() (2020-12-17 19:44:52 +0100)

----------------------------------------------------------------
Colin Ian King (1):
      netfilter: nftables: fix incorrect increment of loop counter

Subash Abhinov Kasiviswanathan (1):
      netfilter: x_tables: Update remaining dereference to RCU

Vasily Averin (2):
      netfilter: ipset: fixes possible oops in mtype_resize
      netfilter: ipset: fix shift-out-of-bounds in htable_bits()

 net/ipv4/netfilter/arp_tables.c       |  2 +-
 net/ipv4/netfilter/ip_tables.c        |  2 +-
 net/ipv6/netfilter/ip6_tables.c       |  2 +-
 net/netfilter/ipset/ip_set_hash_gen.h | 42 +++++++++++++++--------------------
 net/netfilter/nf_tables_api.c         |  4 ++--
 5 files changed, 23 insertions(+), 29 deletions(-)
