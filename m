From: Patrick McHardy <kaber@trash.net>
Subject: Re: Transparent broadband network connectivity (IP PnP)
Date: Thu, 13 Mar 2003 20:19:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E70D9B4.4030703@trash.net>
References: <5.2.0.9.2.20030313100719.01f73bc0@216.136.173.10> <20030313090821.GA7053@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: dragon_nlt@yahoo.com,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <20030313090821.GA7053@naboo.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>
>
>>>Date: Thu, 13 Mar 2003 09:43:50 +0700
>>>To: laforge@gnumonks.org
>>>From: dragon_nlt@yahoo.com
>>>Subject: RE: Transparent broadband network connectivity (IP PnP)
>>>
>>>Hi,
>>>
>>>Maybe you will misunderstand my question. So i will describe the problem
>>>in detail.
>>>
>>>This is the implementation for such a public internet access network like
>>>airport, hotel, ... So the client IP address can be any thing. The main
>>>point is that a client just only need to plug into the net then he can
>>>surf internet without changing his ip configuration.
>>>I found some commercial products for this such as IP PnP
>>>(http://www.infino.co.kr/infino/eng/softpackage_e.php), Reliaware
>>>(http://www.demarctech.com/products/reliawave-rwh/reliawave-ipnpsg.html)
>>>(Please see Address Translate Function section). I wonder that iptables
>>>itself can do it or not.
>>>
>>>With iptables, we can nat outgoing traffic, but the problem is that
>>>clients inside internal network can be any IP address (different subnet,
>>>netmask, gateway, dns ... and even thought clients have the same IP). I
>>>think there is needed a layer-2 NAT, e.g. handling clients which may have
>>>any IP address (even the same IP address), etc. correctly. I found a
>>>useful thread here
>>>http://lists.personaltelco.net/pipermail/ptp/2002q4/010591.html.
>>>
>>>For example
>>>
>>>Client 1 -----------|
>>>192.168.10.5        |
>>>                    |  172.16.1.1  PublicIP
>>>Client 2 -----------|        eth0    eth1
>>>DHCP(172.16.1.90)   |-------- [ GW ] ----- [ router ] --- Internet
>>>                    |  DefaultGW=RouterIP
>>>Client 3 -----------|
>>>200.192.16.10       |
>>>                    |
>>>Client 4 -----------|
>>>64.12.5.12
>>>
>>>I can set the eth0 into proxy arp mode (net.ipv4.conf.eth0.proxy_arp = 1)
>>>to set it as the gateway for all clients, and use iptables SNAT target
>>>inside nat POSTROUTING chain of eth1.
>>>
>>>iptables -t nat -A POSTROUTING -o eth1 -j SNAT --to-source <eth1 ip>
>>>
>>>When client send a packet out, the packet goes into eth0, goes through
>>>forward chain after routing decision, get nat'd on eth1 then send to the
>>>router. The problem is that when the reply packet from router goes back
>>>eth1, after de-nat'd, the packet will be sent to the eth1 following the
>>>default route on gateway box instead of eth0 (since client can have any
>>>ip, so we can't set the routing table; default gateway is router's ip via
>>>eth1). I think there is needed such a MAC based NAT module on PREROUTING
>>>chain of eth0. So the gateway will don't care about client IP, just client
>>>MAC address (assume that MAC address is unique). Do you have any idea?
>>>
>>>Best Regards,
>>>
>>>John Duke
>>>      
>>>

I guess you could use conntrack match with --orig-dst and ROUTE target 
to force packets
out the "correct" interface. You probably still need to do some things 
to make linux send
arp requests for these ips.

Patrick
