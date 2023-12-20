Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04336482EA
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="A2MCvl/1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NwqnKsVeW+XpML0fFO2dz/fpeI6aiEb3WnQruls1zo8=; b=A2MCvl/1f7Bli3+js36YxorT2x
	9GswGhTo8L9FbFjuyUfpHmVT6qRKRd00v0WVQTDQiAeI4Abno3PYYGpyih+Dge1XqVtomcPllX/EZ
	l9Pf0vzp+n5p50KHGvmTEoxAS0JdF4Ad93OHodNgP9BWG3r+fzS5qwea8aI/Sie9u92Q7ZdiW55KV
	cDFjwInEOQwzInJQZY8ZdaCTTXKuq7Xz/uKATeJMGbEri8v4ghvJVLrZJ5ZHti7vffisGwr/FVDXr
	i/Fc2vdTqry6r2Anx7Wa20WSC+XAHRyWBEUz1JSdRVccQfm/kVrefacJZJcMxOj/bvk34DTnrOXdK
	lbSTcdPw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5r-0004Lb-IW
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 21/23] extensions: libebt_pkttype: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:34 +0100
Message-ID: <20231220160636.11778-22-phil@nwl.cc>
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

Not much to gain here. Maybe implement number parsing with fallback to
get rid of that part from extension parsers?

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_pkttype.c | 45 +++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/extensions/libebt_pkttype.c b/extensions/libebt_pkttype.c
index 4e2d19de7983b..b01b83a1f1f45 100644
--- a/extensions/libebt_pkttype.c
+++ b/extensions/libebt_pkttype.c
@@ -9,7 +9,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <netdb.h>
 #include <xtables.h>
 #include <linux/if_packet.h>
@@ -25,10 +24,14 @@ static const char *classes[] = {
 	"fastroute",
 };
 
-static const struct option brpkttype_opts[] =
-{
-	{ "pkttype-type"        , required_argument, 0, '1' },
-	{ 0 }
+enum {
+	O_TYPE,
+};
+
+static const struct xt_option_entry brpkttype_opts[] = {
+	{ .name = "pkttype-type", .id = O_TYPE, .type = XTTYPE_STRING,
+	  .flags = XTOPT_INVERT },
+	XTOPT_TABLEEND,
 };
 
 static void brpkttype_print_help(void)
@@ -40,37 +43,35 @@ static void brpkttype_print_help(void)
 }
 
 
-static int brpkttype_parse(int c, char **argv, int invert, unsigned int *flags,
-			   const void *entry, struct xt_entry_match **match)
+static void brpkttype_parse(struct xt_option_call *cb)
 {
-	struct ebt_pkttype_info *ptinfo = (struct ebt_pkttype_info *)(*match)->data;
-	char *end;
+	struct ebt_pkttype_info *ptinfo = cb->data;
 	long int i;
+	char *end;
+
+	xtables_option_parse(cb);
 
-	switch (c) {
-	case '1':
-		if (invert)
-			ptinfo->invert = 1;
-		i = strtol(optarg, &end, 16);
+	switch (cb->entry->id) {
+	case O_TYPE:
+		ptinfo->invert = cb->invert;
+		i = strtol(cb->arg, &end, 16);
 		if (*end != '\0') {
 			for (i = 0; i < ARRAY_SIZE(classes); i++) {
-				if (!strcasecmp(optarg, classes[i]))
+				if (!strcasecmp(cb->arg, classes[i]))
 					break;
 			}
 			if (i >= ARRAY_SIZE(classes))
-				xtables_error(PARAMETER_PROBLEM, "Could not parse class '%s'", optarg);
+				xtables_error(PARAMETER_PROBLEM,
+					      "Could not parse class '%s'",
+					      cb->arg);
 		}
 		if (i < 0 || i > 255)
 			xtables_error(PARAMETER_PROBLEM, "Problem with specified pkttype class");
 		ptinfo->pkt_type = (uint8_t)i;
 		break;
-	default:
-		return 0;
 	}
-	return 1;
 }
 
-
 static void brpkttype_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct ebt_pkttype_info *pt = (struct ebt_pkttype_info *)match->data;
@@ -107,10 +108,10 @@ static struct xtables_match brpkttype_match = {
 	.size		= XT_ALIGN(sizeof(struct ebt_pkttype_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_pkttype_info)),
 	.help		= brpkttype_print_help,
-	.parse		= brpkttype_parse,
+	.x6_parse	= brpkttype_parse,
 	.print		= brpkttype_print,
 	.xlate		= brpkttype_xlate,
-	.extra_opts	= brpkttype_opts,
+	.x6_options	= brpkttype_opts,
 };
 
 void _init(void)
-- 
2.43.0

