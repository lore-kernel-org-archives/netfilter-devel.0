From: Martijn Lievaart <m@rtij.nl>
Subject: Re: Bridge netfilter defered hooks
Date: Tue, 20 Jun 2006 23:26:06 +0200
Message-ID: <449867EE.5080808@rtij.nl>
References: <448051F3.1070509@trash.net>	<1149267610.3021.11.camel@localhost.localdomain>	<448072FC.3060902@trash.net>	<44809B1C.2010907@gmx.net>	<4487CEA8.8060701@trash.net>
	<44888CD7.8090601@rtij.nl> <4496C9CD.8070701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4496C9CD.8070701@trash.net>
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

Patrick McHardy wrote:

>Martijn Lievaart wrote:
>  
>
>>Patrick McHardy wrote:
>>
>>    
>>
>>Something I've been thinking about. Currently it is impossible to write
>>any kind of generic tool that uses the mark and plays nice with other
>>generic tools. Maybe we need some kind of API that allocates bits in the
>>mark. Something like "give me two bits", that returns some handle to the
>>bits. That handle could then be used for identifying the bits in the mark.
>>    
>>
>
>It can see that it would be useful for complex setups, but I can't think
>of an efficient implementation of this. You would have to carry a table
>of handle identifiers -> mark ranges with every packet, wouldn't you?
>  
>

No, no! Just an API (which doesn't need to be coupled to iptables kernel 
part at all) where one can "reserve" some bits in the nfmark. That 
handle would refer to the same bit(s) everywhere, but you don't need to 
know which bits in the mark you are exactly using. So this implies 
ANDing as well. Something along these lines (error handling simplified):

# reserve 1 bit
MYMARK=`iptables-mark --reserve mybits:1`
# This would return some 'handle' (most probably the offset in the mark, 
prefixed with something)

# Use MYMARK to set just one bit in the mark
iptables -A ..... -j MARK --set $MYMARK

M4
