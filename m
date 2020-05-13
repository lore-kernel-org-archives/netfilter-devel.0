Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB1BC2D0F9
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF54D20784
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qw6git+s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgEMG5L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 02:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730102AbgEMG5J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 02:57:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02187C061A0C;
        Tue, 12 May 2020 23:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4NVlnvH2L/cYRkCm5hQ2+fmz61uNYxGY9AD8xRJmRwA=; b=qw6git+sAifH6bMLJfZjlTewqv
        NLYeyPpqOsrNb12Q/x74J6RUbZnCfLNC5LdjTVEEFwfGJfKBB0Wm7PDyFPN1UNb3oQ27qwe4LfquV
        n9B70V72NPokt4O83Uk4pqSA3g44vBfAfEqvDwHCLmAlSqEzXTrlB9LChlwI7BuINURQxW8lfX4Si
        nYRfdu068mzXy9s69bisvyPSKvUAfHsSRRXeiTBp2od5dmj1i8DzcZQmqhaaSF197SUpha1/eWpKR
        TJPw8Khm8txu1ybGChXX7D23/VEj9UGeEJJSdSh/fgBSLwd2Sy76eelS8Sr2zC7kYO6qBaIh/H8r7
        YlyNgQKw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYlKE-0003VT-6N; Wed, 13 May 2020 06:57:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Ian Kent <raven@themaw.net>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH 03/14] bpfilter: switch to kernel_write
Date:   Wed, 13 May 2020 08:56:45 +0200
Message-Id: <20200513065656.2110441-4-hch@lst.de>
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

While pipes don't really need sb_writers projection, __kernel_write is an
interface better kept private, and the additional rw_verify_area does not
hurt here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/bpfilter/bpfilter_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index c0f0990f30b60..1905e01c3aa9a 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -50,7 +50,7 @@ static int __bpfilter_process_sockopt(struct sock *sk, int optname,
 	req.len = optlen;
 	if (!bpfilter_ops.info.pid)
 		goto out;
-	n = __kernel_write(bpfilter_ops.info.pipe_to_umh, &req, sizeof(req),
+	n = kernel_write(bpfilter_ops.info.pipe_to_umh, &req, sizeof(req),
 			   &pos);
 	if (n != sizeof(req)) {
 		pr_err("write fail %zd\n", n);
-- 
2.26.2

