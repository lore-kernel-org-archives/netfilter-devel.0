From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 1/12]: Don't try to do any random dropping
Date: Tue, 21 Sep 2004 05:20:34 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9E02.8020703@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000009070302030206070502"
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
--------------000009070302030206070502
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

ChangeSet@1.1935.1.1, 2004-09-18 23:18:23+02:00, rusty@rustcorp.com.au
  [NETFILTER]: Don't try to do any random dropping since we now use 
jenkins hash
 
  Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
  Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------000009070302030206070502
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/18 23:18:23+02:00 rusty@rustcorp.com.au 
#   [NETFILTER]: Don't try to do any random dropping since we now use jenkins hash
#   
#   Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/09/18 23:17:57+02:00 rusty@rustcorp.com.au +4 -10
#   [NETFILTER]: Don't try to do any random dropping since we now use jenkins hash
#   
#   Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 11:56:46 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 11:56:46 +02:00
@@ -571,7 +571,6 @@
 	size_t hash;
 	struct ip_conntrack_expect *expected;
 	int i;
-	static unsigned int drop_next;
 
 	if (!ip_conntrack_hash_rnd_initted) {
 		get_random_bytes(&ip_conntrack_hash_rnd, 4);
@@ -580,15 +579,10 @@
 
 	hash = hash_conntrack(tuple);
 
-	if (ip_conntrack_max &&
-	    atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
-		/* Try dropping from random chain, or else from the
-                   chain about to put into (in case they're trying to
-                   bomb one hash chain). */
-		unsigned int next = (drop_next++)%ip_conntrack_htable_size;
-
-		if (!early_drop(&ip_conntrack_hash[next])
-		    && !early_drop(&ip_conntrack_hash[hash])) {
+	if (ip_conntrack_max
+	    && atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
+		/* Try dropping from this hash chain. */
+		if (!early_drop(&ip_conntrack_hash[hash])) {
 			if (net_ratelimit())
 				printk(KERN_WARNING
 				       "ip_conntrack: table full, dropping"

--------------000009070302030206070502--
