From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] [kernel patch] fixed duration connection
Date: Tue, 11 Apr 2006 18:22:46 +0200
Message-ID: <443BD7D6.7030805@trash.net>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
	<4436E03E.9030402@inl.fr> <44381584.4020109@trash.net>
	<4438234A.2080702@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <4438234A.2080702@inl.fr>
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
> I followed your recommendation and here's the patch.

Seems you missed one in the noise :)

------------------------------------------------------------------------

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c
b/net/ipv4/netfilter/ip_conntrack_core.c
index ceaabc1..d9dbe0f 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1130,18 +1130,21 @@ void __ip_ct_refresh_acct(struct ip_conn

 	write_lock_bh(&ip_conntrack_lock);
-------
Please just do:
	if (test_bit(...))
		return;
-------

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
+    /* only update if this is not a fixed timeout */
+    if (! test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status)){
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
+    }

 #ifdef CONFIG_IP_NF_CT_ACCT
 	if (do_acct) {
