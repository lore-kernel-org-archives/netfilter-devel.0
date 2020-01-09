Return-Path: <SRS0=zMD2=26=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B71AC282DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jan 2020 17:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E04D2067D
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jan 2020 17:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731622AbgAIRVX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 12:21:23 -0500
Received: from correo.us.es ([193.147.175.20]:58596 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgAIRVW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 12:21:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DC4DAE8D69
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE26ADA701
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C3C09DA705; Thu,  9 Jan 2020 18:21:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B62D5DA701
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 18:21:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 97A5342EE38E
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:18 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/3] netns support
Date:   Thu,  9 Jan 2020 18:21:12 +0100
Message-Id: <20200109172115.229723-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset adds native netns support:

1) Add nft_ctx_set_netns() to libnftables to specify the network
   namespace.

2) Add new -w/--netns option to specify the network namespace from
   the command line.

Pablo Neira Ayuso (3):
  libnftables: add nft_ctx_set_netns()
  main: split parsing from libnftables initialization
  main: add -w/--netns option

 doc/nft.txt                    |   4 ++
 include/namespace.h            |  21 ++++++++
 include/nftables/libnftables.h |   3 ++
 src/Makefile.am                |   1 +
 src/libnftables.c              |  20 ++++++++
 src/libnftables.map            |   4 ++
 src/main.c                     |  53 ++++++++++++--------
 src/namespace.c                | 107 +++++++++++++++++++++++++++++++++++++++++
 8 files changed, 194 insertions(+), 19 deletions(-)
 create mode 100644 include/namespace.h
 create mode 100644 src/namespace.c

-- 
2.11.0

