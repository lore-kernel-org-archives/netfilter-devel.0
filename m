From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/11] Netfilter:  Fix overlapping expectations in existing
	expectation code
Date: Mon, 17 Jan 2005 16:43:02 +1100
Message-ID: <1105940582.3954.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

Name: Fix overlapping expectations in existing expectation code
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Change kmem_cache_free() calls in ip_conntrack_expect_related() to
ip_conntrack_expect_put(): they should be equivalent but allows a hack
in next patch (caller can keep expect).

More importantly, a previous expectation should only be refreshed and return
EEXIST if it's owned by the same connection (nfsim found this bug).

Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-05 17:59:05.301754184 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-05 18:41:54.330202496 +1100
@@ -912,7 +902,7 @@
 	old = LIST_FIND(&ip_conntrack_expect_list, resent_expect,
 		        struct ip_conntrack_expect *, &expect->tuple, 
 			&expect->mask);
-	if (old) {
+	if (old && old->expectant == related_to) {
 		/* Helper private data may contain offsets but no pointers
 		   pointing into the payload - otherwise we should have to copy 
 		   the data filled out by the helper over the old one */
@@ -929,8 +919,7 @@
 		}
 
 		WRITE_UNLOCK(&ip_conntrack_lock);
-		/* This expectation is not inserted so no need to lock */
-		kmem_cache_free(ip_conntrack_expect_cachep, expect);
+		ip_conntrack_expect_put(expect);
 		return -EEXIST;
 
 	} else if (related_to->helper->max_expected && 
@@ -948,7 +937,7 @@
 				       related_to->helper->name,
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
-			kmem_cache_free(ip_conntrack_expect_cachep, expect);
+			ip_conntrack_expect_put(expect);	
 			return -EPERM;
 		}
 		DEBUGP("ip_conntrack: max number of expected "
@@ -982,7 +971,7 @@
 		WRITE_UNLOCK(&ip_conntrack_lock);
 		DEBUGP("expect_related: busy!\n");
 
-		kmem_cache_free(ip_conntrack_expect_cachep, expect);
+		ip_conntrack_expect_put(expect);	
 		return -EBUSY;
 	}
 
