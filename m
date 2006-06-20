From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bridge netfilter defered hooks
Date: Tue, 20 Jun 2006 23:44:18 +0200
Message-ID: <44986C32.60105@trash.net>
References: <448051F3.1070509@trash.net>	<1149267610.3021.11.camel@localhost.localdomain>	<448072FC.3060902@trash.net>	<44809B1C.2010907@gmx.net>	<4487CEA8.8060701@trash.net>
	<44888CD7.8090601@rtij.nl> <4496C9CD.8070701@trash.net>
	<449867EE.5080808@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <449867EE.5080808@rtij.nl>
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

Martijn Lievaart wrote:
> Patrick McHardy wrote:
> 
>> It can see that it would be useful for complex setups, but I can't think
>> of an efficient implementation of this. You would have to carry a table
>> of handle identifiers -> mark ranges with every packet, wouldn't you?
>>  
>>
> 
> No, no! Just an API (which doesn't need to be coupled to iptables kernel
> part at all) where one can "reserve" some bits in the nfmark. That
> handle would refer to the same bit(s) everywhere, but you don't need to
> know which bits in the mark you are exactly using. So this implies
> ANDing as well. Something along these lines (error handling simplified):
> 
> # reserve 1 bit
> MYMARK=`iptables-mark --reserve mybits:1`
> # This would return some 'handle' (most probably the offset in the mark,
> prefixed with something)
> 
> # Use MYMARK to set just one bit in the mark
> iptables -A ..... -j MARK --set $MYMARK

It seems I misunderstood you, I thought you were talking about dynamic
reservations :) Sure, something like /etc/iproute/rt_realms would make
life easier for users. But it doesn't really solve the problem that its
sometimes really hard to get along with 32 bits.
