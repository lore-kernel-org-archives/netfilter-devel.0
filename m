From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: Transparent broadband network connectivity (IP PnP)
Date: Fri, 14 Mar 2003 07:37:20 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303132137.h2DLbOI16185@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: <dragon_nlt@yahoo.com>,
   "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hmmm ....

  Yes .. you need to fix the laptops' routing ....  if we're not dhcp'ing all 
of these people (which would be the first thing I'd do), then you're stuck
with an internet's worth of IP addresses, masks and gateways ... from
private to public.  So getting the traffic to your linux gateway is the first
problem.   ie;
   user1 = 10.1.1.99 / 255.255.0.0 - gw 10.10.0.12
   user2 = 192.168.27.149 / 255.255.255.0 - gw 192.168.27.254
   user3 = 1.2.3.200 / 255.0.0.0 - gw [not set]   (user3 has a www
                                                                           server at 1.1.1.1)

  What you probably want to do is a layer2 fudge ... where, whatever
they arp for, you give them the linux box; this will then sort out all of
your routing issues ... ie;
  user1 = arp for 10.10.0.12 ... ans = LI:NU:XM:AC
  user2 = arp for 192.168.27.254 ... ans = LI:NU:XM:AC
  user3 = arp for 1.1.1.1 .... ans = LI:NU:XM:AC


  Once they're at the linux router/firewall doohicky, they can then
be universally NAT the traffic .... but then you've got a problem ... 
because the linux box, doing routing, will send user data back to
the internet.  You can fix this by doing one of two things;
  1.  Whatever does the arp spoofing to correct the routing, should
       also rarp the ips of the macs currently asking for arps.  This
       would allow you to layer2 correct the linux box.  this box would
       have a default route to the net.

  2. You could use two linux boxes.  The first (closest to the users)
      would have to do all of the layer 2 work - and then forward (bridge)
      traffic to the second.  The second would have to do ip NATing
      when matching the from MAC ... I think ... I haven't done any layer 2
      stuff in iptables.  second box has default route of the net.

Go with 1.

One problem you'll have with the layer 2 spoofing is that one day the
guy with www.intel.com on his laptop may arrive ... and he may choose
to respond to his own arp requests ... as unlikely as this at first may
appear to be  ... I'm sure its something that will bite you in the ass when
you least want it to (on reflection, if he did arrive and did respond to his
own arps, then you'll be the only guy in the world with the correct 
routing ;-))

Honestly though ... your best bet is DHCP ... most people expect it .. and
a lot of corporate networks are configured for it (meaning that the lappy
owners don't have to change their config to plug into you).

If you do find a way to do the arp and rarp work properly, then let me 
know ... I'd like to keep that one in my repetuar ...



----- Original Message -----
>From: "Patrick McHardy" <kaber@trash.net>
>To: 
>Subject:  Re: Transparent broadband network connectivity (IP PnP)
>Date: Thu, 13 Mar 2003 20:19:16 +0100
>
> >
> >
> >>>Date: Thu, 13 Mar 2003 09:43:50 +0700
> >>>To: laforge@gnumonks.org
> >>>From: dragon_nlt@yahoo.com
> >>>Subject: RE: Transparent broadband network connectivity (IP PnP)
> >>>
> >>>Hi,
> >>>
> >>>Maybe you will misunderstand my question. So i will describe the problem
> >>>in detail.
> >>>
> >>>This is the implementation for such a public internet access network like
> >>>airport, hotel, ... So the client IP address can be any thing. The main
> >>>point is that a client just only need to plug into the net then he can
> >>>surf internet without changing his ip configuration.
> >>>I found some commercial products for this such as IP PnP
> >>>(http://www.infino.co.kr/infino/eng/softpackage_e.php), Reliaware
> >>>(http://www.demarctech.com/products/reliawave-rwh/reliawave-ipnpsg.html)
> >>>(Please see Address Translate Function section). I wonder that iptables
> >>>itself can do it or not.
> >>>
> >>>With iptables, we can nat outgoing traffic, but the problem is that
> >>>clients inside internal network can be any IP address (different subnet,
> >>>netmask, gateway, dns ... and even thought clients have the same IP). I
> >>>think there is needed a layer-2 NAT, e.g. handling clients which may have
> >>>any IP address (even the same IP address), etc. correctly. I found a
> >>>useful thread here
> >>>http://lists.personaltelco.net/pipermail/ptp/2002q4/010591.html.
> >>>
> >>>For example
> >>>
> >>>Client 1 -----------|
> >>>192.168.10.5        |
> >>>                    |  172.16.1.1  PublicIP
> >>>Client 2 -----------|        eth0    eth1
> >>>DHCP(172.16.1.90)   |-------- [ GW ] ----- [ router ] --- Internet
> >>>                    |  DefaultGW=RouterIP
> >>>Client 3 -----------|
> >>>200.192.16.10       |
> >>>                    |
> >>>Client 4 -----------|
> >>>64.12.5.12
> >>>
> >>>I can set the eth0 into proxy arp mode (net.ipv4.conf.eth0.proxy_arp = 1)
> >>>to set it as the gateway for all clients, and use iptables SNAT target
> >>>inside nat POSTROUTING chain of eth1.
> >>>
> >>>iptables -t nat -A POSTROUTING -o eth1 -j SNAT --to-source <eth1 ip>
> >>>
> >>>When client send a packet out, the packet goes into eth0, goes through
> >>>forward chain after routing decision, get nat'd on eth1 then send to the
> >>>router. The problem is that when the reply packet from router goes back
> >>>eth1, after de-nat'd, the packet will be sent to the eth1 following the
> >>>default route on gateway box instead of eth0 (since client can have any
> >>>ip, so we can't set the routing table; default gateway is router's ip via
> >>>eth1). I think there is needed such a MAC based NAT module on PREROUTING
> >>>chain of eth0. So the gateway will don't care about client IP, just client
> >>>MAC address (assume that MAC address is unique). Do you have any idea?
> >>>
> >>>Best Regards,
> >>>
> >>>John Duke
> >>>      
> >>>
> 
> I guess you could use conntrack match with --orig-dst and ROUTE target 
> to force packets
> out the "correct" interface. You probably still need to do some things 
> to make linux send
> arp requests for these ips.
> 
> Patrick
> 
> 
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
