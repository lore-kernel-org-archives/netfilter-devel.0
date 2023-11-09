Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672F5C41535
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 15:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbjKIPB1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 10:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbjKIPBZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 10:01:25 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C7A358A
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 07:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=A4Ll09RKPkM+j4M7xCg0H0lDnGTysoJbXhDagplGVFg=; b=G3UjQd4XAP/tbWZLubBW0I8MtB
        l7NqwgZep5CdDAP7l5XNlijauFISazni2Wv9xshu84L0e83B+sm9yVFjuvZcH8qJaj7FaLJbSk94f
        e2oALuJCTNz/sp6igdPiQabMLVSQS5itQNuVtTc4FgOf8FG/Z7jO+t8qMPrSoWXLL4XIuP7YEsijU
        xdfsUDd8DWFbMLe7AYYV5Sookvop8q8g05MCqCzYLuk5wttQamhefAzkO2BPRSbvuTiKvfC3qswfu
        LdiT/DsaBQh/+HsNsKCVetUDF+sytf6kCMmqeUvNeFrjki7Th9sqbuJ095wKnnaYZvMtusOEoqxm1
        P2n0AQfg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r16X3-0005xM-6D; Thu, 09 Nov 2023 16:01:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v4 0/3] Add locking for NFT_MSG_GETSETELEM_RESET
Date:   Thu,  9 Nov 2023 16:01:13 +0100
Message-ID: <20231109150117.17616-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series attempts to solve for the potential invalidation of table
and set pointers in v3's nf_tables_getsetelem_reset function.

Patch 2 introduces an initializer function for struct nft_set_dump_ctx
which takes care of the table and set lookups. It will be called for
NLM_F_DUMP requests to prepare the dump context and for non-NLM_F_DUMP
requests inside the critical section to perform the necessary lookups.
The dump context's fields are then passed to nft_get_set_elem function.

Since the 'set' field in said dump context is marked const, patch 1 is
needed for called functions to respect the qualifier.

Patch 3 then adds the actual locking counterparts to
nf_tables_getsetelem and nf_tables_dump_set.

Phil Sutter (3):
  netfilter: nf_tables: Pass const set to nft_get_set_elem
  netfilter: nf_tables: Introduce nft_set_dump_ctx_init()
  netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET
    requests

 net/netfilter/nf_tables_api.c | 135 +++++++++++++++++++++++++++-------
 1 file changed, 108 insertions(+), 27 deletions(-)

-- 
2.41.0

