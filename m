From: Thomas Heinz <creatix@hipac.org>
Subject: [PATCH] mac match extension
Date: Tue, 15 Oct 2002 21:44:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DAC7003.6000900@hipac.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020705050907070503040006"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020705050907070503040006
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi

Some days ago, Dan Searle asked for a mac match extension where it
should be possible to apply arbitrary masks to the mac address:
http://msgs.securepoint.com/cgi-bin/get/netfilter-0210/170.html

I extended the mac matching code and attached the patch to this
e-mail.

Although I think that this feature will be used very rarely it
might be helpful to have it in patch-o-matic. Anyway, it's your
decision. If you don't like it or believe that it is not useful
throw it away ;-)


Regards,

Thomas

--------------020705050907070503040006
Content-Type: text/plain;
 name="ipt_mac-mask.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_mac-mask.patch"

--- kernel-source-2.4.19/include/linux/netfilter_ipv4/ipt_mac.h	2002-10-15 17:16:09.000000000 +0200
+++ kernel-source-2.4.19.new/include/linux/netfilter_ipv4/ipt_mac.h	2002-10-15 18:30:44.000000000 +0200
@@ -2,7 +2,9 @@
 #define _IPT_MAC_H
 
 struct ipt_mac_info {
-    unsigned char srcaddr[ETH_ALEN];
-    int invert;
+	unsigned char srcaddr[ETH_ALEN];
+	unsigned char mask[ETH_ALEN];
+	int is_mask;
+	int invert;
 };
 #endif /*_IPT_MAC_H*/
--- kernel-source-2.4.19/net/ipv4/netfilter/ipt_mac.c	2002-10-15 20:48:39.000000000 +0200
+++ kernel-source-2.4.19.new/net/ipv4/netfilter/ipt_mac.c	2002-10-15 20:49:02.000000000 +0200
@@ -18,12 +18,30 @@
 {
     const struct ipt_mac_info *info = matchinfo;
 
-    /* Is mac pointer valid? */
-    return (skb->mac.raw >= skb->head
-	    && (skb->mac.raw + ETH_HLEN) <= skb->data
-	    /* If so, compare... */
-	    && ((memcmp(skb->mac.ethernet->h_source, info->srcaddr, ETH_ALEN)
+    if (info->is_mask) {
+	    if (skb->mac.raw >= skb->head &&
+		(skb->mac.raw + ETH_HLEN) <= skb->data) {
+		    int i;
+		    for (i = 0; i < ETH_HLEN; i++) {
+			    if ((skb->mac.ethernet->h_source[i] & 
+				 info->mask[i]) != 
+				(info->srcaddr[i] & info->mask[i])) {
+				    return info->invert;
+			    }
+		    }
+		    return !info->invert;
+	    } else {
+		    return 0;
+	    }
+    } else {
+	    /* Is mac pointer valid? */
+	    return (skb->mac.raw >= skb->head
+		    && (skb->mac.raw + ETH_HLEN) <= skb->data
+		    /* If so, compare... */
+		    && ((memcmp(skb->mac.ethernet->h_source,
+				info->srcaddr, ETH_ALEN)
 		== 0) ^ info->invert));
+    }
 }
 
 static int

--------------020705050907070503040006
Content-Type: text/plain;
 name="ipt_mac-mask.patch.help"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_mac-mask.patch.help"

Author: Thomas Heinz <creatix@hipac.org>
Status: should work :-)

This patch extends the mac match in a way that arbitrary masks can be applied.

Here is an example:
# iptables -A INPUT -m mac --mac-source 12:34:56:78:90:AB --mac-mask FF:FF:70:07:FF:FF -j REJECT

***** WARNING ***** This patch also patch the userspace directory which means that
                    you have to recompile and reinstall the iptables package after that.

--------------020705050907070503040006
Content-Type: text/plain;
 name="ipt_mac-mask.patch.userspace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_mac-mask.patch.userspace"

--- userspace/extensions/libipt_mac.c~	2002-10-15 17:12:27.000000000 +0200
+++ userspace/extensions/libipt_mac.c	2002-10-15 20:52:33.000000000 +0200
@@ -20,11 +20,14 @@
 "MAC v%s options:\n"
 " --mac-source [!] XX:XX:XX:XX:XX:XX\n"
 "				Match source MAC address\n"
+" --mac-mask XX:XX:XX:XX:XX:XX\n"
+"				Apply mask to source MAC address\n"
 "\n", IPTABLES_VERSION);
 }
 
 static struct option opts[] = {
 	{ "mac-source", 1, 0, '1' },
+	{ "mac-mask", 1, 0, '2' },
 	{0}
 };
 
@@ -37,12 +40,13 @@
 }
 
 static void
-parse_mac(const char *mac, struct ipt_mac_info *info)
+parse_mac(const char *mac, unsigned char macaddress[ETH_ALEN],
+	  char *errmsg)
 {
 	unsigned int i = 0;
 
 	if (strlen(mac) != ETH_ALEN*3-1)
-		exit_error(PARAMETER_PROBLEM, "Bad mac address `%s'", mac);
+		exit_error(PARAMETER_PROBLEM, "%s `%s'", errmsg, mac);
 
 	for (i = 0; i < ETH_ALEN; i++) {
 		long number;
@@ -53,10 +57,10 @@
 		if (end == mac + i*3 + 2
 		    && number >= 0
 		    && number <= 255)
-			info->srcaddr[i] = number;
+			macaddress[i] = number;
 		else
 			exit_error(PARAMETER_PROBLEM,
-				   "Bad mac address `%s'", mac);
+				   "%s `%s'", errmsg, mac);
 	}
 }
 
@@ -69,15 +73,40 @@
       struct ipt_entry_match **match)
 {
 	struct ipt_mac_info *macinfo = (struct ipt_mac_info *)(*match)->data;
+	static int mask_parsed = 0;
+	int i;
 
 	switch (c) {
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-		parse_mac(argv[optind-1], macinfo);
+		parse_mac(argv[optind-1], macinfo->srcaddr, "Bad mac address");
 		if (invert)
 			macinfo->invert = 1;
+		if (!mask_parsed) {
+			macinfo->is_mask = 0;
+		} else if (macinfo->is_mask) {
+			for (i = 0; i < ETH_ALEN; i++)
+				macinfo->srcaddr[i] &= macinfo->mask[i];
+		}
 		*flags = 1;
 		break;
+		
+	case '2':
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "mac-mask: unexpected `!'");
+		parse_mac(argv[optind-1], macinfo->mask,
+			  "Bad mac mask");
+		macinfo->is_mask = 0;
+		mask_parsed = 1;
+		for (i = 0; i < ETH_ALEN; i++) {
+			macinfo->srcaddr[i] &= macinfo->mask[i];
+			if (macinfo->mask[i] != 0xFF) {
+				macinfo->is_mask = 1;
+			}
+		}
+		break;
 
 	default:
 		return 0;
@@ -86,13 +115,20 @@
 	return 1;
 }
 
-static void print_mac(unsigned char macaddress[ETH_ALEN], int invert)
+static void print_mac(unsigned char macaddress[ETH_ALEN],
+		      unsigned char macmask[ETH_ALEN],
+		      int invert)
 {
 	unsigned int i;
-
+	
 	printf("%s%02X", invert ? "! " : "", macaddress[0]);
 	for (i = 1; i < ETH_ALEN; i++)
 		printf(":%02X", macaddress[i]);
+	if (macmask != NULL) {
+		printf("/%02X", macmask[0]);
+		for (i = 1; i < ETH_ALEN; i++)
+			printf(":%02X", macmask[i]);
+	}
 	printf(" ");
 }
 
@@ -112,6 +148,8 @@
 {
 	printf("MAC ");
 	print_mac(((struct ipt_mac_info *)match->data)->srcaddr,
+		  ((struct ipt_mac_info *)match->data)->is_mask ? 
+		  ((struct ipt_mac_info *)match->data)->mask : NULL,
 		  ((struct ipt_mac_info *)match->data)->invert);
 }
 
@@ -120,7 +158,11 @@
 {
 	printf("--mac-source ");
 	print_mac(((struct ipt_mac_info *)match->data)->srcaddr,
-		  ((struct ipt_mac_info *)match->data)->invert);
+		  NULL, ((struct ipt_mac_info *)match->data)->invert);
+	if (((struct ipt_mac_info *)match->data)->is_mask) {
+		printf("--mac-mask ");
+		print_mac(((struct ipt_mac_info *)match->data)->mask, NULL, 0);
+	}
 }
 
 static

--------------020705050907070503040006--
