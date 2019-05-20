Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3C2C04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84A1D20645
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389375AbfETM04 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 08:26:56 -0400
Received: from mail.us.es ([193.147.175.20]:34182 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389421AbfETM0z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 08:26:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2CA141D94A5
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 14:26:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E1F7DA70D
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 14:26:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 13D5BDA705; Mon, 20 May 2019 14:26:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01F11DA704;
        Mon, 20 May 2019 14:26:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 May 2019 14:26:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C15BF4265A31;
        Mon, 20 May 2019 14:26:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH iptables 0/6] cache rework
Date:   Mon, 20 May 2019 14:26:40 +0200
Message-Id: <20190520122646.17788-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patchset updates the cache logic:

* Update nft_table_list_get() to use a list of tables from the cache,
  instead of listing them from the kernel.

* Ensure cache consistency by checking for generation ID is consistent
  when building up the cache.

Without this, we may end up with an inconsistent cache, hence defeating
the refresh transaction logic.

The other patches are just a few preparation patches to allow to
maintain the original cache and a cache that is refreshed everytime this
hits ERESTART.

My plan is to send another batch to revisit the refresh transaction
logic after this patchset, since 0004-restore-race_0 still does not
work after this.

Pablo Neira Ayuso (6):
  nft: add struct nft_cache
  nft: statify nft_rebuild_cache()
  nft: add __nft_table_builtin_find()
  nft: add flush_cache()
  nft: cache table list
  nft: ensure cache consistency

 iptables/nft.c | 195 ++++++++++++++++++++++++++++++++++-----------------------
 iptables/nft.h |  15 +++--
 2 files changed, 126 insertions(+), 84 deletions(-)

-- 
2.11.0

