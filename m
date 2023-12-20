Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962B748780
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BT7YzMVS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=psLWoaIE+k+iYaAnXsr5dVI/OB7MlTNhX0wHjU+6oXo=; b=BT7YzMVSFsh8TFkJ4QcY31J4OQ
	NuDXuwBM+MK+aRsoHXbfsUgCAMknVKSFjNwpkW20eRvKB751GgxmllzeICg8lHm3IE8EQH2XPRuPM
	vcHaaWSihDvbun4nbnP2nawoSZbkhcELoont13AvcROqxwZbIU2cgrdISoAVfLskfAuKcd5icn+VQ
	QhvbmujVhpTwVjVfItH7yKTCj3WEugvP8qCohFFdaxBEOUk5mE6tn+qhbrvkvD7qKudJHabu1vRuc
	VmizNa2HWPWTPTlw0es+rLft/eoA6tRj3V1yIKE+datFZb5DbRMXgzksa1SBz0Sa9qUz0MNfTsKjN
	T3526naA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5q-0004LR-1O
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:46 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 16/23] extensions: libebt_redirect: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:29 +0100
Message-ID: <20231220160636.11778-17-phil@nwl.cc>
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
 extensions/libebt_redirect.c | 40 +++++++++++++++---------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/extensions/libebt_redirect.c b/extensions/libebt_redirect.c
index 7821935e137aa..a44dbaec6cc8b 100644
--- a/extensions/libebt_redirect.c
+++ b/extensions/libebt_redirect.c
@@ -9,17 +9,19 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter_bridge/ebt_redirect.h>
 #include "iptables/nft.h"
 #include "iptables/nft-bridge.h"
 
-#define REDIRECT_TARGET '1'
-static const struct option brredir_opts[] =
+enum {
+	O_TARGET,
+};
+
+static const struct xt_option_entry brredir_opts[] =
 {
-	{ "redirect-target", required_argument, 0, REDIRECT_TARGET },
-	{ 0 }
+	{ .name = "redirect-target", .id = O_TARGET, .type = XTTYPE_STRING },
+	XTOPT_TABLEEND,
 };
 
 static void brredir_print_help(void)
@@ -37,23 +39,15 @@ static void brredir_init(struct xt_entry_target *target)
 	redirectinfo->target = EBT_ACCEPT;
 }
 
-#define OPT_REDIRECT_TARGET  0x01
-static int brredir_parse(int c, char **argv, int invert, unsigned int *flags,
-			 const void *entry, struct xt_entry_target **target)
+static void brredir_parse(struct xt_option_call *cb)
 {
-	struct ebt_redirect_info *redirectinfo =
-	   (struct ebt_redirect_info *)(*target)->data;
-
-	switch (c) {
-	case REDIRECT_TARGET:
-		EBT_CHECK_OPTION(flags, OPT_REDIRECT_TARGET);
-		if (ebt_fill_target(optarg, (unsigned int *)&redirectinfo->target))
-			xtables_error(PARAMETER_PROBLEM, "Illegal --redirect-target target");
-		break;
-	default:
-		return 0;
-	}
-	return 1;
+	struct ebt_redirect_info *redirectinfo = cb->data;
+
+	xtables_option_parse(cb);
+	if (cb->entry->id == O_TARGET &&
+	    ebt_fill_target(cb->arg, (unsigned int *)&redirectinfo->target))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Illegal --redirect-target target");
 }
 
 static void brredir_print(const void *ip, const struct xt_entry_target *target, int numeric)
@@ -97,10 +91,10 @@ static struct xtables_target brredirect_target = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_redirect_info)),
 	.help		= brredir_print_help,
 	.init		= brredir_init,
-	.parse		= brredir_parse,
+	.x6_parse	= brredir_parse,
 	.print		= brredir_print,
 	.xlate		= brredir_xlate,
-	.extra_opts	= brredir_opts,
+	.x6_options	= brredir_opts,
 };
 
 void _init(void)
-- 
2.43.0

