From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 9/12]: Cleanup ctstat
Date: Tue, 21 Sep 2004 05:23:09 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9E9D.1000900@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000708080205010307040304"
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
--------------000708080205010307040304
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

ChangeSet@1.1935.1.9, 2004-09-19 18:18:43+02:00, gandalf@wlug.westbo.se
  [NETFILTER]: Cleanup ctstat
 
  This patch simply adds a macro to increase the statistics.
  And it changes icmp_error to error in struct ip_conntrack_stat in order
  to adopt to the tcp-windowtracking changes.
 
  Based on patch by Pablo Neira.
 
  Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
  Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------000708080205010307040304
Content-Type: text/x-patch;
 name="09.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/19 18:18:43+02:00 gandalf@wlug.westbo.se 
#   [NETFILTER]: Cleanup ctstat
#   
#   This patch simply adds a macro to increase the statistics.
#   And it changes icmp_error to error in struct ip_conntrack_stat in order
#   to adopt to the tcp-windowtracking changes.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/09/19 18:18:22+02:00 gandalf@wlug.westbo.se +1 -1
#   [NETFILTER]: Cleanup ctstat
#   
#   This patch simply adds a macro to increase the statistics.
#   And it changes icmp_error to error in struct ip_conntrack_stat in order
#   to adopt to the tcp-windowtracking changes.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/09/19 18:18:22+02:00 gandalf@wlug.westbo.se +16 -15
#   [NETFILTER]: Cleanup ctstat
#   
#   This patch simply adds a macro to increase the statistics.
#   And it changes icmp_error to error in struct ip_conntrack_stat in order
#   to adopt to the tcp-windowtracking changes.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack.h
#   2004/09/19 18:18:22+02:00 gandalf@wlug.westbo.se +2 -1
#   [NETFILTER]: Cleanup ctstat
#   
#   This patch simply adds a macro to increase the statistics.
#   And it changes icmp_error to error in struct ip_conntrack_stat in order
#   to adopt to the tcp-windowtracking changes.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	2004-09-20 11:59:01 +02:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	2004-09-20 11:59:01 +02:00
@@ -305,12 +305,13 @@
 	unsigned int insert_failed;
 	unsigned int drop;
 	unsigned int early_drop;
-	unsigned int icmp_error;
+	unsigned int error;
 	unsigned int expect_new;
 	unsigned int expect_create;
 	unsigned int expect_delete;
 };
 
+#define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
 
 /* eg. PROVIDES_CONNTRACK(ftp); */
 #define PROVIDES_CONNTRACK(name)                        \
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 11:59:01 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 11:59:01 +02:00
@@ -151,7 +151,7 @@
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
 
 	kmem_cache_free(ip_conntrack_expect_cachep, exp);
-	__get_cpu_var(ip_conntrack_stat).expect_delete++;
+	CONNTRACK_STAT_INC(expect_delete);
 }
 
 inline void ip_conntrack_expect_put(struct ip_conntrack_expect *exp)
@@ -320,14 +320,14 @@
 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);
 	atomic_dec(&ip_conntrack_count);
-	__get_cpu_var(ip_conntrack_stat).delete++;
+	CONNTRACK_STAT_INC(delete);
 }
 
 static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct ip_conntrack *ct = (void *)ul_conntrack;
 
-	__get_cpu_var(ip_conntrack_stat).delete_list++;
+	CONNTRACK_STAT_INC(delete_list);
 
 	WRITE_LOCK(&ip_conntrack_lock);
 	clean_from_lists(ct);
@@ -436,12 +436,12 @@
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		WRITE_UNLOCK(&ip_conntrack_lock);
-	 	__get_cpu_var(ip_conntrack_stat).insert++;
+		CONNTRACK_STAT_INC(insert);
 		return NF_ACCEPT;
 	}
 
 	WRITE_UNLOCK(&ip_conntrack_lock);
-	__get_cpu_var(ip_conntrack_stat).insert_failed++;
+	CONNTRACK_STAT_INC(insert_failed);
 	return NF_DROP;
 }
 
@@ -485,7 +485,7 @@
 	if (del_timer(&h->ctrack->timeout)) {
 		death_by_timeout((unsigned long)h->ctrack);
 		dropped = 1;
-		__get_cpu_var(ip_conntrack_stat).early_drop++;
+		CONNTRACK_STAT_INC(early_drop);
 	}
 	ip_conntrack_put(h->ctrack);
 	return dropped;
@@ -605,13 +605,13 @@
 		if (expected->expectfn)
 			expected->expectfn(conntrack);
 	
-		__get_cpu_var(ip_conntrack_stat).expect_new++;
+		CONNTRACK_STAT_INC(expect_new);
 
 		goto ret;
 	} else  {
 		conntrack->helper = ip_ct_find_helper(&repl_tuple);
 
-		__get_cpu_var(ip_conntrack_stat).new++;
+		CONNTRACK_STAT_INC(new);
 	}
 
 end:	atomic_inc(&ip_conntrack_count);
@@ -716,7 +716,7 @@
 
 	/* Previously seen (loopback or untracked)?  Ignore. */
 	if ((*pskb)->nfct) {
-		__get_cpu_var(ip_conntrack_stat).ignore++;
+		CONNTRACK_STAT_INC(ignore);
 		return NF_ACCEPT;
 	}
 
@@ -727,19 +727,20 @@
 	 * core what to do with the packet. */
 	if (proto->error != NULL 
 	    && (ret = proto->error(*pskb, &ctinfo, hooknum)) <= 0) {
-		__get_cpu_var(ip_conntrack_stat).icmp_error++;
+		CONNTRACK_STAT_INC(error);
+		CONNTRACK_STAT_INC(invalid);
 		return -ret;
 	}
 
 	if (!(ct = resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo))) {
 		/* Not valid part of a connection */
-		__get_cpu_var(ip_conntrack_stat).invalid++;
+		CONNTRACK_STAT_INC(invalid);
 		return NF_ACCEPT;
 	}
 
 	if (IS_ERR(ct)) {
 		/* Too stressed to deal. */
-		__get_cpu_var(ip_conntrack_stat).drop++;
+		CONNTRACK_STAT_INC(drop);
 		return NF_DROP;
 	}
 
@@ -751,7 +752,7 @@
 		 * the netfilter core what to do*/
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct = NULL;
-		__get_cpu_var(ip_conntrack_stat).invalid++;
+		CONNTRACK_STAT_INC(invalid);
 		return -ret;
 	}
 
@@ -759,7 +760,7 @@
 		ret = ct->helper->help(*pskb, ct, ctinfo);
 		if (ret == -1) {
 			/* Invalid */
-			__get_cpu_var(ip_conntrack_stat).invalid++;
+			CONNTRACK_STAT_INC(invalid);
 			nf_conntrack_put((*pskb)->nfct);
 			(*pskb)->nfct = NULL;
 			return NF_ACCEPT;
@@ -963,7 +964,7 @@
 
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
-	__get_cpu_var(ip_conntrack_stat).expect_create++;
+	CONNTRACK_STAT_INC(expect_create);
 
 	return ret;
 }
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-20 11:59:01 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-20 11:59:01 +02:00
@@ -316,7 +316,7 @@
 		   st->insert_failed,
 		   st->drop,
 		   st->early_drop,
-		   st->icmp_error,
+		   st->error,
 
 		   st->expect_new,
 		   st->expect_create,

--------------000708080205010307040304--
