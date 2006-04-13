From: "Eric Leblond" <eric@inl.fr>
Subject: Re: [PATCH 1/3] [kernel patch] fixed duration connection
Date: Thu, 13 Apr 2006 18:17:46 +0200 (CEST)
Message-ID: <56883.194.167.18.244.1144945066.squirrel@mail.inl.fr>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
	<4436E03E.9030402@inl.fr> <44381584.4020109@trash.net>
	<20060412083835.GN31616@sunbeam.de.gnumonks.org>
	<20060412104824.GU31616@sunbeam.de.gnumonks.org>
	<443D4FCE.2030802@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20060413181746_99570"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org, Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <443D4FCE.2030802@trash.net>
To: "Patrick McHardy" <kaber@trash.net>
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

------=_20060413181746_99570
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

> Harald Welte wrote:
>> I don't think we need a config option, but actually could enable this
>> statically.
>
> OK, I'm going to queue this for 2.6.18 then.

That's a GREAT news, I've already found peoples that love this new feature.

>
> Eric, can you please add nf_conntrack support and repost the entire
> patchset? Thanks.

Here it is.

I've done
       if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status)){
               write_unlock_bh(&ip_conntrack_lock);
               return;
       }
to unlock before leaving the function.

Best regards,
--
Eric Leblond
------=_20060413181746_99570
Content-Type: text/x-patch; name="fixed_timeout-flag.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="fixed_timeout-flag.patch"

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
diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index ceaabc1..d34edd7 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1130,6 +1130,12 @@ void __ip_ct_refresh_acct(struct ip_conn
 
 	write_lock_bh(&ip_conntrack_lock);
 
+	/* Only update if this is not a fixed timeout */
+	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status)){
+		write_unlock_bh(&ip_conntrack_lock);
+		return;
+	}
+
 	/* If not in hash table, timer will not be active yet */
 	if (!is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 56389c8..a880692 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1403,6 +1403,12 @@ void __nf_ct_refresh_acct(struct nf_conn
 
 	write_lock_bh(&nf_conntrack_lock);
 
+	/* Only update if this is not a fixed timeout */
+	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status)) {
+		write_unlock_bh(&nf_conntrack_lock);
+		return;
+	}
+
 	/* If not in hash table, timer will not be active yet */
 	if (!nf_ct_is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;
------=_20060413181746_99570--
