From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] Fixed timeout for connections
Date: Mon, 06 Feb 2006 00:08:49 +0100
Message-ID: <43E68581.2060708@inl.fr>
References: <43E5360E.8070900@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080005080902020001020908"
Cc: netfilter-devel@lists.netfilter.org, vincent@inl.fr
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <43E5360E.8070900@inl.fr>
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

This is a multi-part message in MIME format.
--------------080005080902020001020908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Please ignore previous kernel patch (fixed_timeout.patch) and replace it
with the one attached to this mail.

Eric Leblond wrote:
> This set of patches is an implementation of the feature discussed in :
> https://lists.netfilter.org/pipermail/netfilter-devel/2006-January/023127.html
> 
> Basically, it adds the capability a fixed conntrack timeout from
> userspace to be able to define an efficient connection expiration policy.




-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD5oWAnxA7CdMWjzIRAggXAJ9AVc34NngmU3fIw+1mpwXFzLGLIACfefhG
Tq5O8K6n/+VhMB7WtXcPeEI=
=z9gh
-----END PGP SIGNATURE-----

--------------080005080902020001020908
Content-Type: text/x-patch;
 name="fixed_timeout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fixed_timeout.patch"

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 668ec94..fefc11f 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -29,6 +29,9 @@ enum ctattr_type {
 	CTA_HELP,
 	CTA_NAT,
 	CTA_TIMEOUT,
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+	CTA_FIXED_TIMEOUT,
+#endif
 	CTA_MARK,
 	CTA_COUNTERS_ORIG,
 	CTA_COUNTERS_REPLY,
diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
index 215765f..f5e9070 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -82,7 +82,11 @@ struct ip_conntrack
 
 	/* Timer function; drops refcnt when it goes off. */
 	struct timer_list timeout;
-
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+        /* Is timeout fixed ? */
+        struct timer_list fixed_timeout;
+#endif
+        
 #ifdef CONFIG_IP_NF_CT_ACCT
 	/* Accounting Information (same cache line as other written members) */
 	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index db78303..3ad3355 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -46,6 +46,18 @@ config IP_NF_CT_ACCT
 
 	  If unsure, say `N'.
 
+config IP_NF_CT_FIXED_TIMEOUT
+	bool "Connection tracking fixed timeout"
+	depends on IP_NF_CONNTRACK
+	help
+	  If this option is enabled, the connection tracking code will
+	  be able to have connection that will expire automatically after
+          a given time.
+          
+	  This feature can be used with libnetfilter_conntrack library.
+
+	  If unsure, say `N'.
+
 config IP_NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
 	depends on IP_NF_CONNTRACK
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 84c66db..b1062ca 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -319,6 +319,11 @@ destroy_conntrack(struct nf_conntrack *n
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
 
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+        if (timer_pending(&ct->fixed_timeout)) {
+                del_timer(&ct->fixed_timeout);
+        }
+#endif
 	ip_conntrack_event(IPCT_DESTROY, ct);
 	set_bit(IPS_DYING_BIT, &ct->status);
 
@@ -359,6 +364,15 @@ static void death_by_timeout(unsigned lo
 {
 	struct ip_conntrack *ct = (void *)ul_conntrack;
 
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+        /* delete the timer which has not timeout */
+        if (timer_pending(&ct->timeout)) {
+                del_timer(&ct->timeout);
+        }
+        if (timer_pending(&ct->fixed_timeout)) {
+                del_timer(&ct->fixed_timeout);
+        }
+#endif
 	write_lock_bh(&ip_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */
@@ -670,6 +684,12 @@ struct ip_conntrack *ip_conntrack_alloc(
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+	init_timer(&conntrack->fixed_timeout);
+	conntrack->fixed_timeout.data = (unsigned long)conntrack;
+	conntrack->fixed_timeout.function = death_by_timeout;
+#endif
+
 	atomic_inc(&ip_conntrack_count);
 
 	return conntrack;
@@ -724,6 +744,7 @@ init_conntrack(struct ip_conntrack_tuple
 		/* this is ugly, but there is no other place where to put it */
 		conntrack->nat.masq_index = exp->master->nat.masq_index;
 #endif
+
 		nf_conntrack_get(&conntrack->master->ct_general);
 		CONNTRACK_STAT_INC(expect_new);
 	} else {
@@ -1135,12 +1156,12 @@ void __ip_ct_refresh_acct(struct ip_conn
 		ct->timeout.expires = extra_jiffies;
 		event = IPCT_REFRESH;
 	} else {
-		/* Need del_timer for race avoidance (may already be dying). */
-		if (del_timer(&ct->timeout)) {
-			ct->timeout.expires = jiffies + extra_jiffies;
-			add_timer(&ct->timeout);
-			event = IPCT_REFRESH;
-		}
+               /* Need del_timer for race avoidance (may already be dying). */
+               if (del_timer(&ct->timeout)) {
+                       ct->timeout.expires = jiffies + extra_jiffies;
+                       add_timer(&ct->timeout);
+                       event = IPCT_REFRESH;
+               }   
 	}
 
 #ifdef CONFIG_IP_NF_CT_ACCT
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index c9ebbe0..568006f 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -42,7 +42,7 @@
 
 MODULE_LICENSE("GPL");
 
-static char __initdata version[] = "0.90";
+static char __initdata version[] = "0.91";
 
 #if 0
 #define DEBUGP printk
@@ -942,6 +942,25 @@ ctnetlink_change_timeout(struct ip_connt
 }
 
 static inline int
+ctnetlink_change_fixed_timeout(struct ip_conntrack *ct, struct nfattr *cda[])
+{
+	u_int32_t timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_FIXED_TIMEOUT-1]));
+	
+        /* test if timer has already been set */
+        if (timer_pending(&ct->fixed_timeout)){
+	        if (!del_timer(&ct->fixed_timeout))
+		        return -ETIME;
+        }
+
+	ct->fixed_timeout.expires = jiffies + timeout * HZ;
+	add_timer(&ct->fixed_timeout);
+
+	return 0;
+}
+
+
+
+static inline int
 ctnetlink_change_protoinfo(struct ip_conntrack *ct, struct nfattr *cda[])
 {
 	struct nfattr *tb[CTA_PROTOINFO_MAX], *attr = cda[CTA_PROTOINFO-1];
@@ -979,6 +998,14 @@ ctnetlink_change_conntrack(struct ip_con
 			return err;
 	}
 
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+	if (cda[CTA_FIXED_TIMEOUT-1]) {
+		err = ctnetlink_change_fixed_timeout(ct, cda);
+		if (err < 0)
+			return err;
+        }
+#endif
+
 	if (cda[CTA_STATUS-1]) {
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)
@@ -1018,7 +1045,15 @@ ctnetlink_create_conntrack(struct nfattr
 		goto err;
 	ct->timeout.expires = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
 
+        /* we admit jiffies delay on timeout even if is fixed */
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
+
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+	if (cda[CTA_FIXED_TIMEOUT-1]) {
+                ct->fixed_timeout.expires = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_FIXED_TIMEOUT-1]));
+        }
+#endif
+        
 	ct->status |= IPS_CONFIRMED;
 
 	err = ctnetlink_change_status(ct, cda);
@@ -1039,6 +1074,13 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->helper = ip_conntrack_helper_find_get(rtuple);
 
 	add_timer(&ct->timeout);
+
+#ifdef CONFIG_IP_NF_CT_FIXED_TIMEOUT
+	if (cda[CTA_FIXED_TIMEOUT-1]) {
+	        add_timer(&ct->fixed_timeout);
+        }
+#endif
+
 	ip_conntrack_hash_insert(ct);
 
 	if (ct->helper)

--------------080005080902020001020908--
