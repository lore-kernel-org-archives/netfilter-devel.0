From: Philip Craig <philipc@snapgear.com>
Subject: Re: Netfilter+IPsec patches
Date: Wed, 18 Aug 2004 13:28:56 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4122CCF8.2060203@snapgear.com>
References: <20040526033537.GH4402@samad.com.au> <40B53CCE.40704@trash.net> <20040527044613.GC24464@samad.com.au> <20040818024025.GC21419@ns.snowman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20040818024025.GC21419@ns.snowman.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Stephen Frost wrote:
> I've run into a rather annoying problem.  I'm not sure if it's due to
> the IPSEC patches, but I have some suspicion that it is.  Basically the
> story goes like this:

This doesn't sound related to the IPSec patches.  Or did it previously
work without the patches?

> I've got a bunch of network cards in my gateway, in this example we're
> concerned w/ 3 of them- two connections to the internet, one internal.
> For this to work I have to have source-based routing working (which it
> used to, back when I was using 2.4).  It appears to still work fine for
> connections which are *not* NAT'd.  For connections which are NAT'd it
> goes like this:
> 
> eth0 - internet1 (has the 'default' route going out it)
> eth1 - internet2 (has a seperate route table w/ a default route)
> eth2 - internal
> 
> SYN comes in on eth0, NAT'd, goes out eth2, SYN+ACK comes back, that
> gets NAT'd and goes out eth0.  All's happy there.

So a packet with an internal source and a destination on the internet
is routed out eth0.  (Note that routing is prior to SNAT.)

> SYN comes in on eth1, NAT'd, goes out eth2, SYN+ACK comes back, that
> gets NAT'd to the eth1 address but then gets sent out *eth0* instead.

And again a packet with an internal source and a destination on the
internet is still routed out eth0.  Nothing unexpected here, although
it isn't what you want.

> pings (which aren't NAT'd) to the eth1 address work fine.  So do
> traceroute's (again, not NAT'd).  If NAT'ing is turned off and the
> machine accepts connections directly then TCP connections also work
> fine.

These are all connections to the machine's eth1 address, not internal
addresses?  So packets with an eth1 source and a destination on the
internet are routed out eth1.  But this is a different source from
above, so you can't really compare them.

> Policy-based routing is in effect, and is working for things which are
> not NAT'd.  Things which are NAT'd appear to be going out the main
> table's default route though instead of being properly routed.

I assume that currently you are only using the separate routing table
if the source address is eth1.  You need to modify this to also use
the separate routing table for replies to packets that came in eth1.
You can do this using CONNMARK.  Set the connmark for packets coming
in eth1, and restore it for packets coming in eth0, then add an ip rule
to use the separate routing table for that fwmark.

Alternatively, you could look at using the ROUTE target instead of
using policy based routing.  I've never tried it though.

-- 
Philip Craig - SnapGear, A CyberGuard Company - http://www.SnapGear.com
