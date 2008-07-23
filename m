From: Patrick McHardy <kaber@trash.net>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Wed, 23 Jul 2008 16:38:42 +0200
Message-ID: <48874272.1020503@trash.net>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org> <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch> <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch> <488740E7.3040005@gmx.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000802020609050704000002"
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36550 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYGWOis (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:38:48 -0400
In-Reply-To: <488740E7.3040005@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000802020609050704000002
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Fabian Hugelshofer wrote:
> Fabian Hugelshofer wrote:
>> Patrick McHardy wrote:
>>> Callgraph information would be useful since its unclear whether
>>> this is the memcpy triggered by netlink message trimming in
>>> af_netlink.c or something different. Unfortunately according
>>> to the documentation this is only supported on x86. I think
>>> selecting the netfilter options as modules should provide
>>> slightly more detail though.
> [...]
>>
>> memcpy is mostly invoked by skb_copy and netlink_broadcast 
>> (af_netlink). netlink_broadcast is expensive on its own and calls 
>> pskb_expand_head which is expensive as well. Using multipart messages 
>> would reduce the need to call netlink_broadcast.
> 
> I profiled again with nfnetlink and nf_conntrack compiled as modules:
>    103599 61.1842 vmlinux
>     24481 14.4582 ath_pci
>     19232 11.3582 nf_conntrack
>     10435  6.1628 wlan
>      3588  2.1190 nf_conntrack_netlink
>      2869  1.6944 oprofiled
>      1886  1.1138 nf_conntrack_ipv4
>      1447  0.8546 ath_rate_minstrel
>       627  0.3703 nfnetlink
>       237  0.1400 ld-uClibc-0.9.29.so
>       233  0.1376 libuClibc-0.9.29.so
>       183  0.1081 iptable_raw
>       174  0.1028 ctevtest
>       147  0.0868 busybox
>        85  0.0502 libnfnetlink.so.0.2.0
>        60  0.0354 libnetfilter_conntrack.so.1.2.0
>        38  0.0224 arp_tables
>         2  0.0012 arptable_filter
> 
> Again most of the time is spent in the kernel. Memory and skb operations 
> are accounted there. I suspect that they cause the most overhead.
> 
> Do you plan to dig deeper into optimising the non-optimal parts? I 
> consider myself not to have enough understanding to do it myself.

The first thing to try would be to use sane allocation sizes
for the event messages. This patch doesn't implement it properly
(uses probing), but should be enough to test whether it helps.





--------------000802020609050704000002
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 105a616..0aa1b30 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -425,6 +425,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	unsigned int type;
 	sk_buff_data_t b;
 	unsigned int flags = 0, group;
+	static unsigned int size = 128;
 
 	/* ignore our fake conntrack entry */
 	if (ct == &nf_conntrack_untracked)
@@ -446,7 +447,8 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	if (!nfnetlink_has_listeners(group))
 		return NOTIFY_DONE;
 
-	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
+retry:
+	skb = alloc_skb(size, GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;
 
@@ -525,7 +527,8 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 nlmsg_failure:
 nla_put_failure:
 	kfree_skb(skb);
-	return NOTIFY_DONE;
+	size <<= 1;
+	goto retry;
 }
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 

--------------000802020609050704000002--
