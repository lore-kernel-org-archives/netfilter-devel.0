From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Mon, 08 Nov 2004 17:05:38 +0100
Message-ID: <418F9952.5030004@trash.net>
References: <20041107181825.GA3522@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041107181825.GA3522@linuxace.com>
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

Phil Oester wrote:

>As discussed in recent days, MASQUERADE target handling of device events
>is broken in a couple of ways:
>
>1) when ppp interfaces cycle, conntracks with old ip addresses are not
>   flushed
>
>2) an 'ip addr add' on an interface used for masquerading flushes all
>   conntracks associated with that interface
>
>The below patch addresses these issues by changing from using ifindex
>comparisons to verifying that the masquerading ip still exists on the
>box.
>
But without the ifindex comparison, a situation like this can happen:

ppp0 goes down
ppp1 goes down
ppp0 comes up again, same IP as before
ppp1 connections get killed
ppp1 comes up again

So we should keep this.

Regards
Patrick

>  
>
>------------------------------------------------------------------------
>
>diff -ru linux-orig/include/linux/inetdevice.h linux-diff/include/linux/inetdevice.h
>--- linux-orig/include/linux/inetdevice.h	2004-11-04 17:32:05.573870736 -0500
>+++ linux-diff/include/linux/inetdevice.h	2004-11-07 12:57:50.674323160 -0500
>@@ -114,7 +114,7 @@
> 
> static __inline__ int inet_ifa_match(u32 addr, struct in_ifaddr *ifa)
> {
>-	return !((addr^ifa->ifa_address)&ifa->ifa_mask);
>+	return !((addr^ifa->ifa_local)&ifa->ifa_mask);
> }
> 
> /*
>diff -ru linux-orig/net/ipv4/devinet.c linux-diff/net/ipv4/devinet.c
>--- linux-orig/net/ipv4/devinet.c	2004-11-04 17:32:05.000000000 -0500
>+++ linux-diff/net/ipv4/devinet.c	2004-11-07 12:56:27.738931256 -0500
>@@ -1493,6 +1493,7 @@
> 
> EXPORT_SYMBOL(devinet_ioctl);
> EXPORT_SYMBOL(in_dev_finish_destroy);
>+EXPORT_SYMBOL(inet_confirm_addr);
> EXPORT_SYMBOL(inet_select_addr);
> EXPORT_SYMBOL(inetdev_by_index);
> EXPORT_SYMBOL(register_inetaddr_notifier);
>diff -ru linux-orig/net/ipv4/netfilter/ipt_MASQUERADE.c linux-diff/net/ipv4/netfilter/ipt_MASQUERADE.c
>--- linux-orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-04 17:32:05.000000000 -0500
>+++ linux-diff/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-07 12:55:56.501680040 -0500
>@@ -118,16 +118,15 @@
> }
> 
> static inline int
>-device_cmp(const struct ip_conntrack *i, void *_ina)
>+device_cmp(const struct ip_conntrack *i, void *junk)
> {
> 	int ret = 0;
>-	struct in_ifaddr *ina = _ina;
> 
> 	READ_LOCK(&masq_lock);
>-	/* If it's masquerading out this interface with a different address,
>-	   or we don't know the new address of this interface. */
>-	if (i->nat.masq_index == ina->ifa_dev->dev->ifindex
>-	    && i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip != ina->ifa_address)
>+	/* If masquerading this conntrack but the masquerading ip
>+	   no longer exists locally, drop conntrack. */
>+	if (i->nat.masq_index && !(inet_confirm_addr(NULL, 0,
>+	    i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip, RT_SCOPE_HOST)))
> 		ret = 1;
> 	READ_UNLOCK(&masq_lock);
> 
>@@ -150,11 +149,10 @@
> 			   unsigned long event,
> 			   void *ptr)
> {
>-	/* For some configurations, interfaces often come back with
>-	 * the same address.  If not, clean up old conntrack
>-	 * entries. */
>+	/* In some configurations, interfaces come back with the
>+	 * same address.  If not, clean up old conntrack entries. */
> 	if (event == NETDEV_UP)
>-		ip_ct_selective_cleanup(device_cmp, ptr);
>+		ip_ct_selective_cleanup(device_cmp, NULL);
> 	else if (event == NETDEV_DOWN)
> 		ip_ct_selective_cleanup(connect_unassure, ptr);
> 
>  
>
