From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 6/8] netfilter: Add comment above remove_expectations in
	destroy_conntrack()
Date: Fri, 31 Dec 2004 22:41:35 +1100
Message-ID: <1104493295.2791.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Morton <akpm@osdl.org>
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

Name: Add comment above remove_expectations in destroy_conntrack()
Status: Trivial
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

I removed this code in a previous patch, and Patrick McHardy explained
what was wrong.  Add a comment.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-28 12:41:40.731242496 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-28 12:43:37.739454544 +1100
@@ -299,7 +299,10 @@
 		ip_conntrack_destroyed(ct);
 
 	WRITE_LOCK(&ip_conntrack_lock);
-	/* Make sure don't leave any orphaned expectations lying around */
+	/* Expectations will have been removed in clean_from_lists,
+	 * except TFTP can create an expectation on the first packet,
+	 * before connection is in the list, so we need to clean here,
+	 * too. */
 	if (ct->expecting)
 		remove_expectations(ct, 1);
 

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
