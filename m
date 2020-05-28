Return-Path: <SRS0=RvX8=7K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC61BC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 05:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82FED20899
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 05:41:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mol6D5Y6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgE1FlJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 May 2020 01:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgE1FlH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 May 2020 01:41:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAB0C05BD1E;
        Wed, 27 May 2020 22:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=KaeJEwRFrws3Sr3qqEXI33NXZ5dPCgwGDFfFGJ19P54=; b=Mol6D5Y6R1D9e/F+LW7O82xptB
        MXB9jwA/QH+Hy8SHPKIE9AY9NCg51MAr4nUECczMrcFA59wgSqI56QKnTwMKW8xnVPTIvWueF3Vjj
        wUjh9xIDDhLot3gscNRfjixZC3vxMYAXKIYdFh2na+jSY2GxnKgpVrj5s0hDa0x8x2/zYfI3y3C5D
        9tG6RDPUNrJN50tE6EuOyTdH7CpXpQuolVZVJkyGt3GRsQBsVAQqfsgNcbnPrwZKWOB4LR/EdllWc
        HLmPUy75V5oNVKaiRQ8gc15+2dI5tvYkt/SivPutaMVICY8GnP5Z+EHB8elXuF2qm9HZIWk5WlReh
        5mZSaSMA==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeBHs-0002Nk-G0; Thu, 28 May 2020 05:41:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH 07/14] fs: implement kernel_write using __kernel_write
Date:   Thu, 28 May 2020 07:40:36 +0200
Message-Id: <20200528054043.621510-8-hch@lst.de>
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

Consolidate the two in-kernel write helpers to make upcoming changes
easier.  The only difference are the missing call to rw_verify_area
in kernel_write, and an access_ok check that doesn't make sense for
kernel buffers to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index f0768313ea010..abb84391cfbc5 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -499,6 +499,7 @@ static ssize_t __vfs_write(struct file *file, const char __user *p,
 		return -EINVAL;
 }
 
+/* caller is responsible for file_start_write/file_end_write */
 ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t *pos)
 {
 	mm_segment_t old_fs;
@@ -528,16 +529,16 @@ ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t
 ssize_t kernel_write(struct file *file, const void *buf, size_t count,
 			    loff_t *pos)
 {
-	mm_segment_t old_fs;
-	ssize_t res;
+	ssize_t ret;
 
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-	/* The cast to a user pointer is valid due to the set_fs() */
-	res = vfs_write(file, (__force const char __user *)buf, count, pos);
-	set_fs(old_fs);
+	ret = rw_verify_area(WRITE, file, pos, count);
+	if (ret)
+		return ret;
 
-	return res;
+	file_start_write(file);
+	ret =  __kernel_write(file, buf, count, pos);
+	file_end_write(file);
+	return ret;
 }
 EXPORT_SYMBOL(kernel_write);
 
-- 
2.26.2

