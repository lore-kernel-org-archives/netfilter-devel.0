From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 8/8] netfilter: Remove copy_to_user Warnings in Netfilter
Date: Fri, 31 Dec 2004 22:44:02 +1100
Message-ID: <1104493442.2791.23.camel@localhost.localdomain>
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

Name: Remove copy_to_user Warnings in Netfilter
Status: Trivial
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

After changing firewall rules, we try to return the counters to
userspace.  We didn't fail at that point if the copy failed, but it
doesn't really matter.  Someone added a warn_unused_result attribute
to copy_to_user, so we get bogus warnings.

Index: linux-2.6.10-rc3-bk6-Netfilter/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux-2.6.10-rc3-bk6-Netfilter.orig/net/ipv4/netfilter/ip_tables.c	2004-12-13 12:02:08.342802968 +1100
+++ linux-2.6.10-rc3-bk6-Netfilter/net/ipv4/netfilter/ip_tables.c	2004-12-13 12:03:14.954676424 +1100
@@ -1141,12 +1141,12 @@
 	/* Decrease module usage counts and free resource */
 	IPT_ENTRY_ITERATE(oldinfo->entries, oldinfo->size, cleanup_entry,NULL);
 	vfree(oldinfo);
-	/* Silent error: too late now. */
-	copy_to_user(tmp.counters, counters,
-		     sizeof(struct ipt_counters) * tmp.num_counters);
+	if (copy_to_user(tmp.counters, counters,
+			 sizeof(struct ipt_counters) * tmp.num_counters) != 0)
+		ret = -EFAULT;
 	vfree(counters);
 	up(&ipt_mutex);
-	return 0;
+	return ret;
 
  put_module:
 	module_put(t->me);
Index: linux-2.6.10-rc3-bk6-Netfilter/net/ipv6/netfilter/ip6_tables.c
===================================================================
--- linux-2.6.10-rc3-bk6-Netfilter.orig/net/ipv6/netfilter/ip6_tables.c	2004-12-13 12:02:08.342802968 +1100
+++ linux-2.6.10-rc3-bk6-Netfilter/net/ipv6/netfilter/ip6_tables.c	2004-12-13 12:03:14.956676120 +1100
@@ -1222,11 +1222,12 @@
 	IP6T_ENTRY_ITERATE(oldinfo->entries, oldinfo->size, cleanup_entry,NULL);
 	vfree(oldinfo);
 	/* Silent error: too late now. */
-	copy_to_user(tmp.counters, counters,
-		     sizeof(struct ip6t_counters) * tmp.num_counters);
+	if (copy_to_user(tmp.counters, counters,
+			 sizeof(struct ip6t_counters) * tmp.num_counters) != 0)
+		ret = -EFAULT;
 	vfree(counters);
 	up(&ip6t_mutex);
-	return 0;
+	return ret;
 
  put_module:
 	module_put(t->me);
Index: linux-2.6.10-rc3-bk6-Netfilter/net/ipv4/netfilter/arp_tables.c
===================================================================
--- linux-2.6.10-rc3-bk6-Netfilter.orig/net/ipv4/netfilter/arp_tables.c	2004-12-13 12:02:08.342802968 +1100
+++ linux-2.6.10-rc3-bk6-Netfilter/net/ipv4/netfilter/arp_tables.c	2004-12-13 12:03:14.959675664 +1100
@@ -948,12 +948,12 @@
 	/* Decrease module usage counts and free resource */
 	ARPT_ENTRY_ITERATE(oldinfo->entries, oldinfo->size, cleanup_entry,NULL);
 	vfree(oldinfo);
-	/* Silent error: too late now. */
-	copy_to_user(tmp.counters, counters,
-		     sizeof(struct arpt_counters) * tmp.num_counters);
+	if (copy_to_user(tmp.counters, counters,
+			 sizeof(struct arpt_counters) * tmp.num_counters) != 0)
+		ret = -EFAULT;
 	vfree(counters);
 	up(&arpt_mutex);
-	return 0;
+	return ret;
 
  put_module:
 	module_put(t->me);

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
