From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: fix arptable_filter wrong hook registering
Date: Fri, 17 Oct 2008 10:20:50 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810170948050.30268@fbirervta.pbzchgretzou.qr>
References: <20081016012451.6126.34071.stgit@Decadence> <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr> <48F69EF2.5000104@netfilter.org> <alpine.LNX.1.10.0810152201290.28060@fbirervta.pbzchgretzou.qr> <48F72B07.1040706@trash.net>
 <48F72BE8.80602@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45375 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbYJQOUw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:20:52 -0400
In-Reply-To: <48F72BE8.80602@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-10-16 07:56, Pablo Neira Ayuso wrote:
>>>
>>> struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS] __read_mostly;
>>> (The fact that there's still PF_ in the source is merely historical,
>>> and as you see, PF_foo == NFPROTO_foo for that exact reason.)
>> 
>> I agree with Jan on this one, there doesn't seem to be a reason for
>> not using the NFPROTO constants consistently.
>
>OK, then I think that it would make sense a minor cleanup for all the
>NF_HOOK to use NFPROTO_*? We can do this later.

Better now than later! Patch is coming as replies. The one I
submitted earlier (
http://marc.info/?l=netfilter-devel&m=122412130603479&w=2 ) should
remain separate IMO for it fixes a real bug that exists for a few
revisions in the git tree, while the rest is just constant name
conversion.

>BTW, why are we using NFPROTO_ARP to 3? Just a convention I guess.

The only requirement was that it not be 0 (because that maps to
NFPROTO_UNSPEC which needs compat'ed to PF_UNSPEC - which is also 0).
3 was just a random choice, I picked it for its proximity to IPV4.

