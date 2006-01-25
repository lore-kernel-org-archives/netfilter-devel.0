From: Patrick McHardy <kaber@trash.net>
Subject: Re: REDIRECT in kernel >= 2.6.15 broken???
Date: Wed, 25 Jan 2006 12:31:08 +0100
Message-ID: <43D7617C.20102@trash.net>
References: <43D74B7D.000002.25194@pantene.yandex.ru>
	<43D74D68.5090808@trash.net>
	<43D75B4A.000005.27248@mfront8.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dkiba@yandex.ru
In-Reply-To: <43D75B4A.000005.27248@mfront8.yandex.ru>
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

KdF wrote:
>>>Packets get forwarded as usual without any attempt to be redirected.
> 
> 
>>Works fine for me. Please post some details about your setup, the
>>exact rules you're using and what (if any) patches you've applied.
> 
> 
> My setup is following:
> Station with two interfaces, external interface is looking to the router, internal interface attached to LAN.
> 
> Internal interface running pppoe-server, and pppoe-clients connect to it, spawning pppd processes and ppp interfaces.
> Internal ip-address is for example 192.168.0.19. 
> 
> To completely hide it from general ip-network, /proc/*/eth0/arp_ignore is set to 8. We tried to completely disable ARP on this interface, but REDIRECT doesn't work, because it tries to send packets on primary address of this interface, and there is no possibility to change it in our case.
> 
> 192.168.0.19 is an address set on interface running pppoe, 10.1.1.1 is an server peer address for ppp clients spawned by pppoe-server, there is a www server, squid, frox and mail proxy accessible on it, and it is set on the same physical interface.
> 
> Here is a part of firewall rules:
> 
> $ipt -t nat -A PREROUTING -i ppp+ -d      10.1.1.1 -p tcp --dport   80 -j ACCEPT
> $ipt -t nat -A PREROUTING -i ppp+ -d ! 10.1.1.1 -p tcp --dport 21 -j REDIRECT --to-port 2121
> $ipt -t nat -A PREROUTING -i ppp+ -d ! 10.1.1.1 -p tcp --dport 25 -j REDIRECT --to-port 25
> 
> #$ipt -t nat -A PREROUTING -i ppp+ -d ! 10.1.1.1 -p tcp --dport 25 -j DNAT --to-destination 10.1.1.1:25
> 
> $ipt -t nat -A PREROUTING -i ppp+ -p tcp -m multiport --dport 80,81,82,83,88,8000,8001,8002,8080,8081 -j REDIRECT --to-port 111 
> $ipt -t nat -A PREROUTING -i ppp+ -p tcp -m multiport --dport 8082,8083,8091,8100,8101,8102,8103,8888,3128,777 -j REDIRECT --to-port 111 
> 
> With specified kernels, REDIRECT and DNAT don't work for me :(
> I see on router behind this machine that packets are trying to go out with original sources and destinations, and they should be redirected.
> 
> Even if problem in ARP, why they aren't simply dropped? :(
> 
> Maybe trouble is in arp_ignore? Or something changed in processing redirected packets in newer kernels?

My guess is that its related to invalid hardware checksums.
Please check if you have hw checksumming enabled on the underlying
eth device, if so load the ipt_LOG module and execute
"echo 255 >/proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid"
