Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE77C43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 17:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B8ED20657
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 17:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732331AbfFXRKu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 13:10:50 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51486 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732329AbfFXRKu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 13:10:50 -0400
Received: from localhost ([::1]:36344 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hfSUT-0003Zk-4W; Mon, 24 Jun 2019 19:10:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] main: Bail if non-available JSON was requested
Date:   Mon, 24 Jun 2019 19:10:38 +0200
Message-Id: <20190624171038.24672-3-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190624171038.24672-1-phil@nwl.cc>
References: <20190624171038.24672-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If user passes '-j' flag, falling back to standard syntax output
probably causes more harm than good so instead print an error message
and exit(1).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/main.c b/src/main.c
index 9a50f30f850b2..cbfd69a42d045 100644
--- a/src/main.c
+++ b/src/main.c
@@ -277,6 +277,9 @@ int main(int argc, char * const *argv)
 		case OPT_JSON:
 #ifdef HAVE_LIBJANSSON
 			output_flags |= NFT_CTX_OUTPUT_JSON;
+#else
+			fprintf(stderr, "JSON support not compiled-in\n");
+			exit(EXIT_FAILURE);
 #endif
 			break;
 		case OPT_GUID:
-- 
2.21.0

