Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3748FC2D0FD
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C44D20708
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:57:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ac7jfU+K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731821AbgEMG5u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 02:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730521AbgEMG5a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 02:57:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6832C061A0C;
        Tue, 12 May 2020 23:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=v2d8pva8LsFTXWqDIrLlQ4NNcDJbw9ZGB5N3mHruM2Q=; b=Ac7jfU+K7c05lQCCDEcvbMGyeX
        FBWUEVcR/Ep1f5njna/xn1Mv9c0/iztL5/Y5A0nRqtTCsarfQNklqMM4r2fSLJlhC7YD31t3zeo6Y
        b/oAEODYLg6MW9V4E9faNzSpnTnGtCnfy21ArDOUM3DIkMNGU2g7diAM+gGXCdGvNRbXpdEP/zccy
        Kz9pK6/YD6GoKHkY88LJN51YyCFf+F8v8DZXqUhX+oJbue4D8tFqry2Bpsx/GU8iZG5mzi4OubGM/
        5p0o/qFibgfyKNz44I2wnuMdG78Qr3L++T0fDteuQsOqyGz24jN52o8j/edMQ4KAs8UKiQOq3EwHo
        5421umAw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYlKZ-0003aM-JV; Wed, 13 May 2020 06:57:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Ian Kent <raven@themaw.net>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH 11/14] integrity/ima: switch to using __kernel_read
Date:   Wed, 13 May 2020 08:56:53 +0200
Message-Id: <20200513065656.2110441-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513065656.2110441-1-hch@lst.de>
References: <20200513065656.2110441-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

__kernel_read has a bunch of additional sanity checks, and this moves
the set_fs out of non-core code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 security/integrity/iint.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index e12c4900510f6..1d20003243c3f 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -188,19 +188,7 @@ DEFINE_LSM(integrity) = {
 int integrity_kernel_read(struct file *file, loff_t offset,
 			  void *addr, unsigned long count)
 {
-	mm_segment_t old_fs;
-	char __user *buf = (char __user *)addr;
-	ssize_t ret;
-
-	if (!(file->f_mode & FMODE_READ))
-		return -EBADF;
-
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-	ret = __vfs_read(file, buf, count, &offset);
-	set_fs(old_fs);
-
-	return ret;
+	return __kernel_read(file, addr, count, &offset);
 }
 
 /*
-- 
2.26.2

