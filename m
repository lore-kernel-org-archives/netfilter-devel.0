From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 3/12]: Shuffle conntrack structure for better cacheline
 behavior
Date: Tue, 21 Sep 2004 05:22:05 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9E5D.1070601@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080601020104040701010207"
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
--------------080601020104040701010207
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

ChangeSet@1.1935.1.3, 2004-09-18 23:44:40+02:00, rusty@rustcorp.com.au
  [NETFILTER]: Shuffle conntrack structure for better cacheline behavior
 
  Every time we walk the conntrack hashtable list, we hit the same
  cacheline that is dirtied by the use of the conntrack
  entry. Shuffling these entries to the end should help this
  (sizeof(struct ip_conntrack)) > cacheline size).
 
  Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
  Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------080601020104040701010207
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/18 23:44:40+02:00 rusty@rustcorp.com.au 
#   [NETFILTER]: Shuffle conntrack structure for better cacheline behavior
#   
#   Every time we walk the conntrack hashtable list, we hit the same
#   cacheline that is dirtied by the use of the conntrack
#   entry. Shuffling these entries to the end should help this
#   (sizeof(struct ip_conntrack)) > cacheline size).
#   
#   Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack.h
#   2004/09/18 23:44:13+02:00 rusty@rustcorp.com.au +3 -3
#   [NETFILTER]: Shuffle conntrack structure for better cacheline behavior
#   
#   Every time we walk the conntrack hashtable list, we hit the same
#   cacheline that is dirtied by the use of the conntrack
#   entry. Shuffling these entries to the end should help this
#   (sizeof(struct ip_conntrack)) > cacheline size).
#   
#   Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	2004-09-20 11:57:16 +02:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	2004-09-20 11:57:16 +02:00
@@ -172,9 +172,6 @@
            plus 1 for any connection(s) we are `master' for */
 	struct nf_conntrack ct_general;
 
-	/* These are my tuples; original and reply */
-	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
-
 	/* Have we seen traffic both ways yet? (bitset) */
 	unsigned long status;
 
@@ -220,6 +217,9 @@
 	} nat;
 #endif /* CONFIG_IP_NF_NAT_NEEDED */
 
+	/* Traversed often, so hopefully in different cacheline to top */
+	/* These are my tuples; original and reply */
+	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
 };
 
 /* get master conntrack via master expectation */

--------------080601020104040701010207--
