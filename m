From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Mon, 21 Jan 2008 02:19:11 +0100
Message-ID: <4793F30F.1050308@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr> <477E487D.8000901@trash.net> <478C573D.2060401@trash.net> <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr> <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr> <478F5D92.3040404@netfilter.org> <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr> <479345F0.8000009@trash.net> <4793F1F0.2080403@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38473 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbYAUBTU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 20:19:20 -0500
In-Reply-To: <4793F1F0.2080403@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> On Jan 17 2008 14:52, Pablo Neira Ayuso wrote:
>>>> Jan Engelhardt wrote:
>>>>> +    switch (tuple->dst.protonum) {
>>>>> +    case IPPROTO_TCP:
>>>>> +    case IPPROTO_UDP:
>>>>> +    case IPPROTO_SCTP:
>>>> Minor nitpick. Add IPPROTO_UDPLITE.
>>> Yeah that can be easily added.
> 
> BTW, it would be great if we add support for layer 4 protocol state
> matching, e.g. match TCP established. We can use this together with the
> target that would mark certain events as volatile, e.g.
> 
> iptables -A 192.168.0.0/24 -m conntrack ! --tcp-state ESTABLISHED -j
> VOLATILE
> 
> The idea behind this it that ctnetlink would ignore certain events,
> thus, reducing CPU load.


I guess the main question is how to do this properly without running
into compatiblity problems at the next opportunity with our crappy
userspace interface. Can we trust that a u8 is enough for all relevant
states for the forseeable future? For the purpose of avoiding
uninteresting state messages it seems like good enough ...

