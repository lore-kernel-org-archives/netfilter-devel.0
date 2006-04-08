From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 1/3] [kernel patch] fixed duration connection
Date: Sat, 08 Apr 2006 22:55:38 +0200
Message-ID: <4438234A.2080702@inl.fr>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
	<4436E03E.9030402@inl.fr> <44381584.4020109@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070308090109090706010803"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44381584.4020109@trash.net>
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
--------------070308090109090706010803
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi again,

I followed your recommendation and here's the patch.

Patrick McHardy wrote:
> Eric Leblond wrote:
> 
>>Hi,
>>
>>Here's the patch against Linus git tree.
> 
> 
> I don't have any principle objections against merging this (if
> there are no objections from others), a couple of comments
> on the patch though.

BR and thanks a lot for your help,
- --
Eric Leblond
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEOCNKnxA7CdMWjzIRAuVlAJ9v75j2WeEvMAJVqDekgOxzTRmHQwCcDN5B
sdtE712lSkUuG25DMBB9v+w=
=K6vk
-----END PGP SIGNATURE-----

--------------070308090109090706010803
Content-Type: text/x-patch;
 name="fixed_timeout-flag.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fixed_timeout-flag.patch"

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 3ff88c8..68d282d 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -69,6 +69,11 @@ enum ip_conntrack_status {
 	/* Connection is dying (removed from lists), can not be unset. */
 	IPS_DYING_BIT = 9,
 	IPS_DYING = (1 << IPS_DYING_BIT),
+
+    /* Connection has fixed timeout. */
+	IPS_FIXED_TIMEOUT_BIT = 10,
+	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+
 };
 
 /* Connection tracking event bits */
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index ceaabc1..d9dbe0f 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1130,18 +1130,21 @@ void __ip_ct_refresh_acct(struct ip_conn
 
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

--------------070308090109090706010803--
