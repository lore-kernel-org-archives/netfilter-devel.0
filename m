Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B122E282C
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 12:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761222165; cv=none; b=SHaFx2LbtTKEy2ovyfd7FgcGMkG7Zwwn6Z1diDw/tjbdRplDx5DYaWHiON1Th5UK0XUox/P6gmWLwrN1yfnH6v5zF98n/kF9jP1208i2swlCAvgPRJKDIR/hj/BEsmExYNHyy0I8oORVA9Lys2JYneZyhoZ+SPQYPPEM9orvEUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761222165; c=relaxed/simple;
	bh=zdYHK91j5oLoMBwNy+E64KcNCbevnaL4lp/oml0O1UE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sxZvWjltuEVTkWVTTOeo98dzK9RC48W7/bOiZ8eCffJI/hNoJ83eTakQoK3t4HySBMOH++JuqYm7eTausVw1gMGu97iS0Nh+I1ijYEtARxmT7DbOxTfGnYII+aWOmLV+21rE8S4KAcSjD0XnsryjbZlHYXZybsVFIlCesTdjiTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 576836031F; Thu, 23 Oct 2025 14:22:40 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: parser_json: fix format string bugs
Date: Thu, 23 Oct 2025 14:21:33 +0200
Message-ID: <20251023122235.13019-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After adding fmt attribute annotation:
warning: format not a string literal and no format arguments [-Wformat-security]
  131 |         erec_queue(error(&loc, err->text), ctx->msgs);
In function 'json_events_cb':
warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type '__u32' {aka 'unsigned int'} [-Wformat=]

Fix that up too.

Fixes: 586ad210368b ("libnftables: Implement JSON parser")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index e78262505d24..7b4f33848ce1 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -128,7 +128,7 @@ static void json_lib_error(struct json_ctx *ctx, json_error_t *err)
 		.last_column = err->column,
 	};
 
-	erec_queue(error(&loc, err->text), ctx->msgs);
+	erec_queue(error(&loc, "%s", err->text), ctx->msgs);
 }
 
 __attribute__((format(printf, 2, 3)))
@@ -4558,6 +4558,7 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
 	return ret;
 }
 
+__attribute__((format(printf, 2, 3)))
 static int json_echo_error(struct netlink_mon_handler *monh,
 			   const char *fmt, ...)
 {
@@ -4630,7 +4631,7 @@ int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
 
 	json = seqnum_to_json(nlh->nlmsg_seq);
 	if (!json) {
-		json_echo_error(monh, "No JSON command found with seqnum %lu\n",
+		json_echo_error(monh, "No JSON command found with seqnum %u\n",
 				nlh->nlmsg_seq);
 		return MNL_CB_OK;
 	}
-- 
2.51.0

