From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bridge netfilter defered hooks
Date: Mon, 19 Jun 2006 17:59:09 +0200
Message-ID: <4496C9CD.8070701@trash.net>
References: <448051F3.1070509@trash.net>	<1149267610.3021.11.camel@localhost.localdomain>	<448072FC.3060902@trash.net>	<44809B1C.2010907@gmx.net>
	<4487CEA8.8060701@trash.net> <44888CD7.8090601@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <44888CD7.8090601@rtij.nl>
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
>> Yes, its getting a bit tight in there, but so far in all setups I've
>> seen it was possible to get along with the 32 bits using masks or
>> reusing bits after they are no longer needed. I guess we'll have to
>> wait and see ..
>>  
>>
> 
> Something I've been thinking about. Currently it is impossible to write
> any kind of generic tool that uses the mark and plays nice with other
> generic tools. Maybe we need some kind of API that allocates bits in the
> mark. Something like "give me two bits", that returns some handle to the
> bits. That handle could then be used for identifying the bits in the mark.

It can see that it would be useful for complex setups, but I can't think
of an efficient implementation of this. You would have to carry a table
of handle identifiers -> mark ranges with every packet, wouldn't you?
