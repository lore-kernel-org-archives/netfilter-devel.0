From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: [patch] Make --set-counters (-c) accept comma separated counters
Date: Mon, 12 May 2008 22:36:15 +0200
Message-ID: <1210624575.3442.56.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-0djvu6lMlUwW67DAHsn5"
Cc: Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:52151 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYELUgW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 16:36:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-0djvu6lMlUwW67DAHsn5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Here is the --set-counters syntax patch requested earlier today making
--set-counters (-c) accept comma separated counts.

-c packets,bytes

I have not updated the manpage to reflect this alternate syntax for the
--set-counters (-c) option.

Regards
Henrik


--=-0djvu6lMlUwW67DAHsn5
Content-Disposition: attachment; filename=set-counters-comma.patch
Content-Type: text/x-patch; name=set-counters-comma.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: iptables/ip6tables.c
===================================================================
--- iptables.orig/ip6tables.c
+++ iptables/ip6tables.c
@@ -1754,26 +1754,28 @@ int do_command6(int argc, char *argv[], 
 			set_option(&options, OPT_COUNTERS, &fw.ipv6.invflags,
 				   invert);
 			pcnt = optarg;
-			if (optind < argc && argv[optind][0] != '-'
+			bcnt = strchr(pcnt + 1, ',');
+			if (bcnt)
+			    bcnt++;
+			if (!bcnt && optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
 				bcnt = argv[optind++];
-			else
+			if (!bcnt)
 				exit_error(PARAMETER_PROBLEM,
 					"-%c requires packet and byte counter",
 					opt2char(OPT_COUNTERS));
 
-			if (sscanf(pcnt, "%llu", (unsigned long long *)&cnt) != 1)
+			if (sscanf(pcnt, "%llu", &cnt) != 1)
 				exit_error(PARAMETER_PROBLEM,
 					"-%c packet counter not numeric",
 					opt2char(OPT_COUNTERS));
 			fw.counters.pcnt = cnt;
 
-			if (sscanf(bcnt, "%llu", (unsigned long long *)&cnt) != 1)
+			if (sscanf(bcnt, "%llu", &cnt) != 1)
 				exit_error(PARAMETER_PROBLEM,
 					"-%c byte counter not numeric",
 					opt2char(OPT_COUNTERS));
 			fw.counters.bcnt = cnt;
-
 			break;
 
 		case 1: /* non option */
Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c
+++ iptables/iptables.c
@@ -1794,21 +1794,24 @@ int do_command(int argc, char *argv[], c
 			set_option(&options, OPT_COUNTERS, &fw.ip.invflags,
 				   invert);
 			pcnt = optarg;
-			if (optind < argc && argv[optind][0] != '-'
+			bcnt = strchr(pcnt + 1, ',');
+			if (bcnt)
+			    bcnt++;
+			if (!bcnt && optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
 				bcnt = argv[optind++];
-			else
+			if (!bcnt)
 				exit_error(PARAMETER_PROBLEM,
 					"-%c requires packet and byte counter",
 					opt2char(OPT_COUNTERS));
 
-			if (sscanf(pcnt, "%llu", (unsigned long long *)&cnt) != 1)
+			if (sscanf(pcnt, "%llu", &cnt) != 1)
 				exit_error(PARAMETER_PROBLEM,
 					"-%c packet counter not numeric",
 					opt2char(OPT_COUNTERS));
 			fw.counters.pcnt = cnt;
 
-			if (sscanf(bcnt, "%llu", (unsigned long long *)&cnt) != 1)
+			if (sscanf(bcnt, "%llu", &cnt) != 1)
 				exit_error(PARAMETER_PROBLEM,
 					"-%c byte counter not numeric",
 					opt2char(OPT_COUNTERS));

--=-0djvu6lMlUwW67DAHsn5--

