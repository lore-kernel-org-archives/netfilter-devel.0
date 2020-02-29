Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0997C3F2CE
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CDA82469C
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Z+s6h7l7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgB2Loh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:44:37 -0500
Received: from kadath.azazel.net ([81.187.231.250]:49546 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgB2Loh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:44:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vWj9xo9l2oJcrmBs677R/2Vtdjr5ezC3kYgiLOCo13g=; b=Z+s6h7l7LCCvWUkvFkqtHN14UA
        Tzcned9K9WykYc5P3oAM1lQUV9CKRnqbI2aZRkEe+KSUMZmzIN43Zdl2ggIPYMAee+GqiOLGATYuy
        crpPOxS/jyhZdQ8fftDQdmrjTkKdpLcAvIHNJzRyYBFhDiHsIw0lpnPSMMKoz/qC9BCWSPsSYh/0U
        /+ag76UElwgs+C9npYYJZJK8AjKhbjZ537PRzMJPaTI0yn4UBZhXabNBayeGQ0EIXF9NAgmOJlt/J
        1LhQ9sfLXN13SLnGuUDibftH0wHK3eLaMLiKrp68TS9ageeP9E0CBStDn0mKrEHo3xKWEQoC4V8te
        HR2rYYnQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HN-0003Wm-Gv; Sat, 29 Feb 2020 11:27:33 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 12/18] netlink_delinearize: fix typo.
Date:   Sat, 29 Feb 2020 11:27:25 +0000
Message-Id: <20200229112731.796417-13-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200229112731.796417-1-jeremy@azazel.net>
References: <20200229112731.796417-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4fc7b764d7a9..4e5d64ede8bd 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2530,7 +2530,7 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
  * a binop expression with a munged payload expression on the left
  * and a mask to clear the real payload offset/length.
  *
- * So chech if we have one of the following binops:
+ * So check if we have one of the following binops:
  * I)
  *           binop (|)
  *       binop(&)   value/set
-- 
2.25.0

