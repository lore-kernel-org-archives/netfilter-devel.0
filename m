From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Fri, 5 Nov 2004 11:24:31 -0800
Message-ID: <20041105192431.GB3682@linuxace.com>
References: <20041102210440.GA1851@linuxace.com> <418999B2.3070600@trash.net>
	<20041104154355.GA8553@linuxace.com> <418A6D29.60004@trash.net>
	<Pine.LNX.4.61.0411042254020.18136@filer.marasystems.com>
	<418AAF0A.4000201@trash.net>
	<Pine.LNX.4.61.0411050036560.19958@filer.marasystems.com>
	<20041105104845.GF5606@sunbeam.de.gnumonks.org>
	<418BD13D.5080907@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <418BD13D.5080907@trash.net>
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


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 05, 2004 at 08:15:09PM +0100, Patrick McHardy wrote:
> We only know is someone adds a true secondary address, not multiple
> primaries, otherwise we could just ignore it. Anyway, I agree we
> don't need to be overly friendly, I just don't see a case where this
> optimization does something useful. On ethernet devices, why delete
> the IP (if it didn't change) or set the interface down in the first
> place ? On ppp-interfaces, it doesn't work. Phil mentioned powercycling
> his dsl-/cablemodem would set his eth-interface down. I find that hard
> to believe, so I assume he didn't literally meant "my", but picked a
> bad example.
> 
> So, can anyone think of a setup where this optimization does work ?

Yes, I picked a bad example...I'll put down the crackpipe before typing
next time.

Anyway...below is what I'm thinking about now, which will handle both
the ppp case and the 'ip addr add' case.  Unfortunately, it's not working
on the ppp case due to some (IMO) unexpected behaviour from inet_confirm_addr.

Comments?

Phil



--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-test

--- linux-orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-04 17:32:05.669856144 -0500
+++ linux-diff/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-05 14:22:19.595596960 -0500
@@ -118,16 +118,15 @@
 }
 
 static inline int
-device_cmp(const struct ip_conntrack *i, void *_ina)
+device_cmp(const struct ip_conntrack *i, void *junk)
 {
 	int ret = 0;
-	struct in_ifaddr *ina = _ina;
 
 	READ_LOCK(&masq_lock);
-	/* If it's masquerading out this interface with a different address,
-	   or we don't know the new address of this interface. */
-	if (i->nat.masq_index == ina->ifa_dev->dev->ifindex
-	    && i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip != ina->ifa_address)
+	/* If masquerading this conntrack but the masquerading ip
+	   no longer exists locally, drop conntrack. */
+	if (i->nat.masq_index && !(inet_confirm_addr(NULL, 0,
+	    i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip, RT_SCOPE_HOST)))
 		ret = 1;
 	READ_UNLOCK(&masq_lock);
 
@@ -150,11 +149,10 @@
 			   unsigned long event,
 			   void *ptr)
 {
-	/* For some configurations, interfaces often come back with
-	 * the same address.  If not, clean up old conntrack
-	 * entries. */
+	/* In some configurations, interfaces come back with the
+	 * same address.  If not, clean up old conntrack entries. */
 	if (event == NETDEV_UP)
-		ip_ct_selective_cleanup(device_cmp, ptr);
+		ip_ct_selective_cleanup(device_cmp, NULL);
 	else if (event == NETDEV_DOWN)
 		ip_ct_selective_cleanup(connect_unassure, ptr);
 

--k+w/mQv8wyuph6w0--
