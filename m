From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7] xt_mark match rev 1
Date: Sat, 15 Dec 2007 17:42:58 +0100
Message-ID: <47640412.5050207@netfilter.org>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070341010.1262@fbirervta.pbzchgretzou.qr> <475E65AC.9080901@trash.net> <Pine.LNX.4.64.0712151322150.22877@fbirervta.pbzchgretzou.qr> <4763F8FE.5040607@netfilter.org> <Pine.LNX.4.64.0712151708380.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33825 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752641AbXLOQnz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Dec 2007 11:43:55 -0500
In-Reply-To: <Pine.LNX.4.64.0712151708380.22877@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 15 2007 16:55, Pablo Neira Ayuso wrote:
>> The revision thing was a hack that I introduced myself to let us add
>> several improvements that we really needed at that time, actually it is
>> not something we should abuse IMO.
>>
> But it looks like the cleanest way to do things. If you think it is abuse,
> do you have a better way?

Indeed, it is the best way to do things as for now but I don't think
that we should pollute the code with tons of revisions unless that it is
necessary.

>>> Old revisions should be purged after a "reasonable time" (whatever
>>> that means for everyone), or perhaps whenever there is a Linux kernel
>>> version with a trailing .0 (2.7.0, 2.8.0), or when great new things
>>> appear (pkttables, or whatever is in the works).
>>>
>>> I think the step should better be made now than later, or this cruft
>>> will be carried for the next 10 instead of 5 years.
>> I hope that we'll get that long-awaited netlink interface for iptables
>> before those 10 years goes by and we all become museum pieces :)
>>
> What will netlink bring us, with respect to the two states:
> - old iptables, new kernel
> - new iptables, old kernel
> so matching some UUIDs (and .revision is one, more or less) seems like the way
> to go.

Netlink doesn't stick us to fixed structure layouts as it happens to the
current interface since we represent the messages kernel <-> userspace
in TLV (type-length-value) format. Thus, userspace and kernel won't
share structures and new features just require a new type. For that
reason, the netlink interface won't require such revision infrastructure.

Not that I'm against your patches, I'm just stating the right direction
to go for those 5-10 years that you have mentioned. And of course, we
don't have a single line of such interface at the moment :)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
