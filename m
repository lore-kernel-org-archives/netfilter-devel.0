From: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
Subject: Re: policy routing on locally generated packets [summary]
Date: 27 Aug 2003 18:19:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1062001173.1302.37.camel@drs0.manchotnetworks.net>
References: <Pine.LNX.4.44.0308262141080.16076-100000@filer.marasystems.com>
	<1061995596.1247.28.camel@drs0.manchotnetworks.net>
	<3F4CC6BF.2030604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>, Patrick Schaaf <bof@bof.de>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F4CC6BF.2030604@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick and Henrick,


On Wed, 2003-08-27 at 16:57, Patrick McHardy wrote:
> lartc@manchotnetworks.net wrote:
> 
> >final conclusion:
> >to effectively obtain policy routing on locally generated packets, the
> >OUTPUT ROUTING process would need to be hooked into netfilter thereby
> >letting packets be marked. OUTPUT ROUTING would then use the mark to
> >find a routing table via a routing rule. OUTPUT ROUTING would get the
> >route key fields using the "best" destination route within the routing
> >table, or use the default routing table if no suitable route was found.
> >(Cedric -- this would include the iif key therefore obviating/including
> >your patch through ip route commands)
> >
> >
> >iptables --append OUTROUTE --table mangle (expressions) \
> >         --jump MARK --set-mark 0x2
> >
> 
> It is not possible for two reasons:
> - before output routing the packet doesn't have a source ip so it
> would be weird to pass it through iptables tables.
actually, thats just what i want to do -- iptables would mark the packet
only and the output routing would respect the mark ... but 

> - the source is chosen before the ip header is prepended, this
> makes it impossible to pass it to iptables first.
this pretty much says it all ... oh well :-/ 


> Why can't you use NAT ?
i tried the following

iptables --append OUTPUT --table mangle --match owner --uid-owner 500
--jump MARK --set-mark 0x2

iptables --append POSTROUTING --table nat --match mark \
         --mark 0x2 --jump SNAT --to-source 192.168.1.100
ip route flush cache


*tcp/udp work
*icmp and arp (yeah, L2) dont -- but they do when the src address is set
by ip route 
*ip route lets you define all the nitty gritty (key fields) in one place
in a nice garden setting ...

ciao

charles
