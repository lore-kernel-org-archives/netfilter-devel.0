From: Patrick McHardy <kaber@trash.net>
Subject: Re: policy routing on locally generated packets [summary]
Date: Wed, 27 Aug 2003 16:57:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4CC6BF.2030604@trash.net>
References: <Pine.LNX.4.44.0308262141080.16076-100000@filer.marasystems.com> <1061995596.1247.28.camel@drs0.manchotnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>, Patrick Schaaf <bof@bof.de>,
 netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
In-Reply-To: <1061995596.1247.28.camel@drs0.manchotnetworks.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

lartc@manchotnetworks.net wrote:

>final conclusion:
>to effectively obtain policy routing on locally generated packets, the
>OUTPUT ROUTING process would need to be hooked into netfilter thereby
>letting packets be marked. OUTPUT ROUTING would then use the mark to
>find a routing table via a routing rule. OUTPUT ROUTING would get the
>route key fields using the "best" destination route within the routing
>table, or use the default routing table if no suitable route was found.
>(Cedric -- this would include the iif key therefore obviating/including
>your patch through ip route commands)
>
>
>iptables --append OUTROUTE --table mangle (expressions) \
>         --jump MARK --set-mark 0x2
>

It is not possible for two reasons:
- before output routing the packet doesn't have a source ip so it
would be weird to pass it through iptables tables.
- the source is chosen before the ip header is prepended, this
makes it impossible to pass it to iptables first.

Why can't you use NAT ?

Best regards,
Patrick
