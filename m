Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27521C4167B
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 18:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E28122371F
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 18:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgLGSRj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:17:39 -0500
Received: from correo.us.es ([193.147.175.20]:40668 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgLGSRj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Dec 2020 13:17:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB03FDA73F
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB699DA722
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C1034DA78F; Mon,  7 Dec 2020 19:16:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8050DA722
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 07 Dec 2020 19:16:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 96C0C41FF201
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:46 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/5] support for several expression in set elements
Date:   Mon,  7 Dec 2020 19:16:46 +0100
Message-Id: <20201207181651.18771-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset extends nftables to support for several expressions
per set element.

So far, users can only specify either a counter or a ratelimit
per set element, this patchset allows for combining both.

This patchset adds an artificial cap for up to 2 expressions for set
elements which can be easily augmented later on by simply updating the
NFT_SET_EXPR_MAX definition.

Comments welcome, thanks.

Pablo Neira Ayuso (5):
  netfilter: nftables: generalize set expressions support
  netfilter: nftables: move nft_expr before nft_set
  netfilter: nftables: generalize set extension to support for several
    expressions
  netfilter: nftables: add nft_expr_parse() helper function
  netfilter: nftables: netlink support for several set element
    expressions

 include/net/netfilter/nf_tables.h        | 105 +++---
 include/uapi/linux/netfilter/nf_tables.h |   3 +
 net/netfilter/nf_tables_api.c            | 395 +++++++++++++++++------
 net/netfilter/nft_dynset.c               | 141 ++++++--
 net/netfilter/nft_set_hash.c             |  27 +-
 5 files changed, 511 insertions(+), 160 deletions(-)

-- 
2.20.1

