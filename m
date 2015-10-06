From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/2] rule: don't reorder protocol payload expressions
 when merging
Date: Tue, 6 Oct 2015 12:33:28 +0200
Message-ID: <20151006103328.GC12921@breakpoint.cc>
References: <1443237243-4571-1-git-send-email-fw@strlen.de>
 <1443237243-4571-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57599 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbbJFKda (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2015 06:33:30 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@strlen.de>)
	id 1ZjPYm-0006Uf-DT
	for netfilter-devel@vger.kernel.org; Tue, 06 Oct 2015 12:33:28 +0200
Content-Disposition: inline
In-Reply-To: <1443237243-4571-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> An instruction like
> 
>  bridge filter input ip saddr 1.2.3.4 ether saddr a:b:c:d:e:f
> 
> is displayed as
> 
> unknown unknown 0x1020304 [invalid type] ether saddr 00:0f:54:0c:11:04 ether type ip
> 
> .. because the (implicit) 'ether type ip' that is injected before the
> network header match gets merged into the ether saddr instruction.
> 
> This inverts the merge in case the merge candidate contains
> a next header protocol field.
> 
> After this change, the rule will be displayed as
> 
> bridge filter input ether saddr a:b:c:d:e:f ip saddr 1.2.3.4

One side-effect with this approach is that it will reorder the
instructions depending on the family dependencies.

So, f.e.
tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4

will be added/displayed as
tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4

for bridge family, but as

tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04

for ip and inet.

In the bridge case we do need a 'is this ip' dependency test, so we
now merge the ether saddr x into the (implicitly inserted)
'ether protocol ip' expression.

ip family doesn't have such a dependency, since network header is
always ipv4.

For INET the dependency is expressed via 'meta load nfproto', so
no payload merge takes place either.

I pushed a rebased version including tests to
https://git.breakpoint.cc/cgit/fw/nftables.git/log/?h=ether_tests_02
