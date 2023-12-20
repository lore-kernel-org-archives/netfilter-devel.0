Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BFA4879C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KcgVdjRH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tuBSWEacjz+/VLOlGDIEQiBgwGrLyAiy4h9BOJvAsVs=; b=KcgVdjRHXME/vr5RwHiwFFhKrI
	/NFDrzor7XpgFbKsNFjgrWb1EjEXyKUYiJMs3pYCJ/lGgkkKtDYfEWrAEZzQxZbYR2APadDh3Wic6
	w7msAsPVPtFizZia7HfvfBI6wTLwq/VneX/1QIzYmMEUvYvQA1pNWhUrjuYP2JbZ/z7hCbnPEqti5
	pvTeMRpiExDYzZRII7hMU6Hc/q2jvM8bESJCfPgrlyeGEl1f+0OBwv9t3yZKs0+K1RZOg67kb9TMw
	WdV6t3f9/+UVr7V8SOhbN48bf434aAkFKQhOra4SPYsVIWCkTtbDOFtwlXAVAPD7pDDO9i3g1shSK
	BjHwgtMA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5t-0004Lx-7j
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 19/23] extensions: libebt_arp: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:32 +0100
Message-ID: <20231220160636.11778-20-phil@nwl.cc>
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
 extensions/libebt_arp.c | 201 ++++++++++++++--------------------------
 extensions/libebt_arp.t |   7 ++
 2 files changed, 78 insertions(+), 130 deletions(-)

diff --git a/extensions/libebt_arp.c b/extensions/libebt_arp.c
index 63a953d4637da..b6d691d8c0b10 100644
--- a/extensions/libebt_arp.c
+++ b/extensions/libebt_arp.c
@@ -10,7 +10,6 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <netinet/ether.h>
 
@@ -20,26 +19,31 @@
 #include "iptables/nft.h"
 #include "iptables/nft-bridge.h"
 
-#define ARP_OPCODE '1'
-#define ARP_HTYPE  '2'
-#define ARP_PTYPE  '3'
-#define ARP_IP_S   '4'
-#define ARP_IP_D   '5'
-#define ARP_MAC_S  '6'
-#define ARP_MAC_D  '7'
-#define ARP_GRAT   '8'
+/* values must correspond with EBT_ARP_* bit positions */
+enum {
+	O_OPCODE = 0,
+	O_HTYPE,
+	O_PTYPE,
+	O_SRC_IP,
+	O_DST_IP,
+	O_SRC_MAC,
+	O_DST_MAC,
+	O_GRAT,
+};
 
-static const struct option brarp_opts[] = {
-	{ "arp-opcode"    , required_argument, 0, ARP_OPCODE },
-	{ "arp-op"        , required_argument, 0, ARP_OPCODE },
-	{ "arp-htype"     , required_argument, 0, ARP_HTYPE  },
-	{ "arp-ptype"     , required_argument, 0, ARP_PTYPE  },
-	{ "arp-ip-src"    , required_argument, 0, ARP_IP_S   },
-	{ "arp-ip-dst"    , required_argument, 0, ARP_IP_D   },
-	{ "arp-mac-src"   , required_argument, 0, ARP_MAC_S  },
-	{ "arp-mac-dst"   , required_argument, 0, ARP_MAC_D  },
-	{ "arp-gratuitous",       no_argument, 0, ARP_GRAT   },
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry brarp_opts[] = {
+#define ENTRY(n, i, t) { .name = n, .id = i, .type = t, .flags = XTOPT_INVERT }
+	ENTRY("arp-opcode",     O_OPCODE,  XTTYPE_STRING),
+	ENTRY("arp-op",         O_OPCODE,  XTTYPE_STRING),
+	ENTRY("arp-htype",      O_HTYPE,   XTTYPE_STRING),
+	ENTRY("arp-ptype",      O_PTYPE,   XTTYPE_STRING),
+	ENTRY("arp-ip-src",     O_SRC_IP,  XTTYPE_HOSTMASK),
+	ENTRY("arp-ip-dst",     O_DST_IP,  XTTYPE_HOSTMASK),
+	ENTRY("arp-mac-src",    O_SRC_MAC, XTTYPE_ETHERMACMASK),
+	ENTRY("arp-mac-dst",    O_DST_MAC, XTTYPE_ETHERMACMASK),
+	ENTRY("arp-gratuitous", O_GRAT,    XTTYPE_NONE),
+#undef ENTRY
+	XTOPT_TABLEEND
 };
 
 /* a few names */
@@ -78,137 +82,74 @@ static void brarp_print_help(void)
 " protocol type string: see "XT_PATH_ETHERTYPES"\n");
 }
 
-#define OPT_OPCODE 0x01
-#define OPT_HTYPE  0x02
-#define OPT_PTYPE  0x04
-#define OPT_IP_S   0x08
-#define OPT_IP_D   0x10
-#define OPT_MAC_S  0x20
-#define OPT_MAC_D  0x40
-#define OPT_GRAT   0x80
-
-static int
-brarp_parse(int c, char **argv, int invert, unsigned int *flags,
-	    const void *entry, struct xt_entry_match **match)
+static void brarp_parse(struct xt_option_call *cb)
 {
-	struct ebt_arp_info *arpinfo = (struct ebt_arp_info *)(*match)->data;
-	struct in_addr *ipaddr, ipmask;
+	struct ebt_arp_info *arpinfo = cb->data;
+	struct xt_ethertypeent *ent;
 	long int i;
 	char *end;
-	unsigned char *maddr;
-	unsigned char *mmask;
-	unsigned int ipnr;
 
-	switch (c) {
-	case ARP_OPCODE:
-		EBT_CHECK_OPTION(flags, OPT_OPCODE);
-		if (invert)
-			arpinfo->invflags |= EBT_ARP_OPCODE;
-		i = strtol(optarg, &end, 10);
+
+	xtables_option_parse(cb);
+
+	arpinfo->bitmask |= 1 << cb->entry->id;
+	if (cb->invert)
+		arpinfo->invflags |= 1 << cb->entry->id;
+
+	switch (cb->entry->id) {
+	case O_OPCODE:
+		i = strtol(cb->arg, &end, 10);
 		if (i < 0 || i >= (0x1 << 16) || *end !='\0') {
 			for (i = 0; i < ARRAY_SIZE(opcodes); i++)
-				if (!strcasecmp(opcodes[i], optarg))
+				if (!strcasecmp(opcodes[i], cb->arg))
 					break;
 			if (i == ARRAY_SIZE(opcodes))
-				xtables_error(PARAMETER_PROBLEM, "Problem with specified ARP opcode");
+				xtables_error(PARAMETER_PROBLEM,
+					      "Problem with specified ARP opcode");
 			i++;
 		}
 		arpinfo->opcode = htons(i);
-		arpinfo->bitmask |= EBT_ARP_OPCODE;
 		break;
-
-	case ARP_HTYPE:
-		EBT_CHECK_OPTION(flags, OPT_HTYPE);
-		if (invert)
-			arpinfo->invflags |= EBT_ARP_HTYPE;
-		i = strtol(optarg, &end, 10);
+	case O_HTYPE:
+		i = strtol(cb->arg, &end, 10);
 		if (i < 0 || i >= (0x1 << 16) || *end !='\0') {
-			if (!strcasecmp("Ethernet", argv[optind - 1]))
+			if (!strcasecmp("Ethernet", cb->arg))
 				i = 1;
 			else
-				xtables_error(PARAMETER_PROBLEM, "Problem with specified ARP hardware type");
+				xtables_error(PARAMETER_PROBLEM,
+					      "Problem with specified ARP hardware type");
 		}
 		arpinfo->htype = htons(i);
-		arpinfo->bitmask |= EBT_ARP_HTYPE;
 		break;
-	case ARP_PTYPE: {
-		uint16_t proto;
-
-		EBT_CHECK_OPTION(flags, OPT_PTYPE);
-		if (invert)
-			arpinfo->invflags |= EBT_ARP_PTYPE;
-
-		i = strtol(optarg, &end, 16);
-		if (i < 0 || i >= (0x1 << 16) || *end !='\0') {
-			struct xt_ethertypeent *ent;
-
-			ent = xtables_getethertypebyname(argv[optind - 1]);
-			if (!ent)
-				xtables_error(PARAMETER_PROBLEM, "Problem with specified ARP "
-								 "protocol type");
-			proto = ent->e_ethertype;
-
-		} else
-			proto = i;
-		arpinfo->ptype = htons(proto);
-		arpinfo->bitmask |= EBT_ARP_PTYPE;
-		break;
-	}
-
-	case ARP_IP_S:
-	case ARP_IP_D:
-		xtables_ipparse_any(optarg, &ipaddr, &ipmask, &ipnr);
-		if (c == ARP_IP_S) {
-			EBT_CHECK_OPTION(flags, OPT_IP_S);
-			arpinfo->saddr = ipaddr->s_addr;
-			arpinfo->smsk = ipmask.s_addr;
-			arpinfo->bitmask |= EBT_ARP_SRC_IP;
-		} else {
-			EBT_CHECK_OPTION(flags, OPT_IP_D);
-			arpinfo->daddr = ipaddr->s_addr;
-			arpinfo->dmsk = ipmask.s_addr;
-			arpinfo->bitmask |= EBT_ARP_DST_IP;
-		}
-		free(ipaddr);
-		if (invert) {
-			if (c == ARP_IP_S)
-				arpinfo->invflags |= EBT_ARP_SRC_IP;
-			else
-				arpinfo->invflags |= EBT_ARP_DST_IP;
+	case O_PTYPE:
+		i = strtol(cb->arg, &end, 16);
+		if (i >= 0 && i < (0x1 << 16) && *end == '\0') {
+			arpinfo->ptype = htons(i);
+			break;
 		}
+		ent = xtables_getethertypebyname(cb->arg);
+		if (!ent)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Problem with specified ARP protocol type");
+		arpinfo->ptype = htons(ent->e_ethertype);
 		break;
-	case ARP_MAC_S:
-	case ARP_MAC_D:
-		if (c == ARP_MAC_S) {
-			EBT_CHECK_OPTION(flags, OPT_MAC_S);
-			maddr = arpinfo->smaddr;
-			mmask = arpinfo->smmsk;
-			arpinfo->bitmask |= EBT_ARP_SRC_MAC;
-		} else {
-			EBT_CHECK_OPTION(flags, OPT_MAC_D);
-			maddr = arpinfo->dmaddr;
-			mmask = arpinfo->dmmsk;
-			arpinfo->bitmask |= EBT_ARP_DST_MAC;
-		}
-		if (invert) {
-			if (c == ARP_MAC_S)
-				arpinfo->invflags |= EBT_ARP_SRC_MAC;
-			else
-				arpinfo->invflags |= EBT_ARP_DST_MAC;
-		}
-		if (xtables_parse_mac_and_mask(optarg, maddr, mmask))
-			xtables_error(PARAMETER_PROBLEM, "Problem with ARP MAC address argument");
+	case O_SRC_IP:
+		arpinfo->saddr = cb->val.haddr.ip & cb->val.hmask.ip;
+		arpinfo->smsk = cb->val.hmask.ip;
+		break;
+	case O_DST_IP:
+		arpinfo->daddr = cb->val.haddr.ip & cb->val.hmask.ip;
+		arpinfo->dmsk = cb->val.hmask.ip;
+		break;
+	case O_SRC_MAC:
+		memcpy(arpinfo->smaddr, cb->val.ethermac, ETH_ALEN);
+		memcpy(arpinfo->smmsk, cb->val.ethermacmask, ETH_ALEN);
 		break;
-	case ARP_GRAT:
-		EBT_CHECK_OPTION(flags, OPT_GRAT);
-		arpinfo->bitmask |= EBT_ARP_GRAT;
-		if (invert)
-			arpinfo->invflags |= EBT_ARP_GRAT;
+	case O_DST_MAC:
+		memcpy(arpinfo->dmaddr, cb->val.ethermac, ETH_ALEN);
+		memcpy(arpinfo->dmmsk, cb->val.ethermacmask, ETH_ALEN);
 		break;
-	default:
-		return 0;
 	}
-	return 1;
 }
 
 static void brarp_print(const void *ip, const struct xt_entry_match *match, int numeric)
@@ -279,9 +220,9 @@ static struct xtables_match brarp_match = {
 	.size		= XT_ALIGN(sizeof(struct ebt_arp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_arp_info)),
 	.help		= brarp_print_help,
-	.parse		= brarp_parse,
+	.x6_parse	= brarp_parse,
 	.print		= brarp_print,
-	.extra_opts	= brarp_opts,
+	.x6_options	= brarp_opts,
 };
 
 void _init(void)
diff --git a/extensions/libebt_arp.t b/extensions/libebt_arp.t
index 96fbce906107c..c8e874e83c513 100644
--- a/extensions/libebt_arp.t
+++ b/extensions/libebt_arp.t
@@ -1,7 +1,11 @@
 :INPUT,FORWARD,OUTPUT
 -p ARP --arp-op Request;=;OK
+-p ARP --arp-op ! Request;=;OK
+-p ARP --arp-htype Ethernet;-p ARP --arp-htype 1;OK
+-p ARP --arp-htype 1;=;OK
 -p ARP --arp-htype ! 1;=;OK
 -p ARP --arp-ptype 0x2;=;OK
+-p ARP --arp-ptype ! 0x2;=;OK
 -p ARP --arp-ip-src 1.2.3.4;=;OK
 -p ARP ! --arp-ip-dst 1.2.3.4;-p ARP --arp-ip-dst ! 1.2.3.4 -j CONTINUE;OK
 -p ARP --arp-ip-src ! 0.0.0.0;=;OK
@@ -10,6 +14,9 @@
 -p ARP --arp-ip-src ! 1.2.3.4/255.255.255.0;-p ARP --arp-ip-src ! 1.2.3.0/24;OK
 -p ARP --arp-ip-src ! 1.2.3.4/255.0.255.255;-p ARP --arp-ip-src ! 1.0.3.4/255.0.255.255;OK
 -p ARP --arp-mac-src 00:de:ad:be:ef:00;=;OK
+-p ARP --arp-mac-src ! 00:de:ad:be:ef:00;=;OK
 -p ARP --arp-mac-dst de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
+-p ARP --arp-mac-dst ! de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
 -p ARP --arp-gratuitous;=;OK
+-p ARP ! --arp-gratuitous;=;OK
 --arp-htype 1;=;FAIL
-- 
2.43.0

