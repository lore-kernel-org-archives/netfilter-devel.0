From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 1/3] [kernel patch] fixed duration connection
Date: Tue, 11 Apr 2006 22:20:15 +0200
Message-ID: <443C0F7F.7060208@inl.fr>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
	<4436E03E.9030402@inl.fr> <44381584.4020109@trash.net>
	<4438234A.2080702@inl.fr> <443BD7D6.7030805@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090006000402080503000903"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <443BD7D6.7030805@trash.net>
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
--------------090006000402080503000903
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Eric Leblond wrote:
> 
>>I followed your recommendation and here's the patch.
> 
> 
> Seems you missed one in the noise :)

Here it is.

Thank you very much for your patience.

humm, google define:patience gives me :
	good-natured tolerance of delay or incompetence
Definition looks really good this time ;-)

BR,
--
Eric Leblond

--------------090006000402080503000903
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
index ceaabc1..b3d2f92 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1130,6 +1130,10 @@ void __ip_ct_refresh_acct(struct ip_conn
 
 	write_lock_bh(&ip_conntrack_lock);
 
+	/* Only update if this is not a fixed timeout */
+	if (! test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
+		return;
+
 	/* If not in hash table, timer will not be active yet */
 	if (!is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;

--------------090006000402080503000903--
