From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 21:39:30 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409292131000.16633@filer.marasystems.com>
References: <415A12AE.1060901@parknet.dk> <415A3263.7080708@xgendev.com>
	<415A4B4E.1080801@parknet.dk>
	<Pine.LNX.4.61.0409291051190.11661@filer.marasystems.com>
	<415AE4F4.2000903@parknet.dk>
	<Pine.LNX.4.61.0409291855130.15266@filer.marasystems.com>
	<415B02CD.2080403@parknet.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Ben Efros <ben@xgendev.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <415B02CD.2080403@parknet.dk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Sep 2004, Simon Lodal wrote:

>> Having iptables -L output anything else than quad dotted format is an even 
>> worse idea. Why outputting any other notation than the official standard?
>
> Because iptables -nvL lines are already horribly long. Anything making them 
> shorter is good for readability.

Not if the output introduces notations the user is not used to see, and 
even worse if different from what the user entered in the first place.

>> The following syntaxes I see as acceptable
>> 
>> 
>> quad dotted IP, hex or dec
>
> Hex in iptables -L output would cause more confusion and anger than my 
> proposals, I believe.
>
> Hex on input ok except noone uses it.
>
>
>> N dotted IP (less than quad), hex or dec notation
>> 
>> CIDR notation
>>   N octets (up to four) / masksize. Only decimal.
>> 
>>   10/8 == 10.0.0.0/8
>
> In other mail you say 1/0.255.255.255 = 0.0.0.1/0.255.255.255, inconsistent?

Not at all. Your examples is not in CIDR notation as you specify a 
netmask, not a mask size.

> Again question is: When address is only one number, is it interpreted as 
> first or last octet, if any? (ie. append dot, prepend dot, or bark?)

Depends on the whole expression

   10   is a HOST address  (0.0.0.10/255.255.255.255)

   10/0.255.255.255 is a HOST address pattern (0.0.0.10/0.255.255.255)

   10/8 is a network address in CIDR notation. (10.0.0.0/255.0.0.0)

> Or do you really mean that:
> cidr mask => interpret as first octet
> dotted mask => interpret as last octet

Yes.

>> Mask notation
>> 
>>   quad or N dotted IP / netmask in quad or N dotted IP form. hex or dec.
>> 
>> To differentiate between CIDR and Mask notation when the mask is specified 
>> using a single number use the <=32 magics.
>
> From all this I do not see how you interpret N dotted IP or mask, or how it 
> provides the flexibility I am aiming for.

X/0 to X/32 is CIDR with mask size.

X/anythingelse is a ip + netmask.

> BTW iptables currently parses 10.20 as 10.0.0.20, but 10.20/24 becomes 
> 10.0.0.0/24, so apparently the common understanding is not so common.

Depends on the context of the tool. iptables parses IP addresses, not 
networks.

> If that is a concern (and I agree it is) then we should *start* by ruling out 
> all the short forms and big decimal forms outlined in other mails! I could 
> just as well have forgotten a few dots in 1001122, who knows?

Entirely fine by me, but there may be people relying on the current 
syntax and used to using it.

Regards
Henrik
