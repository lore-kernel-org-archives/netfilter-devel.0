Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDF4487B3
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iR96e90d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Jwztqf7Mv5R8pNdNEi14gN+LNlitXZ0Tzjnw1yt/8SM=; b=iR96e90dU58Xe8LgRjCUEkCY9u
	yFWr+XiG+NkzV7HF8JpW83t5kTb5BgkeirqgrI2jtkiIuNADjDEl6Mni3XLM3tdrp8m8aseqtjvjb
	ZTJqyydh2Z3xgOcoYaIpe7EY2OLKnGVxXGjySukvdku6FLe4bTfrnt5RlG2Ywa+MWlEcSJ/rkQyB7
	4hYcfjJYb4LmS/eUTnzB/tqIUtkIE1XskUyQniLBppQ3Nam2VG7sfooquH1ACAH4Df0ysj8l09F76
	NGMzGKz03CSpcLkPsnST76Qtmp8ZOq98G+qf/s6nmyE9OqZ+2hPOEEzLgen50YGtYbeNywE+a0Y5B
	q9mYN7LQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5u-0004MF-SS
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:50 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 17/23] extensions: libebt_802_3: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:30 +0100
Message-ID: <20231220160636.11778-18-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160636.11778-1-phil@nwl.cc>
References: <20231220160636.11778-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_802_3.c | 74 ++++++++++-----------------------------
 extensions/libebt_802_3.t |  2 ++
 2 files changed, 21 insertions(+), 55 deletions(-)

diff --git a/extensions/libebt_802_3.c b/extensions/libebt_802_3.c
index 8cbcdcea4912f..26a7725cd0074 100644
--- a/extensions/libebt_802_3.c
+++ b/extensions/libebt_802_3.c
@@ -13,17 +13,20 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter_bridge/ebt_802_3.h>
 
-#define _802_3_SAP	'1'
-#define _802_3_TYPE	'2'
-
-static const struct option br802_3_opts[] = {
-	{ .name = "802_3-sap",	.has_arg = true, .val = _802_3_SAP },
-	{ .name = "802_3-type",	.has_arg = true, .val = _802_3_TYPE },
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry br802_3_opts[] =
+{
+	{ .name = "802_3-sap", .id = EBT_802_3_SAP,
+	  .type = XTTYPE_UINT8, .base = 16,
+	  .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_802_3_info, sap) },
+	{ .name = "802_3-type", .id = EBT_802_3_TYPE,
+	  .type = XTTYPE_UINT16, .base = 16,
+	  .flags = XTOPT_INVERT | XTOPT_PUT | XTOPT_NBO,
+	  XTOPT_POINTER(struct ebt_802_3_info, type) },
+	XTOPT_TABLEEND,
 };
 
 static void br802_3_print_help(void)
@@ -36,52 +39,14 @@ static void br802_3_print_help(void)
 "  Type implies SAP value 0xaa\n");
 }
 
-static int
-br802_3_parse(int c, char **argv, int invert, unsigned int *flags,
-	      const void *entry, struct xt_entry_match **match)
+static void br802_3_parse(struct xt_option_call *cb)
 {
-	struct ebt_802_3_info *info = (struct ebt_802_3_info *) (*match)->data;
-	unsigned int i;
-	char *end;
-
-	switch (c) {
-	case _802_3_SAP:
-		if (invert)
-			info->invflags |= EBT_802_3_SAP;
-		i = strtoul(optarg, &end, 16);
-		if (i > 255 || *end != '\0')
-			xtables_error(PARAMETER_PROBLEM,
-				      "Problem with specified "
-					"sap hex value, %x",i);
-		info->sap = i; /* one byte, so no byte order worries */
-		info->bitmask |= EBT_802_3_SAP;
-		break;
-	case _802_3_TYPE:
-		if (invert)
-			info->invflags |= EBT_802_3_TYPE;
-		i = strtoul(optarg, &end, 16);
-		if (i > 65535 || *end != '\0') {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Problem with the specified "
-					"type hex value, %x",i);
-		}
-		info->type = htons(i);
-		info->bitmask |= EBT_802_3_TYPE;
-		break;
-	default:
-		return 0;
-	}
+	struct ebt_802_3_info *info = cb->data;
 
-	*flags |= info->bitmask;
-	return 1;
-}
-
-static void
-br802_3_final_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			      "You must specify proper arguments");
+	xtables_option_parse(cb);
+	info->bitmask |= cb->entry->id;
+	if (cb->invert)
+		info->invflags |= cb->entry->id;
 }
 
 static void br802_3_print(const void *ip, const struct xt_entry_match *match,
@@ -112,10 +77,9 @@ static struct xtables_match br802_3_match =
 	.size		= XT_ALIGN(sizeof(struct ebt_802_3_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_802_3_info)),
 	.help		= br802_3_print_help,
-	.parse		= br802_3_parse,
-	.final_check	= br802_3_final_check,
+	.x6_parse	= br802_3_parse,
 	.print		= br802_3_print,
-	.extra_opts	= br802_3_opts,
+	.x6_options	= br802_3_opts,
 };
 
 void _init(void)
diff --git a/extensions/libebt_802_3.t b/extensions/libebt_802_3.t
index a138f35d2c756..2e4945b388830 100644
--- a/extensions/libebt_802_3.t
+++ b/extensions/libebt_802_3.t
@@ -1,5 +1,7 @@
 :INPUT,FORWARD,OUTPUT
 --802_3-sap ! 0x0a -j CONTINUE;=;FAIL
 --802_3-type 0x000a -j RETURN;=;FAIL
+-p Length --802_3-sap 0x0a -j CONTINUE;=;OK
 -p Length --802_3-sap ! 0x0a -j CONTINUE;=;OK
 -p Length --802_3-type 0x000a -j RETURN;=;OK
+-p Length --802_3-type ! 0x000a -j RETURN;=;OK
-- 
2.43.0

