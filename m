From: Yaron Wahl <elllgaucho@yahoo.com>
Subject: IPSEC Tunnel test setup
Date: Sat, 24 Apr 2004 17:57:39 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040425005739.89191.qmail@web50105.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,


I wanted to find a setup that let me test the
establishment of a number of IPSEC tunnels initiated
by a VPN Gateway. You can do it via 


				--------------VPN GW
				|
				|____________ VPN GW
				|
VPN-GW(Device Under Test)-------|
				|____________ VPN GW
				|
				|____________ VPN GW

When number of tunnel setup is getting large, it
becomes not practical


I have tried to find a setup where I could do it via
NAT with 2 Gateways only.



VPN-GW(1.1.1.1)------------NAT------------(2.2.2.2)VPN-GW

As seen by GW 1

Tunnel 1: 1.1.1.1<=>1.1.2.1
Tunnel 2: 1.1.1.1<=>1.1.2.2
.
.

As seen by GW 2

Tunnel 1: 2.2.1.1<=>2.2.2.2
Tunnel 2: 2.2.1.2<=>2.2.2.2
.
.

And where both sides of the NAT devices have to be
configured as default gateway for VPN-Gw's

I have tried to find routers, and open source
implementations who could that, but I have found none.
Maybe I didn't look hard enough.
You can do it with 2 NATting devices though.

The problem with Source NATting and Destination
NATting is that 
-for source natting you modify the source address only
after the routing
-for destination natting you modify the destination
address only before the routing

I decided to write my own Linux Netfilter/Iptables
module to do it, just to experiment with the Linux
kernel with which I don't have too much experience.

It is a new nat target module, that let you modify
source and destination address at the same time and on
the same hook for both directions.

Lets say you have a packet 1.1.1.1=>1.1.2.1 going from
VPN GW 1 to VPN GW 2
when it passes the PREROUTING hook, it will be
modified to 2.2.1.1=>2.2.2.2
When coming back from the VPN-GW2 2.2.2.2=>2.2.1.1
will be modified back to its original 1.1.2.1=>1.1.1.1
also in the PREROUTING hook and this with 1 rule.


The module works for what it was supposed to do: me
having fun experimenting and to have a practical setup
to test multiple IPSEC tunnel initiation.

I wrote on PC with a traditional 2.4.22 kernel
(Fedora). with iptables 1.2.9

If there is interest I can post the code for it

Hasta la pasta

Yaron

=====



	
		
__________________________________
Do you Yahoo!?
Yahoo! Photos: High-quality 4x6 digital prints for 25¢
http://photos.yahoo.com/ph/print_splash
