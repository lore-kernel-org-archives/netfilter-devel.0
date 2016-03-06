From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] extensions: libxt_connlabel: Add translation to nft
Date: Sun, 6 Mar 2016 01:07:03 +0100
Message-ID: <20160306000703.GA31513@breakpoint.cc>
References: <20160305214746.GA16464@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60731 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbcCFAHG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2016 19:07:06 -0500
Content-Disposition: inline
In-Reply-To: <20160305214746.GA16464@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> Add translation for connlabel to nftables.
> Full translation for this match awaits the support for --set option.

Hmm, I sent patches for that a while ago, don't know why they were
not applied... Pablo?

> Examples:
> 
> $ sudo iptables-translate -A INPUT -m connlabel --label eth0-in
> nft add rule ip filter INPUT ct label eth0-in counter

Looks good, thanks!

> $ sudo iptables-translate -A INPUT -m connlabel ! --label eth0-out
> nft add rule ip filter INPUT ct label != eth0-out counter

This one however is not correct.
It will match when eth0-out is not set, yes, but it will also match
if eth0-out and something else is also set.

(!= generates

[ cmp neq reg 1 0x00000004 0x00000000 0x00000000 0x00000000 ]

This should do the same thing as the -m connlabel ! --label ... command:

nft add rule ip filter INPUT ct label & eth0-in != eth0-in counter

[ ct load label => reg 1 ]
[ bitwise reg 1 = (reg=1 & 0x00000004 0x00000000 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
[ cmp neq reg 1 0x00000004 0x00000000 0x00000000 0x00000000 ]

... so we load labels, then mask out everything except eth0-in, then
we check that this bit was not set.
