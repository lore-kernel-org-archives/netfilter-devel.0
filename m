From: John Duke <johnyduke@yahoo.com>
Subject: Re: Transparent broadband network connectivity (IP PnP)
Date: Mon, 17 Mar 2003 21:36:59 +0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.2.0.9.2.20030317205113.022da110@192.168.1.1>
References: <200303132244.h2DMisD16238@singularity.tronunltd.com>
 <200303132244.h2DMisD16238@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>, delaunois@info.ucl.ac.be
In-Reply-To: <3E711528.4040502@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm realy reach the target with proxy arp and the following rules

                        172.16.1.1  PublicIP
Client 1 -----------|        eth0    eth1
<any IP>         |-------- [ GW ] ----- [ router ] --- Internet
                      |  DefaultGW=RouterIP
Client 2 -----------|
<any IP>

# snat output
(1) iptables -t nat -A POSTROUTING -o eth1 -j SNAT --to <PublicIP>

# redirect de-nat'd return packet to internal network
(2) iptables -t mangle -A FORWARD -i eth1 -j ROUTE --iface eth0

# allow internal clients connect to 172.168.1.1 (for ssh, web, ...)
(3) iptables -t mangle -A POSTROUTING -o eth1 -m conntrack --ctreplsrc
172.16.1.1 -j ROUTE --iface eth0

With above configuration, client inside internal network (must use a valid
DNS server) can access into internet as well as connect to the gateway box
via ip 172.16.1.1

But in case client can have any ip configuration, I have to solve the
following issues:
         - Any ip (solved)
         - Any gateway (solved)
         - Any DNS setting (?)
         - Any proxy setting (?)

To solve the any DNS setting issue, I added DNS redirect as follow:

(4) iptables -t nat -I PREROUTING -i eth0 -p tcp --dport 53 -j DNAT --to
<Public DNS IPs>
(5) iptables -t nat -I PREROUTING -i eth0 -p udp --dport 53 -j DNAT --to
<Public DNS IPs>

Then the wierd thing happened. When client send a DNS request, the replied
SYN/ACK from Public DNS server to gateway box, after go into eth1
interface, seems to be disappeared in the kernel. I can not see either that
SYN/ACK packet send out to internal network via eth0 (in correct routing
case) or outside network via eth1 (in wrong routing case). For sure that if
i remove (2) rule, I can see the SYN/ACK packet after de-nat'd send out
again to eth1. It seems to me that ROUTE target has some weird side effect.
Do anyone have any suggestion to override DNS and proxy issues?

Regards,

John

At 12:32 AM 3/14/2003 +0100, Patrick McHardy wrote:
>I still think my suggestion is a lot easier, as i understood him he already
>got so far that the clients can send packet to the internet, they are SNATed
>and reply packet reach the NAT box which DNATs them back automatically.
>With a simple iptables rule packet can be directed to the client-network:
>iptables -A PREROUTING -i eth1 -m conntrack --orig-dst <eth0-ip> -j ROUTE
>--oif eth1
>Only thing left to do is make linux send arp requests for the client ips
>on eth1,
>im unsure how this can be achieved or if anything needs to be done at all.
>
>Patrick
>
>
>Ian Latter wrote:
>
>>Clarifying this ...  correcting 1 and 2 below;
>>
>>  Once they're at the linux router/firewall doohicky, they can then
>>be universally NATed .... but then you've got a problem ... because
>>the linux box, doing layer-3 routing, will send user data back to the
>>internet.  You can fix this by doing one of two things;
>>
>>  1.  Whatever does the arp spoofing to correct the routing, should
>>       also rarp the ips of the macs currently asking for arps.  This
>>       would allow you to layer-2 correct/align the linux box.  ie;
>>            rarp on 10.1.1.99 = US:ER:1M:AC
>>            rarp on 192.168.27.149 = US:ER:2M:AC
>>            rarp on 1.2.3.200 = US:ER:3M:AC
>>          (users[1-n]) --- [linux1/router/fw] -- (net)
>>       This linux box would have a default (l3) route to the net.
>>
>>  2. You could use two linux boxes.  The first (closest to the users)
>>      would have to do all of the layer 2 work - and then forward (bridge)
>>      traffic to the second.  The second would have to do ip NATing
>>      when matching the traffic from the MAC of the first ... I think ... I
>>      haven't done any layer 2 stuff in iptables.  Ie;
>>          (users[1-n]) --- [linux1/l2bridge] -x- [linux2/router/fw] -- (net)
>>      The second linux box has default (l3) route of the net, it
>> would      reply to traffic from the outer interface mac address of the first
>>      linux box.
>>
>>
>>  Option 1 looks easy enough to do ... and seems cooler .. but option
>>2 might let you get away with doing this without writing a scrap of code
>>...  dunno ... check the kernel options and supporting software
>>for the layer 2 stuff .. and if iptables' match on mac will do what we
>>want then you're set.
>>
>>
>>
>>
>
