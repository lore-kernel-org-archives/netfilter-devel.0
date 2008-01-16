From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [14/19] libxt_hashlimit checks
Date: Wed, 16 Jan 2008 14:52:56 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161452250.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38597 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYAPNw6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:52:58 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add checks for libxt_hashlimit so that options cannot be passed twice

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_hashlimit.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: iptables-modules/extensions/libxt_hashlimit.c
===================================================================
--- iptables-modules.orig/extensions/libxt_hashlimit.c
+++ iptables-modules/extensions/libxt_hashlimit.c
@@ -157,6 +157,8 @@ hashlimit_parse(int c, char **argv, int 
 
 	switch(c) {
 	case '%':
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit",
+		          *flags & PARAM_LIMIT);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!parse_rate(optarg, &r->cfg.avg))
 			exit_error(PARAMETER_PROBLEM,
@@ -165,6 +167,8 @@ hashlimit_parse(int c, char **argv, int 
 		break;
 
 	case '$':
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
+		          *flags & PARAM_BURST);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 10000, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
@@ -173,6 +177,8 @@ hashlimit_parse(int c, char **argv, int 
 		*flags |= PARAM_BURST;
 		break;
 	case '&':
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
+		          *flags & PARAM_SIZE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
@@ -181,6 +187,8 @@ hashlimit_parse(int c, char **argv, int 
 		*flags |= PARAM_SIZE;
 		break;
 	case '*':
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
+		          *flags & PARAM_MAX);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
@@ -189,6 +197,9 @@ hashlimit_parse(int c, char **argv, int 
 		*flags |= PARAM_MAX;
 		break;
 	case '(':
+		param_act(P_ONLY_ONCE, "hashlimit",
+		          "--hashlimit-htable-gcinterval",
+		          *flags & PARAM_GCINTERVAL);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
@@ -199,6 +210,8 @@ hashlimit_parse(int c, char **argv, int 
 		*flags |= PARAM_GCINTERVAL;
 		break;
 	case ')':
+		param_act(P_ONLY_ONCE, "hashlimit",
+		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
@@ -208,6 +221,8 @@ hashlimit_parse(int c, char **argv, int 
 		*flags |= PARAM_EXPIRE;
 		break;
 	case '_':
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
+		          *flags & PARAM_MODE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (parse_mode(r, optarg) < 0)
 			exit_error(PARAMETER_PROBLEM, 
@@ -215,6 +230,8 @@ hashlimit_parse(int c, char **argv, int 
 		*flags |= PARAM_MODE;
 		break;
 	case '"':
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-name",
+		          *flags & PARAM_NAME);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (strlen(optarg) == 0)
 			exit_error(PARAMETER_PROBLEM, "Zero-length name?");
