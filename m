From: Guy Martin <gmsoft@tuxicoman.be>
Subject: Re: Per-client NAT routing -- possible?
Date: Fri, 24 Mar 2006 14:28:20 +0100
Message-ID: <20060324142820.4eb646c1.gmsoft@tuxicoman.be>
References: <51e5f6120603220916v3c536afamdb3023563866397d@mail.gmail.com>
	<51e5f6120603221849p2da80ec5nb49ae81d7ae93d8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Jeremy Elson" <jelson@gmail.com>
In-Reply-To: <51e5f6120603221849p2da80ec5nb49ae81d7ae93d8f@mail.gmail.com>
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


Jeremy,


I got similar thing running here :

I first create one routing table per gateway. Each table contains only the default gateway :

caesar ~ # ip ro sh ta 20
default via 172.17.0.2 dev eth4 
caesar ~ #
And the same for each gw.


Then I create routing rules based on the fw mark :

caesar ~ # ip ru
0:      from all lookup local
10:     from all lookup main
20:     from all fwmark 0x2 lookup 20 
30:     from all fwmark 0x3 lookup 30 
40:     from all fwmark 0x4 lookup 40 
32766:  from all lookup main 
32767:  from all lookup default 
caesar ~ # 

The order is important ! You must have the main table before the others at prio 10 for example to avoid problems with your lan.
Also, don't put a default route in the main table as it will get everything routed to this route. Instead, put your default route in the default table.


Then in iptables you simply mark the packets where you want them to be sent. The CONNMARK is used to match connection coming from those gateways. This allow the router to remember where the connection comes from and send subsequent packets from the reverse direction to the right router.

caesar ~ # iptables -L -v -n -t mangle
Chain PREROUTING (policy ACCEPT 162M packets, 120G bytes)
 pkts bytes target     prot opt in     out     source               destination         
 380M  288G CONNMARK   all  --  *      *       0.0.0.0/0            0.0.0.0/0           CONNMARK restore 
 218M  168G ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0           MARK match !0x0 
2413K  147M from_playa  all  --  *      *       172.18.0.11          0.0.0.0/0           /* Packets from playa -> beta-site */ 
 7686  584K MARK       udp  --  *      *       0.0.0.0/0            0.0.0.0/0           /* NTP -> ADSL */ udp dpt:123 MARK set 0x4 
 1659 98108 MARK       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           /* SMTP -> ADSL */ tcp dpt:25 MARK set 0x4 
   35  2080 MARK       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           /* DNS/tcp -> ADSL */ tcp dpt:53 MARK set 0x4 
 118K 8903K MARK       udp  --  *      *       0.0.0.0/0            0.0.0.0/0           /* DNS/udp -> ADSL */ udp dpt:53 MARK set 0x4 
    0     0 MARK       udp  --  *      *       0.0.0.0/0            0.0.0.0/0           /* IAX -> ADSL */ udp dpt:4568 MARK set 0x4 
 176K   12M MARK       all  --  *      *       0.0.0.0/0            0.0.0.0/0           MAC 00:90:27:0A:8C:C6 MARK set 0x2 
1525K   77M MARK       all  --  *      *       0.0.0.0/0            0.0.0.0/0           MAC 00:10:A7:08:F8:E9 MARK set 0x3 
 3726  351K MARK       all  --  *      *       0.0.0.0/0            0.0.0.0/0           MAC 00:12:D9:AE:0C:F7 MARK set 0x4 
 162M  120G CONNMARK   all  --  *      *       0.0.0.0/0            0.0.0.0/0           CONNMARK save 

Chain from_playa (1 references)
 pkts bytes target     prot opt in     out     source               destination         
2432K  171M MARK       all  --  *      *       0.0.0.0/0            0.0.0.0/0           MARK set 0x3 
    7   420 MARK       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:873 MARK set 0x4 
2432K  171M RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0  

This match per host, per port or whatever you want.


HTH,
  Guy


On Wed, 22 Mar 2006 18:49:36 -0800
"Jeremy Elson" <jelson@gmail.com> wrote:

> [ Sent before I subscribed - I think it was silently dropped. 
> Apologies if you get 2. ]
> 
> 
> Hi,
> 
> I'm trying to set up a Linux box as a NATting router.  But here's the
> trick: my box's external interface is on a LAN that has a whole bunch
> of routers on it, any of which can be used to access the Internet.
> I'm trying to figure out how to configure iptables so that the NAT box
> selects the router to use based on client IP address (i.e., the IP
> address on the inside interface).
> 
> I've been tinkering with a command like this:
> 
> iptables -t nat -A POSTROUTING -i $INTERNAL_CLIENT_IP -o
> external-iface0 -j SNAT --to $EXTERNAL_ROUTER_IP
> 
> ...but it seems that --to controls the new source address given to the
> packet (i.e., the router's outside-interface IP), and not the
> destination to which the NATted packet is sent.
> 
> Could someone please point me in the right direction?  Or is this not possible?
> 
> Thanks!
> 
> --Jeremy
> 


-- 
Guy Martin
Gentoo Linux - HPPA port Lead / IPv6 team
