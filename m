Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BF9C10F06
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A3EC2084F
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Ap2hr1as"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfCKPOe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:14:34 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50378 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbfCKPOd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 11:14:33 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 886531A64CE
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 08:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552317273; bh=bfQM895gwJlBxDewQKS1VK2gZbLKYyxFkP4Z2SXBrYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ap2hr1asuVIoKUkXIn/gBB87vN8hYWBtG7Wd4WOZgT+3tXln1pBKRjh/TSDUVHhg9
         L34dg3LxQJsDe/ghBM592MYDtIY6TAN5L8GTVRqzqqP7CS2Z1aC7wAlR0ji+ffHlNq
         N1iRN++92GzQEOxyqhLdWpxHJE3D0C2plk7iBezI=
X-Riseup-User-ID: E8183DF00CF9D93B14984604BB0DA50B1B57DA17C2C6A3AC2AB5E81406677D58
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id ADE3D221C5D;
        Mon, 11 Mar 2019 08:14:32 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v2 4/6] doc: add osf version option to man page
Date:   Mon, 11 Mar 2019 16:14:15 +0100
Message-Id: <20190311151417.17772-4-ffmancera@riseup.net>
In-Reply-To: <20190311151417.17772-1-ffmancera@riseup.net>
References: <20190311151417.17772-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: flags type is now u32
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

