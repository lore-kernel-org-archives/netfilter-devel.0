From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7] xt_mark match rev 1
Date: Mon, 17 Dec 2007 14:08:02 +0100
Message-ID: <476674B2.8050808@netfilter.org>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070341010.1262@fbirervta.pbzchgretzou.qr> <475E65AC.9080901@trash.net> <Pine.LNX.4.64.0712151322150.22877@fbirervta.pbzchgretzou.qr> <4763F8FE.5040607@netfilter.org> <Pine.LNX.4.64.0712151708380.22877@fbirervta.pbzchgretzou.qr> <47640412.5050207@netfilter.org> <47666FF4.6040102@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47468 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753072AbXLQNno (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:43:44 -0500
In-Reply-To: <47666FF4.6040102@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>> What will netlink bring us, with respect to the two states:
>>> - old iptables, new kernel
>>> - new iptables, old kernel
>>> so matching some UUIDs (and .revision is one, more or less) seems
>>> like the way
>>> to go.
>>
>> Netlink doesn't stick us to fixed structure layouts as it happens to the
>> current interface since we represent the messages kernel <-> userspace
>> in TLV (type-length-value) format. Thus, userspace and kernel won't
>> share structures and new features just require a new type. For that
>> reason, the netlink interface won't require such revision infrastructure.
>>
>> Not that I'm against your patches, I'm just stating the right direction
>> to go for those 5-10 years that you have mentioned. And of course, we
>> don't have a single line of such interface at the moment :)
> 
> 
> Actually we do, I've been working on it, but had to interrupt
> for some other stuff. I hope to get back to it over christmas
> and beginning of next year. The goal is to add a compat layer
> for old iptables userspace, but I don't really care about how
> ugly it gets since we hopefully never have to look at it again
> until its removal :)

Cool, consider putting it somewhere, I'm willing to contribute to it ;).
BTW, if nobody complains I'll release iptables 1.4.0 final between today
and tomorrow.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
