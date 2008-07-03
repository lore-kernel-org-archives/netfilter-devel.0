From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH,RFC] Route match
Date: Thu, 3 Jul 2008 18:14:11 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807031808550.23294@fbirervta.pbzchgretzou.qr>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu> <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031749501.4958@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55648 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYGCQOM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:14:12 -0400
In-Reply-To: <Pine.LNX.4.64.0807031749501.4958@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-07-03 17:51, Krzysztof Oledzki wrote:
>> >
>> > Quick and not good examples, I'd say. The main problem with rp_filter is
>> > that it drops the packets >silently<. The real benefit of such a match is
>> > the possibility to log (and drop) faked packets. If the patch had IPv6
>> > support, one could add that additionally (as far as I know) there's no
>> > rp_filter for IPv6 at all.
>>
>> You know what's been bugging me... why don't we replace the entire
>> routing infrastructure by an xtables "route" table, with something like
>
> Because routing in a firewall is slow and too complicated?
                                                     [Citation needed]

I fail to see why Xtables (not just a firewall) should be slower
than the routing table (without routing cache, to make it fair).

Iterating over an IPv4 table compares, at a minimum,
interface name(s), src/dst address and an L4 protocol, plus extra
flags like inversion.

Routing? Well, let's see, it can match src address, src interface,
out interface, dst address, and so on. Sounds pretty much like
the same.
