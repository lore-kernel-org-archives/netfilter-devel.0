From: Patrick McHardy <kaber@trash.net>
Subject: Re: Linux 2.4.23-pre1
Date: Thu, 28 Aug 2003 16:56:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F4E1823.7060600@trash.net>
References: <pcKD.6BP.19@gated-at.bofh.it> <200308280850.h7S8oxGx001862@pc.skynet.be>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010606010609010307090100"
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Hans Lambrechts <hans.lambrechts@skynet.be>
In-Reply-To: <200308280850.h7S8oxGx001862@pc.skynet.be>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010606010609010307090100
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Please try this patch.

Regards,
Patrick

Hans Lambrechts wrote:

>Greetings,
>
>  
>
>>Harald Welte:
>>  o [NETFILTER]: Backport iptables AH/ESP fixes from 2.6.x
>>  o [NETFILTER]: Fix uninitialized return in iptables tftp
>>  o [NETFILTER]: NAT optimization
>>  o [NETFILTER]: Conntrack optimization (LIST_DELETE)
>>
>>    
>>
>
>
>I see this in my log:
>
>Aug 28 10:45:44 pc kernel: MASQUERADE: No route: Rusty's brain broke!
>Aug 28 10:46:10 pc last message repeated 13 times
>Aug 28 10:48:42 pc kernel: NET: 1 messages suppressed.
>Aug 28 10:48:42 pc kernel: MASQUERADE: No route: Rusty's brain broke!
>Aug 28 10:48:43 pc kernel: MASQUERADE: Route sent us somewhere else.
>
>Forwarding and masquerading doesn't work anymore.
>
>Hans
>  
>

--------------010606010609010307090100
Content-Type: text/plain;
 name="x.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x.diff"

===== net/ipv4/netfilter/ipt_MASQUERADE.c 1.6 vs edited =====
--- 1.6/net/ipv4/netfilter/ipt_MASQUERADE.c	Tue Aug 12 11:30:12 2003
+++ edited/net/ipv4/netfilter/ipt_MASQUERADE.c	Thu Aug 28 16:54:15 2003
@@ -90,6 +90,7 @@
 #ifdef CONFIG_IP_ROUTE_FWMARK
 	key.fwmark = (*pskb)->nfmark;
 #endif
+	key.oif = 0;
 	if (ip_route_output_key(&rt, &key) != 0) {
                 /* Funky routing can do this. */
                 if (net_ratelimit())

--------------010606010609010307090100--
