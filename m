From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: Don't call ip_conntrack_put with ip_conntrack_lock held
Date: Tue, 23 Sep 2003 17:54:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F706CC1.1030901@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020208090104070402030009"
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
--------------020208090104070402030009
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch changes destroy_conntrack so ip_conntrack_put for the master 
conntrack
is called without the ip_conntrack_lock held. There is currently no 
situation in which
destroy_conntrack could be called with a conntrack that has a master 
with a refcount
of 1 so it is not a problem now (at least I couldn't spot one) but it 
seems right anyway.

Best regards,
Patrick


--------------020208090104070402030009
Content-Type: text/plain;
 name="2.4-destroy-conntrack.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.4-destroy-conntrack.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1136  -> 1.1137 
#	net/ipv4/netfilter/ip_conntrack_core.c	1.26    -> 1.27   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/23	kaber@trash.net	1.1137
# [NETFILTER]: Don't call ip_conntrack_put with ip_conntrack_lock held
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Tue Sep 23 17:35:29 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Tue Sep 23 17:35:29 2003
@@ -308,7 +308,7 @@
 static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
-	struct ip_conntrack *ct = (struct ip_conntrack *)nfct;
+	struct ip_conntrack *ct = (struct ip_conntrack *)nfct, *master = NULL;
 	struct ip_conntrack_protocol *proto;
 
 	DEBUGP("destroy_conntrack(%p)\n", ct);
@@ -335,11 +335,14 @@
 			/* can't call __unexpect_related here,
 			 * since it would screw up expect_list */
 			list_del(&ct->master->expected_list);
-			ip_conntrack_put(ct->master->expectant);
+			master = ct->master->expectant;
 		}
 		kfree(ct->master);
 	}
 	WRITE_UNLOCK(&ip_conntrack_lock);
+
+	if (master)
+		ip_conntrack_put(master);
 
 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);

--------------020208090104070402030009--
