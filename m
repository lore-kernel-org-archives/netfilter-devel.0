From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 23:35:48 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401272301070.27343-100000@filer.marasystems.com>
References: <20040127205123.GA11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Willy Tarreau <willy@w.ods.org>, Tom Eastep <teastep@shorewall.net>,
   Michal Ludvig <mludvig@suse.cz>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040127205123.GA11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Jan 2004, Harald Welte wrote:

> Please don't confuse hooks with chains.  I suggested to add new
> netfilter hooks (NF_IP_{PRE,POST}_XFRM), but attach the old INPUT/OUTPUT
> (or even PREROUTING/POSTROUTING) chains to those hooks.

Sorry for the naming mismatch. With the current close relation between 
hooks and chains it is easy to confuse the two when one is not installing 
hooks every day. All thoughts was in netfilter hooks not iptables chains.

Using the existing existing hooks with NF_IP_LOCAL_IN/OUT for the IPSec
wrapped packets is a exact match on what is required for conntrack, but to
answer my own question on what is wrong with INPUT/OUTPUT there is nothing
wrong but NAT and mangle may benefit from using a couple of new hooks for
the "original" packets just at the border to IPSec due to the different
rerouting requirements. NF_IP_LOCAL_IN/OUT is however an exact match for
all existing netfilter module requirements on the encapsulated packets
from what I can tell.

If there is a desire to use new hooks for the encapsulated packets then
this should be done for the whole path of those packets, which obviously
becomes somewhat tricky as it is not known yet at the NF_IP_PRE_ROUTING
time of incoming packets that the encapsulated packet will go to IPSec and
a bastard on final output of transmitted packets.


My slightly revised proposal is now (this time using hook names to avoid
confusion)

(Client) -> Gateway -> (Gateway)

1. NF_IP_PRE_ROUTING
2. NF_IP_FORWARD
3. NF_IP_XXXXXXXX, transparently mapped to the POSTROUTING chain in 
iptables.

[IPSec encapsulation]

4. NF_IP_LOCAL_OUT
5. NF_IP_POST_ROUTING


(Gateway) -> Gateway -> (client)

1. NF_IP_PRE_ROUTING
2. NF_IP_LOCAL_IN

[IPSec decapsulation]

3. NF_IP_YYYYYYYY, transparently mapped to the PREROUTING chain in 
iptables
4. NF_IP_FORWARD
5. NF_IP_POST_ROUTING


And similarily for the Host -> Gateway/Host case (locally generated 
packets).



But I'd say the use of new hooks should be avoided unless seen needed when 
implementing rerouting. Similar "rerouting" needs to be done in the normal 
hook to allow netfilter packet modifications to change the routing/policy 
decision to cause a previously clear text packet to be sent over IPSec as 
is needed on the same changes to packets decided to go to an IPSec SPI.

My problem with adding new hooks is that I don't see a value in adding new
types of hooks if all uses of this hook will be mapped to the exact same
code paths.

What is pretty clear is that the "rerouting" requirements is far from
obvious and needs to be analyzed carefully. If one thought rerouting of
packets in the plain IP with ip_route_me_harder was a mess the situation
is now some orders of magnitude more complex it seems, at least from a
quick evaluation without digging into the actual 2.6 IPSec code.

Regards
Henrik
