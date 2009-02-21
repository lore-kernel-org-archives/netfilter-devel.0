From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/6] libxt_policy: use bounded strtoui
Date: Sat, 21 Feb 2009 04:18:04 +0100
Message-ID: <1235186284-31661-7-git-send-email-jengelh@medozas.de>
References: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, hadi@cyberus.ca
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37819 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbZBUDSI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:18:08 -0500
In-Reply-To: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

reqid and SPI can only have a value in the range 0..UINT32_MAX, not
the entire range of the "long" type. Also throw an error if the
incoming string does not look like a pure number.

"Replaces" commit 6db2ded2f22a7e78743c86af523b8430876582e9.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_policy.c |   10 +++++++---
 extensions/libipt_policy.c  |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 0016da2..5106c28 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -156,7 +156,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 	struct ip6t_policy_info *info = (void *)(*match)->data;
 	struct ip6t_policy_elem *e = &info->pol[info->len];
 	struct in6_addr *addr = NULL, mask;
-	unsigned int naddr = 0;
+	unsigned int naddr = 0, num;
 	int mode;
 
 	xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -197,7 +197,9 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		e->match.reqid = 1;
 		e->invert.reqid = invert;
-		e->reqid = strtoul(argv[optind-1], NULL, 10);
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
+			xtables_param_act(XTF_BAD_VALUE, "policy", "--reqid", optarg);
+		e->reqid = num;
 		break;
 	case '5':
 		if (e->match.spi)
@@ -206,7 +208,9 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		e->match.spi = 1;
 		e->invert.spi = invert;
-		e->spi = strtoul(argv[optind-1], NULL, 0x10);
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
+			xtables_param_act(XTF_BAD_VALUE, "policy", "--spi", optarg);
+		e->spi = num;
 		break;
 	case '6':
 		if (e->match.saddr)
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index 1271fba..ae7282a 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -124,7 +124,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 	struct ipt_policy_info *info = (void *)(*match)->data;
 	struct ipt_policy_elem *e = &info->pol[info->len];
 	struct in_addr *addr = NULL, mask;
-	unsigned int naddr = 0;
+	unsigned int naddr = 0, num;
 	int mode;
 
 	xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -165,7 +165,9 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		e->match.reqid = 1;
 		e->invert.reqid = invert;
-		e->reqid = strtoul(argv[optind-1], NULL, 10);
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
+			xtables_param_act(XTF_BAD_VALUE, "policy", "--spi", optarg);
+		e->reqid = num;
 		break;
 	case '5':
 		if (e->match.spi)
@@ -174,7 +176,9 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		e->match.spi = 1;
 		e->invert.spi = invert;
-		e->spi = strtoul(argv[optind-1], NULL, 0x10);
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
+			xtables_param_act(XTF_BAD_VALUE, "policy", "--spi", optarg);
+		e->spi = num;
 		break;
 	case '6':
 		if (e->match.saddr)
-- 
1.6.1.3

