From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: clear nf_debug for ipsec tunnel packets
Date: Mon, 25 Aug 2003 00:35:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F493DB3.9060607@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010304030202050701000401"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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
--------------010304030202050701000401
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

this patch for 2.6 clears nf_debug in ip_local_deliver_finish so the
"hook ... already set" message in nf_hook_slow won't get triggered for
decapsulated ipsec-tunnel packets when passing them through the network
stack again.

Best regards,
Patrick

--------------010304030202050701000401
Content-Type: text/plain;
 name="pom-2.6-tunnel-debug.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pom-2.6-tunnel-debug.diff"

diff -urN a/patch-o-matic_2.5/pending/27-ipsec_tunnel-nf_debug.diff b/patch-o-matic_2.5/pending/27-ipsec_tunnel-nf_debug.diff
--- a/patch-o-matic_2.5/pending/27-ipsec_tunnel-nf_debug.diff	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic_2.5/pending/27-ipsec_tunnel-nf_debug.diff	2003-08-24 23:17:43.000000000 +0200
@@ -0,0 +1,11 @@
+===== net/ipv4/ip_input.c 1.17 vs edited =====
+--- 1.17/net/ipv4/ip_input.c	Mon Jun 16 17:11:36 2003
++++ edited/net/ipv4/ip_input.c	Sun Aug 24 23:11:36 2003
+@@ -201,6 +201,7 @@
+ 
+ #ifdef CONFIG_NETFILTER_DEBUG
+ 	nf_debug_ip_local_deliver(skb);
++	skb->nf_debug = 0;
+ #endif /*CONFIG_NETFILTER_DEBUG*/
+ 
+ 	__skb_pull(skb, ihl);
diff -urN a/patch-o-matic_2.5/pending/27-ipsec_tunnel-nf_debug.diff.help b/patch-o-matic_2.5/pending/27-ipsec_tunnel-nf_debug.diff.help
--- a/patch-o-matic_2.5/pending/27-ipsec_tunnel-nf_debug.diff.help	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic_2.5/pending/27-ipsec_tunnel-nf_debug.diff.help	2003-08-24 23:34:23.000000000 +0200
@@ -0,0 +1,7 @@
+Author: Patrick McHardy <kaber@trash.net>
+Status: Working
+
+This patch clears nf_debug in ip_local_deliver_finish so the
+"hook ... already set" message in nf_hook_slow won't get triggered for
+decapsulated ipsec-tunnel packets when passing them through the network
+stack again.

--------------010304030202050701000401--
