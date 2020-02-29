Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE99C3F2C6
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16DF1246A2
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="fq0OWb2V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgB2L1f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:27:35 -0500
Received: from kadath.azazel.net ([81.187.231.250]:48664 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgB2L1e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:27:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fi6j/dfGgRtoClZIv14HWK47KAlOgpECidodpVATpX0=; b=fq0OWb2VD/iC15HWy1OmpY4/bp
        eNKgdpZZ+R9oYpd37wTsySkMBD8acu9Y2JeHsoDCXGW8xuKewFfr46mS4cfuRtOUuEih3yWqRhTI1
        8a1irzKXQqBxp0ajuhCrgBkn9g9UfpOQeKfWuB0ZpCtrd3ELnFN4BOJmFTS+FhkII76j+iUL5IloO
        X3mcBDwvNhjbM5epm+Jg8J5f5ra/3AS5g5bOq8OODYsMBEUn9RePuoHoiZESrlqkJAVfg9tspXitf
        Cq0jzNJwcdUUC+klOH22sN9JvBZKBGu57i9hYTy5y6GVEJxukB3KrT/FQgMgYY01A0mG04ZlFu74j
        roDfhE7Q==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HM-0003Wm-Fs; Sat, 29 Feb 2020 11:27:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 06/18] netlink_delinearize: set shift RHS byte-order.
Date:   Sat, 29 Feb 2020 11:27:19 +0000
Message-Id: <20200229112731.796417-7-jeremy@azazel.net>
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

The RHS operand for bitwise shift is in HBO.  Set this explicitly.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0058e2cfe42a..3c80895a43f9 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -440,6 +440,7 @@ static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
 
 	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_DATA, &nld.len);
 	right = netlink_alloc_value(loc, &nld);
+	right->byteorder = BYTEORDER_HOST_ENDIAN;
 
 	expr = binop_expr_alloc(loc, op, left, right);
 	expr->len = left->len;
-- 
2.25.0

