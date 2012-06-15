From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re[3]: [RFC] netfilter: xt_TEE: IPv4 Don't Fragmet options
Date: Fri, 15 Jun 2012 14:51:41 +0200 (CEST)
Message-ID: <8oegugq.b2a4d43e41f924be4614ef9ef41297fa@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	fw@strlen.de
To: "Jan Engelhardt" <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:51645 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab2FOMvu convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:51:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>On Friday 2012-06-15 08:37, Hans Schillstrom wrote:
>>>
>>>Applications often don't have the means to set DF, think SOCK_STREAM.
>>
>>Yeah I do, and TCP usually set the DF bit and if you inherit that it should
>>not be a problem. BTW, I don't see any real use case for TCP except for a
>>"remote" tcpdump
>
>Remote dumping is the point of TEE. At least that is what people
>have blogged about so far :)
>
>>Inherit - don't force, it's a better idea
>>if you don't set it you don't expect an ICMP either.
>
>So what does syslogd do in the IPv6-UDP case?

As I wrote in my first mail IPv6 is a different story, you don't have any options there
since you are not allowed to "re-frag" the packet

>>>As Pablo mentioned, you cannot touch this structure.
>>
>>I know this was just a RFC,  I  should have made a note about that :-)
>
>Then I'll await your new patch.

To make things clear :
I'll send a patch that keep the current behaviour, so it doesn't break things for people.


