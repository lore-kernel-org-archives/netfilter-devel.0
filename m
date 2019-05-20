Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D84C04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 19:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B56AB20675
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 19:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbfETTIb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 15:08:31 -0400
Received: from mail.us.es ([193.147.175.20]:38338 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfETTIb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 15:08:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12FDCBAEE7
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 21:08:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06E6DDA706
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 21:08:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F0DF8DA704; Mon, 20 May 2019 21:08:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA7B5DA701;
        Mon, 20 May 2019 21:08:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 May 2019 21:08:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A71324265A31;
        Mon, 20 May 2019 21:08:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH iptables 0/6] ERESTART fixes
Date:   Mon, 20 May 2019 21:08:16 +0200
Message-Id: <20190520190822.18873-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A batch of patches to fix concurrent updates via iptables-restore that
result in ERESTART errors in iptables.

Pablo Neira Ayuso (5):
  nft: keep original cache in case of ERESTART
  nft: don't skip table addition from ERESTART
  nft: don't care about previous state in ERESTART
  nft: do not retry on EINTR
  nft: reset netlink sender buffer size of socket restart

Phil Sutter (1):
  xtables: Fix for explicit rule flushes

 iptables/nft.c | 79 ++++++++++++++++++++++++++++------------------------------
 iptables/nft.h |  3 ++-
 2 files changed, 40 insertions(+), 42 deletions(-)

-- 
2.11.0

