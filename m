From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 1/3] parser: Add operation not supported error message
Date: Mon, 16 Mar 2015 16:06:09 +0100
Message-ID: <1426518371-11717-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34958 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbbCPPFx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 11:05:53 -0400
Received: by wgdm6 with SMTP id m6so42427088wgd.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 08:05:51 -0700 (PDT)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id s19sm15725928wik.18.2015.03.16.08.05.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2015 08:05:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we try to import a ruleset in json or xml and the operation is not
supported, we don't show any error message to this case.

This patch adds a new error path if the operation is not supported.
Moreover, this patch sets up this error by default when we create the
structure nft_parse_err.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/libnftnl/common.h |    1 +
 src/common.c              |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
index f8f1304..d92b170 100644
--- a/include/libnftnl/common.h
+++ b/include/libnftnl/common.h
@@ -7,6 +7,7 @@ enum {
 	NFT_PARSE_EBADINPUT	= 0,
 	NFT_PARSE_EMISSINGNODE,
 	NFT_PARSE_EBADTYPE,
+	NFT_PARSE_OPNOTSUPP,
 };
 
 enum nft_output_type {
diff --git a/src/common.c b/src/common.c
index 7fce48e..fc0bc97 100644
--- a/src/common.c
+++ b/src/common.c
@@ -44,7 +44,15 @@ EXPORT_SYMBOL(nft_nlmsg_build_hdr);
 
 struct nft_parse_err *nft_parse_err_alloc(void)
 {
-	return calloc(1, sizeof(struct nft_parse_err));
+	struct nft_parse_err *err;
+
+	err = calloc(1, sizeof(struct nft_parse_err));
+	if (err == NULL)
+		return NULL;
+
+	err->error = NFT_PARSE_OPNOTSUPP;
+
+	return err;
 }
 EXPORT_SYMBOL(nft_parse_err_alloc);
 
@@ -66,6 +74,8 @@ int nft_parse_perror(const char *msg, struct nft_parse_err *err)
 	case NFT_PARSE_EBADTYPE:
 		return fprintf(stderr, "%s: Invalid type in node \"%s\"\n",
 			       msg, err->node_name);
+	case NFT_PARSE_OPNOTSUPP:
+		return fprintf(stderr, "%s: Operation not supported\n", msg);
 	default:
 		return fprintf(stderr, "%s: Undefined error\n", msg);
 	}
-- 
1.7.10.4

