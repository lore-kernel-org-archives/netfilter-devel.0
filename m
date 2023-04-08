Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D59EC77B6C
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Apr 2023 18:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjDHSS0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Apr 2023 14:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDHSS0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2023 14:18:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEE783C13;
        Sat,  8 Apr 2023 11:18:24 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nft] main: Error out when combining -i/--interactive and -f/--file
Date:   Sat,  8 Apr 2023 20:18:18 +0200
Message-Id: <20230408181818.72264-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These two options are mutually exclusive, display error in that case:

 # nft -i -f test.nft
 Error: -i/--interactive and -f/--file options cannot be combined

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/main.c b/src/main.c
index 9bd25db82343..cb20850b71c5 100644
--- a/src/main.c
+++ b/src/main.c
@@ -405,9 +405,19 @@ int main(int argc, char * const *argv)
 			nft_ctx_set_dry_run(nft, true);
 			break;
 		case OPT_FILE:
+			if (interactive) {
+				fprintf(stderr,
+					"Error: -i/--interactive and -f/--file options cannot be combined\n");
+				exit(EXIT_FAILURE);
+			}
 			filename = optarg;
 			break;
 		case OPT_INTERACTIVE:
+			if (filename) {
+				fprintf(stderr,
+					"Error: -i/--interactive and -f/--file options cannot be combined\n");
+				exit(EXIT_FAILURE);
+			}
 			interactive = true;
 			break;
 		case OPT_INCLUDEPATH:
-- 
2.30.2

