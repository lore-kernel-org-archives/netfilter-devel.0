From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ipt_ACCOUNT 1.15 released
Date: Thu, 16 Apr 2009 18:34:17 +0200
Message-ID: <200904161834.17450.thomas.jarosch@intra2net.com>
References: <200904141744.57570.thomas.jarosch@intra2net.com> <200904151011.42360.thomas.jarosch@intra2net.com> <1239788429.11865.20.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:56114 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbZDPQeW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:34:22 -0400
In-Reply-To: <1239788429.11865.20.camel@enterprise.ims-firmen.de>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Thomas,

On Wednesday, 15. April 2009 11:40:29 you wrote:
> > As you already mentioned, I'm not sure it would be a good idea
> > to include it as the kernel patch extends the kernel<->user space socket
> > operations in include/linux/netfilter_ipv4/ip_tables.h.
>
> I noticed this too, and the question for me is, do you really need
> do things this way? Because that's really the only thing that requires
> a kernel patch in your module. Ipset for instance doesn't anymore, but
> I guess they've been "assigned" a permanent socket option number.... if
> that could happen for your module: problem solved.

Interesting findings. The "IPT_BASE_CTL" socket operation usually starts
at 64 and then various operations get added to it by incrementing the value.

ipset's socket operations use absolute values like 0x201,
I'm wondering if they were registered somewhere or just "allocated".

> > I'm still surprised how many people are using ipt_ACCOUNT,
> > somehow it is magnetic to ISPs in central and eastern europe :-)
>
> One reason springs to mind, apart from the obvious "they were there
> first" reason: 64 bit counters... your module only uses 32 bit counters
> which is not really great if you all you want to do account traffic at
> an ISP, because if you've got a fully loaded 100 Mbps-Port your counters
> will overflow every 5 minutes, so one needs to write software
> that can extract and adding up the accounting data by querying your
> module very often (I just did that for a future project ;).
>
> Also the other ipt_account allows saving and restoring the accounting
> state, thereby allowing you to deal with crashes and reboots.
>
> But as you say, ipt_account is not really supported anymore, so....
>
> BTW, if you plan to add 64bit counters and maybe also IPv6 capability
> I'd be very much willing to help ;)

The 32bit counters were a design decision to store a complete class C subnet 
into one kernel page. We query the data on our own system every second to 
check the online timeout of dial up lines, so that doesn't affect us.

Transforming the internal data structure into a hash table would be the way to 
go for IPv6 support and 64 bit counters. I guess it wouldn't be slower than 
the current approach or could even be faster for large networks,
so that would need a performance benchmark.

On the other side I would look at conntrack accounting first, it wasn't ready 
for production use when I wrote ipt_ACCOUNT back then, which it is now.

Cheers,
Thomas

