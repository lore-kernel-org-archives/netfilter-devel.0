Return-Path: <SRS0=dzjG=EK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFE8C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 12:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD432221F8
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 12:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbgKDMw4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Nov 2020 07:52:56 -0500
Received: from correo.us.es ([193.147.175.20]:47850 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729880AbgKDMw4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Nov 2020 07:52:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB87B82DC71
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 13:52:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBA91DA72F
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 13:52:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CAC93DA78F; Wed,  4 Nov 2020 13:52:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E9C6DA72F
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 13:52:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 13:52:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 5AABE42EF9E3
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 13:52:52 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 0/2] fixes for nftables offload
Date:   Wed,  4 Nov 2020 13:52:47 +0100
Message-Id: <20201104125249.11704-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

These patchset fixes nftables offload for the two cases:

- matching on exact IP address
- matching on prefix IP address

Tested with mlx5.

Pablo Neira Ayuso (2):
  netfilter: nftables_offload: set address type in control dissector
  netfilter: nftables_offload: build mask based from the matching bytes

 include/net/netfilter/nf_tables_offload.h |  7 +++
 net/netfilter/nf_tables_offload.c         | 18 ++++++
 net/netfilter/nft_cmp.c                   |  8 +--
 net/netfilter/nft_meta.c                  | 16 +++---
 net/netfilter/nft_payload.c               | 68 +++++++++++++++++------
 5 files changed, 88 insertions(+), 29 deletions(-)

-- 
2.20.1

