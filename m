From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 1/19]: Clean up ip_conntrack stats
Date: Mon, 25 Oct 2004 02:48:37 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4D65.5010904@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020408050401000108010304"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
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
--------------020408050401000108010304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Use CONNTRACK_STAT_INC for changing statistics.



--------------020408050401000108010304
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/19 02:06:42+02:00 pablo@eurodev.net 
#   [NETFILTER]: Clean up ip_conntrack stats
#   
#   Signed-off-by: Pablo Neira <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/10/19 02:06:14+02:00 pablo@eurodev.net +2 -4
#   [NETFILTER]: Clean up ip_conntrack stats
#   
#   Signed-off-by: Pablo Neira <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-22 03:36:57 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-22 03:36:57 +02:00
@@ -352,16 +352,14 @@
 {
 	struct ip_conntrack_tuple_hash *h;
 	unsigned int hash = hash_conntrack(tuple);
-	/* use per_cpu() to avoid multiple calls to smp_processor_id() */
-	unsigned int cpu = smp_processor_id();
 
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
 	list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
 		if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
-			per_cpu(ip_conntrack_stat, cpu).found++;
+			CONNTRACK_STAT_INC(found);
 			return h;
 		}
-		per_cpu(ip_conntrack_stat, cpu).searched++;
+		CONNTRACK_STAT_INC(searched);
 	}
 
 	return NULL;

--------------020408050401000108010304--
