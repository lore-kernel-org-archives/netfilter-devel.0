From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat PATCH] ebtables-compat: fix ACCEPT printing by
 simplifying logic
Date: Thu, 15 Jan 2015 13:51:06 +0100
Message-ID: <20150115125106.GA8896@salvia>
References: <20150113173610.3965.9202.stgit@nfdev.cica.es>
 <20150115123225.GA8323@salvia>
 <CAOkSjBiG0KPZRfJuw2skqDuL8u6nEi8uyQmmSNbdZd4A7UEv0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51151 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbbAOMsM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:48:12 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBiG0KPZRfJuw2skqDuL8u6nEi8uyQmmSNbdZd4A7UEv0Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 15, 2015 at 01:44:16PM +0100, Arturo Borrero Gonzalez wrote:
> On 15 January 2015 at 13:32, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Jan 13, 2015 at 06:36:10PM +0100, Arturo Borrero Gonzalez wrote:
> >> The commit bc543af ("ebtables-compat: fix segfault in rules w/o target")
> >> doesn't handle all possible cases of target printing, and ACCEPT is left
> >> behind.
> >>
> >> BTW, the logic of target (-j XXX) printing is a bit weird. This patch
> >> simplifies it.
> >>
> >> I assume:
> >>  * cs->jumpto is only filled by nft_immediate.
> >>  * cs->target is only filled by nft_target.
> >>
> >> So we end with these cases:
> >>  * nft_immediate contains a 'standard' target (ACCEPT, DROP, CONTINUE, RETURN, chain)
> >>   Then cs->jumpto contains the target already. We have the rule.
> >>  * No standard target. If nft_target contains a target, try to load it.
> >>  * Neither nft_target nor nft_immediate exist. Then, assume CONTINUE.
> >>
> >> The printing path is then straight forward: either cs.jumpto or cs.target
> >> contains the target.
> >>
> >> As there isn't support for target extensions yet, there is no way to test the
> >> nft_target (cs.target) path.
> >
> > Not telling this is wrong, but I guess the resulting code to print the
> > target has to converge to what we have in iptables-compat (see
> > iptables/nft-ipv4.c). I mean, the handling should look similar. Could
> > you revisit that and make sure that this and the existing code
> > converge to the point? Thanks.
> 
> I could try to factorize code to a common function, something like:
> void nft_shared_rule_translate_target(char **jumpto, struct
> xtables_target **target)
> void nft_shared_print_target(const char *jumpto, const struct
> xtables_target *target)
> 
> Do you like the idea?

Yes, the more we consolidate the less redundancy. Please, for the
function names, I'd suggest a bit shorter ones: nft_set_target() and
nft_print_target() I'd say.
