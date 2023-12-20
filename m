Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9551346BB3
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RpR286P2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1pWAFbeBzfGwJpINmW80uTP4w9R7Uci1v6WTD7E9/YM=; b=RpR286P2oG40s13BNlELaO3nAi
	/cqVRK1FG0Iw8W69k11uqCP1PfCcTGCWkaP0X66FiiETSFDkqDaM66EhNMVvub6IWCiNy7MO1DHsp
	vKypnqam3xM6T40aB0bSYsYr/UfgBlebbueB54/DYEAqlasYUJAaKXV6uVEyXKKCIHYfA8pfkIIjs
	WsYJkVsjELFB9Yhbn6Vl6Jm5HKAs9d2/0EatFLWJ2Kqav1s8hzqA1+SeFNrSRN1YkYmlIK0q5BAzt
	skv44AF08jGNSj7N9TBe8qYWG3ssknWrtFlZna5T4eab79HzG/udkVRlWFl87rC65shSqxE31M5Sp
	sh6UzBIg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5n-0004L2-VZ
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:44 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 08/23] extensions: libebt_arpreply: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:21 +0100
Message-ID: <20231220160636.11778-9-phil@nwl.cc>
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
 extensions/libebt_arpreply.c | 52 +++++++++++++-----------------------
 extensions/libebt_arpreply.t |  4 +++
 2 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/extensions/libebt_arpreply.c b/extensions/libebt_arpreply.c
index 80ba2159ff946..1d6ba36a27b03 100644
--- a/extensions/libebt_arpreply.c
+++ b/extensions/libebt_arpreply.c
@@ -10,22 +10,22 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <netinet/ether.h>
 #include <linux/netfilter_bridge/ebt_arpreply.h>
 #include "iptables/nft.h"
 #include "iptables/nft-bridge.h"
 
-#define OPT_REPLY_MAC     0x01
-#define OPT_REPLY_TARGET  0x02
+enum {
+	O_MAC,
+	O_TARGET,
+};
 
-#define REPLY_MAC '1'
-#define REPLY_TARGET '2'
-static const struct option brarpreply_opts[] = {
-	{ "arpreply-mac" ,    required_argument, 0, REPLY_MAC    },
-	{ "arpreply-target" , required_argument, 0, REPLY_TARGET },
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry brarpreply_opts[] = {
+	{ .name = "arpreply-mac" ,    .id = O_MAC, .type = XTTYPE_ETHERMAC,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_arpreply_info, mac) },
+	{ .name = "arpreply-target" , .id = O_TARGET, .type = XTTYPE_STRING },
+	XTOPT_TABLEEND,
 };
 
 static void brarpreply_print_help(void)
@@ -44,31 +44,15 @@ static void brarpreply_init(struct xt_entry_target *target)
 	replyinfo->target = EBT_DROP;
 }
 
-static int
-brarpreply_parse(int c, char **argv, int invert, unsigned int *flags,
-	    const void *entry, struct xt_entry_target **tg)
-
+static void brarpreply_parse(struct xt_option_call *cb)
 {
-	struct ebt_arpreply_info *replyinfo = (void *)(*tg)->data;
-	struct ether_addr *addr;
-
-	switch (c) {
-	case REPLY_MAC:
-		EBT_CHECK_OPTION(flags, OPT_REPLY_MAC);
-		if (!(addr = ether_aton(optarg)))
-			xtables_error(PARAMETER_PROBLEM, "Problem with specified --arpreply-mac mac");
-		memcpy(replyinfo->mac, addr, ETH_ALEN);
-		break;
-	case REPLY_TARGET:
-		EBT_CHECK_OPTION(flags, OPT_REPLY_TARGET);
-		if (ebt_fill_target(optarg, (unsigned int *)&replyinfo->target))
-			xtables_error(PARAMETER_PROBLEM, "Illegal --arpreply-target target");
-		break;
+	struct ebt_arpreply_info *replyinfo = cb->data;
 
-	default:
-		return 0;
-	}
-	return 1;
+	xtables_option_parse(cb);
+	if (cb->entry->id == O_TARGET &&
+	    ebt_fill_target(cb->arg, (unsigned int *)&replyinfo->target))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Illegal --arpreply-target target");
 }
 
 static void brarpreply_print(const void *ip, const struct xt_entry_target *t, int numeric)
@@ -90,9 +74,9 @@ static struct xtables_target arpreply_target = {
 	.size		= XT_ALIGN(sizeof(struct ebt_arpreply_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_arpreply_info)),
 	.help		= brarpreply_print_help,
-	.parse		= brarpreply_parse,
+	.x6_parse	= brarpreply_parse,
 	.print		= brarpreply_print,
-	.extra_opts	= brarpreply_opts,
+	.x6_options	= brarpreply_opts,
 };
 
 void _init(void)
diff --git a/extensions/libebt_arpreply.t b/extensions/libebt_arpreply.t
index 6734501a106b5..66103e16dcd42 100644
--- a/extensions/libebt_arpreply.t
+++ b/extensions/libebt_arpreply.t
@@ -1,4 +1,8 @@
 :PREROUTING
 *nat
+-j arpreply;=;FAIL
+-p ARP -i foo -j arpreply;-p ARP -i foo -j arpreply --arpreply-mac 00:00:00:00:00:00;OK
 -p ARP -i foo -j arpreply --arpreply-mac de:ad:00:be:ee:ff --arpreply-target ACCEPT;=;OK
 -p ARP -i foo -j arpreply --arpreply-mac de:ad:00:be:ee:ff;=;OK
+-p ARP -j arpreply ! --arpreply-mac de:ad:00:be:ee:ff;;FAIL
+-p ARP -j arpreply --arpreply-mac de:ad:00:be:ee:ff ! --arpreply-target ACCEPT;;FAIL
-- 
2.43.0

