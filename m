From: Patrick McHardy <kaber@trash.net>
Subject: PATCH: make MARK target terminate
Date: Mon, 17 Jun 2002 05:46:09 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D0D5B81.7010106@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080309030808090901030203"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080309030808090901030203
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

The attached patch adds a new option --terminate to the MARK target 
which lets the user choose
if MARK should return IPT_CONTINUE (normal behaviour) or NF_ACCEPT (to 
terminate further rule processing).
This can be useful if you have complex marking rules, f.e. for QoS.
The current patch is against a clean MARK target, if anyone wishes i can 
also make a patch which will apply after MARK-operations.
A CONNMARK patch will follow but currently CONNMARK doesn't apply clean 
against 2.4.18/2.4.19-pre10 ..

Bye,
Patrick

--------------080309030808090901030203
Content-Type: text/plain;
 name="iptables-terminate.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-terminate.diff"

diff -urN userspace-clean/patch-o-matic/extra/MARK-terminate.patch userspace/patch-o-matic/extra/MARK-terminate.patch
--- userspace-clean/patch-o-matic/extra/MARK-terminate.patch	Thu Jan  1 01:00:00 1970
+++ userspace/patch-o-matic/extra/MARK-terminate.patch	Mon Jun 17 05:36:21 2002
@@ -0,0 +1,23 @@
+diff -urN linux/include/linux/netfilter_ipv4/ipt_MARK.h linux-2.4.18-terminate/include/linux/netfilter_ipv4/ipt_MARK.h
+--- linux/include/linux/netfilter_ipv4/ipt_MARK.h	Fri Mar 17 19:56:20 2000
++++ linux-2.4.18-terminate/include/linux/netfilter_ipv4/ipt_MARK.h	Mon Jun 17 05:07:29 2002
+@@ -3,6 +3,7 @@
+ 
+ struct ipt_mark_target_info {
+ 	unsigned long mark;
++	u_int8_t terminate;
+ };
+ 
+ #endif /*_IPT_MARK_H_target*/
+diff -urN linux/net/ipv4/netfilter/ipt_MARK.c linux-2.4.18-terminate/net/ipv4/netfilter/ipt_MARK.c
+--- linux/net/ipv4/netfilter/ipt_MARK.c	Sun Sep 30 21:26:08 2001
++++ linux-2.4.18-terminate/net/ipv4/netfilter/ipt_MARK.c	Mon Jun 17 05:07:58 2002
+@@ -21,7 +21,7 @@
+ 		(*pskb)->nfmark = markinfo->mark;
+ 		(*pskb)->nfcache |= NFC_ALTERED;
+ 	}
+-	return IPT_CONTINUE;
++	return markinfo->terminate ? NF_ACCEPT : IPT_CONTINUE;
+ }
+ 
+ static int
diff -urN userspace-clean/patch-o-matic/extra/MARK-terminate.patch.help userspace/patch-o-matic/extra/MARK-terminate.patch.help
--- userspace-clean/patch-o-matic/extra/MARK-terminate.patch.help	Thu Jan  1 01:00:00 1970
+++ userspace/patch-o-matic/extra/MARK-terminate.patch.help	Mon Jun 17 05:36:21 2002
@@ -0,0 +1,9 @@
+Author: Patrick McHardy <kaber@trash.net>
+Status: Working
+
+This patch adds a new option --terminate to MARK to terminate chain traversal.
+
+# iptables -t mangle -A PREROUTING -m tos --tos 0x08 -j MARK --set-mark 0x15 --terminate
+
+***** WARNING ***** This patch also patch the userspace directory which means that you
+                    you have to recompile and reinstall the iptables package after that.
diff -urN userspace-clean/patch-o-matic/extra/MARK-terminate.patch.userspace userspace/patch-o-matic/extra/MARK-terminate.patch.userspace
--- userspace-clean/patch-o-matic/extra/MARK-terminate.patch.userspace	Thu Jan  1 01:00:00 1970
+++ userspace/patch-o-matic/extra/MARK-terminate.patch.userspace	Mon Jun 17 05:36:21 2002
@@ -0,0 +1,42 @@
+diff -urN extensions/libipt_MARK.c extensions/libipt_MARK.c
+--- extensions/libipt_MARK.c	Wed May 29 15:08:16 2002
++++ extensions/libipt_MARK.c	Mon Jun 17 05:21:16 2002
+@@ -26,6 +26,7 @@
+ 
+ static struct option opts[] = {
+ 	{ "set-mark", 1, 0, '1' },
++	{ "terminate", 0, 0, '2' },
+ 	{ 0 }
+ };
+ 
+@@ -57,6 +58,10 @@
+ 		*flags = 1;
+ 		break;
+ 
++	case '2':
++		markinfo->terminate = 1;
++		break;
++		
+ 	default:
+ 		return 0;
+ 	}
+@@ -88,6 +93,9 @@
+ 		(const struct ipt_mark_target_info *)target->data;
+ 	printf("MARK set ");
+ 	print_mark(markinfo->mark, numeric);
++	
++	if (markinfo->terminate)
++		printf("terminate ");
+ }
+ 
+ /* Saves the union ipt_targinfo in parsable form to stdout. */
+@@ -98,6 +106,9 @@
+ 		(const struct ipt_mark_target_info *)target->data;
+ 
+ 	printf("--set-mark 0x%lx ", markinfo->mark);
++
++	if (markinfo->terminate)
++		printf("--terminate ");
+ }
+ 
+ static

--------------080309030808090901030203--
