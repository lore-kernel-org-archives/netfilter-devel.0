From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 19:05:15 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409291855130.15266@filer.marasystems.com>
References: <415A12AE.1060901@parknet.dk> <415A3263.7080708@xgendev.com>
	<415A4B4E.1080801@parknet.dk>
	<Pine.LNX.4.61.0409291051190.11661@filer.marasystems.com>
	<415AE4F4.2000903@parknet.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Ben Efros <ben@xgendev.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <415AE4F4.2000903@parknet.dk>
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

> 1) iptables input: iptables' support for full 32bit format addresses is both 
> lacking and undocumented and could disappear without notice. So if any 
> programs use it they should rather be fixed.

I repead once again, introducing a new notation looking the same as an 
older well established (even if depreated) notation but with a different 
meaning is a terribly bad idea.

> iptables -L is for human eyes while iptables-save is for machine parsing. So 
> what if we make iptables -L print in any format it likes (not intended for 
> machine parsing anyway), but have iptables-save always print addresses in 
> full dotted quad?

Having iptables -L output anything else than quad dotted format is an even 
worse idea. Why outputting any other notation than the official standard?

> The question is how to interpret a single number. Implicitly append or 
> prepend a dot? Or interpret as full 32bit notation? Or ignore it?

Depends on if it is a CIDR number or not.

The following syntaxes I see as acceptable


quad dotted IP, hex or dec

N dotted IP (less than quad), hex or dec notation

CIDR notation
   N octets (up to four) / masksize. Only decimal.

   10/8 == 10.0.0.0/8

Mask notation

   quad or N dotted IP / netmask in quad or N dotted IP form. hex or dec.

To differentiate between CIDR and Mask notation when the mask is specified 
using a single number use the <=32 magics.


I do not find 10. as suitable shorthand for 10.0.0.0/8 even if this form 
is currently not in use in any of the established notations. The problem 
with 10. is that this could just as well be a partially typed IP address 
where the administrator meant to enter more information but forgot. These 
things happens more often than one would think.

Regards
Henrik
