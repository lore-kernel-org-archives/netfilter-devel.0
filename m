From: Eicke Friedrich <tady@gmx.net>
Subject: [PATCH] IPP2P update to 0.6.1
Date: Fri, 10 Sep 2004 11:17:03 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4141710F.7040303@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060503050508080906010205"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060503050508080906010205
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi folks,

a patch against latest pom-ng snapshot is attached containing an
update to the current ipp2p code. It offers first support for WinMX
packets (beta - please come back to me with any feedback) and some
code cleanup (spaces). Please apply.

Regards,
Eicke.

PS: is the script creating daily snapshots of pom-ng at
ftp.netfilter.org not running?

--------------060503050508080906010205
Content-Type: text/plain;
 name="ipp2p-0.6.1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipp2p-0.6.1.diff"

diff -Nru patch-o-matic-ng-orig/ipp2p/iptables/extensions/libipt_ipp2p.c patch-o-matic-ng-new/ipp2p/iptables/extensions/libipt_ipp2p.c
--- patch-o-matic-ng-orig/ipp2p/iptables/extensions/libipt_ipp2p.c	2004-07-13 13:43:15.000000000 +0200
+++ patch-o-matic-ng-new/ipp2p/iptables/extensions/libipt_ipp2p.c	2004-09-10 11:06:34.442282680 +0200
@@ -1,4 +1,3 @@
-
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -19,18 +18,19 @@
     printf(
     "IPP2P v%s options:\n"
     " --ipp2p	Grab all known p2p packets\n"
-    " --ipp2p-data	Grab all known p2p data packets\n"    
-    " --edk		Grab all known eDonkey/eMule/Overnet packets\n"    
+    " --ipp2p-data	Grab all known p2p data packets\n"
+    " --edk		Grab all known eDonkey/eMule/Overnet packets\n"
     " --edk-data	Grab all eDonkey/eMule/Overnet data packets\n"
     " --dc		Grab all known Direct Connect packets\n"
     " --dc-data	Grab all Direct Connect data packets\n"
-    " --kazaa	Grab all KaZaA packets\n"    
+    " --kazaa	Grab all KaZaA packets\n"
     " --kazaa-data	Grab all KaZaA data packets\n"
-    " --gnu		Grab all Gnutella packets\n"    
+    " --gnu		Grab all Gnutella packets\n"
     " --gnu-data	Grab all Gnutella data packets\n"
-    " --bit		Grab all BitTorrent packets\n"    
+    " --bit		Grab all BitTorrent packets\n"
     " --apple	Grab all AppleJuice packets (beta - just a few tests until now)\n"
     " --soul		SoulSeek (beta - handle with care)\n"
+    " --winmx	WinMX (beta - handle with care)\n"
     "\nNote that the follwing options will have the same meaning:\n"
     " '--ipp2p' is equal to '--edk --dc --kazaa --gnu'\n"
     " '--ipp2p-data' is equal to '--edk-data --dc-data --kazaa-data --gnu-data'\n"
@@ -43,18 +43,19 @@
 
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
+	{ "apple", 0, 0, 'c' },
+	{ "soul", 0, 0, 'd' },
+	{ "winmx", 0, 0, 'e' },
         {0}
 };
 
@@ -348,6 +349,18 @@
 	    break;																											
 
 
+	case 'e':		/*cmd: winmx*/
+            if ((*flags & IPP2P_WINMX) == IPP2P_WINMX)
+            exit_error(PARAMETER_PROBLEM,
+                                "ipp2p: `--winmx' may only be "
+                                "specified once!");
+	    if (invert) exit_error(PARAMETER_PROBLEM, "ipp2p: invert [!] is not allowed!");
+
+            *flags += IPP2P_WINMX;
+	    info->cmd = *flags;
+	    break;																											
+
+
 	default:
             exit_error(PARAMETER_PROBLEM,
 	    "\nipp2p-parameter problem: for ipp2p usage type: iptables -m ipp2p --help\n");
@@ -377,17 +390,18 @@
     printf("ipp2p v%s", IPP2P_VERSION);
     if ((info->cmd & SHORT_HAND_IPP2P) == SHORT_HAND_IPP2P) printf(" --ipp2p");
     if ((info->cmd & SHORT_HAND_DATA) == SHORT_HAND_DATA) printf(" --ipp2p-data");
-    if ((info->cmd & IPP2P_KAZAA) == IPP2P_KAZAA) printf(" --kazaa");        
+    if ((info->cmd & IPP2P_KAZAA) == IPP2P_KAZAA) printf(" --kazaa");
     if ((info->cmd & IPP2P_DATA_KAZAA) == IPP2P_DATA_KAZAA) printf(" --kazaa-data");
-    if ((info->cmd & IPP2P_DATA_GNU) == IPP2P_DATA_GNU) printf(" --gnu-data");    
+    if ((info->cmd & IPP2P_DATA_GNU) == IPP2P_DATA_GNU) printf(" --gnu-data");
     if ((info->cmd & IPP2P_GNU) == IPP2P_GNU) printf(" --gnu");
-    if ((info->cmd & IPP2P_EDK) == IPP2P_EDK) printf(" --edk");    
-    if ((info->cmd & IPP2P_DATA_EDK) == IPP2P_DATA_EDK) printf(" --edk-data");    
+    if ((info->cmd & IPP2P_EDK) == IPP2P_EDK) printf(" --edk");
+    if ((info->cmd & IPP2P_DATA_EDK) == IPP2P_DATA_EDK) printf(" --edk-data");
     if ((info->cmd & IPP2P_DATA_DC) == IPP2P_DATA_DC) printf(" --dc-data");
-    if ((info->cmd & IPP2P_DC) == IPP2P_DC) printf(" --dc");    
-    if ((info->cmd & IPP2P_BIT) == IPP2P_BIT) printf(" --bit");        
-    if ((info->cmd & IPP2P_APPLE) == IPP2P_APPLE) printf(" --apple");    
-    if ((info->cmd & IPP2P_SOUL) == IPP2P_SOUL) printf(" --soul");        
+    if ((info->cmd & IPP2P_DC) == IPP2P_DC) printf(" --dc");
+    if ((info->cmd & IPP2P_BIT) == IPP2P_BIT) printf(" --bit");
+    if ((info->cmd & IPP2P_APPLE) == IPP2P_APPLE) printf(" --apple");
+    if ((info->cmd & IPP2P_SOUL) == IPP2P_SOUL) printf(" --soul");
+    if ((info->cmd & IPP2P_WINMX) == IPP2P_WINMX) printf(" --winmx");
     printf(" ");
 }
 			    						   
@@ -400,17 +414,18 @@
     
     if ((info->cmd & SHORT_HAND_IPP2P) == SHORT_HAND_IPP2P) printf("--ipp2p ");
     if ((info->cmd & SHORT_HAND_DATA) == SHORT_HAND_DATA) printf("--ipp2p-data ");
-    if ((info->cmd & IPP2P_KAZAA) == IPP2P_KAZAA) printf("--kazaa ");        
+    if ((info->cmd & IPP2P_KAZAA) == IPP2P_KAZAA) printf("--kazaa ");
     if ((info->cmd & IPP2P_DATA_KAZAA) == IPP2P_DATA_KAZAA) printf("--kazaa-data ");
-    if ((info->cmd & IPP2P_DATA_GNU) == IPP2P_DATA_GNU) printf("--gnu-data ");    
+    if ((info->cmd & IPP2P_DATA_GNU) == IPP2P_DATA_GNU) printf("--gnu-data ");
     if ((info->cmd & IPP2P_GNU) == IPP2P_GNU) printf("--gnu ");
-    if ((info->cmd & IPP2P_EDK) == IPP2P_EDK) printf("--edk ");    
-    if ((info->cmd & IPP2P_DATA_EDK) == IPP2P_DATA_EDK) printf("--edk-data ");    
+    if ((info->cmd & IPP2P_EDK) == IPP2P_EDK) printf("--edk ");
+    if ((info->cmd & IPP2P_DATA_EDK) == IPP2P_DATA_EDK) printf("--edk-data ");
     if ((info->cmd & IPP2P_DATA_DC) == IPP2P_DATA_DC) printf("--dc-data ");
-    if ((info->cmd & IPP2P_DC) == IPP2P_DC) printf("--dc ");    
-    if ((info->cmd & IPP2P_BIT) == IPP2P_BIT) printf("--bit ");        
-    if ((info->cmd & IPP2P_APPLE) == IPP2P_APPLE) printf("--apple ");    
-    if ((info->cmd & IPP2P_SOUL) == IPP2P_SOUL) printf("--soul ");        
+    if ((info->cmd & IPP2P_DC) == IPP2P_DC) printf("--dc ");
+    if ((info->cmd & IPP2P_BIT) == IPP2P_BIT) printf("--bit ");
+    if ((info->cmd & IPP2P_APPLE) == IPP2P_APPLE) printf("--apple ");
+    if ((info->cmd & IPP2P_SOUL) == IPP2P_SOUL) printf("--soul ");
+    if ((info->cmd & IPP2P_WINMX) == IPP2P_WINMX) printf("--winmx ");
 }
 
 		
diff -Nru patch-o-matic-ng-orig/ipp2p/iptables/extensions/libipt_ipp2p.man patch-o-matic-ng-new/ipp2p/iptables/extensions/libipt_ipp2p.man
--- patch-o-matic-ng-orig/ipp2p/iptables/extensions/libipt_ipp2p.man	2004-07-13 13:43:15.000000000 +0200
+++ patch-o-matic-ng-new/ipp2p/iptables/extensions/libipt_ipp2p.man	2004-09-10 09:36:30.031877944 +0200
@@ -26,6 +26,9 @@
 .B "--soul "
 Matches some SoulSeek packets. Considered as beta, use careful!
 .TP
+.B "--winmx "
+Matches some WinMX packets. Considered as beta, use careful!
+.TP
 .B "--edk-data "
 Matches eDonkey control packets initiating a download.
 .TP
diff -Nru patch-o-matic-ng-orig/ipp2p/linux/include/linux/netfilter_ipv4/ipt_ipp2p.h patch-o-matic-ng-new/ipp2p/linux/include/linux/netfilter_ipv4/ipt_ipp2p.h
--- patch-o-matic-ng-orig/ipp2p/linux/include/linux/netfilter_ipv4/ipt_ipp2p.h	2004-07-13 13:43:15.000000000 +0200
+++ patch-o-matic-ng-new/ipp2p/linux/include/linux/netfilter_ipv4/ipt_ipp2p.h	2004-09-10 09:30:02.129848016 +0200
@@ -1,6 +1,6 @@
 #ifndef __IPT_IPP2P_H
 #define __IPT_IPP2P_H
-#define IPP2P_VERSION "0.6"
+#define IPP2P_VERSION "0.6.1"
 
 struct ipt_p2p_info {
     int cmd;    
@@ -22,5 +22,6 @@
 #define IPP2P_BIT		1024
 #define IPP2P_APPLE		2048
 #define IPP2P_SOUL		4096
+#define IPP2P_WINMX		8192
 
 #endif /*__IPT_IPP2P_H*/
diff -Nru patch-o-matic-ng-orig/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c patch-o-matic-ng-new/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c
--- patch-o-matic-ng-orig/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c	2004-07-13 13:43:15.000000000 +0200
+++ patch-o-matic-ng-new/ipp2p/linux/net/ipv4/netfilter/ipt_ipp2p.c	2004-09-10 11:01:56.511534576 +0200
@@ -35,6 +35,37 @@
 
 }
 
+/*Search for WinMX commands*/
+int
+search_winmx (unsigned char *haystack, int packet_len, int head_len)
+{
+    unsigned char *t = haystack;
+    int c;
+    t += head_len;
+
+    if (((packet_len - head_len) == 4) && (memcmp(t, "SEND", 4) == 0))  return 1;
+    if (packet_len < (head_len + 10)) return 0;
+
+    if (memcmp(t, "SEND", 4) == 0){
+        c = head_len + 4;
+        t += 4;
+        while (c < packet_len - 5) {
+            if ((t[0] == 0x20) && (t[1] == 0x22)) {
+                c += 2;
+                t += 2;
+                while (c < packet_len - 2) {
+                    if ((t[0] == 0x22) && (t[1] == 0x20)) return 1;
+                    t++;
+                    c++;
+                }
+            }
+            t++;
+            c++;
+        }
+    }
+    return 0;
+
+} /*search_winmx*/
 
 /*Search for appleJuice commands*/
 int
@@ -330,6 +361,7 @@
     {IPP2P_BIT,SHORT_HAND_NONE,40, &search_bittorrent},
     {IPP2P_APPLE,SHORT_HAND_NONE,20, &search_apple},
     {IPP2P_SOUL,SHORT_HAND_NONE,20, &search_soul},
+    {IPP2P_WINMX,SHORT_HAND_NONE,20, &search_winmx},
     {0,0,0,NULL}
 };
 
diff -Nru patch-o-matic-ng-orig/ipp2p/linux-2.6/include/linux/netfilter_ipv4/ipt_ipp2p.h patch-o-matic-ng-new/ipp2p/linux-2.6/include/linux/netfilter_ipv4/ipt_ipp2p.h
--- patch-o-matic-ng-orig/ipp2p/linux-2.6/include/linux/netfilter_ipv4/ipt_ipp2p.h	2004-07-13 13:43:15.000000000 +0200
+++ patch-o-matic-ng-new/ipp2p/linux-2.6/include/linux/netfilter_ipv4/ipt_ipp2p.h	2004-09-10 09:29:22.119930448 +0200
@@ -1,6 +1,6 @@
 #ifndef __IPT_IPP2P_H
 #define __IPT_IPP2P_H
-#define IPP2P_VERSION "0.6"
+#define IPP2P_VERSION "0.6.1"
 
 struct ipt_p2p_info {
     int cmd;    
@@ -22,5 +22,6 @@
 #define IPP2P_BIT		1024
 #define IPP2P_APPLE		2048
 #define IPP2P_SOUL		4096
+#define IPP2P_WINMX		8192
 
 #endif /*__IPT_IPP2P_H*/
diff -Nru patch-o-matic-ng-orig/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c patch-o-matic-ng-new/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c
--- patch-o-matic-ng-orig/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	2004-07-13 13:43:15.000000000 +0200
+++ patch-o-matic-ng-new/ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	2004-09-10 11:02:17.171393800 +0200
@@ -32,6 +32,38 @@
 }
 
 
+/*Search for WinMX commands*/
+int
+search_winmx (unsigned char *haystack, int packet_len, int head_len)
+{
+    unsigned char *t = haystack;
+    int c;
+    t += head_len;
+
+    if (((packet_len - head_len) == 4) && (memcmp(t, "SEND", 4) == 0))  return 1;
+    if (packet_len < (head_len + 10)) return 0;
+
+    if (memcmp(t, "SEND", 4) == 0){
+        c = head_len + 4;
+        t += 4;
+        while (c < packet_len - 5) {
+            if ((t[0] == 0x20) && (t[1] == 0x22)) {
+                c += 2;
+                t += 2;
+                while (c < packet_len - 2) {
+                    if ((t[0] == 0x22) && (t[1] == 0x20)) return 1;
+                    t++;
+                    c++;
+                }
+            }
+            t++;
+            c++;
+        }
+    }
+    return 0;
+
+} /*search_winmx*/
+
 /*Search for appleJuice commands*/
 int
 search_apple (unsigned char *haystack, int packet_len, int head_len)
@@ -326,6 +358,7 @@
     {IPP2P_BIT,SHORT_HAND_NONE,40, &search_bittorrent},
     {IPP2P_APPLE,SHORT_HAND_NONE,20, &search_apple},
     {IPP2P_SOUL,SHORT_HAND_NONE,20, &search_soul},
+    {IPP2P_WINMX,SHORT_HAND_NONE,20, &search_winmx},
     {0,0,0,NULL}
 };
 

--------------060503050508080906010205--
