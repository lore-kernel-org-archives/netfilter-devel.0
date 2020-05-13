Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03A6C2D0FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9682923128
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:58:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eWlybqD1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbgEMG6G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 02:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730102AbgEMG5O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 02:57:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F55C061A0C;
        Tue, 12 May 2020 23:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=LiemweaQJNNyLn4dfMO7A8hjFLXFG2PuwhKLysUSths=; b=eWlybqD1KoTTOjAxPIZ2GmGWuc
        r0mVzo6v3VqIjQsb1BJnI2VjR76FE6lLwK8iPOkLkniP/nfrJ0HvsMbGVVwb9dxmOFJqw4rLzstig
        /AOO6BOIDBHii8SHUYx5IOVsShPqYwPBXLqTKTKBhFWohbuk1wq8vGYbjFt1N57z/Qy2lB5KQhtZo
        EBr/cuX/UaWaQgc1OmWk0ayffxDDRoMTObYde4/cIkEUoDzQO6pkUpiUZJvIJ7/G2keHRveErX+22
        eHW8Spdj0zreRaHWSiScS5jdBaDJFGXKD6kB8Lbt08MtLXYAF/FdfIsVQqY80hDNZp/eNDpiNTtAs
        zXXZfWsg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYlKJ-0003WJ-K9; Wed, 13 May 2020 06:57:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Ian Kent <raven@themaw.net>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH 05/14] fs: check FMODE_WRITE in __kernel_write
Date:   Wed, 13 May 2020 08:56:47 +0200
Message-Id: <20200513065656.2110441-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513065656.2110441-1-hch@lst.de>
References: <20200513065656.2110441-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We still need to check if the fѕ is open write, even for the low-level
helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index 2c601d853ff3d..76be155ad9824 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -505,6 +505,8 @@ ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t
 	const char __user *p;
 	ssize_t ret;
 
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_WRITE))
 		return -EINVAL;
 
-- 
2.26.2

