Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2779FC10F11
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 10:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5161321738
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 10:38:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="hp2S9fCu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733089AbfC0KiG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 06:38:06 -0400
Received: from mx1.riseup.net ([198.252.153.129]:55534 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbfC0KiF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 06:38:05 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 249721A64FF
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Mar 2019 03:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1553683085; bh=t2zNXC8jxqKtNOdpWvaqEsDK3ix5QeQ0rurYMf+3Gsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hp2S9fCupWHjf47P2LE5J9MB3DE+Ztir82+9GNRZV9gJCOijGq23h31C7RC+e3cur
         Saku4f3k16EvZuGsoGfIewh2VbP2+1eu4GO41+DjL8fUxthe7/OjqmDZLaNlyVphjw
         QY4MOCa2Bspg6iQkvndtT8cHZSNJWS/ATiHd8j0g=
X-Riseup-User-ID: 701AF8D5DBEE2E00C68BA934D10380F96D373C600AA12E7159127B6F99AB8541
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 43E441205E8;
        Wed, 27 Mar 2019 03:38:04 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 4/6 nft v3] doc: add osf version option to man page
Date:   Wed, 27 Mar 2019 11:37:59 +0100
Message-Id: <20190327103801.2049-4-ffmancera@riseup.net>
In-Reply-To: <20190327103801.2049-1-ffmancera@riseup.net>
References: <20190327103801.2049-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 doc/primary-expression.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index d819b24..a62ed00 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -219,6 +219,8 @@ and others) from packets with the SYN bit set.
 |ttl|
 Do TTL checks on the packet to determine the operating system.|
 string
+|version|
+Do OS version checks on the packet.|
 |name|
 Name of the OS signature to match. All signatures can be found at pf.os file.
 Use "unknown" for OS signatures that the expression could not detect.|
-- 
2.20.1

