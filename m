From: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
Subject: Re: policy routing on locally generated packets
Date: 26 Aug 2003 10:47:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1061887675.1273.37.camel@drs0.manchotnetworks.net>
References: <1061813400.1289.36.camel@drs0.manchotnetworks.net>
	<3F4A01BE.1090805@trash.net> <3F4A2795.3030805@trash.net>
	<1061837608.1333.9.camel@drs0.manchotnetworks.net>
	<20030825190750.GH423@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
   netfilter-devel
	 <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030825190750.GH423@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick(s),


On Mon, 2003-08-25 at 21:07, Patrick Schaaf wrote:
> > This would provide a way to fiddle with the packet properties without
> > the neccesity of changing bind() in a specific application ... or would
> > it? 
> 
> Regarding this path, two comments:
> 
> 1) you can most easily LD_PRELOAD a small bit of library which replaces
> bind() and friends, and does the thing you want.
Most likely true, but I am a non-programmmer, and if I had preference,
changes to routing would be done without touching code.

> 2) the chbind functionality of http://www.solucorp.qc.ca/miscprj/s_context.hc
> is a somewhat more / somewhat less intrusive method.
I'll have a look, but (1)

> What about mangle/PREROUTING? Doesn't it / shouldn't it sit before a
> routing decision for locally generated packets?
PREROUTING is "before" a routing decision. but only affects packets
coming in over the wire, and not locally generated. 

My issue arises from ip accounting -- that is -- each user on a linux
box must have their wire traffic accounted for. As in the first message
of the thread:

#!/bin/bash
iptables --append OUTPUT --table mangle --match owner \
     --gid-owner 500 --jump MARK --set-mark 0x2

iptables --append OUTPUT --table mangle --match owner \
     --gid-owner 501 --jump MARK --set-mark 0x3

ip rule add fwmark 0x2 table 2
ip route add default dev eth0 src 192.168.0.1 via 192.168.0.254 table 2
ip rule add fwmark 0x3 table 3
ip route add default dev eth0 src 192.168.0.2 via 192.168.0.253 table 3
ip route flush cache
#end_script

This script would cause group 500 to use src address .1 and group 501
src address .2. Because each group has its own src address, I can do
wire level accounting/routing by group (or eventually user). In the
example, I am also selecting a router based on the gid. 

So I am searching for a hopefully simple way to implement this without
having to recompile a bunch of stuff.

Thanks Again!

Ciao

Charles




> 
> best regards
>   Patrick
