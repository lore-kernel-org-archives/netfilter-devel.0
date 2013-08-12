From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables RFC v3 PATCH 11/16] nft: Refactor firewall
 printing so it reuses already parsed cs struct
Date: Mon, 12 Aug 2013 13:54:04 +0300
Message-ID: <5208BECC.1090604@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1376055090-26551-12-git-send-email-tomasz.bursztyka@linux.intel.com> <20130809215145.GB7102@localhost> <520894B3.50209@linux.intel.com> <20130812093047.GA4516@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:48994 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab3HLKyX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:54:23 -0400
In-Reply-To: <20130812093047.GA4516@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> Could you recheck in detail patches 3/16 and 4/16?
>> If there is no flaws in the translation engine, we might just go for
>> it at it is.
> I'm not convinced that this approach is the way to go. In the payload
> case, the number of instruction tuples will explode, and you will have
> to iterate many times to find the corresponding parser.

There are many ways to reduce drastically such lookup process, current 
implementation is just here to prove it works.
I have actually some code for that, by extending the instruction 
declaration with extra infos, it kills looping. Not finished though.
(have also a solution for not pre-loading all extensions, btw)

Actually NAT is probably the worst example. I should have implemented 2 
or 3 totally different other extensions.
Because nat exists as its own expression in nftables, so indeed it's 
really easy to pick it up in an expression list.
if (expr == "nat") parse_nat();

But it's not going to be that simple with complex set of different 
expressions representing one extension.
Of course it's can still work with programmatic way but it's going to be 
really annoying in maintenance, entangled code, bug prone etc...
Since every time you will support a new extension, code will need to change.
With my approach: no code change needed anymore, just declaring the 
right instruction which is very trivial.

> Anyway, I really think we have to start by converting nft to ipt
> command state in one single patch, as your patches 11-13 do, we need
> it for whatever approach we decide to follow. If you don't have time
> to make that rebase, I'll try to find some spare time to work on it.
> Let me know.

I can find time.

Tomasz
