From: Andreas Jellinghaus <aj@dungeon.inka.de>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 22:13:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <pan.2004.01.27.21.13.32.754125@dungeon.inka.de>
References: <20040124082252.GA19035@alpha.home.local> <Pine.LNX.4.44.0401241015470.32723-100000@filer.marasystems.com> <20040124092721.GA19140@alpha.home.local> <20040127103917.GC11761@sunbeam.de.gnumonks.org> <20040127132725.GA14685@openoffice.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

On Tue, 27 Jan 2004 14:27:25 +0100, Valentijn Sessink wrote:

> Hello,
> 
> At Tue, Jan 27, 2004 at 11:39:18AM +0100, Harald Welte wrote:
>> I also disagree that an ESP packet should be trated as locally
>> generated (and thus iterate over OUTPUT).
> 
> This is what happens with incoming packets: they hit INPUT twice.

yes, but once before and once after decryption. use either fwmark
or an ipip tunnel interface to destinguish between already decrypted
and was-never-encrypted packets. 

> On output, however, things are not so transparant. A packet hits OUTPUT,
> then gets encrypted. A totally different packet hits POSTROUTING. This makes
> no sense.

use an interface, and you will see the packet twice, plus the interface
does the route lookup on the encrypted packet. so no ugly hacks in the
routing table are necessary.

(ugly hacks scenario: consider a road warrior.
he is 192.168.3.2 and his vpn gateway is 192.168.3.1. he wants to put
the company net on that GW address. But without a GW he doesn't know
on which interface to put it. it could be either wlan (if the tunnel
is established with his wireless lan card), or the eth0 interface
(if he is using ethernet cable to connect to the net).
sure, the ipsec software could manipulate the routing table after
altering local and remote tunnel endpoints, but that is an ugly hack
and a bad design.)

[symetry]

that does not work:
netfilter wants NAT to be the first thing for incoming packets
and the last thing for outgoing packets. thats symetry.

but you want ipsec encryption and decryption as soon as possible:
both before looking at the routing table.

mixing those two will never result in symetry. if you try it
(routing before encapsulation), the result has problems.

Andreas
