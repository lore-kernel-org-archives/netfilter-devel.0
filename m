Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23D1C76195
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 00:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4E4A206DD
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 00:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbfGUASE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 20:18:04 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48892 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbfGUASE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 20:18:04 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hozYA-0001ia-HD; Sun, 21 Jul 2019 02:18:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] src: erec: fall back to internal location if its null
Date:   Sun, 21 Jul 2019 02:14:05 +0200
Message-Id: <20190721001406.23785-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190721001406.23785-1-fw@strlen.de>
References: <20190721001406.23785-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This should never happen (we should pass valid locations to the error
reporting functions), but in case we screw up we will segfault during
error reporting.

cat crash
table inet filter {
}
table inet filter {
      chain test {
        counter
    }
}
"nft -f crash" Now reports:
internal:0:0-0: Error: No such file or directory

... which is both bogus and useless, but better than crashing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/erec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/erec.c b/src/erec.c
index c550a596b38c..28197924a82c 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -92,6 +92,9 @@ void erec_print(struct output_ctx *octx, const struct error_record *erec,
 	FILE *f;
 	int l;
 
+	if (!indesc)
+		indesc = &internal_indesc;
+
 	switch (indesc->type) {
 	case INDESC_BUFFER:
 	case INDESC_CLI:
-- 
2.21.0

