From: Martijn Lievaart <m@rtij.nl>
Subject: Re: Bridge netfilter defered hooks
Date: Thu, 08 Jun 2006 22:47:19 +0200
Message-ID: <44888CD7.8090601@rtij.nl>
References: <448051F3.1070509@trash.net>	<1149267610.3021.11.camel@localhost.localdomain>	<448072FC.3060902@trash.net>
	<44809B1C.2010907@gmx.net> <4487CEA8.8060701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4487CEA8.8060701@trash.net>
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

>Carl-Daniel Hailfinger wrote:
>  
>
>>IIRC the mark has only 32 bits. Not so long ago, I was using 30 bits
>>of that in my firewalling rules on a bridge-router. I might have
>>squeezed the physdev match in the remaining 2 bits, but I'm not
>>sure. I do admit the setup was fairly uncommon (bridging and
>>double nat with only one machine).
>>    
>>
>
>Yes, its getting a bit tight in there, but so far in all setups I've
>seen it was possible to get along with the 32 bits using masks or
>reusing bits after they are no longer needed. I guess we'll have to
>wait and see ..
>  
>

Something I've been thinking about. Currently it is impossible to write 
any kind of generic tool that uses the mark and plays nice with other 
generic tools. Maybe we need some kind of API that allocates bits in the 
mark. Something like "give me two bits", that returns some handle to the 
bits. That handle could then be used for identifying the bits in the mark.

As an added benefit, this encapsulates the operations on the mark, 
making it trivial to switch to say 64 bits for the mark.

What do others think?

M4
