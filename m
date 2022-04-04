Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4271BC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344175AbiDDM37 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344310AbiDDM37 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:29:59 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC4E3DDE5
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+tMeOfFNy/xK7ES4mtzrYCI73dTzTeZ+cjq9W3wiHsU=; b=E1dPuVFJMv0+HufxsnIMOpnDby
        QY85ywO82pOXSfdNY0qcW4BFVORQ/oK4Ll4adV0WQ/GYZX0TQ25jdoCWmxNVwloo3kfNqEL85o2Q5
        ocElfixwpAelqqfiY8G9hTE8z6jNStmE2xYO+bK+WyxVY+BDOL38IsjZi6OAGXzfSloC/ywd6k3cK
        1Vdq+cVnNQK2kwXugKxTiOyY5SkpARLefLq+7/CRiVFsJoyKeSFpE39cpOh6xXOjZ8s/Ms9pDRNk4
        S1qKbLOPEITCYXzLOlPss6/18lAHiCAhQvqwoMIQ516NDAL9gdEZhShScUgJ/g2y0vcuhLm5epgZz
        ywO4YSlw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbK-007FTC-PU; Mon, 04 Apr 2022 13:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 24/32] netlink_delinearize: fix typo
Date:   Mon,  4 Apr 2022 13:14:02 +0100
Message-Id: <20220404121410.188509-25-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9f6fdee3e92d..8f19594a1633 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2878,7 +2878,7 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
  * a binop expression with a munged payload expression on the left
  * and a mask to clear the real payload offset/length.
  *
- * So chech if we have one of the following binops:
+ * So check if we have one of the following binops:
  * I)
  *           binop (|)
  *       binop(&)   value/set
-- 
2.35.1

