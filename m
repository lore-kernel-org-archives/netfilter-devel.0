Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB216CA9EBB
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 20:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FAA920679
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 20:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Zxma8tpM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbfJVU65 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 16:58:57 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44382 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731583AbfJVU65 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 16:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=25quoZCCYiIyiazwz2MALf83UbZHAzPoupVaRdAasp4=; b=Zxma8tpMfDkEih2vjnk1z8SJIS
        QTk0Zs3IKjwlTkfcXKhBDavj7Xx43KM+ruqi4htTNsewLR/YznohhXDASrF8ZtlJvIDrzIqv4NM3U
        YCajekvBElWcF6DhDkSDpM8UFlOPKGGe47QSjy+CGKNNHY2RieYYRCB092tXW49IUQPGSzgzKgF78
        Hm5qIOAMEfxfusYZbjMzUevw0qxagMGRZoUTUiuS0mSKYPsM3DhffQrxLtklykbZfh/7KeU+kVmlt
        CRef+jbJqgtBfG47Km6lzFRPEQZ/9MfHXXLsEpN9EL74APtODzOfUPMmdLjTEje3EmTkgDTvKHQq8
        qZqr3PEw==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iN1F1-0002CC-LY; Tue, 22 Oct 2019 21:58:55 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 3/4] main: add missing `OPT_NUMERIC_PROTO` long option.
Date:   Tue, 22 Oct 2019 21:58:54 +0100
Message-Id: <20191022205855.22507-4-jeremy@azazel.net>
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

The `options` array is missing an entry for `OPT_NUMERIC_PROTO`.  Add a
new option, `--numeric-protocol`, consistent with the documentation.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/main.c b/src/main.c
index ebd6d7c322d7..c1c404e14eeb 100644
--- a/src/main.c
+++ b/src/main.c
@@ -116,6 +116,10 @@ static const struct option options[] = {
 		.name		= "numeric-priority",
 		.val		= OPT_NUMERIC_PRIO,
 	},
+	{
+		.name		= "numeric-protocol",
+		.val		= OPT_NUMERIC_PROTO,
+	},
 	{
 		.name		= "numeric-time",
 		.val		= OPT_NUMERIC_TIME,
-- 
2.23.0

