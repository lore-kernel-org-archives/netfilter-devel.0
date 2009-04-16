From: Thomas Jacob <jacob@internet24.de>
Subject: Re: ipt_ACCOUNT 1.15 released
Date: Thu, 16 Apr 2009 20:29:46 +0200
Message-ID: <1239906586.26220.58.camel@enterprise.ims-firmen.de>
References: <200904141744.57570.thomas.jarosch@intra2net.com>
	 <200904151011.42360.thomas.jarosch@intra2net.com>
	 <1239788429.11865.20.camel@enterprise.ims-firmen.de>
	 <200904161834.17450.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:33158 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705AbZDPS3t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:29:49 -0400
In-Reply-To: <200904161834.17450.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2009-04-16 at 18:34 +0200, Thomas Jarosch wrote:
> Hello Thomas,

> Interesting findings. The "IPT_BASE_CTL" socket operation usually starts
> at 64 and then various operations get added to it by incrementing the value.
> 
> ipset's socket operations use absolute values like 0x201,
> I'm wondering if they were registered somewhere or just "allocated".

include/linux/netfilter_ipv4/ip_set.h

/*
 * A sockopt of such quality has hardly ever been seen before on the
open
 * market!  This little beauty, hardly ever used: above 64, so it's
 * traditionally used for firewalling, not touched (even once!) by the
 * 2.0, 2.2 and 2.4 kernels!
 *
 * Comes with its own certificate of authenticity, valid anywhere in the
 * Free world!
 *
 * Rusty, 19.4.2000
 */
#define SO_IP_SET       83

But maybe someone on the list who remembers how this number got
to be can comment on the issue ;)

> The 32bit counters were a design decision to store a complete class C subnet 
> into one kernel page. We query the data on our own system every second to 
> check the online timeout of dial up lines, so that doesn't affect us.
>
> Transforming the internal data structure into a hash table would be the way to 
> go for IPv6 support and 64 bit counters. I guess it wouldn't be slower than 
> the current approach or could even be faster for large networks,
> so that would need a performance benchmark.

That's what I thought as well, hash tables are the way to
go. 

I am stilling thinking about implementing this, if I find the time.
Also, in order to make IPv6 accounting practical, I would probably add
some sort of subnet accounting along the following lines.

-j ACCOUNT --network 1234:4567::/32 --account_mask /64

which would only account packets in --network, and count data
for a whole subnet instead of a single IP, as assigning single
IPv6 addresses to customers is kind of silly in an ISP environment.

To collect data for single IPs just use --account_mask 128.

Another idea, possibly useful from an ISP perspective, might be
to only start the counters (i.e. add the entry to the hash bucket) if
packets with the IP/subnet have arrived from a certain direction first.

This way, your tables don't overflow with all the IP scans
from the Internet.

> On the other side I would look at conntrack accounting first, it wasn't ready 
> for production use when I wrote ipt_ACCOUNT back then, which it is now.

>From where I'm standing this looks much resource extensive than the
approaches taken by ipt_ACCOUNT or ipt_account. All I am interested in
is a byte counter per target IP/subnet that can be queried once a day
so that I know who is consuming my bandwidth. Something that passes
each connection track to user space doesn't look so good for that.

But maybe I am wrong about this, I  haven't actually tried to use it.


