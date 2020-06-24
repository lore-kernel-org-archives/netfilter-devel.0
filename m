Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78930C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 632AA20836
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403935AbgFXNaM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 09:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389998AbgFXNaK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 09:30:10 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AE9C0613ED
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 06:30:09 -0700 (PDT)
Received: janet.servers.dxld.at; Wed, 24 Jun 2020 15:30:07 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Subject: [libnf_ct PATCH v2 2/9] Fix nfexp_snprintf return value docs
Date:   Wed, 24 Jun 2020 15:29:58 +0200
Message-Id: <20200624133005.22046-2-dxld@darkboxed.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200624133005.22046-1-dxld@darkboxed.org>
References: <20200624133005.22046-1-dxld@darkboxed.org>
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

