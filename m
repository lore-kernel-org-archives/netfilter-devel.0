From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables performance under 2.6.0[-test9]
Date: Wed, 29 Oct 2003 01:32:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9F0AAD.2040203@trash.net>
References: <3F9D4370.99795B87@fy.chalmers.se> <3F9D5E60.866B0B63@fy.chalmers.se> <3F9E292C.3020509@trash.net> <3F9E3E6C.C0CC5598@fy.chalmers.se> <3F9E406C.7050105@trash.net> <3F9E506A.BD4BA635@fy.chalmers.se> <3F9E5EE6.1090103@trash.net> <3F9EE6C8.AE3F16DA@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Polyakov <appro@fy.chalmers.se>
In-Reply-To: <3F9EE6C8.AE3F16DA@fy.chalmers.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Andy Polyakov wrote:

>>This is either a misconfiguration or a bug in TCP.
>>    
>>
>
>Looks like neither:-) My NIC turned to be NETIF_F_TSO capable, which
>means that it "can off-load TCP/IP segmentation" and kernel is allowed
>to and does throw packets larger than ethernet MTU at it [and tcpdump
>therefore was honest].
>
>I'm currently running attached patch and it apparently solves my
>*particular* problem, but I can't tell if it's actually "the right
>thing(tm)" to do... Is (*pskb)->sk->sk_route_caps right place to check?
>Maybe out->features is more appropriate? Is there TSO maximum which one
>should compare (*pskb)->len against? That kind of questions...
>  
>
NETIF_F_TSO is a netdevice flag but it needs to be enabled, so its
probably not dev->features which we need to check. I'm going to have
a look at this tomorrow. However I do not understand why the packets
got dropped after fragmentation. This is what we need to understand
for fixing.

>HOWEVER!!! Even if we figure out "the right thing(tm)" and address the
>NETIF_F_TSO issue in proper manner, it does *not* necessarily mean that
>performance problem will disappear as well. Well, in my optinion... I
>mean performance might still suffer, whenever user will for example
>masquerade a larger MTU interface behind "narrower" one, e.g. behind
>PPPoE virtual interface, and further experiments should therefore be
>performed... But I'm not sure if I'll be able to assist, because my
>NETIF_F_TSO capable NIC might make it impossible to arrange for proper
>setup [without PPPoE which I simply don't have]. I'll try, but can't
>make any promises... Cheers. A.
>

Yes that it a known problem, ip_conntrack will perform refragmentation
with different mtu despite IP_DF set. The ipv6 conntrack port from USAGI
solved the problem by keeping the original sk_buffs with the defragmented
one and instead of refragmenting sending the original ones and checking
size and DF for them. This solves the pmtu discovery issues.

One remaining (not very important) problem are protocols like NFS
which send carefully spaced fragments. Defragmentation "eats" the
spacing so they are send to the device in a burst.

Regards,
Patrick


>------------------------------------------------------------------------
>
>--- ./net/ipv4/netfilter/ip_conntrack_standalone.c.orig	Sat Oct 25 20:43:32 2003
>+++ ./net/ipv4/netfilter/ip_conntrack_standalone.c	Tue Oct 28 23:16:56 2003
>@@ -198,6 +198,9 @@
> 	if (ip_confirm(hooknum, pskb, in, out, okfn) != NF_ACCEPT)
> 		return NF_DROP;
> 
>+	if ((*pskb)->sk && (*pskb)->sk->sk_route_caps&NETIF_F_TSO)
>+		return NF_ACCEPT;
>+
> 	/* Local packets are never produced too large for their
> 	   interface.  We degfragment them at LOCAL_OUT, however,
> 	   so we have to refragment them here. */
>  
>
