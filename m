Return-Path: <SRS0=AczV=AE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A3DC433E2
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 12:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A6A20716
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 12:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732589AbgFWMew (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jun 2020 08:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732507AbgFWMep (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jun 2020 08:34:45 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0483C061795
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2020 05:34:44 -0700 (PDT)
Received: janet.servers.dxld.at; Tue, 23 Jun 2020 14:34:43 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
Subject: [libnf_ct resend PATCH 2/8] Fix nfexp_snprintf return value docs
Date:   Tue, 23 Jun 2020 14:33:57 +0200
Message-Id: <20200623123403.31676-3-dxld@darkboxed.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200623123403.31676-1-dxld@darkboxed.org>
References: <20200623123403.31676-1-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The docs currently say "[...] Otherwise, 0 is returned."  which is just
completely wrong. Just like nfct_snprintf the expected buffer size is
returned.

Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
---
 src/expect/api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/expect/api.c b/src/expect/api.c
index 33099d8..39cd092 100644
--- a/src/expect/api.c
+++ b/src/expect/api.c
@@ -795,8 +795,9 @@ int nfexp_catch(struct nfct_handle *h)
  * 	- NFEXP_O_LAYER: include layer 3 information in the output, this is
  * 			*only* required by NFEXP_O_DEFAULT.
  * 
- * On error, -1 is returned and errno is set appropiately. Otherwise,
- * 0 is returned.
+ * On error, -1 is returned and errno is set appropiately. Otherwise the
+ * size of what _would_ be written is returned, even if the size of the
+ * buffer is insufficient. This behaviour is similar to snprintf.
  */
 int nfexp_snprintf(char *buf,
 		  unsigned int size,
-- 
2.20.1

