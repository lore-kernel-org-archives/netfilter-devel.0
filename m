From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] connlimit match fixes for >= 2.6.10
Date: Sat, 12 Feb 2005 13:32:54 -0800
Message-ID: <20050212213254.GA11884@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Below updates connlimit for:

1) removal of nf_ct_info
2) removal of ctrack

Fixes bugzilla #'s 268 and 286.

Phil



--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-connlimit

diff -ru pom-orig/connlimit/linux-2.6/net/ipv4/netfilter/ipt_connlimit.c pom-new/connlimit/linux-2.6/net/ipv4/netfilter/ipt_connlimit.c
--- pom-orig/connlimit/linux-2.6/net/ipv4/netfilter/ipt_connlimit.c	2004-02-19 18:30:21.000000000 -0500
+++ pom-new/connlimit/linux-2.6/net/ipv4/netfilter/ipt_connlimit.c	2005-02-12 16:05:34.896897472 -0500
@@ -58,6 +58,7 @@
 	int addit = 1, matches = 0;
 	struct ip_conntrack_tuple tuple;
 	struct ip_conntrack_tuple_hash *found;
+	struct ip_conntrack *foundct = NULL;
 	struct ipt_connlimit_conn *conn;
 	struct list_head *hash,*lh;
 
@@ -69,9 +70,11 @@
 	for (lh = hash->next; lh != hash; lh = lh->next) {
 		conn = list_entry(lh,struct ipt_connlimit_conn,list);
 		found = ip_conntrack_find_get(&conn->tuple,ct);
+		if (found)
+			foundct = tuplehash_to_ctrack(found);
 		if (0 == memcmp(&conn->tuple,&tuple,sizeof(tuple)) &&
 		    found != NULL &&
-		    found->ctrack->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT) {
+		    foundct->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT) {
 			/* Just to be sure we have it only once in the list.
 			   We should'nt see tuples twice unless someone hooks this
 			   into a table without "-p tcp --syn" */
@@ -82,7 +85,7 @@
 		       ipt_iphash(addr & mask),
 		       NIPQUAD(conn->tuple.src.ip), ntohs(conn->tuple.src.u.tcp.port),
 		       NIPQUAD(conn->tuple.dst.ip), ntohs(conn->tuple.dst.u.tcp.port),
-		       (NULL != found) ? tcp[found->ctrack->proto.tcp.state] : "gone");
+		       (NULL != found) ? tcp[foundct->proto.tcp.state] : "gone");
 #endif
 		if (NULL == found) {
 			/* this one is gone */
@@ -91,20 +94,20 @@
 			kfree(conn);
 			continue;
 		}
-		if (found->ctrack->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT) {
+		if (foundct->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT) {
 			/* we don't care about connections which are
 			   closed already -> ditch it */
 			lh = lh->prev;
 			list_del(lh->next);
 			kfree(conn);
-			nf_conntrack_put(&found->ctrack->infos[0]);
+			nf_conntrack_put(&foundct->ct_general);
 			continue;
 		}
 		if ((addr & mask) == (conn->tuple.src.ip & mask)) {
 			/* same source IP address -> be counted! */
 			matches++;
 		}
-		nf_conntrack_put(&found->ctrack->infos[0]);
+		nf_conntrack_put(&foundct->ct_general);
 	}
 	if (addit) {
 		/* save the new connection in our list */

--ZPt4rx8FFjLCG7dd--
