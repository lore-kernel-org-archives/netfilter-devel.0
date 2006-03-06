From: "Per Hedeland" <hedeland@nortel.com>
Subject: [PATCH] oops in ipt_recent.c
Date: Mon, 6 Mar 2006 23:03:51 +0100 (CET)
Message-ID: <200603062203.k26M3pI5024778@tordmule.bluetail.com>
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

Hi,

I got an oops due to ipt_recent stepping outside its hash table
- this was on kernel 2.4, but it seems the bug is still there
in latest 2.6. Patch against 2.6.15.6 below.

--Per Hedeland


--- a/net/ipv4/netfilter/ipt_recent.c	Sun Mar  5 20:07:54 2006
+++ b/net/ipv4/netfilter/ipt_recent.c	Mon Mar  6 22:25:53 2006
@@ -588,7 +588,7 @@
 #endif
 			/* Check if this is part of a collision chain */
 			while(hash_table[(orig_hash_result+1) % ip_list_hash_size] != -1) {
-				orig_hash_result++;
+				orig_hash_result = (orig_hash_result+1) % ip_list_hash_size;
 				if(hash_func(r_list[hash_table[orig_hash_result]].addr,ip_list_hash_size) == hash_result) {
 					/* Found collision chain, how deep does this rabbit hole go? */
 #ifdef DEBUG
