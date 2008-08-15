From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxt_iprange: fix option names
Date: Fri, 15 Aug 2008 18:56:50 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808151856350.26696@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33907 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYHOW4v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:56:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 7d8353abfe708cfdd3b62a323a4a26c8adcb2cc1
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Aug 15 18:50:22 2008 -0400

libxt_iprange: fix option names

There is no --src-ip, just --src-range. (Same for --dst-range.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_iprange.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 8c8521e..503372f 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -106,18 +106,18 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 	char *end;
 
 	switch (c) {
-	case '1': /* --src-ip */
+	case '1': /* --src-range */
 		end = strchr(optarg, '-');
 		if (end == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-ip", optarg);
+			param_act(P_BAD_VALUE, "iprange", "--src-range", optarg);
 		*end = '\0';
 		ia = numeric_to_ipaddr(optarg);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-ip", optarg);
+			param_act(P_BAD_VALUE, "iprange", "--src-range", optarg);
 		memcpy(&info->src_min.in, ia, sizeof(*ia));
 		ia = numeric_to_ipaddr(end+1);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-ip", end + 1);
+			param_act(P_BAD_VALUE, "iprange", "--src-range", end + 1);
 		memcpy(&info->src_max.in, ia, sizeof(*ia));
 		info->flags |= IPRANGE_SRC;
 		if (invert)
@@ -125,18 +125,18 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= F_SRCIP;
 		return true;
 
-	case '2': /* --dst-ip */
+	case '2': /* --dst-range */
 		end = strchr(optarg, '-');
 		if (end == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-ip", optarg);
+			param_act(P_BAD_VALUE, "iprange", "--dst-range", optarg);
 		*end = '\0';
 		ia = numeric_to_ipaddr(optarg);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-ip", optarg);
+			param_act(P_BAD_VALUE, "iprange", "--dst-range", optarg);
 		memcpy(&info->dst_min.in, ia, sizeof(*ia));
 		ia = numeric_to_ipaddr(end + 1);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-ip", end + 1);
+			param_act(P_BAD_VALUE, "iprange", "--dst-range", end + 1);
 		memcpy(&info->dst_max.in, ia, sizeof(*ia));
 		info->flags |= IPRANGE_DST;
 		if (invert)
@@ -156,18 +156,18 @@ iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 	char *end;
 
 	switch (c) {
-	case '1': /* --src-ip */
+	case '1': /* --src-range */
 		end = strchr(optarg, '-');
 		if (end == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-ip", optarg);
+			param_act(P_BAD_VALUE, "iprange", "--src-range", optarg);
 		*end = '\0';
 		ia = numeric_to_ip6addr(optarg);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-ip", optarg);
+			param_act(P_BAD_VALUE, "iprange", "--src-range", optarg);
 		memcpy(&info->src_min.in, ia, sizeof(*ia));
 		ia = numeric_to_ip6addr(end+1);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-ip", end + 1);
+			param_act(P_BAD_VALUE, "iprange", "--src-range", end + 1);
 		memcpy(&info->src_max.in, ia, sizeof(*ia));
 		info->flags |= IPRANGE_SRC;
 		if (invert)
@@ -175,18 +175,18 @@ iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= F_SRCIP;
 		return true;
 
-	case '2': /* --dst-ip */
+	case '2': /* --dst-range */
 		end = strchr(optarg, '-');
 		if (end == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-ip", optarg);
+			param_act(P_BAD_VALUE, "iprange", "--dst-range", optarg);
 		*end = '\0';
 		ia = numeric_to_ip6addr(optarg);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-ip", optarg);
+			param_act(P_BAD_VALUE, "iprange", "--dst-range", optarg);
 		memcpy(&info->dst_min.in, ia, sizeof(*ia));
 		ia = numeric_to_ip6addr(end + 1);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-ip", end + 1);
+			param_act(P_BAD_VALUE, "iprange", "--dst-range", end + 1);
 		memcpy(&info->dst_max.in, ia, sizeof(*ia));
 		info->flags |= IPRANGE_DST;
 		if (invert)

