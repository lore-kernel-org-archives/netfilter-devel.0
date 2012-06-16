From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] netfilter: xt_TEE: IPv4 Don't Fragmet options
Date: Sat, 16 Jun 2012 15:18:38 +0200
Message-ID: <20120616131838.GB22939@breakpoint.cc>
References: <8oegugq.b2a4d43e41f924be4614ef9ef41297fa@obelix.schillstrom.com>
 <alpine.LNX.2.01.1206151500260.12865@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hans Schillstrom <hans@schillstrom.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44528 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884Ab2FPNSn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:18:43 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1206151500260.12865@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Friday 2012-06-15 14:51, Hans Schillstrom wrote:
> >
> Here's another point I remember why we forced IP_DF: we want to keep
> the packet as-is. The receiver of the cloned packet (often a logger)
> has no way of autonomously knowing whether the packet was already
> fragmented originally as it came into the cloner, or whether
> fragmentation is a doing of the cloner.

Except that, if the path mtu was too low, it doesn't even
receive that packet.  If the sender does PMTUD, that might be ok
since future packets will be reduced in size.

But if the sender doesn't do PMTUD (and 'DF not set' indicates that)
your 'clone receiver' will never get any data at all...

TEE really shouldn't force DF.
