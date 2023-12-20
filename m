Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CD948787
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="keJzEQTT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DsMj8d7ZYLXTMYE4tGABxvfV+fwB/2elrqzyLdufm+Q=; b=keJzEQTTsCVdG9VZMJyG5nbbPP
	xpQK743pmTHtLa69u6eK9pg/GvNsKlFQwGjdI2pO1L9jjCzevqwtLcKxntL7VSBEHBlwNpLUC4fYJ
	Ngcyc1kO6YYvuv1MMXKYmOB3gXz/9bFgqpgkeEQzOdXMJwByC7wGSQATWcsOlr8jwUcR4ktGIJ+8m
	Iwn6amq1LLPGKBs++3VFvnafsVRdWPx57vK+QsgZzRQaCkxz6EmV5ii2e1bTh4lVqVnJ3eScnpJ5K
	taUGxfM5fc+OpD+N4x0g9RJLjyVBgxPRCuRaRGbWBQbyjP9umw4MmeDi9OKvVxgd67o1wat6pppJt
	VSPv9ijg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5s-0004Lp-IW
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/23] extensions: libebt_dnat: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:22 +0100
Message-ID: <20231220160636.11778-10-phil@nwl.cc>
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
 extensions/libebt_dnat.c | 64 +++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff --git a/extensions/libebt_dnat.c b/extensions/libebt_dnat.c
index 9f5f721ea79d2..447ff105b5ac5 100644
--- a/extensions/libebt_dnat.c
+++ b/extensions/libebt_dnat.c
@@ -9,21 +9,25 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <netinet/ether.h>
 #include <xtables.h>
 #include <linux/netfilter_bridge/ebt_nat.h>
 #include "iptables/nft.h"
 #include "iptables/nft-bridge.h"
 
-#define NAT_D '1'
-#define NAT_D_TARGET '2'
-static const struct option brdnat_opts[] =
+enum {
+	O_DST,
+	O_TARGET,
+};
+
+static const struct xt_option_entry brdnat_opts[] =
 {
-	{ "to-destination", required_argument, 0, NAT_D },
-	{ "to-dst"        , required_argument, 0, NAT_D },
-	{ "dnat-target"   , required_argument, 0, NAT_D_TARGET },
-	{ 0 }
+	{ .name = "to-destination", .id = O_DST, .type = XTTYPE_ETHERMAC,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_nat_info, mac) },
+	{ .name = "to-dst"        , .id = O_DST, .type = XTTYPE_ETHERMAC,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_nat_info, mac) },
+	{ .name = "dnat-target"   , .id = O_TARGET, .type = XTTYPE_STRING },
+	XTOPT_TABLEEND,
 };
 
 static void brdnat_print_help(void)
@@ -31,7 +35,8 @@ static void brdnat_print_help(void)
 	printf(
 	"dnat options:\n"
 	" --to-dst address       : MAC address to map destination to\n"
-	" --dnat-target target   : ACCEPT, DROP, RETURN or CONTINUE\n");
+	" --dnat-target target   : ACCEPT, DROP, RETURN or CONTINUE\n"
+	"                          (standard target is ACCEPT)\n");
 }
 
 static void brdnat_init(struct xt_entry_target *target)
@@ -41,35 +46,20 @@ static void brdnat_init(struct xt_entry_target *target)
 	natinfo->target = EBT_ACCEPT;
 }
 
-#define OPT_DNAT        0x01
-#define OPT_DNAT_TARGET 0x02
-static int brdnat_parse(int c, char **argv, int invert, unsigned int *flags,
-			 const void *entry, struct xt_entry_target **target)
+static void brdnat_parse(struct xt_option_call *cb)
 {
-	struct ebt_nat_info *natinfo = (struct ebt_nat_info *)(*target)->data;
-	struct ether_addr *addr;
-
-	switch (c) {
-	case NAT_D:
-		EBT_CHECK_OPTION(flags, OPT_DNAT);
-		if (!(addr = ether_aton(optarg)))
-			xtables_error(PARAMETER_PROBLEM, "Problem with specified --to-destination mac");
-		memcpy(natinfo->mac, addr, ETH_ALEN);
-		break;
-	case NAT_D_TARGET:
-		EBT_CHECK_OPTION(flags, OPT_DNAT_TARGET);
-		if (ebt_fill_target(optarg, (unsigned int *)&natinfo->target))
-			xtables_error(PARAMETER_PROBLEM, "Illegal --dnat-target target");
-		break;
-	default:
-		return 0;
-	}
-	return 1;
+	struct ebt_nat_info *natinfo = cb->data;
+
+	xtables_option_parse(cb);
+	if (cb->entry->id == O_TARGET &&
+	    ebt_fill_target(cb->arg, (unsigned int *)&natinfo->target))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Illegal --dnat-target target");
 }
 
-static void brdnat_final_check(unsigned int flags)
+static void brdnat_final_check(struct xt_fcheck_call *fc)
 {
-	if (!flags)
+	if (!fc->xflags)
 		xtables_error(PARAMETER_PROBLEM,
 			      "You must specify proper arguments");
 }
@@ -116,11 +106,11 @@ static struct xtables_target brdnat_target =
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
 	.help		= brdnat_print_help,
 	.init		= brdnat_init,
-	.parse		= brdnat_parse,
-	.final_check	= brdnat_final_check,
+	.x6_parse	= brdnat_parse,
+	.x6_fcheck	= brdnat_final_check,
 	.print		= brdnat_print,
 	.xlate		= brdnat_xlate,
-	.extra_opts	= brdnat_opts,
+	.x6_options	= brdnat_opts,
 };
 
 void _init(void)
-- 
2.43.0

