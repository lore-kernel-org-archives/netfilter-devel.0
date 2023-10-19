Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F00CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 11:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbjJSLd7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 07:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345348AbjJSLdz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 07:33:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F89134
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 04:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hd07u3EdFt0KRsZUY07krZJYf36MxKLKJrHEaOCmJO0=; b=kBL2hRA6s1GDsLoC1Zzlmy500P
        NHZVktyBzVSSmVPGfAH+IEFmAmHxn9ykTBsttrFsZni4PgB+G2hx/TYTj5b338X/4PGlLw8bjdwsz
        Jcyb+Si6yZIiOnQZxuywJqGaLDR/fLyax5yKuq+Zj40/qBQQ2cyMeiIt0GYkzrypCuM2dO6NPasaQ
        Bd46URKn/CXH1RDKEdzH0qOJnE80jlZYNMJHQBq1iuyHwHPa+SQeSYzTKAvatYbu4/j78J39srgJp
        EhCS7XERYkZMrLttN2A1u8uQjAlD1VvZ6KnZN0Gt00unIkH/AjPO5DLaHhFhvXXivKWWEaaS3MQ9m
        r/+DHOcA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qtRHj-0000Sp-Ik; Thu, 19 Oct 2023 13:33:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v3 0/3] Introduce locking for rule reset requests
Date:   Thu, 19 Oct 2023 13:33:44 +0200
Message-ID: <20231019113347.8753-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extracted series from the previous v2 of "Introduce locking for reset
requests". If consensus is reached over the implementation details,
respective series for object and set element reset follow.

Changes since v2:
- Aim at nf-next with this.
- Refactoring of nft_rule_dump_ctx already accepted.
- New patch 1 streamlining the changes in the remaining patches.
- Some reorg of local variables.

Phil Sutter (3):
  netfilter: nf_tables: Open-code audit log call in nf_tables_getrule()
  netfilter: nf_tables: Introduce nf_tables_getrule_single()
  netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests

 net/netfilter/nf_tables_api.c | 139 +++++++++++++++++++++++++---------
 1 file changed, 104 insertions(+), 35 deletions(-)

-- 
2.41.0

