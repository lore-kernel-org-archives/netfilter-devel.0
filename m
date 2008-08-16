From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Fri, 15 Aug 2008 21:09:22 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808152104380.30044@fbirervta.pbzchgretzou.qr>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>  <48A5CEFE.5090407@netfilter.org>  <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr>  <Pine.LNX.4.64.0808152243280.20098@blackhole.kfki.hu>
 <alpine.LNX.1.10.0808151743310.10478@fbirervta.pbzchgretzou.qr>  <Pine.LNX.4.64.0808160037390.20328@blackhole.kfki.hu> <412e6f7f0808151738k3b03cafax900b01f45726051e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35805 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYHPBJY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 21:09:24 -0400
In-Reply-To: <412e6f7f0808151738k3b03cafax900b01f45726051e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-08-15 20:38, Changli Gao wrote:
>On Sat, Aug 16, 2008 at 6:44 AM, Jozsef Kadlecsik
><kadlec@blackhole.kfki.hu> wrote:
>> On Fri, 15 Aug 2008, Jan Engelhardt wrote:
>>
>It sounds a good idae. But in order to avoid clashing, we'd better
>change all the options for all matches in this way:
>
>match: foo
>match-options: --foo-bar
>
>I don't mean that some maches share the same options is encouraged,
>but I don't think it lose readable, as I think most of people will
>think the long options after a "-m" option until another match appears
>with the leading "-m"  are all for this corresponding match. Global
>option naming space allow commands like this:
>
>iptables ... -m a --a-option-1 -m b --b-option-1 --a-option-2
>
>Oh, I think it make the command unreadable, and we should not allow it happen.

As I see it, -m enables a new set of options and brings them in top
priority, possibly overriding older ones. And because matches don't
get printed in whacky option order when running iptables-save or
similar, I see nothing wrong with keeping it that way and go on
sometimes having same --names for different -m. It's kinda redundant
to give --set-mark with -j MARK, because eh well obviously it will
set the mark in some way, it could have just been -j MARK --mark 17.

>I encountered this issue when I debugging a match. Its parse function
>is like this:
>
>parse(...)
>{
>        if (*flags)
>                error...;
>        switch (c) {
>        case 'a':
>                ....
>                break;
>        default:
>                return 0;
>        }
>       *flags = 1;
>
>        return 1;
>}
>
>it will fail if there is another kinds of match after it, as all the
>options not belong to it are parsed to its parse function. I think it
>is the reason why default branch in switch exists. I make things a
>little different from my original thought.

Why should it fail?
Once you gave -m secondmatch, you OBVIOUSLY want options
from the second one, and rarely from the first.

>When writting this, I get another idea to solve this. Before calling
>the parse function, we should check if c is in the option range with
>one line code:
>
>c > m->option_offset && c < m->option_offset + OPTION_OFFSET

Just how the hell is that supposed to work.
