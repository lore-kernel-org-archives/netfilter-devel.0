From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2 iptables] extensions: libxt_connlabel: Add translation
 to nft
Date: Sat, 16 Jul 2016 19:59:49 +0200
Message-ID: <20160716175949.GB16259@breakpoint.cc>
References: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
 <20160716145130.GA2307@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
	fw@strlen.de, Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49382 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbcGPSAI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jul 2016 14:00:08 -0400
Content-Disposition: inline
In-Reply-To: <20160716145130.GA2307@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Jul 16, 2016 at 06:42:24PM +0800, Liping Zhang wrote:
> >   # iptables-translate -A INPUT -m connlabel ! --label bit40 --set
> >   nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter
> 
> I think this logic is inverted, I mean:
> 
> nft add rule ip filter INPUT ct label and bit40 != bit40 ct label set bit40 counter
>                              ---------------------------
> 
> test should happen before set.

xt_connlabel does:

if (info->options & XT_CONNLABEL_OP_SET)
	return (nf_connlabel_set(ct, info->bit) == 0) ^ invert;

So if info->bit is/got set (either it was already set or ct has connlabel
area where we could toggle the desired bit) then the match returns false
if invert was requested.

And to do that the "ct label set" operation needs to happen first.
To achive the same as the xt match in one op we'd need to alter the
"set" operation to also fill a dreg to perform a test; I don't think
its good idea.
