From: Eicke Friedrich <mai97bwf@studserv.uni-leipzig.de>
Subject: IPP2P 0.7 update (POM-ng patch included)
Date: Fri, 24 Dec 2004 00:44:58 +0100
Message-ID: <41CB587A.4000402@studserv.uni-leipzig.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060509070002090605010202"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060509070002090605010202
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

IPP2P 0.7 has been released. It offers a couple of new features including:
-UDP filtering support for some P2P networks
-improved SoulSeek filter
-Ares/AresLite matching support
-debug option to print matchinfo into kernel log

A patch against POM-ng is attached to this e-mail - please apply! Thanks.

Kind regards,
Eicke

--------------060509070002090605010202
Content-Type: text/plain;
 name="ipp2p-0.7.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipp2p-0.7.diff"

diff -Nru patch-o-matic-ng-old/ipp2p/help patch-o-matic-ng/ipp2p/help
--- patch-o-matic-ng-old/ipp2p/help	2004-07-13 13:43:15.000000000 +0200
+++ patch-o-matic-ng/ipp2p/help	2004-12-24 00:18:50.521492712 +0100
@@ -5,4 +5,4 @@
 accounting or shaping of P2P traffic.
 
 Examples:
-iptables -A FORWARD -p tcp -m ipp2p --edk --kazaa --dc --gnu --bit --apple -j DROP
+iptables -A FORWARD -m ipp2p --edk --kazaa --tcp --udp  -j DROP
diff -Nru patch-o-matic-ng-old/ipp2p/info patch-o-matic-ng/ipp2p/info
--- patch-o-matic-ng-old/ipp2p/info	2004-07-13 13:43:15.000000000 +0200
+++ patch-o-matic-ng/ipp2p/info	2004-12-24 00:19:11.952234744 +0100
@@ -1,5 +1,5 @@
-Title:		Detects some p2p packets
-Author: 	Eicke Friedrich <tady@gmx.net>
+Title:		Detects some P2P packets
+Author: 	Eicke Friedrich <ipp2p@ipp2p.org>
 Status: 	Stable
 Repository: 	extra
 Recompile:	netfilter, iptables
diff -Nru patch-o-matic-ng-old/ipp2p/iptables/extensions/libipt_ipp2p.c patch-o-matic-ng/ipp2p/iptables/extensions/libipt_ipp2p.c
--- patch-o-matic-ng-old/ipp2p/iptables/extensions/libipt_ipp2p.c	2004-09-13 00:27:06.000000000 +0200
+++ patch-o-matic-ng/ipp2p/iptables/extensions/libipt_ipp2p.c	2004-12-24 00:27:07.133996136 +0100
@@ -1,3 +1,4 @@
+
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -18,24 +19,32 @@
     printf(
     "IPP2P v%s options:\n"
     " --ipp2p	Grab all known p2p packets\n"
-    " --ipp2p-data	Grab all known p2p data packets\n"
-    " --edk		Grab all known eDonkey/eMule/Overnet packets\n"
-    " --edk-data	Grab all eDonkey/eMule/Overnet data packets\n"
-    " --dc		Grab all known Direct Connect packets\n"
-    " --dc-data	Grab all Direct Connect data packets\n"
-    " --kazaa	Grab all KaZaA packets\n"
-    " --kazaa-data	Grab all KaZaA data packets\n"
-    " --gnu		Grab all Gnutella packets\n"
-    " --gnu-data	Grab all Gnutella data packets\n"
-    " --bit		Grab all BitTorrent packets\n"
-    " --apple	Grab all AppleJuice packets (beta - just a few tests until now)\n"
-    " --soul		SoulSeek (beta - handle with care)\n"
-    " --winmx	WinMX (beta - handle with care)\n"
+    " --ipp2p-data	Identify all known p2p download commands (obsolete)\n\n"
+    " --edk		[TCP&UDP]	All known eDonkey/eMule/Overnet packets\n"
+    " --dc		[TCP] 		All known Direct Connect packets\n"
+    " --kazaa	[TCP&UDP] 	All known KaZaA packets\n"
+    " --gnu		[TCP&UDP]	All known Gnutella packets\n"
+    " --bit		[TCP&UDP]	All known BitTorrent packets\n"
+    " --apple	[TCP] 		All known AppleJuice packets (beta - just a few tests until now)\n"
+    " --winmx	[TCP] 		All known WinMX (beta - need feedback)\n"
+    " --soul		[TCP] 		All known SoulSeek (beta - need feedback!)\n"
+    " --ares		[TCP] 		All known Ares - use with DROP only (beta - need feedback!)\n\n"
+    " --edk-data	[TCP] 		eDonkey/eMule/Overnet download commands (obsolete)\n"
+    " --dc-data	[TCP] 		Direct Connect download command (obsolete)\n"
+    " --kazaa-data	[TCP] 		KaZaA download command (obsolete)\n"
+    " --gnu-data	[TCP] 		Gnutella download command (obsolete)\n"
     "\nNote that the follwing options will have the same meaning:\n"
     " '--ipp2p' is equal to '--edk --dc --kazaa --gnu'\n"
     " '--ipp2p-data' is equal to '--edk-data --dc-data --kazaa-data --gnu-data'\n"
-    "\nIPP2P is designed for TCP only and has to be used together with -p tcp!\n"
-    "\nExample: iptables -A FORWARD -p tcp -m ipp2p --ipp2p -j DROP\n\n"
+    "\nIPP2P was intended for TCP only. Due to increasing usage of UDP we needed to change this:\n"
+    " --udp		search UDP packets only\n"
+    " --tcp		search TCP packets only\n"
+    " --udp --tcp	search UDP and TCP packets\n"
+    "\nSee README included with this package for more details or visit http://www.ipp2p.org\n"
+    "\nExamples:\n"
+    " iptables -A FORWARD -m ipp2p --ipp2p -j MARK --set-mark 0x01\n"
+    " iptables -A FORWARD -m ipp2p --udp --kazaa --bit -j DROP\n"
+    " iptables -A FORWARD -m ipp2p --tcp --edk --soul -j DROP\n\n"
     , IPP2P_VERSION);
 }
 
@@ -43,19 +52,23 @@
 
 static struct option opts[] = {
         { "ipp2p", 0, 0, '1' },
-        { "edk", 0, 0, '2' },
-        { "ipp2p-data", 0, 0, '3' },
+        { "edk", 0, 0, '2' },	
+        { "ipp2p-data", 0, 0, '3' },		
         { "kazaa-data", 0, 0, '4' },
-        { "edk-data", 0, 0, '5' },
+        { "edk-data", 0, 0, '5' },	
         { "dc-data", 0, 0, '6' },
 	{ "dc", 0, 0, '7' },
-	{ "gnu-data", 0, 0, '8' },
+	{ "gnu-data", 0, 0, '8' },	
 	{ "gnu", 0, 0, '9' },
 	{ "kazaa", 0, 0, 'a' },
 	{ "bit", 0, 0, 'b' },
-	{ "apple", 0, 0, 'c' },
-	{ "soul", 0, 0, 'd' },
-	{ "winmx", 0, 0, 'e' },
+	{ "apple", 0, 0, 'c' },	
+	{ "soul", 0, 0, 'd' },	
+	{ "winmx", 0, 0, 'e' },	
+	{ "ares", 0, 0, 'f' },
+	{ "debug", 0, 0, 'g' },
+	{ "udp", 0, 0, 'h' },
+	{ "tcp", 0, 0, 'i' },
         {0}
 };
 
@@ -64,7 +77,15 @@
 static void
 init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
+    struct ipt_p2p_info *info = (struct ipt_p2p_info *)m->data;
+
     *nfcache |= NFC_UNKNOWN;
+
+    /*init the module with default values*/
+    info->cmd = 0;
+    info->debug = 0;
+    info->proto = IPP2P_PROTO_DEFAULT;
+
 }
 	
 
@@ -76,7 +97,6 @@
 {
     struct ipt_p2p_info *info = (struct ipt_p2p_info *)(*match)->data;
     
-    info->cmd = 0;
     switch (c) {
 	case '1':		/*cmd: ipp2p*/
 	    if ((*flags & SHORT_HAND_IPP2P) == SHORT_HAND_IPP2P)
@@ -91,9 +111,7 @@
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p' may only be "
 				"specified alone!");
-	    
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
 	    *flags += SHORT_HAND_IPP2P;
 	    info->cmd = *flags;
 	    break;
@@ -107,18 +125,14 @@
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p' may only be "
 				"specified alone!");
-
 	    if ((*flags & SHORT_HAND_DATA) == SHORT_HAND_DATA)
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p-data' may only be "
 				"specified alone!");
-
             if ((*flags & IPP2P_DATA_EDK) == IPP2P_DATA_EDK)
             exit_error(PARAMETER_PROBLEM,
                                 "ipp2p: use `--edk' OR `--edk-data' but not both of them!");
-
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-	    
 	    *flags += IPP2P_EDK;
 	    info->cmd = *flags;	    
 	    break;
@@ -136,10 +150,7 @@
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p-data' may only be "
 				"specified alone!");
-
-
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
 	    *flags += SHORT_HAND_DATA;
 	    info->cmd = *flags;	    
 	    break;
@@ -157,13 +168,10 @@
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p-data' may only be "
 				"specified alone!");
-
             if ((*flags & IPP2P_KAZAA) == IPP2P_KAZAA)
             exit_error(PARAMETER_PROBLEM,
                                 "ipp2p: use `--kazaa' OR `--kazaa-data' but not both of them!");
-				
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_DATA_KAZAA;
 	    info->cmd = *flags;
 	    break;
@@ -177,18 +185,14 @@
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p' may only be "
 				"specified alone!");
-
 	    if ((*flags & SHORT_HAND_DATA) == SHORT_HAND_DATA)
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p-data' may only be "
 				"specified alone!");
-
             if ((*flags & IPP2P_EDK) == IPP2P_EDK)
             exit_error(PARAMETER_PROBLEM,
                                 "ipp2p: use `--edk' OR `--edk-data' but not both of them!");
-
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_DATA_EDK;
 	    info->cmd = *flags;
 	    break;																											
@@ -202,7 +206,6 @@
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p-data' may only be "
 				"specified alone!");
-
 	    if ((*flags & SHORT_HAND_IPP2P) == SHORT_HAND_IPP2P)
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p' may only be "
@@ -210,9 +213,7 @@
             if ((*flags & IPP2P_DC) == IPP2P_DC)
             exit_error(PARAMETER_PROBLEM,
                                 "ipp2p: use `--dc' OR `--dc-data' but not both of them!");
-
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_DATA_DC;
 	    info->cmd = *flags;
 	    break;																											
@@ -230,13 +231,10 @@
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p-data' may only be "
 				"specified alone!");
-
             if ((*flags & IPP2P_DATA_DC) == IPP2P_DATA_DC)
             exit_error(PARAMETER_PROBLEM,
                                 "ipp2p: use `--dc' OR `--dc-data' but not both of them!");
-
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_DC;
 	    info->cmd = *flags;
 	    break;																											
@@ -255,13 +253,10 @@
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p-data' may only be "
 				"specified alone!");
-
             if ((*flags & IPP2P_GNU) == IPP2P_GNU)
             exit_error(PARAMETER_PROBLEM,
                                 "ipp2p: use `--gnu' OR `--gnu-data' but not both of them!");
-
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_DATA_GNU;
 	    info->cmd = *flags;
 	    break;																											
@@ -275,7 +270,6 @@
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p-data' may only be "
 				"specified alone!");
-
 	    if ((*flags & SHORT_HAND_IPP2P) == SHORT_HAND_IPP2P)
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p' may only be "
@@ -283,9 +277,7 @@
             if ((*flags & IPP2P_DATA_GNU) == IPP2P_DATA_GNU)
             exit_error(PARAMETER_PROBLEM,
                                 "ipp2p: use `--gnu' OR `--gnu-data' but not both of them!");
-
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_GNU;
 	    info->cmd = *flags;
 	    break;																											
@@ -299,7 +291,6 @@
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p-data' may only be "
 				"specified alone!");
-
 	    if ((*flags & SHORT_HAND_IPP2P) == SHORT_HAND_IPP2P)
 		    exit_error(PARAMETER_PROBLEM,
 				"ipp2p: `--ipp2p' may only be "
@@ -307,9 +298,7 @@
             if ((*flags & IPP2P_DATA_KAZAA) == IPP2P_DATA_KAZAA)
             exit_error(PARAMETER_PROBLEM,
                                 "ipp2p: use `--kazaa' OR `--kazaa-data' but not both of them!");
-
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_KAZAA;
 	    info->cmd = *flags;
 	    break;																											
@@ -320,7 +309,6 @@
                                 "ipp2p: `--bit' may only be "
                                 "specified once!");
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_BIT;
 	    info->cmd = *flags;
 	    break;																											
@@ -331,7 +319,6 @@
                                 "ipp2p: `--apple' may only be "
                                 "specified once!");
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_APPLE;
 	    info->cmd = *flags;
 	    break;																											
@@ -343,7 +330,6 @@
                                 "ipp2p: `--soul' may only be "
                                 "specified once!");
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_SOUL;
 	    info->cmd = *flags;
 	    break;																											
@@ -355,11 +341,43 @@
                                 "ipp2p: `--winmx' may only be "
                                 "specified once!");
 	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
-
             *flags += IPP2P_WINMX;
 	    info->cmd = *flags;
 	    break;																											
 
+	case 'f':		/*cmd: ares*/
+            if ((*flags & IPP2P_ARES) == IPP2P_ARES)
+            exit_error(PARAMETER_PROBLEM,
+                                "ipp2p: `--ares' may only be "
+                                "specified once!");
+	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
+            *flags += IPP2P_ARES;
+	    info->cmd = *flags;
+	    break;																											
+
+	case 'g':		/*cmd: debug*/
+	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
+	    info->debug = 1;
+	    break;																											
+
+	case 'h':		/*cmd: udp*/
+	    if ((info->proto & IPP2P_PROTO_UDP) == IPP2P_PROTO_UDP)
+		exit_error(PARAMETER_PROBLEM,
+                    "ipp2p: --udp may only be specified once!");
+
+	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
+	    info->proto += IPP2P_PROTO_UDP;
+	    break;																											
+
+
+	case 'i':		/*cmd: tcp*/
+	    if ((info->proto & IPP2P_PROTO_TCP) == IPP2P_PROTO_TCP)
+		exit_error(PARAMETER_PROBLEM,
+                    "ipp2p: --tcp may only be specified once!");
+	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
+	    info->proto += IPP2P_PROTO_TCP;
+	    break;																											
+
 
 	default:
             exit_error(PARAMETER_PROBLEM,
@@ -402,6 +420,10 @@
     if ((info->cmd & IPP2P_APPLE) == IPP2P_APPLE) printf(" --apple");
     if ((info->cmd & IPP2P_SOUL) == IPP2P_SOUL) printf(" --soul");
     if ((info->cmd & IPP2P_WINMX) == IPP2P_WINMX) printf(" --winmx");
+    if ((info->cmd & IPP2P_ARES) == IPP2P_ARES) printf(" --ares");
+    if ((info->proto & IPP2P_PROTO_UDP) == IPP2P_PROTO_UDP) printf(" --udp");
+    if ((info->proto & IPP2P_PROTO_TCP) == IPP2P_PROTO_TCP) printf(" --tcp");
+    if (info->debug != 0) printf(" --debug");
     printf(" ");
 }
 			    						   
@@ -426,6 +448,10 @@
     if ((info->cmd & IPP2P_APPLE) == IPP2P_APPLE) printf("--apple ");
     if ((info->cmd & IPP2P_SOUL) == IPP2P_SOUL) printf("--soul ");
     if ((info->cmd & IPP2P_WINMX) == IPP2P_WINMX) printf("--winmx ");
+    if ((info->cmd & IPP2P_ARES) == IPP2P_ARES) printf("--ares ");
+    if ((info->proto & IPP2P_PROTO_UDP) == IPP2P_PROTO_UDP) printf("--udp ");
+    if ((info->proto & IPP2P_PROTO_TCP) == IPP2P_PROTO_TCP) printf("--tcp ");
+    if (info->debug != 0) printf("--debug ");
 }
 
 		
@@ -454,5 +480,3 @@
     register_match(&ipp2p);
 }
 
- 
-
diff -Nru patch-o-matic-ng-old/ipp2p/iptables/extensions/libipt_ipp2p.man patch-o-matic-ng/ipp2p/iptables/extensions/libipt_ipp2p.man
--- patch-o-matic-ng-old/ipp2p/iptables/extensions/libipt_ipp2p.man	2004-09-13 00:27:06.000000000 +0200
+++ patch-o-matic-ng/ipp2p/iptables/extensions/libipt_ipp2p.man	2004-12-24 00:36:11.532235024 +0100
@@ -1,9 +1,9 @@
-This module matches certain TCP packets in P2P flows. It is not
+This module matches certain packets in P2P flows. It is not
 designed to match all packets belonging to a P2P connection - 
-use IPP2P together with CONNMARK for this purpose. As it works
-on TCP packets only it can only be used in conjunction with
-.B -p tcp
-. It provides the following options:
+use IPP2P together with CONNMARK for this purpose. Also visit
+http://www.ipp2p.org for detailed information.
+
+IPP2P provides the following options:
 .TP
 .B "--edk "
 Matches as many eDonkey/eMule packets as possible.
@@ -29,20 +29,20 @@
 .B "--winmx "
 Matches some WinMX packets. Considered as beta, use careful!
 .TP
-.B "--edk-data "
-Matches eDonkey control packets initiating a download.
-.TP
-.B "--kazaa-data "
-Matches KaZaA control packets initiating a download.
-.TP
-.B "--gnu-data "
-Matches Gnutella control packets initiating a download.
-.TP
-.B "--dc-data "
-Matches Direct Connect control packets initiating a download.
+.B "--ares "
+Matches Ares and AresLite packets. Use together with -j DROP only.
 .TP
 .B "--ipp2p "
 Short hand for: --edk --kazaa --gnu --dc
 .TP
-.B "--ipp2p-data "
-Short hand for: --edk-data --kazaa-data --gnu-data --dc-data
+.B "--tcp "
+Makes IPP2P analyze TCP packets only. Can be also be used together
+with --udp
+.TP
+.B "--udp "
+Makes IPP2P analyze UDP packets only. Can be also be used together
+with --tcp
+.TP
+.B "--debug "
+Prints some information about each hit into kernel logfile. May 
+produce huge logfiles so beware!
diff -Nru patch-o-matic-ng-old/ipp2p/linux/include/linux/netfilter_ipv4/ipt_ipp2p.h patch-o-matic-ng/ipp2p/linux/include/linux/netfilter_ipv4/ipt_ipp2p.h
--- patch-o-matic-ng-old/ipp2p/linux/include/linux/netfilter_ipv4/ipt_ipp2p.h	2004-09-13 00:27:06.000000000 +0200
+++ patch-o-matic-ng/ipp2p/linux/include/linux/netfilter_ipv4/ipt_ipp2p.h	2004-12-23 12:53:03.000000000 +0100
@@ -1,11 +1,14 @@
 #ifndef __IPT_IPP2P_H
 #define __IPT_IPP2P_H
-#define IPP2P_VERSION "0.6.1"
+#define IPP2P_VERSION "0.7"
 
 struct ipt_p2p_info {
-    int cmd;    
+    int cmd;
+    int debug;
+    int proto;
 };
 
+#endif //__IPT_IPP2P_H
 
 #define SHORT_HAND_IPP2P	1 /* --ipp2p switch*/
 #define SHORT_HAND_DATA		4 /* --ipp2p-data switch*/
@@ -23,5 +26,9 @@
 #define IPP2P_APPLE		2048
 #define IPP2P_SOUL		4096
 #define IPP2P_WINMX		8192
+#define IPP2P_ARES		16384
+
+#define IPP2P_PROTO_DEFAULT	1
+#define IPP2P_PROTO_UDP		2
+#define IPP2P_PROTO_TCP		4
 
-#endif /*__IPT_IPP2P_H*/
diff -Nru patch-o-matic-ng-old/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c patch-o-matic-ng/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c
--- patch-o-matic-ng-old/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c	2004-09-13 00:30:14.000000000 +0200
+++ patch-o-matic-ng/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c	2004-12-24 00:37:38.872957216 +0100
@@ -3,38 +3,170 @@
 #include <linux/version.h>
 #include <linux/netfilter_ipv4/ipt_ipp2p.h>
 #include <net/tcp.h>
+#include <net/udp.h>
 
-#if defined(MODVERSIONS)
-    #include <linux/modversions.h>
-#endif
-
+#define get_u8(X,O)  (*(__u8 *)(X + O))
 #define get_u16(X,O)  (*(__u16 *)(X + O))
+#define get_u32(X,O)  (*(__u32 *)(X + O))
 
-MODULE_AUTHOR("Eicke Friedrich <tady at gmx dot net>");
+MODULE_AUTHOR("Eicke Friedrich <ipp2p@ipp2p.org>");
 MODULE_DESCRIPTION("An extension to iptables to identify P2P traffic.");
 MODULE_LICENSE("GPL");
 
 
+/*Search for UDP eDonkey/eMule/Kad commands*/
+int
+udp_search_edk (unsigned char *haystack, int packet_len)
+{
+    unsigned char *t = haystack;
+    t += 8;
+
+    switch (t[0]) {
+    case 0xe3: {	/*edonkey*/
+	switch (t[1]) {
+			/* e3 9a + 16Bytes Hash | size == 26 */
+	case 0x9a: if (packet_len == 26) return ((IPP2P_EDK * 100) + 1);
+			/* e3 96 xx yy zz kk | size == 14 | server status request */
+	case 0x96: if (packet_len == 14) return ((IPP2P_EDK * 100) + 2);
+			/* e3 a2 | size == 10 or 14 <-- recheck*/
+	}
+    }
+
+    case 0xc5: {	/*emule*/
+	switch (t[1]) {
+			/* c5 91 xx yy | size == 12 (8+4) | xx != 0x00  -- xx yy queue rating */
+	case 0x91: if ((packet_len == 12) && (t[2] != 0x00)) return ((IPP2P_EDK * 100) + 3);
+			/* c5 90 xx ..  yy | size == 26 (8+2+16) | xx .. yy == hash  -- file ping */
+	case 0x90: if ((packet_len == 26) && (t[2] != 0x00)) return ((IPP2P_EDK * 100) + 4);
+			/* c5 92 | size == 10 (8+2) -- file not found */
+	case 0x92: if (packet_len == 10) return ((IPP2P_EDK * 100) + 5);
+			/* c5 93 | size == 10 (8+2) -- queue full */
+	case 0x93: if (packet_len == 10) return ((IPP2P_EDK * 100) + 6);
+	}
+    }
+
+    case 0xe4: {	/*kad*/
+	switch (t[1]) {
+			/* e4 50 | size == 12 */
+	    case 0x50: if (packet_len == 12) return ((IPP2P_EDK * 100) + 7);
+			/* e4 58 | size == 14 */
+	    case 0x58: if ((packet_len == 14) && (t[2] != 0x00)) return ((IPP2P_EDK * 100) + 8);
+			/* e4 59 | size == 10 */
+	    case 0x59: if (packet_len == 10) return ((IPP2P_EDK * 100) + 9);
+			/* e4 30 .. | t[18] == 0x01 | size > 26 | --> search */
+	    case 0x30: if ((packet_len > 26) && (t[18] == 0x01)) return ((IPP2P_EDK * 100) + 10);
+			/* e4 28 .. 00 | t[68] == 0x00 | size > 76 */
+	    case 0x28: if ((packet_len > 76) && (t[68] == 0x00)) return ((IPP2P_EDK * 100) + 11);
+			/* e4 20 .. | size == 43 */
+	    case 0x20: if ((packet_len == 43) && (t[2] != 0x00) && (t[34] != 0x00)) return ((IPP2P_EDK * 100) + 12);
+			/* e4 00 .. 00 | size == 35 ? */
+	    case 0x00: if ((packet_len == 35) && (t[26] == 0x00)) return ((IPP2P_EDK * 100) + 13);
+			/* e4 10 .. 00 | size == 35 ? */
+	    case 0x10: if ((packet_len == 35) && (t[26] == 0x00)) return ((IPP2P_EDK * 100) + 14);
+			/* e4 18 .. 00 | size == 35 ? */
+	    case 0x18: if ((packet_len == 35) && (t[26] == 0x00)) return ((IPP2P_EDK * 100) + 15);
+			/* e4 40 .. | t[18] == 0x01 | t[19] == 0x00 | size > 40 */
+	    case 0x40: if ((packet_len > 40) && (t[18] == 0x01) && (t[19] == 0x00)) return ((IPP2P_EDK * 100) + 16);
+	}
+    }
+    
+    default: return 0;
+    } /* end of switch (t[0]) */
+}/*udp_search_edk*/
+
+
+/*Search for UDP Gnutella commands*/
+int
+udp_search_gnu (unsigned char *haystack, int packet_len)
+{
+    unsigned char *t = haystack;
+    t += 8;
+    
+    if (memcmp(t, "GND", 3) == 0) return ((IPP2P_GNU * 100) + 1);
+    if (memcmp(t, "GNUTELLA ", 9) == 0) return ((IPP2P_GNU * 100) + 2);
+    return 0;
+}/*udp_search_gnu*/
+
+
+/*Search for UDP KaZaA commands*/
+int
+udp_search_kazaa (unsigned char *haystack, int packet_len)
+{
+    unsigned char *t = haystack;
+    
+    if (t[packet_len-1] == 0x00){
+	t += (packet_len - 6);
+	if (memcmp(t, "KaZaA", 5) == 0) return (IPP2P_KAZAA * 100);
+    }
+    return 0;
+}/*udp_search_kazaa*/
+
+
+/*Search for UDP BitTorrent commands*/
+int
+udp_search_bit (unsigned char *haystack, int packet_len)
+{
+    unsigned char *t = haystack;
+    
+    /* packet_len has to be 24 */
+    if (packet_len != 24) return 0;
+
+    t += 8;    
+
+    /* ^ 00 00 04 17 27 10 19 80 */
+    if ((ntohl(get_u32(t, 0)) == 0x00000417) && (ntohl(get_u32(t, 4)) == 0x27101980)) return (IPP2P_BIT * 100);
+
+    return 0;
+}/*udp_search_bit*/
+
+
+
+/*Search for Ares commands*/
+int
+search_ares (unsigned char *haystack, int packet_len, int head_len)
+{
+    unsigned char *t = haystack;
+    t += head_len;
+
+    if ((packet_len - head_len) == 6){	/* possible connect command*/
+	if ((t[0] == 0x03) && (t[1] == 0x00) && (t[2] == 0x5a) && (t[3] == 0x04) && (t[4] == 0x03) && (t[5] == 0x05))
+	    return ((IPP2P_ARES * 100) + 1);			/* found connect packet: 03 00 5a 04 03 05 */
+    }
+    if ((packet_len - head_len) == 60){	/* possible download command*/
+	if ((t[59] == 0x0a) && (t[58] == 0x0a)){
+	    if (memcmp(t, "PUSH SHA1:", 10) == 0) /* found download command */
+	    	return ((IPP2P_ARES * 100) + 2);
+	}
+    }
+    return 0;
+} /*search_ares*/
+
+
 /*Search for SoulSeek commands*/
 int
 search_soul (unsigned char *haystack, int packet_len, int head_len)
 {
     unsigned char *t = haystack;
-    int cmd;    
     t += head_len;
 
-    cmd = get_u16(t, 0);	
-    if (cmd == (packet_len - head_len - 4))
-    {
-	if ((t[2] == 0x00) && (t[3] == 0x00) && (t[4] == 0x01)) return 1; 
-					/*CONNECT: xx xx 00 00 01*/
-	if ((t[2] == 0x00) && (t[3] == 0x00) && (t[4] == 0x28)) return 1; 
-					/*TRANSFER REQUEST: xx xx 00 00 28*/
+    if (get_u16(t, 0) == (packet_len - head_len - 4)){
+	    /* xx xx 00 00 yy zz 00 00 .. | xx = sizeof(payload) - 4 */
+	if ((get_u16(t,2) == 0x0000) &&(t[4] != 0x00) && (get_u16(t,6) == 0x0000))
+	    return ((IPP2P_SOUL * 100) + 1);
+    } else {
+	    /* 00 00 00 00 00 00 00 00 + sizeof(payload) == 8*/
+	if (((packet_len - head_len) == 8) && (get_u32(t, 0) == 0x00000000) && (get_u32(t, 4) == 0x00000000))
+	    return ((IPP2P_SOUL * 100) + 2);
     }
+    
+    /* 01 xx 00 00 00 yy .. zz 00 00 00 .. | xx == sizeof(nick) | yy .. zz == nick */
+    if ((t[0] == 0x01) && (t[2] == 0x00) && (get_u16(t,3) == 0x0000) && ((packet_len - head_len) > ((get_u8(t,1))+6)) && 
+	(t[(get_u8(t,1))+4] != 0x00) && (t[(get_u8(t,1))+5] == 0x01) && (t[(get_u8(t,1))+6] == 0x00))
+	    return ((IPP2P_SOUL * 100) + 3);
     return 0;
-
 }
 
+
 /*Search for WinMX commands*/
 int
 search_winmx (unsigned char *haystack, int packet_len, int head_len)
@@ -43,31 +175,31 @@
     int c;
     t += head_len;
 
-    if (((packet_len - head_len) == 4) && (memcmp(t, "SEND", 4) == 0))  return 1;
-    if (((packet_len - head_len) == 3) && (memcmp(t, "GET", 3) == 0))  return 1;
+    if (((packet_len - head_len) == 4) && (memcmp(t, "SEND", 4) == 0))  return ((IPP2P_WINMX * 100) + 1);
+    if (((packet_len - head_len) == 3) && (memcmp(t, "GET", 3) == 0))  return ((IPP2P_WINMX * 100) + 2);
     if (packet_len < (head_len + 10)) return 0;
 
     if ((memcmp(t, "SEND", 4) == 0) || (memcmp(t, "GET", 3) == 0)){
         c = head_len + 4;
-        t += 4;
-        while (c < packet_len - 5) {
-            if ((t[0] == 0x20) && (t[1] == 0x22)) {
-                c += 2;
-                t += 2;
-                while (c < packet_len - 2) {
-                    if ((t[0] == 0x22) && (t[1] == 0x20)) return 1;
-                    t++;
-                    c++;
-                }
-            }
-            t++;
-            c++;
-        }
+	t += 4;
+	while (c < packet_len - 5) {
+	    if ((t[0] == 0x20) && (t[1] == 0x22)){
+		c += 2;
+		t += 2;
+		while (c < packet_len - 2) {
+		    if ((t[0] == 0x22) && (t[1] == 0x20)) return ((IPP2P_WINMX * 100) + 3);
+		    t++;
+		    c++;
+		}
+	    }
+	    t++;
+	    c++;
+	}    
     }
     return 0;
-
 } /*search_winmx*/
 
+
 /*Search for appleJuice commands*/
 int
 search_apple (unsigned char *haystack, int packet_len, int head_len)
@@ -75,7 +207,7 @@
     unsigned char *t = haystack;
     t += head_len;
     
-    if ((memcmp(t, "ajprot", 6) == 0) && (t[6] == 0x0d) && (t[7] == 0x0a))  return 1;
+    if ((memcmp(t, "ajprot", 6) == 0) && (t[6] == 0x0d) && (t[7] == 0x0a))  return (IPP2P_APPLE * 100);
     
     return 0;
 }
@@ -91,7 +223,7 @@
     
     t += head_len + 1;
     
-    if (memcmp(t, "BitTorrent protocol", 19) == 0) return 1;        
+    if (memcmp(t, "BitTorrent protocol", 19) == 0) return (IPP2P_BIT * 100);
     return 0;
 }
 
@@ -107,7 +239,7 @@
 
     t += head_len;
     if (memcmp(t, "GET /.hash=", 11) == 0)
-	return 1;
+	return (IPP2P_DATA_KAZAA * 100);
     else
 	return 0;
 }
@@ -122,8 +254,8 @@
     if (!((*(haystack + packet_len - 2) == 0x0d) && (*(haystack + packet_len - 1) == 0x0a))) return 0;    
 
     t += head_len;
-    if (memcmp(t, "GET /get/", 9) == 0)	return 1;
-    if (memcmp(t, "GET /uri-res/", 13) == 0) return 1; 
+    if (memcmp(t, "GET /get/", 9) == 0)	return ((IPP2P_DATA_GNU * 100) + 1);
+    if (memcmp(t, "GET /uri-res/", 13) == 0) return ((IPP2P_DATA_GNU * 100) + 2); 
     
     return 0;
 }
@@ -140,8 +272,8 @@
 
     t += head_len;
 
-    if (memcmp(t, "GNUTELLA CONNECT/", 17) == 0) return 1;        
-    if (memcmp(t, "GNUTELLA/", 9) == 0) return 1;    
+    if (memcmp(t, "GNUTELLA CONNECT/", 17) == 0) return ((IPP2P_GNU * 100) + 1);
+    if (memcmp(t, "GNUTELLA/", 9) == 0) return ((IPP2P_GNU * 100) + 2);    
 
     if ((memcmp(t, "GET /get/", 9) == 0) || (memcmp(t, "GET /uri-res/", 13) == 0))
     {        
@@ -149,7 +281,7 @@
 	t += 8;
 	while (c < packet_len - 22) {
 	    if ((t[0] == 0x0d) && (t[1] == 0x0a)) {
-		    if ((memcmp(t, "X-Gnutella-", 11) == 0) || (memcmp(t, "X-Queue:", 8) == 0)) return 1;
+		    if ((memcmp(t, "X-Gnutella-", 11) == 0) || (memcmp(t, "X-Queue:", 8) == 0)) return ((IPP2P_GNU * 100) + 3);
 		    t += 2;
 		    c += 2;
 	    } else {
@@ -172,14 +304,14 @@
     if (!((*(haystack + packet_len - 2) == 0x0d) && (*(haystack + packet_len - 1) == 0x0a))) return 0;
 
     t += head_len;
-    if (memcmp(t, "GIVE ", 5) == 0) return 1;    
+    if (memcmp(t, "GIVE ", 5) == 0) return ((IPP2P_KAZAA * 100) + 1);
     
     if (memcmp(t, "GET /", 5) == 0) {
         c = head_len + 8;
 	t += 8;
 	while (c < packet_len - 22) {
 	    if ((t[0] == 0x0d) && (t[1] == 0x0a)) {
-    		    if ( memcmp(t, "X-Kazaa-Username: ", 18) == 0 ) return 1;	    
+    		    if ( memcmp(t, "X-Kazaa-Username: ", 18) == 0 ) return ((IPP2P_KAZAA * 100) + 2);	    
 		    t += 2;
 		    c += 2;
 	    } else {
@@ -200,7 +332,7 @@
 	return 0;
     else {
 	if (*(haystack+head_len+5) == 0x47) 
-	    return 1;
+	    return (IPP2P_DATA_EDK * 100);
 	else 	
 	    return 0;
     }
@@ -220,8 +352,8 @@
 	cmd = get_u16(t, 1);	
 	if (cmd == (packet_len - head_len - 5))	{
 	    switch (t[5]) {
-		case 0x82: return 1;
-		case 0x15: return 1;
+		case 0x82: return ((IPP2P_EDK * 100) + 42);
+		case 0x15: return ((IPP2P_EDK * 100) + 43);
 		default: return 0;
 	    }
 	}
@@ -235,18 +367,18 @@
 
 	if (cmd == (packet_len - head_len - 5))	{
 	    switch (t[5]) {
-		case 0x01: return 1;	
-		case 0x02: return 1;		    	    
-		case 0x60: return 1;
-		case 0x81: return 1;
-		case 0x82: return 1;	    
-		case 0x85: return 1;	    
-		case 0x86: return 1;
-		case 0x87: return 1;
-		case 0x40: return 1;
-		case 0x92: return 1;
-		case 0x93: return 1;	
-		case 0x12: return 1;		    
+		case 0x01: return ((IPP2P_EDK * 100) + 30);
+		case 0x02: return ((IPP2P_EDK * 100) + 31);
+		case 0x60: return ((IPP2P_EDK * 100) + 32);
+		case 0x81: return ((IPP2P_EDK * 100) + 33);
+		case 0x82: return ((IPP2P_EDK * 100) + 34);
+		case 0x85: return ((IPP2P_EDK * 100) + 35);
+		case 0x86: return ((IPP2P_EDK * 100) + 36);
+		case 0x87: return ((IPP2P_EDK * 100) + 37);
+		case 0x40: return ((IPP2P_EDK * 100) + 38);
+		case 0x92: return ((IPP2P_EDK * 100) + 39);
+		case 0x93: return ((IPP2P_EDK * 100) + 40);
+		case 0x12: return ((IPP2P_EDK * 100) + 41);
 		default: return 0;
 	    }
 	}
@@ -259,47 +391,47 @@
 	return 0;
     else {
 	t += head_len;	
-	cmd = get_u16(t, 1);	
+	cmd = get_u16(t, 1);
 	if (cmd == (packet_len - head_len - 5)) {
 	    switch (t[5]) {
-		case 0x01: return 1;	/*Client: hello or Server:hello*/
-		case 0x50: return 1;	/*Client: file status*/
-		case 0x16: return 1;	/*Client: search*/
-		case 0x58: return 1;	/*Client: file request*/
-		case 0x48: return 1;	/*???*/
-		case 0x54: return 1;	/*???*/
-		case 0x47: return 1;	/*Client: file segment request*/
-		case 0x46: return 1; /*Client: download segment*/
-		case 0x4c: return 1;	/*Client: Hello-Answer*/
-		case 0x4f: return 1;	/*Client: file status request*/
-		case 0x59: return 1;	/*Client: file request answer*/
-		case 0x65: return 1;	/*Client: ???*/
-		case 0x66: return 1;	/*Client: ???*/
-		case 0x51: return 1;	/*Client: ???*/
-		case 0x52: return 1;	/*Client: ???*/
-		case 0x4d: return 1;	/*Client: ???*/
-		case 0x5c: return 1;	/*Client: ???*/
-		case 0x38: return 1;	/*Client: ???*/
-		case 0x69: return 1;	/*Client: ???*/
-		case 0x19: return 1;	/*Client: ???*/
-		case 0x42: return 1;	/*Client: ???*/
-		case 0x34: return 1;	/*Client: ???*/
-		case 0x94: return 1;	/*Client: ???*/
-		case 0x1c: return 1;	/*Client: ???*/
-		case 0x6a: return 1;	/*Client: ???*/
+		case 0x01: return ((IPP2P_EDK * 100) + 1);	/*Client: hello or Server:hello*/
+		case 0x50: return ((IPP2P_EDK * 100) + 2);	/*Client: file status*/
+		case 0x16: return ((IPP2P_EDK * 100) + 3);	/*Client: search*/
+		case 0x58: return ((IPP2P_EDK * 100) + 4);	/*Client: file request*/
+		case 0x48: return ((IPP2P_EDK * 100) + 5);	/*???*/
+		case 0x54: return ((IPP2P_EDK * 100) + 6);	/*???*/
+		case 0x47: return ((IPP2P_EDK * 100) + 7);	/*Client: file segment request*/
+		case 0x46: return ((IPP2P_EDK * 100) + 8); /*Client: download segment*/
+		case 0x4c: return ((IPP2P_EDK * 100) + 9);	/*Client: Hello-Answer*/
+		case 0x4f: return ((IPP2P_EDK * 100) + 10);	/*Client: file status request*/
+		case 0x59: return ((IPP2P_EDK * 100) + 11);	/*Client: file request answer*/
+		case 0x65: return ((IPP2P_EDK * 100) + 12);	/*Client: ???*/
+		case 0x66: return ((IPP2P_EDK * 100) + 13);	/*Client: ???*/
+		case 0x51: return ((IPP2P_EDK * 100) + 14);	/*Client: ???*/
+		case 0x52: return ((IPP2P_EDK * 100) + 15);	/*Client: ???*/
+		case 0x4d: return ((IPP2P_EDK * 100) + 16);	/*Client: ???*/
+		case 0x5c: return ((IPP2P_EDK * 100) + 17);	/*Client: ???*/
+		case 0x38: return ((IPP2P_EDK * 100) + 18);	/*Client: ???*/
+		case 0x69: return ((IPP2P_EDK * 100) + 19);	/*Client: ???*/
+		case 0x19: return ((IPP2P_EDK * 100) + 20);	/*Client: ???*/
+		case 0x42: return ((IPP2P_EDK * 100) + 21);	/*Client: ???*/
+		case 0x34: return ((IPP2P_EDK * 100) + 22);	/*Client: ???*/
+		case 0x94: return ((IPP2P_EDK * 100) + 23);	/*Client: ???*/
+		case 0x1c: return ((IPP2P_EDK * 100) + 24);	/*Client: ???*/
+		case 0x6a: return ((IPP2P_EDK * 100) + 25);	/*Client: ???*/
 		default: return 0;
 	    }
 	} else {
 	    if (cmd > packet_len - head_len - 5) {
 		if ((t[3] == 0x00) && (t[4] == 0x00)) {
-		    if (t[5] == 0x01) return 1;
-		    if (t[5] == 0x4c) return 1;
+		    if (t[5] == 0x01) return ((IPP2P_EDK * 100) + 26);
+		    if (t[5] == 0x4c) return ((IPP2P_EDK * 100) + 27);
 		} 
 		return 0;
 		
 	    }	/*non edk packet*/
-	    if (t[cmd+5] == 0xe3) return 1;		/*found another edk-command*/
-	    if (t[cmd+5] == 0xc5) return 1;		/*found an emule-command*/	    
+	    if (t[cmd+5] == 0xe3) return ((IPP2P_EDK * 100) + 28);/*found another edk-command*/
+	    if (t[cmd+5] == 0xc5) return ((IPP2P_EDK * 100) + 29);/*found an emule-command*/	    
 	    return 0;
 	}
     }
@@ -317,7 +449,7 @@
     else {
 	t += head_len + 1;
         if (memcmp(t, "Send|", 5) == 0)
-	    return 1;
+	    return (IPP2P_DATA_DC * 100);
 	else
 	    return 0;
     }	
@@ -333,12 +465,12 @@
 
     if ((*(haystack + head_len) == 0x24) && (*(haystack + packet_len - 1) == 0x7c)) {
     	t += head_len + 1;
-	if (memcmp(t, "Lock ", 5) == 0)	 return 1; /*hub: hello*/
-	if (memcmp(t, "Key ", 4) == 0)	 return 1; /*client: hello*/
-	if (memcmp(t, "Hello ", 6) == 0) return 1; /*hub:connected*/
-	if (memcmp(t, "MyNick ", 7) == 0) return 1; /*client-client: hello*/
-	if (memcmp(t, "Search ", 7) == 0) return 1; /*client: search*/
-	if (memcmp(t, "Send", 4) == 0)	 return 1; /*client: start download*/
+	if (memcmp(t, "Lock ", 5) == 0)	 return ((IPP2P_DC * 100) + 1); /*hub: hello*/
+	if (memcmp(t, "Key ", 4) == 0)	 return ((IPP2P_DC * 100) + 2); /*client: hello*/
+	if (memcmp(t, "Hello ", 6) == 0) return ((IPP2P_DC * 100) + 3); /*hub:connected*/
+	if (memcmp(t, "MyNick ", 7) == 0) return ((IPP2P_DC * 100) + 4); /*client-client: hello*/
+	if (memcmp(t, "Search ", 7) == 0) return ((IPP2P_DC * 100) + 5); /*client: search*/
+	if (memcmp(t, "Send", 4) == 0)	 return ((IPP2P_DC * 100) + 6); /*client: start download*/
 	return 0;
     } else
 	return 0;
@@ -361,8 +493,23 @@
     {IPP2P_KAZAA,SHORT_HAND_IPP2P,35, &search_all_kazaa},
     {IPP2P_BIT,SHORT_HAND_NONE,40, &search_bittorrent},
     {IPP2P_APPLE,SHORT_HAND_NONE,20, &search_apple},
-    {IPP2P_SOUL,SHORT_HAND_NONE,20, &search_soul},
+    {IPP2P_SOUL,SHORT_HAND_NONE,25, &search_soul},
     {IPP2P_WINMX,SHORT_HAND_NONE,20, &search_winmx},
+    {IPP2P_ARES,SHORT_HAND_NONE,25, &search_ares},
+    {0,0,0,NULL}
+};
+
+
+static struct {
+    int command;
+    __u8 short_hand;			/*for fucntions included in short hands*/
+    int packet_len;
+    int (*function_name) (unsigned char *, int);
+} udp_list[] = {
+    {IPP2P_KAZAA,SHORT_HAND_IPP2P,14, &udp_search_kazaa},
+    {IPP2P_BIT,SHORT_HAND_NONE,23, &udp_search_bit},
+    {IPP2P_GNU,SHORT_HAND_IPP2P,11, &udp_search_gnu},
+    {IPP2P_EDK,SHORT_HAND_IPP2P,9, &udp_search_edk},
     {0,0,0,NULL}
 };
 
@@ -382,29 +529,65 @@
     struct iphdr *ip = skb->nh.iph;
     int p2p_result = 0, i = 0;
     int head_len;
-    struct tcphdr *tcph = (void *) ip + ip->ihl * 4;
 
+    /*must not be a fragment*/
+    if (offset) {printk("IPP2P.match: offset found %i \n",offset); return 0;}
 
     int hlen = ntohs(ip->tot_len)-(ip->ihl*4);	/*hlen = packet-data length*/
     haystack=(char *)ip+(ip->ihl*4);		/*haystack = packet data*/
 
-
-    if (tcph->fin) return 0;  /*if FIN bit is set bail out*/
-    if (tcph->syn) return 0;  /*if SYN bit is set bail out*/
-    if (tcph->rst) return 0;  /*if RST bit is set bail out*/
+    switch (ip->protocol){
+	case IPPROTO_TCP:		/*what to do with a TCP packet*/
+	{
+	    /*if don't look for TCP packets bail out*/
+	    if ((info->proto > IPP2P_PROTO_DEFAULT) && (info->proto < IPP2P_PROTO_TCP)) return 0;
 	    
-
-    head_len = tcph->doff * 4; /*get TCP-Header-Size*/
-    while (matchlist[i].command) {
-	if ((((info->cmd & matchlist[i].command) == matchlist[i].command) ||
-	    ((info->cmd & matchlist[i].short_hand) == matchlist[i].short_hand)) &&
-		(hlen > matchlist[i].packet_len)) {
-	    p2p_result = matchlist[i].function_name(haystack, hlen, head_len);
-	    if (p2p_result) return p2p_result;
+	    struct tcphdr *tcph = (void *) ip + ip->ihl * 4;
+	    if (tcph->fin) return 0;  /*if FIN bit is set bail out*/
+	    if (tcph->syn) return 0;  /*if SYN bit is set bail out*/
+	    if (tcph->rst) return 0;  /*if RST bit is set bail out*/
+	    head_len = tcph->doff * 4; /*get TCP-Header-Size*/
+	    while (matchlist[i].command) {
+		if ((((info->cmd & matchlist[i].command) == matchlist[i].command) ||
+		    ((info->cmd & matchlist[i].short_hand) == matchlist[i].short_hand)) &&
+		    (hlen > matchlist[i].packet_len)) {
+			    p2p_result = matchlist[i].function_name(haystack, hlen, head_len);
+			    if (p2p_result) 
+			    {
+				if (info->debug) printk("IPP2P.debug:TCP-match: %i from: %u.%u.%u.%u:%i to: %u.%u.%u.%u:%i Length: %i\n", 
+				    p2p_result, NIPQUAD(ip->saddr),ntohs(tcph->source), NIPQUAD(ip->daddr),ntohs(tcph->dest),hlen);
+				return p2p_result;
+    			    }
+    		}
+	    i++;
+	    }
+	    return p2p_result;
+	}
+	
+	case IPPROTO_UDP:		/*what to do with an UDP packet*/
+	{
+	    /*if we don't look for UDP packets bail out*/
+	    if ((info->proto & IPP2P_PROTO_UDP) != IPP2P_PROTO_UDP) return 0;
+	    
+	    struct udphdr *udph = (void *) ip + ip->ihl * 4;
+	    while (udp_list[i].command){
+		if ((((info->cmd & udp_list[i].command) == udp_list[i].command) ||
+		    ((info->cmd & udp_list[i].short_hand) == udp_list[i].short_hand)) &&
+		    (hlen > udp_list[i].packet_len)) {
+			    p2p_result = udp_list[i].function_name(haystack, hlen);
+			    if (p2p_result){
+				if (info->debug) printk("IPP2P.debug:UDP-match: %i from: %u.%u.%u.%u:%i to: %u.%u.%u.%u:%i Length: %i\n", 
+				    p2p_result, NIPQUAD(ip->saddr),ntohs(udph->source), NIPQUAD(ip->daddr),ntohs(udph->dest),hlen);
+				return p2p_result;
+			    }
+		}
+	    i++;
+	    }			
+	    return p2p_result;
 	}
-	i++;
+    
+	default: return 0;
     }
-    return p2p_result;
 }
 
 
@@ -417,12 +600,10 @@
 	    unsigned int hook_mask)
 {
         /* Must specify -p tcp */
-    if (ip->proto != IPPROTO_TCP || (ip->invflags & IPT_INV_PROTO)) {
-	printk("ipp2p: Only works on TCP packets, use -p tcp\n");
-	return 0;
-    }
-							
-
+/*    if (ip->proto != IPPROTO_TCP || (ip->invflags & IPT_INV_PROTO)) {
+ *	printk("ipp2p: Only works on TCP packets, use -p tcp\n");
+ *	return 0;
+ *    }*/
     return 1;
 }
 									    
diff -Nru patch-o-matic-ng-old/ipp2p/linux-2.6/include/linux/netfilter_ipv4/ipt_ipp2p.h patch-o-matic-ng/ipp2p/linux-2.6/include/linux/netfilter_ipv4/ipt_ipp2p.h
--- patch-o-matic-ng-old/ipp2p/linux-2.6/include/linux/netfilter_ipv4/ipt_ipp2p.h	2004-09-13 00:27:06.000000000 +0200
+++ patch-o-matic-ng/ipp2p/linux-2.6/include/linux/netfilter_ipv4/ipt_ipp2p.h	2004-12-23 12:53:03.000000000 +0100
@@ -1,11 +1,14 @@
 #ifndef __IPT_IPP2P_H
 #define __IPT_IPP2P_H
-#define IPP2P_VERSION "0.6.1"
+#define IPP2P_VERSION "0.7"
 
 struct ipt_p2p_info {
-    int cmd;    
+    int cmd;
+    int debug;
+    int proto;
 };
 
+#endif //__IPT_IPP2P_H
 
 #define SHORT_HAND_IPP2P	1 /* --ipp2p switch*/
 #define SHORT_HAND_DATA		4 /* --ipp2p-data switch*/
@@ -23,5 +26,9 @@
 #define IPP2P_APPLE		2048
 #define IPP2P_SOUL		4096
 #define IPP2P_WINMX		8192
+#define IPP2P_ARES		16384
+
+#define IPP2P_PROTO_DEFAULT	1
+#define IPP2P_PROTO_UDP		2
+#define IPP2P_PROTO_TCP		4
 
-#endif /*__IPT_IPP2P_H*/
diff -Nru patch-o-matic-ng-old/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c patch-o-matic-ng/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c
--- patch-o-matic-ng-old/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	2004-09-13 00:30:14.000000000 +0200
+++ patch-o-matic-ng/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	2004-12-24 00:37:15.602494864 +0100
@@ -3,32 +3,168 @@
 #include <linux/version.h>
 #include <linux/netfilter_ipv4/ipt_ipp2p.h>
 #include <net/tcp.h>
+#include <net/udp.h>
 
+
+#define get_u8(X,O)  (*(__u8 *)(X + O))
 #define get_u16(X,O)  (*(__u16 *)(X + O))
+#define get_u32(X,O)  (*(__u32 *)(X + O))
 
-MODULE_AUTHOR("Eicke Friedrich <tady at gmx dot net>");
+MODULE_AUTHOR("Eicke Friedrich <ipp2p@ipp2p.org>");
 MODULE_DESCRIPTION("An extension to iptables to identify P2P traffic.");
 MODULE_LICENSE("GPL");
 
 
+/*Search for UDP eDonkey/eMule/Kad commands*/
+int
+udp_search_edk (unsigned char *haystack, int packet_len)
+{
+    unsigned char *t = haystack;
+    t += 8;
+
+    switch (t[0]) {
+    case 0xe3: {	/*edonkey*/
+	switch (t[1]) {
+			/* e3 9a + 16Bytes Hash | size == 26 */
+	case 0x9a: if (packet_len == 26) return ((IPP2P_EDK * 100) + 1);
+			/* e3 96 xx yy zz kk | size == 14 | server status request */
+	case 0x96: if (packet_len == 14) return ((IPP2P_EDK * 100) + 2);
+			/* e3 a2 | size == 10 or 14 <-- recheck*/
+	}
+    }
+
+    case 0xc5: {	/*emule*/
+	switch (t[1]) {
+			/* c5 91 xx yy | size == 12 (8+4) | xx != 0x00  -- xx yy queue rating */
+	case 0x91: if ((packet_len == 12) && (t[2] != 0x00)) return ((IPP2P_EDK * 100) + 3);
+			/* c5 90 xx ..  yy | size == 26 (8+2+16) | xx .. yy == hash  -- file ping */
+	case 0x90: if ((packet_len == 26) && (t[2] != 0x00)) return ((IPP2P_EDK * 100) + 4);
+			/* c5 92 | size == 10 (8+2) -- file not found */
+	case 0x92: if (packet_len == 10) return ((IPP2P_EDK * 100) + 5);
+			/* c5 93 | size == 10 (8+2) -- queue full */
+	case 0x93: if (packet_len == 10) return ((IPP2P_EDK * 100) + 6);
+	}
+    }
+
+    case 0xe4: {	/*kad*/
+	switch (t[1]) {
+			/* e4 50 | size == 12 */
+	    case 0x50: if (packet_len == 12) return ((IPP2P_EDK * 100) + 7);
+			/* e4 58 | size == 14 */
+	    case 0x58: if ((packet_len == 14) && (t[2] != 0x00)) return ((IPP2P_EDK * 100) + 8);
+			/* e4 59 | size == 10 */
+	    case 0x59: if (packet_len == 10) return ((IPP2P_EDK * 100) + 9);
+			/* e4 30 .. | t[18] == 0x01 | size > 26 | --> search */
+	    case 0x30: if ((packet_len > 26) && (t[18] == 0x01)) return ((IPP2P_EDK * 100) + 10);
+			/* e4 28 .. 00 | t[68] == 0x00 | size > 76 */
+	    case 0x28: if ((packet_len > 76) && (t[68] == 0x00)) return ((IPP2P_EDK * 100) + 11);
+			/* e4 20 .. | size == 43 */
+	    case 0x20: if ((packet_len == 43) && (t[2] != 0x00) && (t[34] != 0x00)) return ((IPP2P_EDK * 100) + 12);
+			/* e4 00 .. 00 | size == 35 ? */
+	    case 0x00: if ((packet_len == 35) && (t[26] == 0x00)) return ((IPP2P_EDK * 100) + 13);
+			/* e4 10 .. 00 | size == 35 ? */
+	    case 0x10: if ((packet_len == 35) && (t[26] == 0x00)) return ((IPP2P_EDK * 100) + 14);
+			/* e4 18 .. 00 | size == 35 ? */
+	    case 0x18: if ((packet_len == 35) && (t[26] == 0x00)) return ((IPP2P_EDK * 100) + 15);
+			/* e4 40 .. | t[18] == 0x01 | t[19] == 0x00 | size > 40 */
+	    case 0x40: if ((packet_len > 40) && (t[18] == 0x01) && (t[19] == 0x00)) return ((IPP2P_EDK * 100) + 16);
+	}
+    }
+    
+    default: return 0;
+    } /* end of switch (t[0]) */
+}/*udp_search_edk*/
+
+
+/*Search for UDP Gnutella commands*/
+int
+udp_search_gnu (unsigned char *haystack, int packet_len)
+{
+    unsigned char *t = haystack;
+    t += 8;
+    
+    if (memcmp(t, "GND", 3) == 0) return ((IPP2P_GNU * 100) + 1);
+    if (memcmp(t, "GNUTELLA ", 9) == 0) return ((IPP2P_GNU * 100) + 2);
+    return 0;
+}/*udp_search_gnu*/
+
+
+/*Search for UDP KaZaA commands*/
+int
+udp_search_kazaa (unsigned char *haystack, int packet_len)
+{
+    unsigned char *t = haystack;
+    
+    if (t[packet_len-1] == 0x00){
+	t += (packet_len - 6);
+	if (memcmp(t, "KaZaA", 5) == 0) return (IPP2P_KAZAA * 100);
+    }
+    return 0;
+}/*udp_search_kazaa*/
+
+
+/*Search for UDP BitTorrent commands*/
+int
+udp_search_bit (unsigned char *haystack, int packet_len)
+{
+    unsigned char *t = haystack;
+    
+    /* packet_len has to be 24 */
+    if (packet_len != 24) return 0;
+
+    t += 8;    
+
+    /* ^ 00 00 04 17 27 10 19 80 */
+    if ((ntohl(get_u32(t, 0)) == 0x00000417) && (ntohl(get_u32(t, 4)) == 0x27101980)) return (IPP2P_BIT * 100);
+
+    return 0;
+}/*udp_search_bit*/
+
+
+
+/*Search for Ares commands*/
+int
+search_ares (unsigned char *haystack, int packet_len, int head_len)
+{
+    unsigned char *t = haystack;
+    t += head_len;
+
+    if ((packet_len - head_len) == 6){	/* possible connect command*/
+	if ((t[0] == 0x03) && (t[1] == 0x00) && (t[2] == 0x5a) && (t[3] == 0x04) && (t[4] == 0x03) && (t[5] == 0x05))
+	    return ((IPP2P_ARES * 100) + 1);			/* found connect packet: 03 00 5a 04 03 05 */
+    }
+    if ((packet_len - head_len) == 60){	/* possible download command*/
+	if ((t[59] == 0x0a) && (t[58] == 0x0a)){
+	    if (memcmp(t, "PUSH SHA1:", 10) == 0) /* found download command */
+	    	return ((IPP2P_ARES * 100) + 2);
+	}
+    }
+    return 0;
+} /*search_ares*/
+
+
 /*Search for SoulSeek commands*/
 int
 search_soul (unsigned char *haystack, int packet_len, int head_len)
 {
     unsigned char *t = haystack;
-    int cmd;    
     t += head_len;
 
-    cmd = get_u16(t, 0);	
-    if (cmd == (packet_len - head_len - 4))
-    {
-	if ((t[2] == 0x00) && (t[3] == 0x00) && (t[4] == 0x01)) return 1; 
-					/*CONNECT: xx xx 00 00 01*/
-	if ((t[2] == 0x00) && (t[3] == 0x00) && (t[4] == 0x28)) return 1; 
-					/*TRANSFER REQUEST: xx xx 00 00 28*/
+    if (get_u16(t, 0) == (packet_len - head_len - 4)){
+	    /* xx xx 00 00 yy zz 00 00 .. | xx = sizeof(payload) - 4 */
+	if ((get_u16(t,2) == 0x0000) &&(t[4] != 0x00) && (get_u16(t,6) == 0x0000))
+	    return ((IPP2P_SOUL * 100) + 1);
+    } else {
+	    /* 00 00 00 00 00 00 00 00 + sizeof(payload) == 8*/
+	if (((packet_len - head_len) == 8) && (get_u32(t, 0) == 0x00000000) && (get_u32(t, 4) == 0x00000000))
+	    return ((IPP2P_SOUL * 100) + 2);
     }
+    
+    /* 01 xx 00 00 00 yy .. zz 00 00 00 .. | xx == sizeof(nick) | yy .. zz == nick */
+    if ((t[0] == 0x01) && (t[2] == 0x00) && (get_u16(t,3) == 0x0000) && ((packet_len - head_len) > ((get_u8(t,1))+6)) && 
+	(t[(get_u8(t,1))+4] != 0x00) && (t[(get_u8(t,1))+5] == 0x01) && (t[(get_u8(t,1))+6] == 0x00))
+	    return ((IPP2P_SOUL * 100) + 3);
     return 0;
-
 }
 
 
@@ -40,31 +176,31 @@
     int c;
     t += head_len;
 
-    if (((packet_len - head_len) == 4) && (memcmp(t, "SEND", 4) == 0))  return 1;
-    if (((packet_len - head_len) == 3) && (memcmp(t, "GET", 3) == 0))  return 1;
+    if (((packet_len - head_len) == 4) && (memcmp(t, "SEND", 4) == 0))  return ((IPP2P_WINMX * 100) + 1);
+    if (((packet_len - head_len) == 3) && (memcmp(t, "GET", 3) == 0))  return ((IPP2P_WINMX * 100) + 2);
     if (packet_len < (head_len + 10)) return 0;
 
     if ((memcmp(t, "SEND", 4) == 0) || (memcmp(t, "GET", 3) == 0)){
         c = head_len + 4;
-        t += 4;
-        while (c < packet_len - 5) {
-            if ((t[0] == 0x20) && (t[1] == 0x22)) {
-                c += 2;
-                t += 2;
-                while (c < packet_len - 2) {
-                    if ((t[0] == 0x22) && (t[1] == 0x20)) return 1;
-                    t++;
-                    c++;
-                }
-            }
-            t++;
-            c++;
-        }
+	t += 4;
+	while (c < packet_len - 5) {
+	    if ((t[0] == 0x20) && (t[1] == 0x22)){
+		c += 2;
+		t += 2;
+		while (c < packet_len - 2) {
+		    if ((t[0] == 0x22) && (t[1] == 0x20)) return ((IPP2P_WINMX * 100) + 3);
+		    t++;
+		    c++;
+		}
+	    }
+	    t++;
+	    c++;
+	}    
     }
     return 0;
-
 } /*search_winmx*/
 
+
 /*Search for appleJuice commands*/
 int
 search_apple (unsigned char *haystack, int packet_len, int head_len)
@@ -72,7 +208,7 @@
     unsigned char *t = haystack;
     t += head_len;
     
-    if ((memcmp(t, "ajprot", 6) == 0) && (t[6] == 0x0d) && (t[7] == 0x0a))  return 1;
+    if ((memcmp(t, "ajprot", 6) == 0) && (t[6] == 0x0d) && (t[7] == 0x0a))  return (IPP2P_APPLE * 100);
     
     return 0;
 }
@@ -88,7 +224,7 @@
     
     t += head_len + 1;
     
-    if (memcmp(t, "BitTorrent protocol", 19) == 0) return 1;        
+    if (memcmp(t, "BitTorrent protocol", 19) == 0) return (IPP2P_BIT * 100);
     return 0;
 }
 
@@ -104,7 +240,7 @@
 
     t += head_len;
     if (memcmp(t, "GET /.hash=", 11) == 0)
-	return 1;
+	return (IPP2P_DATA_KAZAA * 100);
     else
 	return 0;
 }
@@ -119,8 +255,8 @@
     if (!((*(haystack + packet_len - 2) == 0x0d) && (*(haystack + packet_len - 1) == 0x0a))) return 0;    
 
     t += head_len;
-    if (memcmp(t, "GET /get/", 9) == 0)	return 1;
-    if (memcmp(t, "GET /uri-res/", 13) == 0) return 1; 
+    if (memcmp(t, "GET /get/", 9) == 0)	return ((IPP2P_DATA_GNU * 100) + 1);
+    if (memcmp(t, "GET /uri-res/", 13) == 0) return ((IPP2P_DATA_GNU * 100) + 2); 
     
     return 0;
 }
@@ -137,8 +273,8 @@
 
     t += head_len;
 
-    if (memcmp(t, "GNUTELLA CONNECT/", 17) == 0) return 1;        
-    if (memcmp(t, "GNUTELLA/", 9) == 0) return 1;    
+    if (memcmp(t, "GNUTELLA CONNECT/", 17) == 0) return ((IPP2P_GNU * 100) + 1);
+    if (memcmp(t, "GNUTELLA/", 9) == 0) return ((IPP2P_GNU * 100) + 2);    
 
     if ((memcmp(t, "GET /get/", 9) == 0) || (memcmp(t, "GET /uri-res/", 13) == 0))
     {        
@@ -146,7 +282,7 @@
 	t += 8;
 	while (c < packet_len - 22) {
 	    if ((t[0] == 0x0d) && (t[1] == 0x0a)) {
-		    if ((memcmp(t, "X-Gnutella-", 11) == 0) || (memcmp(t, "X-Queue:", 8) == 0)) return 1;
+		    if ((memcmp(t, "X-Gnutella-", 11) == 0) || (memcmp(t, "X-Queue:", 8) == 0)) return ((IPP2P_GNU * 100) + 3);
 		    t += 2;
 		    c += 2;
 	    } else {
@@ -169,14 +305,14 @@
     if (!((*(haystack + packet_len - 2) == 0x0d) && (*(haystack + packet_len - 1) == 0x0a))) return 0;
 
     t += head_len;
-    if (memcmp(t, "GIVE ", 5) == 0) return 1;    
+    if (memcmp(t, "GIVE ", 5) == 0) return ((IPP2P_KAZAA * 100) + 1);
     
     if (memcmp(t, "GET /", 5) == 0) {
         c = head_len + 8;
 	t += 8;
 	while (c < packet_len - 22) {
 	    if ((t[0] == 0x0d) && (t[1] == 0x0a)) {
-    		    if ( memcmp(t, "X-Kazaa-Username: ", 18) == 0 ) return 1;	    
+    		    if ( memcmp(t, "X-Kazaa-Username: ", 18) == 0 ) return ((IPP2P_KAZAA * 100) + 2);	    
 		    t += 2;
 		    c += 2;
 	    } else {
@@ -197,7 +333,7 @@
 	return 0;
     else {
 	if (*(haystack+head_len+5) == 0x47) 
-	    return 1;
+	    return (IPP2P_DATA_EDK * 100);
 	else 	
 	    return 0;
     }
@@ -217,8 +353,8 @@
 	cmd = get_u16(t, 1);	
 	if (cmd == (packet_len - head_len - 5))	{
 	    switch (t[5]) {
-		case 0x82: return 1;
-		case 0x15: return 1;
+		case 0x82: return ((IPP2P_EDK * 100) + 42);
+		case 0x15: return ((IPP2P_EDK * 100) + 43);
 		default: return 0;
 	    }
 	}
@@ -232,18 +368,18 @@
 
 	if (cmd == (packet_len - head_len - 5))	{
 	    switch (t[5]) {
-		case 0x01: return 1;	
-		case 0x02: return 1;		    	    
-		case 0x60: return 1;
-		case 0x81: return 1;
-		case 0x82: return 1;	    
-		case 0x85: return 1;	    
-		case 0x86: return 1;
-		case 0x87: return 1;
-		case 0x40: return 1;
-		case 0x92: return 1;
-		case 0x93: return 1;	
-		case 0x12: return 1;		    
+		case 0x01: return ((IPP2P_EDK * 100) + 30);
+		case 0x02: return ((IPP2P_EDK * 100) + 31);
+		case 0x60: return ((IPP2P_EDK * 100) + 32);
+		case 0x81: return ((IPP2P_EDK * 100) + 33);
+		case 0x82: return ((IPP2P_EDK * 100) + 34);
+		case 0x85: return ((IPP2P_EDK * 100) + 35);
+		case 0x86: return ((IPP2P_EDK * 100) + 36);
+		case 0x87: return ((IPP2P_EDK * 100) + 37);
+		case 0x40: return ((IPP2P_EDK * 100) + 38);
+		case 0x92: return ((IPP2P_EDK * 100) + 39);
+		case 0x93: return ((IPP2P_EDK * 100) + 40);
+		case 0x12: return ((IPP2P_EDK * 100) + 41);
 		default: return 0;
 	    }
 	}
@@ -256,47 +392,47 @@
 	return 0;
     else {
 	t += head_len;	
-	cmd = get_u16(t, 1);	
+	cmd = get_u16(t, 1);
 	if (cmd == (packet_len - head_len - 5)) {
 	    switch (t[5]) {
-		case 0x01: return 1;	/*Client: hello or Server:hello*/
-		case 0x50: return 1;	/*Client: file status*/
-		case 0x16: return 1;	/*Client: search*/
-		case 0x58: return 1;	/*Client: file request*/
-		case 0x48: return 1;	/*???*/
-		case 0x54: return 1;	/*???*/
-		case 0x47: return 1;	/*Client: file segment request*/
-		case 0x46: return 1; /*Client: download segment*/
-		case 0x4c: return 1;	/*Client: Hello-Answer*/
-		case 0x4f: return 1;	/*Client: file status request*/
-		case 0x59: return 1;	/*Client: file request answer*/
-		case 0x65: return 1;	/*Client: ???*/
-		case 0x66: return 1;	/*Client: ???*/
-		case 0x51: return 1;	/*Client: ???*/
-		case 0x52: return 1;	/*Client: ???*/
-		case 0x4d: return 1;	/*Client: ???*/
-		case 0x5c: return 1;	/*Client: ???*/
-		case 0x38: return 1;	/*Client: ???*/
-		case 0x69: return 1;	/*Client: ???*/
-		case 0x19: return 1;	/*Client: ???*/
-		case 0x42: return 1;	/*Client: ???*/
-		case 0x34: return 1;	/*Client: ???*/
-		case 0x94: return 1;	/*Client: ???*/
-		case 0x1c: return 1;	/*Client: ???*/
-		case 0x6a: return 1;	/*Client: ???*/
+		case 0x01: return ((IPP2P_EDK * 100) + 1);	/*Client: hello or Server:hello*/
+		case 0x50: return ((IPP2P_EDK * 100) + 2);	/*Client: file status*/
+		case 0x16: return ((IPP2P_EDK * 100) + 3);	/*Client: search*/
+		case 0x58: return ((IPP2P_EDK * 100) + 4);	/*Client: file request*/
+		case 0x48: return ((IPP2P_EDK * 100) + 5);	/*???*/
+		case 0x54: return ((IPP2P_EDK * 100) + 6);	/*???*/
+		case 0x47: return ((IPP2P_EDK * 100) + 7);	/*Client: file segment request*/
+		case 0x46: return ((IPP2P_EDK * 100) + 8); /*Client: download segment*/
+		case 0x4c: return ((IPP2P_EDK * 100) + 9);	/*Client: Hello-Answer*/
+		case 0x4f: return ((IPP2P_EDK * 100) + 10);	/*Client: file status request*/
+		case 0x59: return ((IPP2P_EDK * 100) + 11);	/*Client: file request answer*/
+		case 0x65: return ((IPP2P_EDK * 100) + 12);	/*Client: ???*/
+		case 0x66: return ((IPP2P_EDK * 100) + 13);	/*Client: ???*/
+		case 0x51: return ((IPP2P_EDK * 100) + 14);	/*Client: ???*/
+		case 0x52: return ((IPP2P_EDK * 100) + 15);	/*Client: ???*/
+		case 0x4d: return ((IPP2P_EDK * 100) + 16);	/*Client: ???*/
+		case 0x5c: return ((IPP2P_EDK * 100) + 17);	/*Client: ???*/
+		case 0x38: return ((IPP2P_EDK * 100) + 18);	/*Client: ???*/
+		case 0x69: return ((IPP2P_EDK * 100) + 19);	/*Client: ???*/
+		case 0x19: return ((IPP2P_EDK * 100) + 20);	/*Client: ???*/
+		case 0x42: return ((IPP2P_EDK * 100) + 21);	/*Client: ???*/
+		case 0x34: return ((IPP2P_EDK * 100) + 22);	/*Client: ???*/
+		case 0x94: return ((IPP2P_EDK * 100) + 23);	/*Client: ???*/
+		case 0x1c: return ((IPP2P_EDK * 100) + 24);	/*Client: ???*/
+		case 0x6a: return ((IPP2P_EDK * 100) + 25);	/*Client: ???*/
 		default: return 0;
 	    }
 	} else {
 	    if (cmd > packet_len - head_len - 5) {
 		if ((t[3] == 0x00) && (t[4] == 0x00)) {
-		    if (t[5] == 0x01) return 1;
-		    if (t[5] == 0x4c) return 1;
+		    if (t[5] == 0x01) return ((IPP2P_EDK * 100) + 26);
+		    if (t[5] == 0x4c) return ((IPP2P_EDK * 100) + 27);
 		} 
 		return 0;
 		
 	    }	/*non edk packet*/
-	    if (t[cmd+5] == 0xe3) return 1;		/*found another edk-command*/
-	    if (t[cmd+5] == 0xc5) return 1;		/*found an emule-command*/	    
+	    if (t[cmd+5] == 0xe3) return ((IPP2P_EDK * 100) + 28);/*found another edk-command*/
+	    if (t[cmd+5] == 0xc5) return ((IPP2P_EDK * 100) + 29);/*found an emule-command*/	    
 	    return 0;
 	}
     }
@@ -314,7 +450,7 @@
     else {
 	t += head_len + 1;
         if (memcmp(t, "Send|", 5) == 0)
-	    return 1;
+	    return (IPP2P_DATA_DC * 100);
 	else
 	    return 0;
     }	
@@ -330,12 +466,12 @@
 
     if ((*(haystack + head_len) == 0x24) && (*(haystack + packet_len - 1) == 0x7c)) {
     	t += head_len + 1;
-	if (memcmp(t, "Lock ", 5) == 0)	 return 1; /*hub: hello*/
-	if (memcmp(t, "Key ", 4) == 0)	 return 1; /*client: hello*/
-	if (memcmp(t, "Hello ", 6) == 0) return 1; /*hub:connected*/
-	if (memcmp(t, "MyNick ", 7) == 0) return 1; /*client-client: hello*/
-	if (memcmp(t, "Search ", 7) == 0) return 1; /*client: search*/
-	if (memcmp(t, "Send", 4) == 0)	 return 1; /*client: start download*/
+	if (memcmp(t, "Lock ", 5) == 0)	 return ((IPP2P_DC * 100) + 1); /*hub: hello*/
+	if (memcmp(t, "Key ", 4) == 0)	 return ((IPP2P_DC * 100) + 2); /*client: hello*/
+	if (memcmp(t, "Hello ", 6) == 0) return ((IPP2P_DC * 100) + 3); /*hub:connected*/
+	if (memcmp(t, "MyNick ", 7) == 0) return ((IPP2P_DC * 100) + 4); /*client-client: hello*/
+	if (memcmp(t, "Search ", 7) == 0) return ((IPP2P_DC * 100) + 5); /*client: search*/
+	if (memcmp(t, "Send", 4) == 0)	 return ((IPP2P_DC * 100) + 6); /*client: start download*/
 	return 0;
     } else
 	return 0;
@@ -358,8 +494,23 @@
     {IPP2P_KAZAA,SHORT_HAND_IPP2P,35, &search_all_kazaa},
     {IPP2P_BIT,SHORT_HAND_NONE,40, &search_bittorrent},
     {IPP2P_APPLE,SHORT_HAND_NONE,20, &search_apple},
-    {IPP2P_SOUL,SHORT_HAND_NONE,20, &search_soul},
+    {IPP2P_SOUL,SHORT_HAND_NONE,25, &search_soul},
     {IPP2P_WINMX,SHORT_HAND_NONE,20, &search_winmx},
+    {IPP2P_ARES,SHORT_HAND_NONE,25, &search_ares},
+    {0,0,0,NULL}
+};
+
+
+static struct {
+    int command;
+    __u8 short_hand;			/*for fucntions included in short hands*/
+    int packet_len;
+    int (*function_name) (unsigned char *, int);
+} udp_list[] = {
+    {IPP2P_KAZAA,SHORT_HAND_IPP2P,14, &udp_search_kazaa},
+    {IPP2P_BIT,SHORT_HAND_NONE,23, &udp_search_bit},
+    {IPP2P_GNU,SHORT_HAND_IPP2P,11, &udp_search_gnu},
+    {IPP2P_EDK,SHORT_HAND_IPP2P,9, &udp_search_edk},
     {0,0,0,NULL}
 };
 
@@ -377,29 +528,65 @@
     struct iphdr *ip = skb->nh.iph;
     int p2p_result = 0, i = 0;
     int head_len;
-    struct tcphdr *tcph = (void *) ip + ip->ihl * 4;
 
+    /*must not be a fragment*/
+    if (offset) {printk("IPP2P.match: offset found %i \n",offset); return 0;}
 
     int hlen = ntohs(ip->tot_len)-(ip->ihl*4);	/*hlen = packet-data length*/
     haystack=(char *)ip+(ip->ihl*4);		/*haystack = packet data*/
 
-
-    if (tcph->fin) return 0;  /*if FIN bit is set bail out*/
-    if (tcph->syn) return 0;  /*if SYN bit is set bail out*/
-    if (tcph->rst) return 0;  /*if RST bit is set bail out*/
+    switch (ip->protocol){
+	case IPPROTO_TCP:		/*what to do with a TCP packet*/
+	{
+	    /*if don't look for TCP packets bail out*/
+	    if ((info->proto > IPP2P_PROTO_DEFAULT) && (info->proto < IPP2P_PROTO_TCP)) return 0;
 	    
-
-    head_len = tcph->doff * 4; /*get TCP-Header-Size*/
-    while (matchlist[i].command) {
-	if ((((info->cmd & matchlist[i].command) == matchlist[i].command) ||
-	    ((info->cmd & matchlist[i].short_hand) == matchlist[i].short_hand)) &&
-		(hlen > matchlist[i].packet_len)) {
-	    p2p_result = matchlist[i].function_name(haystack, hlen, head_len);
-	    if (p2p_result) return p2p_result;
+	    struct tcphdr *tcph = (void *) ip + ip->ihl * 4;
+	    if (tcph->fin) return 0;  /*if FIN bit is set bail out*/
+	    if (tcph->syn) return 0;  /*if SYN bit is set bail out*/
+	    if (tcph->rst) return 0;  /*if RST bit is set bail out*/
+	    head_len = tcph->doff * 4; /*get TCP-Header-Size*/
+	    while (matchlist[i].command) {
+		if ((((info->cmd & matchlist[i].command) == matchlist[i].command) ||
+		    ((info->cmd & matchlist[i].short_hand) == matchlist[i].short_hand)) &&
+		    (hlen > matchlist[i].packet_len)) {
+			    p2p_result = matchlist[i].function_name(haystack, hlen, head_len);
+			    if (p2p_result) 
+			    {
+				if (info->debug) printk("IPP2P.debug:TCP-match: %i from: %u.%u.%u.%u:%i to: %u.%u.%u.%u:%i Length: %i\n", 
+				    p2p_result, NIPQUAD(ip->saddr),ntohs(tcph->source), NIPQUAD(ip->daddr),ntohs(tcph->dest),hlen);
+				return p2p_result;
+    			    }
+    		}
+	    i++;
+	    }
+	    return p2p_result;
+	}
+	
+	case IPPROTO_UDP:		/*what to do with an UDP packet*/
+	{
+	    /*if we don't look for UDP packets bail out*/
+	    if ((info->proto & IPP2P_PROTO_UDP) != IPP2P_PROTO_UDP) return 0;
+	    
+	    struct udphdr *udph = (void *) ip + ip->ihl * 4;
+	    while (udp_list[i].command){
+		if ((((info->cmd & udp_list[i].command) == udp_list[i].command) ||
+		    ((info->cmd & udp_list[i].short_hand) == udp_list[i].short_hand)) &&
+		    (hlen > udp_list[i].packet_len)) {
+			    p2p_result = udp_list[i].function_name(haystack, hlen);
+			    if (p2p_result){
+				if (info->debug) printk("IPP2P.debug:UDP-match: %i from: %u.%u.%u.%u:%i to: %u.%u.%u.%u:%i Length: %i\n", 
+				    p2p_result, NIPQUAD(ip->saddr),ntohs(udph->source), NIPQUAD(ip->daddr),ntohs(udph->dest),hlen);
+				return p2p_result;
+			    }
+		}
+	    i++;
+	    }			
+	    return p2p_result;
 	}
-	i++;
+    
+	default: return 0;
     }
-    return p2p_result;
 }
 
 
@@ -412,12 +599,10 @@
 	    unsigned int hook_mask)
 {
         /* Must specify -p tcp */
-    if (ip->proto != IPPROTO_TCP || (ip->invflags & IPT_INV_PROTO)) {
-	printk("ipp2p: Only works on TCP packets, use -p tcp\n");
-	return 0;
-    }
-							
-
+/*    if (ip->proto != IPPROTO_TCP || (ip->invflags & IPT_INV_PROTO)) {
+ *	printk("ipp2p: Only works on TCP packets, use -p tcp\n");
+ *	return 0;
+ *    }*/
     return 1;
 }
 									    

--------------060509070002090605010202--
