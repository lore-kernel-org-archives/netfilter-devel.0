Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC0F48790
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GUP5HZ9m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i05eKpHfF17bXGPWpGEF2zW9FNMvMineAY0xjPXm0bQ=; b=GUP5HZ9m3SMVvzD88stRdWNko4
	JlZJt59lCAttxLuJN3lz6SmstIGiIPN5IfbxVxvJ56eEV0HhsAdcVurnEkJvrGX+e4EibbUvYOZsy
	eVQ1hvtEy8RpB9I7iMfFAWOu5hXMiU+Q2r56bR4bxQzmoO/KjkjCG/sIPPnClLGWgtabV4pdPxrVD
	DR3pE/ewkUlSjisn3sHI229Oxz68exFDZozOKShGbDHFWURvkLX2CgKWSYznFbMmjmUTerhD4bSeR
	zzEFNKq7sLiMfYPmcMTL/9QAtynvC4cBuUA2iV5d9TF7CN61YH+cWY4wCZI6CRtqQOBc+HRqA6v/q
	Ot1aHbbQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5s-0004Lt-TL
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 07/23] extensions: libebt_stp: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:20 +0100
Message-ID: <20231220160636.11778-8-phil@nwl.cc>
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
 extensions/libebt_stp.c | 244 ++++++++++++++--------------------------
 extensions/libebt_stp.t |  16 +++
 2 files changed, 100 insertions(+), 160 deletions(-)

diff --git a/extensions/libebt_stp.c b/extensions/libebt_stp.c
index 41059baae7078..9b372d1d4351a 100644
--- a/extensions/libebt_stp.c
+++ b/extensions/libebt_stp.c
@@ -9,7 +9,6 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <netinet/ether.h>
 #include <linux/netfilter_bridge/ebt_stp.h>
 #include <xtables.h>
@@ -17,35 +16,37 @@
 #include "iptables/nft.h"
 #include "iptables/nft-bridge.h"
 
-#define STP_TYPE	'a'
-#define STP_FLAGS	'b'
-#define STP_ROOTPRIO	'c'
-#define STP_ROOTADDR	'd'
-#define STP_ROOTCOST	'e'
-#define STP_SENDERPRIO	'f'
-#define STP_SENDERADDR	'g'
-#define STP_PORT	'h'
-#define STP_MSGAGE	'i'
-#define STP_MAXAGE	'j'
-#define STP_HELLOTIME	'k'
-#define STP_FWDD	'l'
-#define STP_NUMOPS 12
+/* These must correspond to the bit position in EBT_STP_* defines */
+enum {
+	O_TYPE = 0,
+	O_FLAGS,
+	O_RPRIO,
+	O_RADDR,
+	O_RCOST,
+	O_SPRIO,
+	O_SADDR,
+	O_PORT,
+	O_MSGAGE,
+	O_MAXAGE,
+	O_HTIME,
+	O_FWDD,
+};
 
-static const struct option brstp_opts[] =
-{
-	{ "stp-type"         , required_argument, 0, STP_TYPE},
-	{ "stp-flags"        , required_argument, 0, STP_FLAGS},
-	{ "stp-root-prio"    , required_argument, 0, STP_ROOTPRIO},
-	{ "stp-root-addr"    , required_argument, 0, STP_ROOTADDR},
-	{ "stp-root-cost"    , required_argument, 0, STP_ROOTCOST},
-	{ "stp-sender-prio"  , required_argument, 0, STP_SENDERPRIO},
-	{ "stp-sender-addr"  , required_argument, 0, STP_SENDERADDR},
-	{ "stp-port"         , required_argument, 0, STP_PORT},
-	{ "stp-msg-age"      , required_argument, 0, STP_MSGAGE},
-	{ "stp-max-age"      , required_argument, 0, STP_MAXAGE},
-	{ "stp-hello-time"   , required_argument, 0, STP_HELLOTIME},
-	{ "stp-forward-delay", required_argument, 0, STP_FWDD},
-	{ 0 }
+static const struct xt_option_entry brstp_opts[] = {
+#define ENTRY(n, i, t) { .name = n, .id = i, .type = t, .flags = XTOPT_INVERT }
+	ENTRY("stp-type",          O_TYPE,   XTTYPE_STRING),
+	ENTRY("stp-flags",         O_FLAGS,  XTTYPE_STRING),
+	ENTRY("stp-root-prio",     O_RPRIO,  XTTYPE_UINT16RC),
+	ENTRY("stp-root-addr",     O_RADDR,  XTTYPE_ETHERMACMASK),
+	ENTRY("stp-root-cost",     O_RCOST,  XTTYPE_UINT32RC),
+	ENTRY("stp-sender-prio",   O_SPRIO,  XTTYPE_UINT16RC),
+	ENTRY("stp-sender-addr",   O_SADDR,  XTTYPE_ETHERMACMASK),
+	ENTRY("stp-port",          O_PORT,   XTTYPE_UINT16RC),
+	ENTRY("stp-msg-age",       O_MSGAGE, XTTYPE_UINT16RC),
+	ENTRY("stp-max-age",       O_MAXAGE, XTTYPE_UINT16RC),
+	ENTRY("stp-hello-time",    O_HTIME,  XTTYPE_UINT16RC),
+	ENTRY("stp-forward-delay", O_FWDD,   XTTYPE_UINT16RC),
+	XTOPT_TABLEEND,
 };
 
 #define BPDU_TYPE_CONFIG 0
@@ -82,67 +83,6 @@ static void brstp_print_help(void)
 "   \"topology-change-ack\": topology change acknowledgement flag (0x80)");
 }
 
-static int parse_range(const char *portstring, void *lower, void *upper,
-   int bits, uint32_t min, uint32_t max)
-{
-	char *buffer;
-	char *cp, *end;
-	uint32_t low_nr, upp_nr;
-	int ret = 0;
-
-	buffer = xtables_strdup(portstring);
-
-	if ((cp = strchr(buffer, ':')) == NULL) {
-		low_nr = strtoul(buffer, &end, 10);
-		if (*end || low_nr < min || low_nr > max) {
-			ret = -1;
-			goto out;
-		}
-		if (bits == 2) {
-			*(uint16_t *)lower =  low_nr;
-			*(uint16_t *)upper =  low_nr;
-		} else {
-			*(uint32_t *)lower =  low_nr;
-			*(uint32_t *)upper =  low_nr;
-		}
-	} else {
-		*cp = '\0';
-		cp++;
-		if (!*buffer)
-			low_nr = min;
-		else {
-			low_nr = strtoul(buffer, &end, 10);
-			if (*end || low_nr < min) {
-				ret = -1;
-				goto out;
-			}
-		}
-		if (!*cp)
-			upp_nr = max;
-		else {
-			upp_nr = strtoul(cp, &end, 10);
-			if (*end || upp_nr > max) {
-				ret = -1;
-				goto out;
-			}
-		}
-		if (upp_nr < low_nr) {
-			ret = -1;
-			goto out;
-		}
-		if (bits == 2) {
-			*(uint16_t *)lower = low_nr;
-			*(uint16_t *)upper = upp_nr;
-		} else {
-			*(uint32_t *)lower = low_nr;
-			*(uint32_t *)upper = upp_nr;
-		}
-	}
-out:
-	free(buffer);
-	return ret;
-}
-
 static void print_range(unsigned int l, unsigned int u)
 {
 	if (l == u)
@@ -151,103 +91,87 @@ static void print_range(unsigned int l, unsigned int u)
 		printf("%u:%u", l, u);
 }
 
-static int
-brstp_parse(int c, char **argv, int invert, unsigned int *flags,
-	    const void *entry, struct xt_entry_match **match)
+static void brstp_parse(struct xt_option_call *cb)
 {
-	struct ebt_stp_info *stpinfo = (struct ebt_stp_info *)(*match)->data;
-	unsigned int flag;
-	long int i;
+	struct ebt_stp_info *stpinfo = cb->data;
 	char *end = NULL;
+	long int i;
+
+	xtables_option_parse(cb);
 
-	if (c < 'a' || c > ('a' + STP_NUMOPS - 1))
-		return 0;
-	flag = 1 << (c - 'a');
-	EBT_CHECK_OPTION(flags, flag);
-	if (invert)
-		stpinfo->invflags |= flag;
-	stpinfo->bitmask |= flag;
-	switch (flag) {
-	case EBT_STP_TYPE:
-		i = strtol(optarg, &end, 0);
+	stpinfo->bitmask |= 1 << cb->entry->id;
+	if (cb->invert)
+		stpinfo->invflags |= 1 << cb->entry->id;
+
+	switch (cb->entry->id) {
+	case O_TYPE:
+		i = strtol(cb->arg, &end, 0);
 		if (i < 0 || i > 255 || *end != '\0') {
-			if (!strcasecmp(optarg, BPDU_TYPE_CONFIG_STRING))
+			if (!strcasecmp(cb->arg, BPDU_TYPE_CONFIG_STRING))
 				stpinfo->type = BPDU_TYPE_CONFIG;
-			else if (!strcasecmp(optarg, BPDU_TYPE_TCN_STRING))
+			else if (!strcasecmp(cb->arg, BPDU_TYPE_TCN_STRING))
 				stpinfo->type = BPDU_TYPE_TCN;
 			else
 				xtables_error(PARAMETER_PROBLEM, "Bad --stp-type argument");
 		} else
 			stpinfo->type = i;
 		break;
-	case EBT_STP_FLAGS:
-		i = strtol(optarg, &end, 0);
+	case O_FLAGS:
+		i = strtol(cb->arg, &end, 0);
 		if (i < 0 || i > 255 || *end != '\0') {
-			if (!strcasecmp(optarg, FLAG_TC_STRING))
+			if (!strcasecmp(cb->arg, FLAG_TC_STRING))
 				stpinfo->config.flags = FLAG_TC;
-			else if (!strcasecmp(optarg, FLAG_TC_ACK_STRING))
+			else if (!strcasecmp(cb->arg, FLAG_TC_ACK_STRING))
 				stpinfo->config.flags = FLAG_TC_ACK;
 			else
 				xtables_error(PARAMETER_PROBLEM, "Bad --stp-flags argument");
 		} else
 			stpinfo->config.flags = i;
 		break;
-	case EBT_STP_ROOTPRIO:
-		if (parse_range(argv[optind-1], &(stpinfo->config.root_priol),
-		    &(stpinfo->config.root_priou), 2, 0, 0xffff))
-			xtables_error(PARAMETER_PROBLEM, "Bad --stp-root-prio range");
+	case O_RADDR:
+		memcpy(stpinfo->config.root_addr, cb->val.ethermac, ETH_ALEN);
+		memcpy(stpinfo->config.root_addrmsk,
+		       cb->val.ethermacmask, ETH_ALEN);
 		break;
-	case EBT_STP_ROOTCOST:
-		if (parse_range(argv[optind-1], &(stpinfo->config.root_costl),
-		    &(stpinfo->config.root_costu), 4, 0, 0xffffffff))
-			xtables_error(PARAMETER_PROBLEM, "Bad --stp-root-cost range");
+	case O_SADDR:
+		memcpy(stpinfo->config.sender_addr, cb->val.ethermac, ETH_ALEN);
+		memcpy(stpinfo->config.sender_addrmsk,
+		       cb->val.ethermacmask, ETH_ALEN);
 		break;
-	case EBT_STP_SENDERPRIO:
-		if (parse_range(argv[optind-1], &(stpinfo->config.sender_priol),
-		    &(stpinfo->config.sender_priou), 2, 0, 0xffff))
-			xtables_error(PARAMETER_PROBLEM, "Bad --stp-sender-prio range");
+
+#define RANGE_ASSIGN(name, fname, val) {				    \
+		stpinfo->config.fname##l = val[0];			    \
+		stpinfo->config.fname##u = cb->nvals > 1 ? val[1] : val[0]; \
+		if (val[1] < val[0])					    \
+			xtables_error(PARAMETER_PROBLEM,		    \
+				      "Bad --stp-" name " range");	    \
+}
+	case O_RPRIO:
+		RANGE_ASSIGN("root-prio", root_prio, cb->val.u16_range);
 		break;
-	case EBT_STP_PORT:
-		if (parse_range(argv[optind-1], &(stpinfo->config.portl),
-		    &(stpinfo->config.portu), 2, 0, 0xffff))
-			xtables_error(PARAMETER_PROBLEM, "Bad --stp-port-range");
+	case O_RCOST:
+		RANGE_ASSIGN("root-cost", root_cost, cb->val.u32_range);
 		break;
-	case EBT_STP_MSGAGE:
-		if (parse_range(argv[optind-1], &(stpinfo->config.msg_agel),
-		    &(stpinfo->config.msg_ageu), 2, 0, 0xffff))
-			xtables_error(PARAMETER_PROBLEM, "Bad --stp-msg-age range");
+	case O_SPRIO:
+		RANGE_ASSIGN("sender-prio", sender_prio, cb->val.u16_range);
 		break;
-	case EBT_STP_MAXAGE:
-		if (parse_range(argv[optind-1], &(stpinfo->config.max_agel),
-		    &(stpinfo->config.max_ageu), 2, 0, 0xffff))
-			xtables_error(PARAMETER_PROBLEM, "Bad --stp-max-age range");
+	case O_PORT:
+		RANGE_ASSIGN("port", port, cb->val.u16_range);
 		break;
-	case EBT_STP_HELLOTIME:
-		if (parse_range(argv[optind-1], &(stpinfo->config.hello_timel),
-		    &(stpinfo->config.hello_timeu), 2, 0, 0xffff))
-			xtables_error(PARAMETER_PROBLEM, "Bad --stp-hello-time range");
+	case O_MSGAGE:
+		RANGE_ASSIGN("msg-age", msg_age, cb->val.u16_range);
 		break;
-	case EBT_STP_FWDD:
-		if (parse_range(argv[optind-1], &(stpinfo->config.forward_delayl),
-		    &(stpinfo->config.forward_delayu), 2, 0, 0xffff))
-			xtables_error(PARAMETER_PROBLEM, "Bad --stp-forward-delay range");
+	case O_MAXAGE:
+		RANGE_ASSIGN("max-age", max_age, cb->val.u16_range);
 		break;
-	case EBT_STP_ROOTADDR:
-		if (xtables_parse_mac_and_mask(argv[optind-1],
-					       stpinfo->config.root_addr,
-					       stpinfo->config.root_addrmsk))
-			xtables_error(PARAMETER_PROBLEM, "Bad --stp-root-addr address");
+	case O_HTIME:
+		RANGE_ASSIGN("hello-time", hello_time, cb->val.u16_range);
 		break;
-	case EBT_STP_SENDERADDR:
-		if (xtables_parse_mac_and_mask(argv[optind-1],
-					       stpinfo->config.sender_addr,
-					       stpinfo->config.sender_addrmsk))
-			xtables_error(PARAMETER_PROBLEM, "Bad --stp-sender-addr address");
+	case O_FWDD:
+		RANGE_ASSIGN("forward-delay", forward_delay, cb->val.u16_range);
 		break;
-	default:
-		xtables_error(PARAMETER_PROBLEM, "Unknown stp option");
+#undef RANGE_ASSIGN
 	}
-	return 1;
 }
 
 static void brstp_print(const void *ip, const struct xt_entry_match *match,
@@ -257,7 +181,7 @@ static void brstp_print(const void *ip, const struct xt_entry_match *match,
 	const struct ebt_stp_config_info *c = &(stpinfo->config);
 	int i;
 
-	for (i = 0; i < STP_NUMOPS; i++) {
+	for (i = 0; (1 << i) < EBT_STP_MASK; i++) {
 		if (!(stpinfo->bitmask & (1 << i)))
 			continue;
 		printf("--%s %s", brstp_opts[i].name,
@@ -308,9 +232,9 @@ static struct xtables_match brstp_match = {
 	.family		= NFPROTO_BRIDGE,
 	.size		= sizeof(struct ebt_stp_info),
 	.help		= brstp_print_help,
-	.parse		= brstp_parse,
+	.x6_parse	= brstp_parse,
 	.print		= brstp_print,
-	.extra_opts	= brstp_opts,
+	.x6_options	= brstp_opts
 };
 
 void _init(void)
diff --git a/extensions/libebt_stp.t b/extensions/libebt_stp.t
index 17d6c1c0978e3..b3c7e5f3aa8f3 100644
--- a/extensions/libebt_stp.t
+++ b/extensions/libebt_stp.t
@@ -1,13 +1,29 @@
 :INPUT,FORWARD,OUTPUT
 --stp-type 1;=;OK
+--stp-type ! 1;=;OK
 --stp-flags 0x1;--stp-flags topology-change -j CONTINUE;OK
+--stp-flags ! topology-change;=;OK
 --stp-root-prio 1 -j ACCEPT;=;OK
+--stp-root-prio ! 1 -j ACCEPT;=;OK
 --stp-root-addr 0d:ea:d0:0b:ee:f0;=;OK
+--stp-root-addr ! 0d:ea:d0:0b:ee:f0;=;OK
+--stp-root-addr 0d:ea:d0:00:00:00/ff:ff:ff:00:00:00;=;OK
+--stp-root-addr ! 0d:ea:d0:00:00:00/ff:ff:ff:00:00:00;=;OK
 --stp-root-cost 1;=;OK
+--stp-root-cost ! 1;=;OK
 --stp-sender-prio 1;=;OK
+--stp-sender-prio ! 1;=;OK
 --stp-sender-addr de:ad:be:ef:00:00;=;OK
+--stp-sender-addr ! de:ad:be:ef:00:00;=;OK
+--stp-sender-addr de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
+--stp-sender-addr ! de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
 --stp-port 1;=;OK
+--stp-port ! 1;=;OK
 --stp-msg-age 1;=;OK
+--stp-msg-age ! 1;=;OK
 --stp-max-age 1;=;OK
+--stp-max-age ! 1;=;OK
 --stp-hello-time 1;=;OK
+--stp-hello-time ! 1;=;OK
 --stp-forward-delay 1;=;OK
+--stp-forward-delay ! 1;=;OK
-- 
2.43.0

