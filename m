From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] cleanup for random seed initialization ip_conntrack_hash_rnd
Date: Tue, 13 Apr 2004 00:56:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407B1E91.5090206@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030202080101090606080401"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
 Harald Welte <laforge@netfilter.org>
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
--------------030202080101090606080401
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald and list,

Attached a clean up for the initialization of the random seed used in 
ip_conntrack. With this patch the random seed is initialized once when 
ip_conntrack is loaded instead of checking every time a conntrack is 
created whether it was already initialized or not. If I'm missing 
something, please let me know.

regards,
Pablo

--------------030202080101090606080401
Content-Type: text/plain;
 name="ip_conntrack_hash_rnd-cleanup.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_hash_rnd-cleanup.diff"

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.3-patched/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-18 04:57:11.000000000 +0100
+++ linux-2.6.3-patched/net/ipv4/netfilter/ip_conntrack_core.c	2004-04-13 00:46:17.000000000 +0200
@@ -109,7 +109,6 @@
 	nf_conntrack_put(&ct->infos[0]);
 }
 
-static int ip_conntrack_hash_rnd_initted;
 static unsigned int ip_conntrack_hash_rnd;
 
 static u_int32_t
@@ -628,11 +627,6 @@
 	int i;
 	static unsigned int drop_next;
 
-	if (!ip_conntrack_hash_rnd_initted) {
-		get_random_bytes(&ip_conntrack_hash_rnd, 4);
-		ip_conntrack_hash_rnd_initted = 1;
-	}
-
 	hash = hash_conntrack(tuple);
 
 	if (ip_conntrack_max &&
@@ -1369,6 +1363,8 @@
 {
 	unsigned int i;
 	int ret;
+	
+	get_random_bytes(&ip_conntrack_hash_rnd, 4);
 
 	/* Idea from tcp.c: use 1/16384 of memory.  On i386: 32MB
 	 * machine has 256 buckets.  >= 1GB machines have 8192 buckets. */

--------------030202080101090606080401--
