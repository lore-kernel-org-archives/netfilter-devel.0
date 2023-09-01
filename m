Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D2FCA0FE6
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 12:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbjIAMHg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 08:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjIAMHf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 08:07:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60A691
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 05:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kpJPSCVYUnW0x0djZBM0jlaPDutXMgmk9nzClMm6AgA=; b=dUzXpHkZshzlw92oY+7vPXMItw
        S93VfSGMH6dISMPLGXDF/bCfs0OkDThju6xKW7P328NZ1IZ05/yaWRWL5y58PsH3C9nuqt3owQVTv
        7veUj9SxGXS8K3HIsBhJFZTRWYxvjmh537LPYriPJA/5ihIzd/C4BGAA6yCd6vynl+iYtul/8TaR0
        PQfTl05AgSLKbZBLvGTLXb19a2FwUE9XPMFpdgD1PbpATZZrXfhlcVCynQPFLlA9w4KX4yPwrhNJQ
        sBUGfhB2SUFLITpcHREScm+F8eaqNivm8lb0qLWMrO02krYtz9YQ+M5mbsk69gzonLQTLCpcRH270
        6/8J3n2g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qc2vv-00011N-WB; Fri, 01 Sep 2023 14:07:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf PATCH] netfilter: nf_tables: uapi: Describe NFTA_RULE_CHAIN_ID
Date:   Fri,  1 Sep 2023 14:15:16 +0200
Message-ID: <20230901121516.30344-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a brief description to the enum's comment.

Fixes: 837830a4b439b ("netfilter: nf_tables: add NFTA_RULE_CHAIN_ID attribute")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 8466c2a9938f3..ca30232b7bc8a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -263,6 +263,7 @@ enum nft_chain_attributes {
  * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
  * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
  * @NFTA_RULE_POSITION_ID: transaction unique identifier of the previous rule (NLA_U32)
+ * @NFTA_RULE_CHAIN_ID: add the rule to chain by ID, alternative to @NFTA_RULE_CHAIN (NLA_U32)
  */
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
-- 
2.41.0

