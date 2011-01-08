From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/13] iptables: abort on empty interface specification
Date: Sat,  8 Jan 2011 16:20:06 +0100
Message-ID: <1294500015-10691-6-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32891 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab1AHPUV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:21 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fiedler Roman brings to attention that if, in a faulty script,
"$some_variable" expands to an empty string, iptables should probably
catch this most likely undesired invocation. If no/all interfaces were
really desired, one can either omit -i completely, or use -i +.

References: http://marc.info/?l=netfilter&m=129439862903487&w=2
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |    8 ++++++++
 iptables.c  |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 84908eb..b8449f6 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1573,6 +1573,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 
 		case 'i':
+			if (*optarg == '\0')
+				xtables_error(PARAMETER_PROBLEM,
+					"Empty interface is likely to be "
+					"undesired");
 			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_VIANAMEIN, &fw.ipv6.invflags,
 				   invert);
@@ -1582,6 +1586,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			break;
 
 		case 'o':
+			if (*optarg == '\0')
+				xtables_error(PARAMETER_PROBLEM,
+					"Empty interface is likely to be "
+					"undesired");
 			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ipv6.invflags,
 				   invert);
diff --git a/iptables.c b/iptables.c
index 6549c1d..e0efbf1 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1590,6 +1590,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 
 		case 'i':
+			if (*optarg == '\0')
+				xtables_error(PARAMETER_PROBLEM,
+					"Empty interface is likely to be "
+					"undesired");
 			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_VIANAMEIN, &fw.ip.invflags,
 				   invert);
@@ -1599,6 +1603,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			break;
 
 		case 'o':
+			if (*optarg == '\0')
+				xtables_error(PARAMETER_PROBLEM,
+					"Empty interface is likely to be "
+					"undesired");
 			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ip.invflags,
 				   invert);
-- 
1.7.1

