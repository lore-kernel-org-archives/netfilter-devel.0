From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim 1/4] Linux 2.6.11 API fixes
Date: Mon, 21 Feb 2005 18:18:21 +0100
Message-ID: <20050221171821.GA32344@roonstrasse.net>
References: <20050221171719.GA32254@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050221171719.GA32254@roonstrasse.net>
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


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch ports nfsim to the Linux 2.6.11-rc4 API.


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="01-nfsim-new_linux_2_6_11_api.patch"

Mon Feb 21 16:47:08 CET 2005  max@duempel.org
  * linux 2.6.11-rc4 api
diff -rN -u nfsim-1-old/core/ipv4/ipv4.c nfsim-1-new/core/ipv4/ipv4.c
--- nfsim-1-old/core/ipv4/ipv4.c	Mon Feb 21 18:04:27 2005
+++ nfsim-1-new/core/ipv4/ipv4.c	Mon Feb 21 18:04:27 2005
@@ -530,7 +530,7 @@
 	return skb;
 }
 
-struct sk_buff *ip_defrag(struct sk_buff *skb)
+struct sk_buff *ip_defrag(struct sk_buff *skb, u32 user)
 {
 	struct fraglist *i;
 
diff -rN -u nfsim-1-old/core/ipv4/ipv4.h nfsim-1-new/core/ipv4/ipv4.h
--- nfsim-1-old/core/ipv4/ipv4.h	Mon Feb 21 18:04:27 2005
+++ nfsim-1-new/core/ipv4/ipv4.h	Mon Feb 21 16:41:58 2005
@@ -562,7 +562,7 @@
 int ip_route(struct sk_buff *skb);
 
 int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff*));
-struct sk_buff *ip_defrag(struct sk_buff *skb);
+struct sk_buff *ip_defrag(struct sk_buff *skb, u32 user);
 void ipfrag_flush(void);
 
 void icmp_send(struct sk_buff *skb_in, int type, int code, u32 info);
diff -rN -u nfsim-1-old/kernelenv/include/kernelenv.h nfsim-1-new/kernelenv/include/kernelenv.h
--- nfsim-1-old/kernelenv/include/kernelenv.h	Mon Feb 21 18:04:27 2005
+++ nfsim-1-new/kernelenv/include/kernelenv.h	Mon Feb 21 16:39:32 2005
@@ -40,6 +40,18 @@
 #include <ctype.h>
 #include <list.h>
 
+enum ip_defrag_users
+{
+        IP_DEFRAG_LOCAL_DELIVER,
+        IP_DEFRAG_CALL_RA_CHAIN,
+        IP_DEFRAG_CONNTRACK_IN,
+        IP_DEFRAG_CONNTRACK_OUT,
+        IP_DEFRAG_NAT_OUT,
+        IP_DEFRAG_VS_IN,
+        IP_DEFRAG_VS_OUT,
+        IP_DEFRAG_VS_FWD
+};
+
 /* Types */
 typedef uint8_t u8;
 typedef int8_t s8;


--7AUc2qLy4jB3hD7Z--
