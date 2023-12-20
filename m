Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF2A41235
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JZacSPcW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NWzSjKl6OgcFuTM2TN8nHeX0rZPtZ0zt9rtrb5DvTPk=; b=JZacSPcWhM352ae6hBv1ZX94hh
	y/DXAclbAueE/0Binhw8A3P9FBM4tiKn55EtKdKSxfASCwAHePdq0pn47JwgFTSOF11f4FierpAyT
	vZ+ZpaHuZ+hHBIfzZ2FhAjhTOLQn6JDeijroV3JdHl34eJnIIxCMiJ6wT2CjHgvdUZy6lKTGa9e6T
	7Z3DnMOAmAOgL+Orjj0P0ULg6AlvAKQC948Les8ALomQJwqnmda4lWj9lHBM7fzV5aodmI1BZ9B2V
	JcY5rddaj+Upfo4CGZe8GrUaDqaLWV8MKA7iTeBe88CMVKXUXIFYZjjAXGfM/6+FAFREGJ5f/eKNB
	cxbHMS1Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5s-0004Ll-8H
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 18/23] extensions: libebt_vlan: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:31 +0100
Message-ID: <20231220160636.11778-19-phil@nwl.cc>
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
 extensions/libebt_vlan.c | 102 +++++++++++++--------------------------
 1 file changed, 34 insertions(+), 68 deletions(-)

diff --git a/extensions/libebt_vlan.c b/extensions/libebt_vlan.c
index fa697921068dc..7f5aa8cd474d6 100644
--- a/extensions/libebt_vlan.c
+++ b/extensions/libebt_vlan.c
@@ -9,7 +9,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <ctype.h>
 #include <xtables.h>
 #include <netinet/if_ether.h>
@@ -18,29 +17,19 @@
 #include "iptables/nft.h"
 #include "iptables/nft-bridge.h"
 
-#define NAME_VLAN_ID    "id"
-#define NAME_VLAN_PRIO  "prio"
-#define NAME_VLAN_ENCAP "encap"
-
-#define VLAN_ID    '1'
-#define VLAN_PRIO  '2'
-#define VLAN_ENCAP '3'
-
-static const struct option brvlan_opts[] = {
-	{"vlan-id"   , required_argument, NULL, VLAN_ID},
-	{"vlan-prio" , required_argument, NULL, VLAN_PRIO},
-	{"vlan-encap", required_argument, NULL, VLAN_ENCAP},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry brvlan_opts[] =
+{
+	{ .name = "vlan-id", .id = EBT_VLAN_ID, .type = XTTYPE_UINT16,
+	  .max = 4094, .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_vlan_info, id) },
+	{ .name = "vlan-prio", .id = EBT_VLAN_PRIO, .type = XTTYPE_UINT8,
+	  .max = 7, .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_vlan_info, prio) },
+	{ .name = "vlan-encap", .id = EBT_VLAN_ENCAP, .type = XTTYPE_STRING,
+	  .flags = XTOPT_INVERT },
+	XTOPT_TABLEEND,
 };
 
-/*
- * option inverse flags definition
- */
-#define OPT_VLAN_ID     0x01
-#define OPT_VLAN_PRIO   0x02
-#define OPT_VLAN_ENCAP  0x04
-#define OPT_VLAN_FLAGS	(OPT_VLAN_ID | OPT_VLAN_PRIO | OPT_VLAN_ENCAP)
-
 static void brvlan_print_help(void)
 {
 	printf(
@@ -50,57 +39,34 @@ static void brvlan_print_help(void)
 "--vlan-encap [!] encap : Encapsulated frame protocol (hexadecimal or name)\n");
 }
 
-static int
-brvlan_parse(int c, char **argv, int invert, unsigned int *flags,
-	       const void *entry, struct xt_entry_match **match)
+static void brvlan_parse(struct xt_option_call *cb)
 {
-	struct ebt_vlan_info *vlaninfo = (struct ebt_vlan_info *) (*match)->data;
+	struct ebt_vlan_info *vlaninfo = cb->data;
 	struct xt_ethertypeent *ethent;
 	char *end;
-	struct ebt_vlan_info local;
-
-	switch (c) {
-	case VLAN_ID:
-		EBT_CHECK_OPTION(flags, OPT_VLAN_ID);
-		if (invert)
-			vlaninfo->invflags |= EBT_VLAN_ID;
-		local.id = strtoul(optarg, &end, 10);
-		if (local.id > 4094 || *end != '\0')
-			xtables_error(PARAMETER_PROBLEM, "Invalid --vlan-id range ('%s')", optarg);
-		vlaninfo->id = local.id;
-		vlaninfo->bitmask |= EBT_VLAN_ID;
-		break;
-	case VLAN_PRIO:
-		EBT_CHECK_OPTION(flags, OPT_VLAN_PRIO);
-		if (invert)
-			vlaninfo->invflags |= EBT_VLAN_PRIO;
-		local.prio = strtoul(optarg, &end, 10);
-		if (local.prio >= 8 || *end != '\0')
-			xtables_error(PARAMETER_PROBLEM, "Invalid --vlan-prio range ('%s')", optarg);
-		vlaninfo->prio = local.prio;
-		vlaninfo->bitmask |= EBT_VLAN_PRIO;
-		break;
-	case VLAN_ENCAP:
-		EBT_CHECK_OPTION(flags, OPT_VLAN_ENCAP);
-		if (invert)
-			vlaninfo->invflags |= EBT_VLAN_ENCAP;
-		local.encap = strtoul(optarg, &end, 16);
+
+	xtables_option_parse(cb);
+
+	vlaninfo->bitmask |= cb->entry->id;
+	if (cb->invert)
+		vlaninfo->invflags |= cb->entry->id;
+
+	if (cb->entry->id == EBT_VLAN_ENCAP) {
+		vlaninfo->encap = strtoul(cb->arg, &end, 16);
 		if (*end != '\0') {
-			ethent = xtables_getethertypebyname(optarg);
+			ethent = xtables_getethertypebyname(cb->arg);
 			if (ethent == NULL)
-				xtables_error(PARAMETER_PROBLEM, "Unknown --vlan-encap value ('%s')", optarg);
-			local.encap = ethent->e_ethertype;
+				xtables_error(PARAMETER_PROBLEM,
+					      "Unknown --vlan-encap value ('%s')",
+					      cb->arg);
+			vlaninfo->encap = ethent->e_ethertype;
 		}
-		if (local.encap < ETH_ZLEN)
-			xtables_error(PARAMETER_PROBLEM, "Invalid --vlan-encap range ('%s')", optarg);
-		vlaninfo->encap = htons(local.encap);
-		vlaninfo->bitmask |= EBT_VLAN_ENCAP;
-		break;
-	default:
-		return 0;
-
+		if (vlaninfo->encap < ETH_ZLEN)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Invalid --vlan-encap range ('%s')",
+				      cb->arg);
+		vlaninfo->encap = htons(vlaninfo->encap);
 	}
-	return 1;
 }
 
 static void brvlan_print(const void *ip, const struct xt_entry_match *match,
@@ -144,10 +110,10 @@ static struct xtables_match brvlan_match = {
 	.size		= XT_ALIGN(sizeof(struct ebt_vlan_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_vlan_info)),
 	.help		= brvlan_print_help,
-	.parse		= brvlan_parse,
+	.x6_parse	= brvlan_parse,
 	.print		= brvlan_print,
 	.xlate		= brvlan_xlate,
-	.extra_opts	= brvlan_opts,
+	.x6_options	= brvlan_opts,
 };
 
 void _init(void)
-- 
2.43.0

