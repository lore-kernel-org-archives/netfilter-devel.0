Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A528CA9EBA
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 20:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4FD820B7C
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 20:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="vDyXk3D/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbfJVU65 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 16:58:57 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44384 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731093AbfJVU65 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 16:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a/YD0t1Tg1mxyVmrlgKUPdsqlNxwDYFO1c7/k11pLTE=; b=vDyXk3D/fT+dHA6XkSh9hnaD/W
        XkeTgZ+gF6Ao/lMD9/dVMROYBFXhPzFqItK93x4C5Dk5xhFbY36dOiD27d5BVT5QFIes2rqzm8xA0
        mbneTsEn8zip+IL0Bvraja4le9uZpJ/SrcY2cvAy0yRTLWmtE7xByIlqzc+lUINBYXCp7mgCnIDUE
        XMEJAZxfQazZwb1IJDRQb4bEhlyagp0axw+0fpsDUM2MwAmObwrajw74kPebU9L2U6gK05+usNt7t
        P89hhwoMyPcldV5llEwGzdl0ZAEmQ2N5ggm2+xGclJw0sak2d0Dlm3R+djrWy0rG41SWKcNhKpFOd
        RBZegRnQ==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iN1F1-0002CC-QD; Tue, 22 Oct 2019 21:58:55 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 4/4] main: remove duplicate output flag assignment.
Date:   Tue, 22 Oct 2019 21:58:55 +0100
Message-Id: <20191022205855.22507-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191022205855.22507-1-jeremy@azazel.net>
References: <20191022205855.22507-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`NFT_CTX_OUTPUT_NUMERIC_TIME` is implicit in
`NFT_CTX_OUTPUT_NUMERIC_ALL`: there are is no need explicitly to OR it
into output_flags when `--numeric` is passed.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/main.c b/src/main.c
index c1c404e14eeb..a3b752384996 100644
--- a/src/main.c
+++ b/src/main.c
@@ -245,7 +245,6 @@ int main(int argc, char * const *argv)
 			break;
 		case OPT_NUMERIC:
 			output_flags |= NFT_CTX_OUTPUT_NUMERIC_ALL;
-			output_flags |= NFT_CTX_OUTPUT_NUMERIC_TIME;
 			break;
 		case OPT_STATELESS:
 			output_flags |= NFT_CTX_OUTPUT_STATELESS;
-- 
2.23.0

