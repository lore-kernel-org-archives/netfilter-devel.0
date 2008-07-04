From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH,RFC] Route match
Date: Fri, 4 Jul 2008 02:37:29 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807040228180.1890@fbirervta.pbzchgretzou.qr>
References: <20080703003942.GA2012@linuxace.com>  <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr>  <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu>  <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031425530.1816@blackhole.kfki.hu>  <alpine.LNX.1.10.0807031511310.23294@fbirervta.pbzchgretzou.qr>  <Pine.LNX.4.64.0807031517350.1816@blackhole.kfki.hu>  <alpine.LNX.1.10.0807031612330.23294@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807032348310.3107@blackhole.kfki.hu>  <alpine.LNX.1.10.0807040054120.1890@fbirervta.pbzchgretzou.qr> <38bcb3ec0807031719n6cdc3233m605271c638b5716f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34492 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbYGDAhb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 20:37:31 -0400
In-Reply-To: <38bcb3ec0807031719n6cdc3233m605271c638b5716f@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-07-04 02:19, James King wrote:
>>
>> -N table5
>> -N table6
>> -A table5 -d 10.10.96.2 -j ROUTE --dev eth2
>> -A table5 -j ROUTE --via 10.10.96.1 --dev eth0  # default route!
>> -A table6 -j ROUTE --via 10.11.96.1 --dev eth1  # also a default
>> -A ROUTING -m mark --mark 5 -j table5
>> -A ROUTING -m mark --mark 6 -j table6
>
>Wouldn't this break with normal routing concepts, since xtables
>traverses the chain linearly, while routing lookups use longest prefix
>match (most specific route wins)?

Very well observed. However,

- the kernel is likely to do a linear rule list search (in `ip ru l`)
  too, because I would not imagine how you could optimize _that_
  more than Xtables when it has to compare src/dst addresses, fwmarks,
  etc.

- you are right, the *routing* table is sorted by longest prefix,
  and that is probably why people tout it as "optimized for the case".
  But I would not see anything wrong with the user doing the sorting
  (or even Xtables).

 (Maybe I just want a new command-line interface for routing instead
  of a new in-core architecture...)


> IOW, unless xtables automatically
>inserted the rule into the correct spot in the chain (as opposed to
>just appending to the end of the chain like -A implies), you could run
>into situations where specifying the rules out of order would send the
>packet to the wrong next-hop.

Or you could actually optimize it. If, say 95% of all your packets
go out on eth0, the following route table (which is dependent
upon cabling), with its ordering, is suboptimal:

	192.168.1.1/32 dev isp0
	192.168.1.0/24 dev eth0

Relaxing the longest-prefix ordering would mean less traversal
time through the chains (i.e. minimizing the time taken
for routing table traversal for randomly distributed packets,
but weighted according to network situation, over a given
time period.)
