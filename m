Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F108EB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jun 2023 15:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjFVPq4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jun 2023 11:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjFVPq4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jun 2023 11:46:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5110610F8
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jun 2023 08:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EJWcIAkqGCqnNQC3m9PBwCRq7lLVRRVpW1SVzkFbTFo=; b=HzF0R2nGoC24pEQHEBl8O5a+t4
        kHt96iPOBY9jorfAPWAHmDamxckU3sV2hVKW6c3Y1k6yUsG+Iuw0F50kA78eXmtN/mYFz6rJaEquk
        sQpjQ0Ux6BDdpYrc43ptO+M36nMoAwdvvEm0uBCF1wMSYJ/bvr5LjX5VbHZgkJHnWqABEDiq1G19J
        dfVaiZOdjjbAeuNv11eYNUtVll1QRnvB5O8PlSaRghiqL0Ydc3DryBrnO7A9xPgV3HCPTXZoCnBIS
        h59FpxTxYWsqALWzWcHPf8/ZIdSRX+FLfLsqHiZ/e718jBX0Sbf/ozNpOLoesXc4Jx/K5Iz/toE18
        JNFRv3KQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qCMWL-0001sX-Ky; Thu, 22 Jun 2023 17:46:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/4] main: Make 'buf' variable branch-local
Date:   Thu, 22 Jun 2023 17:46:31 +0200
Message-Id: <20230622154634.25862-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230622154634.25862-1-phil@nwl.cc>
References: <20230622154634.25862-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is used only to linearize non-option argv for passing to
nft_run_cmd_from_buffer(), reduce its scope. Allows to safely move the
free() call there, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/main.c b/src/main.c
index cb20850b71c5b..a1592c1823f49 100644
--- a/src/main.c
+++ b/src/main.c
@@ -361,9 +361,9 @@ int main(int argc, char * const *argv)
 	const struct option *options = get_options();
 	bool interactive = false, define = false;
 	const char *optstring = get_optstring();
-	char *buf = NULL, *filename = NULL;
 	unsigned int output_flags = 0;
 	unsigned int debug_mask;
+	char *filename = NULL;
 	unsigned int len;
 	int i, val, rc;
 
@@ -514,6 +514,8 @@ int main(int argc, char * const *argv)
 	nft_ctx_output_set_flags(nft, output_flags);
 
 	if (optind != argc) {
+		char *buf;
+
 		for (len = 0, i = optind; i < argc; i++)
 			len += strlen(argv[i]) + strlen(" ");
 
@@ -529,6 +531,7 @@ int main(int argc, char * const *argv)
 				strcat(buf, " ");
 		}
 		rc = !!nft_run_cmd_from_buffer(nft, buf);
+		free(buf);
 	} else if (filename != NULL) {
 		rc = !!nft_run_cmd_from_filename(nft, filename);
 	} else if (interactive) {
@@ -543,7 +546,6 @@ int main(int argc, char * const *argv)
 		exit(EXIT_FAILURE);
 	}
 
-	free(buf);
 	nft_ctx_free(nft);
 
 	return rc;
-- 
2.40.0

