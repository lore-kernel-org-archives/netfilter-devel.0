From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC] netfilter: xt_TEE: IPv4 Don't Fragmet options
Date: Sat, 16 Jun 2012 15:57:29 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1206161557180.19053@frira.zrqbmnf.qr>
References: <8oegugq.b2a4d43e41f924be4614ef9ef41297fa@obelix.schillstrom.com> <alpine.LNX.2.01.1206151500260.12865@frira.zrqbmnf.qr> <20120616131838.GB22939@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Hans Schillstrom <hans@schillstrom.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51133 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab2FPN5b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:57:31 -0400
In-Reply-To: <20120616131838.GB22939@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2012-06-16 15:18, Florian Westphal wrote:

>Jan Engelhardt <jengelh@inai.de> wrote:
>> On Friday 2012-06-15 14:51, Hans Schillstrom wrote:
>> >
>> Here's another point I remember why we forced IP_DF: we want to keep
>> the packet as-is. The receiver of the cloned packet (often a logger)
>> has no way of autonomously knowing whether the packet was already
>> fragmented originally as it came into the cloner, or whether
>> fragmentation is a doing of the cloner.
>
>Except that, if the path mtu was too low, it doesn't even
>receive that packet.  If the sender does PMTUD, that might be ok
>since future packets will be reduced in size.
>
>But if the sender doesn't do PMTUD (and 'DF not set' indicates that)
>your 'clone receiver' will never get any data at all...

Good thing IPv4 is being phased out ;-)
