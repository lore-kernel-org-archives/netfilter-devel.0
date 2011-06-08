From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] ecn match ported to ipv6
Date: Wed, 08 Jun 2011 19:32:03 +0200
Message-ID: <4DEFB213.5030802@trash.net>
References: <1307545312.3057.49.camel@edumazet-laptop> <BANLkTi=ORBH0q_arGbFUdjk=WMjbBz1KZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Dave Taht <dave.taht@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50455 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1FHRcN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:32:13 -0400
In-Reply-To: <BANLkTi=ORBH0q_arGbFUdjk=WMjbBz1KZg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.06.2011 17:47, Dave Taht wrote:
> On Wed, Jun 8, 2011 at 9:01 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
>> Dave Taht mentioned in bloat list that netfilter ecn match was ipv4
>> only.
>>
>> Is there any plan to make the switch from net/ipv4/netfilter/ipt_ecn.c
>> to net/netfilter/xt_ecn.c ?
>>
>> I can probably do it but not before ~ten days, so if someone is
>> interested, this will please Dave ;)

That should be a relatively quick job, I'll give it a shot while
my dinner is cooking :)

> The larger question I had was this
> 
> "iptables seems to think ecn can only be looked at in TCP streams, where (for
> example), ecn bits can be copied to the outer header of a udp vpn
> stream, and marked
> 
> when needed."
> 
> ECN is an ip level standard, not just a tcp one.

That probably needs a new revision and is slightly more work, lets
begin by porting it to IPv6, then we can add this on top.

> http://www.ietf.org/rfc/rfc3168.txt
> 
> Example of ECN on ipsec:
> 
> http://huchra.bufferbloat.net/~d/veryhappynetwork.png
> 
> Also ECN marking in various qdiscs like HTB as presently being discussed on
> the bloat list
> 
> https://lists.bufferbloat.net/pipermail/bloat/2011-June/000555.html

I'd suggest to make this generic so other qdiscs can use it as well.

> and a truly crazy idea regarding combining DSCP with firewalling is here:
> 
> https://lists.bufferbloat.net/pipermail/bloat/2011-June/000558.html
> 
> To give some context as to what we've been up to regarding bufferbloat, I
> have a test lab setup with a bunch of wndr3700v2 routers at georgia tech,
> and have pushed  every ecn and bloat related patch in linux head into the
> openwrt distro, and am playing with all sorts of techniques now, with
> increasingly good results.
> 
> The 'uberwrt' project is in addition to the debloat-testing work
> and has various subprojects...
> 
> http://www.bufferbloat.net/projects/uberwrt/wiki
> 

