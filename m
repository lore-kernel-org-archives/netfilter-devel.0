Return-Path: <SRS0=RvX8=7K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2C6C433E2
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 05:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0FF620899
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 05:42:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WE4SAKBG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgE1Fkw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 May 2020 01:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgE1Fkw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 May 2020 01:40:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CE8C05BD1E;
        Wed, 27 May 2020 22:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=P7QNZHLDU9SPyDwV+b1BobdLyPS2Aa8qPobGkmYeBSo=; b=WE4SAKBGOw/Eof/y9Xx+vXK5oA
        UVDxfHwdd33ocqUYDbHO6tLOm1/gOuEBIuh4873sJ1BN53m5aqQlQnM4x4+Uk5+T3Q9kdpXiq1P7s
        STKwqNMqLcGlp3YwupkSOuZsd3chuaWpDC1NUId7wPDDMIhlAAIw0TtP2upxC5ydzuTkSWmiCnlVB
        rP1wpD7cmDySRWgOhsx46L6+Z5EhJs6KVrIlyw6lKmHGAsgqSWeWGwND//V/D2WkCyZmWBoqxqhe3
        pIiYx2sBBLgKk0FjFdRm1mMjnt6oJNurAP5KUSM+0RTu2Z4UmDq3rXcrbPCIRZViJq+8NhkW+uUpF
        iAOMSI0A==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeBHc-0002JI-Ay; Thu, 28 May 2020 05:40:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH 01/14] cachefiles: switch to kernel_write
Date:   Thu, 28 May 2020 07:40:30 +0200
Message-Id: <20200528054043.621510-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528054043.621510-1-hch@lst.de>
References: <20200528054043.621510-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

__kernel_write doesn't take a sb_writers references, which we need here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Howells <dhowells@redhat.com>
---
 fs/cachefiles/rdwr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index e7726f5f1241c..3080cda9e8245 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -937,7 +937,7 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
 	}
 
 	data = kmap(page);
-	ret = __kernel_write(file, data, len, &pos);
+	ret = kernel_write(file, data, len, &pos);
 	kunmap(page);
 	fput(file);
 	if (ret != len)
-- 
2.26.2

