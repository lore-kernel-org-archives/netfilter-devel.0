From: Jan Engelhardt <jengelh@inai.de>
Subject: Re[2]:  [RFC] netfilter: xt_TEE: IPv4 Don't Fragmet options
Date: Fri, 15 Jun 2012 12:00:40 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1206151157510.29044@frira.zrqbmnf.qr>
References: <8oegugq.fb5f47534daac35954f4ab92cf50648f@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	fw@strlen.de
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42638 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615Ab2FOKAn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:00:43 -0400
In-Reply-To: <8oegugq.fb5f47534daac35954f4ab92cf50648f@obelix.schillstrom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2012-06-15 08:37, Hans Schillstrom wrote:
>>
>>Applications often don't have the means to set DF, think SOCK_STREAM.
>
>Yeah I do, and TCP usually set the DF bit and if you inherit that it should
>not be a problem. BTW, I don't see any real use case for TCP except for a
>"remote" tcpdump

Remote dumping is the point of TEE. At least that is what people
have blogged about so far :)

>Inherit - don't force, it's a better idea
>if you don't set it you don't expect an ICMP either.

So what does syslogd do in the IPv6-UDP case?


>>As Pablo mentioned, you cannot touch this structure.
>
>I know this was just a RFC,  I  should have made a note about that :-)

Then I'll await your new patch.
