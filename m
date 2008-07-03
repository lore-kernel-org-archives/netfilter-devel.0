From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH,RFC] Route match
Date: Thu, 3 Jul 2008 16:15:06 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807031612330.23294@fbirervta.pbzchgretzou.qr>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu> <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031425530.1816@blackhole.kfki.hu>
 <alpine.LNX.1.10.0807031511310.23294@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031517350.1816@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42093 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYGCOPI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:15:08 -0400
In-Reply-To: <Pine.LNX.4.64.0807031517350.1816@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-07-03 15:31, Jozsef Kadlecsik wrote:
>On Thu, 3 Jul 2008, Jan Engelhardt wrote:
>> On Thursday 2008-07-03 14:39, Jozsef Kadlecsik wrote:
>> >
>> >One can find a lot of smaller and bigger missing pieces, like a new table, 
>> >new hook, if we'd associate a 'routing table' to a 'chain in the iptables 
>> >route table', then we'd need a default policy support (i.e. default route) 
>> >for the user defined chains too, etc.
>> 
>> User-defined chains always have an implicit policy of 'RETURN',
>> and I would not turn a knob on that property anytime.
>
>Routing cannot be replaced by netfilter 'route' table without supporting a 
>'default policy' (as default route) in the user defined chains (as routing 
>tables).

User-defines chains return to the main chain once control runs off their end.
Since the main chain has a default policy, I do not see aproblem.

>> The default policy for the main chain is of course 'UNREACHABLE'.
>
>Hm, I don't understand you: if we want to replace routing with a 'route'
>table, then the default policy (i.e. the default route) cannot be 
>'UNREACHABLE'.

It can (well, we'd have to make UNREACHABLE an acceptable
default policy). This is what routing does today. For example:


$ ip r g 2001::1
unreachable 2001::1 from :: dev lo  table unspec  proto none  src ::1  metric
-1  error -101 hoplimit 255


>Unless you intend to define the 'default route' as the last rule in any 
>chain...

No, default route would be

	iptables -t route -A ROUTING <no further conditions> -j ROUTE --via
my-default-gw-ip


Because traditional routing tables can have no default route,
xtables should not be forced to have one either.
