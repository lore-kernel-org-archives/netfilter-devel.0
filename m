From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: MAC Filtering
Date: Wed, 05 Jan 2005 19:16:37 +0100
Message-ID: <1104948997.3377.7.camel@localhost.localdomain>
References: <200501051425.36450.erwin.vandevelde@gmail.com>
	<17648.213.236.112.75.1104937880.squirrel@213.236.112.75>
	<200501051712.18817.erwin.vandevelde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: erwin.vandevelde@gmail.com
In-Reply-To: <200501051712.18817.erwin.vandevelde@gmail.com>
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

Op wo, 05-01-2005 te 17:12 +0100, schreef Erwin Van de Velde:
> Hi,
> 
> I don't want to bridge, I only said I have to when using ebtables. I need MAC 
> filtering without bridging... I'm fully aware of the fact that iptables works 
> on layer 3 and that MAC is layer 2, however if it can filter on source MAC 
> addresses, why can't it filter on destination MAC addresses?

You can use ebtables without using a bridge as follows:

brctl addbr br0
brctl addif br0 eth0
ifconfig eth0 0.0.0.0
ifconfig br0 $IP_OF_ETH0_SIDE
brctl addbr br1
brctl addif br1 eth1
ifconfig eth1 0.0.0.0
ifconfig br1 $IP_OF_ETH1_SIDE

Change your routing table as needed. Your router thus uses brx instead
of ethx to transmit and receive packets. ebtables will see the packets,
so you can do
ebtables -A OUTPUT -d $A_MAC_ADDRESS -j <target>

If you only need to check the destination address in one direction, f.e.
traffic leaving on eth0, you only need one bridge (in this case only
br0), with the proper routing table.

The downside is that your performance will downgrade substantially,
because all traffic will be queued twice.

cheers,
Bart
