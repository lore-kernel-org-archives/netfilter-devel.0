Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1514482EA
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dy0sX8pQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=j1ocAMd7tCs2w6rmR4ixb+c31+2WVFKhoy8zdLzP3Ow=; b=dy0sX8pQ6hijQdA7xHeBFoaSDL
	LrtMyRGb9NzOOjt2gV8FKtffwJwWWU7lDj233ayaJAvgiI2PNtmRM0SPDWzUbMYvN73307FV0jVQQ
	C8y8KQoP5QHjJJNNmqCMfXTBEy+iIweFMyMWGgmPASIBkzkWPY+c2rdBVmKYY46EwCpWf94QGqTUf
	aYm8uLrmRVCqaYILQD8YevaFyAaFiCO+84ZQ3s52niCUey1oWcZ/Ok7Vtpza1nKb13FhTjV2L8wMY
	Q7pn08KPS3g6LZ3zdrG+Ph68mjRB+KwAxDlNarbD+bY5MEvc74KSUy/YaRV2XkuI4Imy0Y/gtX4yQ
	EwBloL1A==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5p-0004LG-AC
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:45 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 15/23] extensions: libebt_snat: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:28 +0100
Message-ID: <20231220160636.11778-16-phil@nwl.cc>
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
 extensions/libebt_snat.c | 74 +++++++++++++++++-----------------------
 extensions/libebt_snat.t |  2 ++
 2 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/extensions/libebt_snat.c b/extensions/libebt_snat.c
index c1124bf32d1e5..1dc738fa5ca36 100644
--- a/extensions/libebt_snat.c
+++ b/extensions/libebt_snat.c
@@ -9,23 +9,27 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <netinet/ether.h>
 #include <xtables.h>
 #include <linux/netfilter_bridge/ebt_nat.h>
 #include "iptables/nft.h"
 #include "iptables/nft-bridge.h"
 
-#define NAT_S '1'
-#define NAT_S_TARGET '2'
-#define NAT_S_ARP '3'
-static const struct option brsnat_opts[] =
+enum {
+	O_SRC,
+	O_TARGET,
+	O_ARP,
+};
+
+static const struct xt_option_entry brsnat_opts[] =
 {
-	{ "to-source"     , required_argument, 0, NAT_S },
-	{ "to-src"        , required_argument, 0, NAT_S },
-	{ "snat-target"   , required_argument, 0, NAT_S_TARGET },
-	{ "snat-arp"      ,       no_argument, 0, NAT_S_ARP },
-	{ 0 }
+	{ .name = "to-source", .id = O_SRC, .type = XTTYPE_ETHERMAC,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_nat_info, mac) },
+	{ .name = "to-src",    .id = O_SRC, .type = XTTYPE_ETHERMAC,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_nat_info, mac) },
+	{ .name = "snat-target", .id = O_TARGET, .type = XTTYPE_STRING },
+	{ .name = "snat-arp", .id = O_ARP, .type = XTTYPE_NONE },
+	XTOPT_TABLEEND,
 };
 
 static void brsnat_print_help(void)
@@ -44,43 +48,29 @@ static void brsnat_init(struct xt_entry_target *target)
 	natinfo->target = EBT_ACCEPT;
 }
 
-#define OPT_SNAT         0x01
-#define OPT_SNAT_TARGET  0x02
-#define OPT_SNAT_ARP     0x04
-static int brsnat_parse(int c, char **argv, int invert, unsigned int *flags,
-			 const void *entry, struct xt_entry_target **target)
+static void brsnat_parse(struct xt_option_call *cb)
 {
-	struct ebt_nat_info *natinfo = (struct ebt_nat_info *)(*target)->data;
-	struct ether_addr *addr;
-
-	switch (c) {
-	case NAT_S:
-		EBT_CHECK_OPTION(flags, OPT_SNAT);
-		if (!(addr = ether_aton(optarg)))
-			xtables_error(PARAMETER_PROBLEM, "Problem with specified --to-source mac");
-		memcpy(natinfo->mac, addr, ETH_ALEN);
-		break;
-	case NAT_S_TARGET:
-		{ unsigned int tmp;
-		EBT_CHECK_OPTION(flags, OPT_SNAT_TARGET);
-		if (ebt_fill_target(optarg, &tmp))
-			xtables_error(PARAMETER_PROBLEM, "Illegal --snat-target target");
-		natinfo->target = (natinfo->target & ~EBT_VERDICT_BITS) | (tmp & EBT_VERDICT_BITS);
-		}
+	struct ebt_nat_info *natinfo = cb->data;
+	unsigned int tmp;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_TARGET:
+		if (ebt_fill_target(cb->arg, &tmp))
+			xtables_error(PARAMETER_PROBLEM,
+				      "Illegal --snat-target target");
+		natinfo->target &= ~EBT_VERDICT_BITS;
+		natinfo->target |= tmp & EBT_VERDICT_BITS;
 		break;
-	case NAT_S_ARP:
-		EBT_CHECK_OPTION(flags, OPT_SNAT_ARP);
+	case O_ARP:
 		natinfo->target ^= NAT_ARP_BIT;
 		break;
-	default:
-		return 0;
 	}
-	return 1;
 }
 
-static void brsnat_final_check(unsigned int flags)
+static void brsnat_final_check(struct xt_fcheck_call *fc)
 {
-	if (!flags)
+	if (!fc->xflags)
 		xtables_error(PARAMETER_PROBLEM,
 			      "You must specify proper arguments");
 }
@@ -133,11 +123,11 @@ static struct xtables_target brsnat_target =
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
 	.help		= brsnat_print_help,
 	.init		= brsnat_init,
-	.parse		= brsnat_parse,
-	.final_check	= brsnat_final_check,
+	.x6_parse	= brsnat_parse,
+	.x6_fcheck	= brsnat_final_check,
 	.print		= brsnat_print,
 	.xlate		= brsnat_xlate,
-	.extra_opts	= brsnat_opts,
+	.x6_options	= brsnat_opts,
 };
 
 void _init(void)
diff --git a/extensions/libebt_snat.t b/extensions/libebt_snat.t
index 639b13f300c9d..f5d02340fc576 100644
--- a/extensions/libebt_snat.t
+++ b/extensions/libebt_snat.t
@@ -2,3 +2,5 @@
 *nat
 -o someport -j snat --to-source a:b:c:d:e:f;-o someport -j snat --to-src 0a:0b:0c:0d:0e:0f --snat-target ACCEPT;OK
 -o someport+ -j snat --to-src de:ad:00:be:ee:ff --snat-target CONTINUE;=;OK
+-j snat;;FAIL
+-j snat --to-src de:ad:00:be:ee:ff;-j snat --to-src de:ad:00:be:ee:ff --snat-target ACCEPT;OK
-- 
2.43.0

