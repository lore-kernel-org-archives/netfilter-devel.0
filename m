Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D06C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 12:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B05322074D
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 12:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YkE5+1YF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbgFOMOm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 08:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729701AbgFOMNI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 08:13:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535A8C061A0E;
        Mon, 15 Jun 2020 05:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jzV+T85fyIY/sAf/kMztKfiAVfq1VzZmIi5LCeoOypo=; b=YkE5+1YFVkKtHugpo6WqOnTtwW
        kaLbsbL3/1HgqpHrPc8HQQypbti2XhcEfHqm/BLrXH7gp5PrKbtn1a/4aW2UO030MbnxScOFjKZDT
        7WiHrFJYAjLprSF8qpopP9Ffzrshvl42OFZcuQwUkIJVAAp6ZZCPNx4azD3YP4ME4c/XqnXj7Rh8B
        cCTny3XhqYbArIWAKoUiCrBArWdQ95SkuHOCkKRjLKEZELiGtofRV8HE1WesGep5P1HcbxmQkxn2b
        BpUPHSzHqZsJUaym0xhC4KLaRrmRgkhj3xgx+YPJid2y7ejwl7hJN6G/+C+FC62Egg1g8eE7URdrw
        O9aWCwIg==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jknz7-0006zO-Ie; Mon, 15 Jun 2020 12:13:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH 02/13] autofs: switch to kernel_write
Date:   Mon, 15 Jun 2020 14:12:46 +0200
Message-Id: <20200615121257.798894-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200615121257.798894-1-hch@lst.de>
References: <20200615121257.798894-1-hch@lst.de>
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
Acked-by: Ian Kent <raven@themaw.net>
---
 fs/autofs/waitq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs/waitq.c b/fs/autofs/waitq.c
index b04c528b19d342..74c886f7c51cbe 100644
--- a/fs/autofs/waitq.c
+++ b/fs/autofs/waitq.c
@@ -53,7 +53,7 @@ static int autofs_write(struct autofs_sb_info *sbi,
 
 	mutex_lock(&sbi->pipe_mutex);
 	while (bytes) {
-		wr = __kernel_write(file, data, bytes, &file->f_pos);
+		wr = kernel_write(file, data, bytes, &file->f_pos);
 		if (wr <= 0)
 			break;
 		data += wr;
-- 
2.26.2

