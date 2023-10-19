Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF5FCDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 14:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345856AbjJSODp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345616AbjJSODp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 10:03:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E9F130
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 07:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CgexEDIBur6eSe99WYHhuTfr3lINfE0KF0NSNDwKyp0=; b=PdnOlmU6hibUHXy2HHtjx4jZCT
        4h7ber0Y2bbvLVjI+5thY29R48m230GWPcdCFLKVAkIJGo+wzBNfv7y05GMWAxvCXtHwn3cZaGvmE
        a1c8Gcc5+AmuM5uRRkRq1gP2Yfn1AnTTqgD3lbJDgYCCz27F+SN0i618/JkdAZFoGZea9gHf4cm4X
        TCfnd1v8clMG8H+AEk3NC/PJWd3tpcYvLCucgw4w7QR9A7np6XYTwB9xtXKuCaNlUef+OEq1HXMj0
        0IEVMPbmTgVRqBCd0ifCNdE+y8l974jT3P5AL6cSFJNvsNG0mxu9STE+nDIA9SYz1hzQ2nMO0HIf/
        OopGt/xQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qtTci-0002PJ-VZ; Thu, 19 Oct 2023 16:03:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v4 0/3] Introduce locking for rule reset requests
Date:   Thu, 19 Oct 2023 16:03:33 +0200
Message-ID: <20231019140336.31563-1-phil@nwl.cc>
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

Changes since v3:
- Use '%.*s' format specifier as suggested by Florian.
- Add a comment as suggested by Pablo.

Phil Sutter (3):
  netfilter: nf_tables: Open-code audit log call in nf_tables_getrule()
  netfilter: nf_tables: Introduce nf_tables_getrule_single()
  netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests

 net/netfilter/nf_tables_api.c | 144 +++++++++++++++++++++++++---------
 1 file changed, 109 insertions(+), 35 deletions(-)

-- 
2.41.0

