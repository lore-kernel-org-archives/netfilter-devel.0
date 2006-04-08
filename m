From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] [kernel patch] fixed duration connection
Date: Sat, 08 Apr 2006 21:56:52 +0200
Message-ID: <44381584.4020109@trash.net>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
	<4436E03E.9030402@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <4436E03E.9030402@inl.fr>
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

Eric Leblond wrote:
> Hi,
> 
> Here's the patch against Linus git tree.

I don't have any principle objections against merging this (if
there are no objections from others), a couple of comments
on the patch though.


+#if defined(CONFIG_IP_NF_CT_FIXED_TIMEOUT) ||
defined(CONFIG_NF_CT_FIXED_TIMEOUT)
+    /* Connection has fixed timeout. */
+	IPS_FIXED_TIMEOUT_BIT = 10,
+	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+#endif

Probably not worth adding a config option for this.

+
 };


@@ -85,6 +85,7 @@ struct ip_conntrack
 	/* Timer function; drops refcnt when it goes off. */
 	struct timer_list timeout;

+

Please remove this.

 #ifdef CONFIG_IP_NF_CT_ACCT
 	/* Accounting Information (same cache line as other written members) */
 	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
@@ -292,6 +293,13 @@ static inline int is_dying(struct ip_con
 	return test_bit(IPS_DYING_BIT, &ct->status);
 }

+#if defined(CONFIG_IP_NF_CT_FIXED_TIMEOUT) ||
defined(CONFIG_NF_CT_FIXED_TIMEOUT)
+static inline int is_fixedtimeout(struct ip_conntrack *ct)
+{
+	return test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status);
+}
+#endif

I guess without a seperate config option we don't need this function
anymore.
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c
b/net/ipv4/netfilter/ip_conntrack_core.c
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
+#if defined(CONFIG_IP_NF_CT_FIXED_TIMEOUT)  ||
defined(CONFIG_NF_CT_FIXED_TIMEOUT)
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

Please just do a simple

if (!test_bit(...))
	return;

at the beginning.
