From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 1/3] [kernel patch] fixed duration connection
Date: Fri, 07 Apr 2006 23:57:18 +0200
Message-ID: <4436E03E.9030402@inl.fr>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070603040907030203000301"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <4436DF6B.4060208@inl.fr>
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
--------------070603040907030203000301
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

Here's the patch against Linus git tree.

It simply modifies enum ip_conntrack_status by adding a
IPS_FIXED_TIMEOUT field. This field is then checked at refresh time.

- --
Regit
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFENuA+nxA7CdMWjzIRAoedAKCOuZyfUK8CWq3k5UBzZSc+HP1slwCgh00S
PYw7RpDtK/3TwMByLfCihNk=
=+LK+
-----END PGP SIGNATURE-----

--------------070603040907030203000301
Content-Type: text/x-patch;
 name="fixed_timeout-flag.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fixed_timeout-flag.patch"

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 3ff88c8..a827ce2 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -69,6 +69,13 @@ enum ip_conntrack_status {
 	/* Connection is dying (removed from lists), can not be unset. */
 	IPS_DYING_BIT = 9,
 	IPS_DYING = (1 << IPS_DYING_BIT),
+
+#if defined(CONFIG_IP_NF_CT_FIXED_TIMEOUT) || defined(CONFIG_NF_CT_FIXED_TIMEOUT)
+    /* Connection has fixed timeout. */
+	IPS_FIXED_TIMEOUT_BIT = 10,
+	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+#endif
+
 };
 
 /* Connection tracking event bits */
diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
index d54d7b2..44f6e33 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -85,6 +85,7 @@ struct ip_conntrack
 	/* Timer function; drops refcnt when it goes off. */
 	struct timer_list timeout;
 
+
 #ifdef CONFIG_IP_NF_CT_ACCT
 	/* Accounting Information (same cache line as other written members) */
 	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
@@ -292,6 +293,13 @@ static inline int is_dying(struct ip_con
 	return test_bit(IPS_DYING_BIT, &ct->status);
 }
 
+#if defined(CONFIG_IP_NF_CT_FIXED_TIMEOUT) || defined(CONFIG_NF_CT_FIXED_TIMEOUT)
+static inline int is_fixedtimeout(struct ip_conntrack *ct)
+{
+	return test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status);
+}
+#endif
+
 extern unsigned int ip_conntrack_htable_size;
  
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 77855cc..1f306ec 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -46,6 +46,18 @@ config IP_NF_CT_ACCT
 
 	  If unsure, say `N'.
 
+config IP_NF_CT_FIXED_TIMEOUT
+	bool "Connection tracking fixed timeout (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && IP_NF_CONNTRACK
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
index ceaabc1..44fa788 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1130,18 +1130,27 @@ void __ip_ct_refresh_acct(struct ip_conn
 
 	write_lock_bh(&ip_conntrack_lock);
 
-	/* If not in hash table, timer will not be active yet */
-	if (!is_confirmed(ct)) {
-		ct->timeout.expires = extra_jiffies;
-		event = IPCT_REFRESH;
-	} else {
-		/* Need del_timer for race avoidance (may already be dying). */
-		if (del_timer(&ct->timeout)) {
-			ct->timeout.expires = jiffies + extra_jiffies;
-			add_timer(&ct->timeout);
-			event = IPCT_REFRESH;
-		}
-	}
+#if defined(CONFIG_IP_NF_CT_FIXED_TIMEOUT)  || defined(CONFIG_NF_CT_FIXED_TIMEOUT)
+    /* only update if this is not a fixed timeout */
+    if (! is_fixedtimeout(ct)){
+#endif
+        /* If not in hash table, timer will not be active yet */
+        if (!is_confirmed(ct)) {
+            ct->timeout.expires = extra_jiffies;
+            event = IPCT_REFRESH;
+        } else {
+            /* Need del_timer for race avoidance (may already be dying). */
+            if (del_timer(&ct->timeout)) {
+                ct->timeout.expires = jiffies + extra_jiffies;
+                add_timer(&ct->timeout);
+                event = IPCT_REFRESH;
+            }
+        }
+#if defined(CONFIG_IP_NF_CT_FIXED_TIMEOUT) 
+    } else {
+		DEBUGP("FIXED TIMEOUT: Not updating\n");
+    }
+#endif
 
 #ifdef CONFIG_IP_NF_CT_ACCT
 	if (do_acct) {
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e2893ef..8c24fc4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -60,6 +60,18 @@ config NF_CONNTRACK_MARK
 	  of packets, but this mark value is kept in the conntrack session
 	  instead of the individual packets.
 
+config CONFIG_NF_CT_FIXED_TIMEOUT
+	bool  "Connection with fixed expiration delay (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	help
+	  If this option is enabled, the connection tracking code will
+	  be able to have connection that will expire automatically after
+          a given time.
+          
+	  This feature can be used with libnetfilter_conntrack library.
+
+	  If unsure, say `N'.
+
 config NF_CONNTRACK_EVENTS
 	bool "Connection tracking events (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK

--------------070603040907030203000301--
