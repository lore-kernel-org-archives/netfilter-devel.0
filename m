From: Simon Lodal <simonl@parknet.dk>
Subject: Re: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 20:45:33 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415B02CD.2080403@parknet.dk>
References: <415A12AE.1060901@parknet.dk> <415A3263.7080708@xgendev.com>
	<415A4B4E.1080801@parknet.dk>
	<Pine.LNX.4.61.0409291051190.11661@filer.marasystems.com>
	<415AE4F4.2000903@parknet.dk>
	<Pine.LNX.4.61.0409291855130.15266@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ben Efros <ben@xgendev.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0409291855130.15266@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom skrev:
> I repead once again, introducing a new notation looking the same as an 
> older well established (even if depreated) notation but with a different 
> meaning is a terribly bad idea.

Agree, and I am trying to avoid it! By only adding previously unused syntax.

But I still feel that programs relying on undocumented, partly working 
features should know they are in trouble.


>> iptables -L is for human eyes while iptables-save is for machine 
>> parsing. So what if we make iptables -L print in any format it likes 
>> (not intended for machine parsing anyway), but have iptables-save 
>> always print addresses in full dotted quad?
> 
> Having iptables -L output anything else than quad dotted format is an 
> even worse idea. Why outputting any other notation than the official 
> standard?

Because iptables -nvL lines are already horribly long. Anything making 
them shorter is good for readability.

There is no point in trying to parse iptables -L output since all the 
modules already output random stuff in the right column. So we should 
rather try to make it more readable for humans.


>> The question is how to interpret a single number. Implicitly append or 
>> prepend a dot? Or interpret as full 32bit notation? Or ignore it?
> 
> Depends on if it is a CIDR number or not.

Requires backwards parsing? Not good.


> The following syntaxes I see as acceptable
> 
> 
> quad dotted IP, hex or dec

Hex in iptables -L output would cause more confusion and anger than my 
proposals, I believe.

Hex on input ok except noone uses it.


> N dotted IP (less than quad), hex or dec notation
> 
> CIDR notation
>   N octets (up to four) / masksize. Only decimal.
> 
>   10/8 == 10.0.0.0/8

In other mail you say 1/0.255.255.255 = 0.0.0.1/0.255.255.255, inconsistent?

Again question is: When address is only one number, is it interpreted as 
first or last octet, if any? (ie. append dot, prepend dot, or bark?)

Or do you really mean that:
cidr mask => interpret as first octet
dotted mask => interpret as last octet


> Mask notation
> 
>   quad or N dotted IP / netmask in quad or N dotted IP form. hex or dec.
> 
> To differentiate between CIDR and Mask notation when the mask is 
> specified using a single number use the <=32 magics.

 From all this I do not see how you interpret N dotted IP or mask, or 
how it provides the flexibility I am aiming for.

As I understand it you rule out numbers >255, I agree to that.

BTW iptables currently parses 10.20 as 10.0.0.20, but 10.20/24 becomes 
10.0.0.0/24, so apparently the common understanding is not so common.


> I do not find 10. as suitable shorthand for 10.0.0.0/8 even if this form 
> is currently not in use in any of the established notations. The problem 
> with 10. is that this could just as well be a partially typed IP address 
> where the administrator meant to enter more information but forgot. 
> These things happens more often than one would think.

If that is a concern (and I agree it is) then we should *start* by 
ruling out all the short forms and big decimal forms outlined in other 
mails! I could just as well have forgotten a few dots in 1001122, who knows?

I believe my proposal will make partial addresses (and masks) easier to 
understand since the dot(s) explicitly show where the missing octets 
are. Contrary to N dotted form without extra dots.

May not have been clear but the idea is of course that dotted masks can 
be partial as well, fx. "10./255.", "0.0.1.0/.255.0" etc.


Simon
