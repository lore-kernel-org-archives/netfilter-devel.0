Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A88AC4360F
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 201CA2084F
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="RWhv9F9f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfCKPOf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:14:35 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50402 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbfCKPOf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 11:14:35 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id E52F91A64B3
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 08:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552317275; bh=BWR8CkLIh2gYu4i/h0BBavQf5Ta0QDxeWb42Me2NHG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWhv9F9fhqknJ0DfE7g6Hu1pBpx10KxOmpd/ORyyKqVi5ly3lYkq/dzJG/+AK8Xfz
         abYuuxEQDF3qRnUIEZC/MPs1jzy32INar50Friee+nCiltAamh5t6UmSxN0v14eU1/
         2Szn9EqsRYwvSsDYPGU8HuUkrOkWIMDiiEPuA5pU=
X-Riseup-User-ID: 0024AD2E1772FB792A1DD80A6067366730EADDE07A8676E51FFD17080CBF4C77
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 1FA77221C5D;
        Mon, 11 Mar 2019 08:14:33 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v2 5/6] files: osf: update pf.os with newer OS fingerprints
Date:   Mon, 11 Mar 2019 16:14:16 +0100
Message-Id: <20190311151417.17772-5-ffmancera@riseup.net>
In-Reply-To: <20190311151417.17772-1-ffmancera@riseup.net>
References: <20190311151417.17772-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After notice that some fingerprints are outdated we have updated the most common
of them.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: flags type is now u32
---
 files/osf/pf.os | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/files/osf/pf.os b/files/osf/pf.os
index e285851..7612d76 100644
--- a/files/osf/pf.os
+++ b/files/osf/pf.os
@@ -233,6 +233,10 @@ S4:64:1:60:M*,S,T,N,W7:		Linux:2.6::Linux 2.6 (newer, 3)
 T4:64:1:60:M*,S,T,N,W7:		Linux:2.6::Linux 2.6 (newer, 4)
 
 S10:64:1:60:M*,S,T,N,W4:	Linux:3.0::Linux 3.0
+S10:64:1:60:M*,S,T,N,W6:	Linux:3.1::Linux 3.1
+S10:64:1:60:M*,S,T,N,W7:	Linux:3.4-3.10::Linux 3.4 - 3.10
+S20:64:1:60:M*,S,T,N,W7:	Linux:3.11-4.19::Linux 3.11 - 4.19
+S44:64:1:60:M*,S,T,N,W7:	Linux:4.20::Linux 4.20
 
 S3:64:1:60:M*,S,T,N,W1:		Linux:2.5::Linux 2.5 (sometimes 2.4)
 S4:64:1:60:M*,S,T,N,W1:		Linux:2.5-2.6::Linux 2.5/2.6
@@ -284,6 +288,8 @@ S22:64:1:52:M*,N,N,S,N,W0:	Linux:2.2:ts:Linux 2.2 w/o timestamps
 65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:4.7-4.11::FreeBSD 4.7-5.2
 65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:5.0-5.2::FreeBSD 4.7-5.2
 
+65535:64:1:60:M*,N,W6,S,T:	FreeBSD:9.0-12.0::FreeBSD 9.0 - 12.0
+
 # XXX need quirks support
 # 65535:64:1:60:M*,N,W0,N,N,T:Z:FreeBSD:5.1-5.4::5.1-current (1)
 # 65535:64:1:60:M*,N,W1,N,N,T:Z:FreeBSD:5.1-5.4::5.1-current (2)
-- 
2.20.1

