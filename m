From: "Temp02" <temp02@bluereef.com.au>
Subject: Re: Multiple Address specification or match
Date: Thu, 30 Sep 2004 18:59:43 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <002901c4a6cb$d3ae6490$2201010a@bluereef.local>
References: <018201c4a6ab$a1ecb6c0$2201010a@bluereef.local><415BAAF0.6030907@rediffmail.com><019d01c4a6b9$55278370$2201010a@bluereef.local>
	<Pine.LNX.4.61.0409301033400.28021@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Swapnil Nagle <swapsn@rediffmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

thanks for your feedback but neither of these solutions are particularly
elegant.

The first (using more than one rule), requires the use of a lot more rules
than are really necessary, as an example, lets say that I wanted to prevent
access a range of subnets but allow everything else. Ideally I should be
able to:

iptables -A PREROUTING -d ! 10.0.0.0/8 -d ! 192.168.1.0/24 -d !
172.16.0.0/16 -m whatever -j ACCEPT

instead I would need three explicit drop rules and then an allow everything
else rule. (assuming a default drop policy).

The problem with the IPset/pool options are that they match only on a range
of addresses, not specifically by source or destination, also they seem to
require the use of another userspace program to actually build the sets
which in itself complicates the process.

Is it hard to extend the source and destination match functions to accept
multiple arguments?

----- Original Message -----
From: "Henrik Nordstrom" <hno@marasystems.com>
To: "Temp02" <temp02@bluereef.com.au>
Cc: <netfilter-devel@lists.netfilter.org>; "Swapnil Nagle"
<swapsn@rediffmail.com>
Sent: Thursday, September 30, 2004 6:34 PM
Subject: Re: Multiple Address specification or match


> On Thu, 30 Sep 2004, Temp02 wrote:
>
> > No obviously a single source can't be both addresses, but the intent is
to
> > allow a single rule to be used to match sources from both source ranges.
>
> There is two ways for doing this
>
> a) Using two rules, one per IP address.
>
> b) Using an ippool/ipset storing the IP addresses.
>
> Regards
> Henrik
>
