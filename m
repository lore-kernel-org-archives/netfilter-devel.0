From: "Temp02" <temp02@bluereef.com.au>
Subject: Re: Multiple Address specification or match
Date: Fri, 1 Oct 2004 18:41:13 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <015601c4a792$6890f250$2201010a@bluereef.local>
References: <003301c4a6cc$069e3fb0$2201010a@bluereef.local>
	<Pine.LNX.4.61.0409301336380.29461@filer.marasystems.com>
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

The ippool and ipset matches only support linux 2.4 not 2.6 unfortunately.
The iprange match would suit my needs but it only allows a single match as
well. What would I need to change in iptables to allow the match to be
called more than once, as in:

iptables -m iprange 10.0.0.0-10.255.255.255 -m iprange
172.16.0.0-172.16.255.255

is this an easy to add switch somewhere?

thanks,

----- Original Message -----
From: "Henrik Nordstrom" <hno@marasystems.com>
To: "Temp02" <temp02@bluereef.com.au>
Cc: <netfilter-devel@lists.netfilter.org>; "Swapnil Nagle"
<swapsn@rediffmail.com>
Sent: Thursday, September 30, 2004 9:38 PM
Subject: Re: Multiple Address specification or match


> On Thu, 30 Sep 2004, Temp02 wrote:
>
> > The problem with the IPset/pool options are that they match only on a
range
> > of addresses, not specifically by source or destination
>
> Eh? They match specificaly on either source or destination.
>
> > also they seem to require the use of another userspace program to
> > actually build the sets which in itself complicates the process.
>
> True.
>
> > Is it hard to extend the source and destination match functions to
accept
> > multiple arguments?
>
> Yes and no.
>
> It is not hard to make a custom match matching multiple IP addresses, but
> it would be restricted in the number of addresses you can match.
>
> If you need to group very many addresses then ippool/ipset is the correct
> tool.
>
> Regards
> Henrik
>
