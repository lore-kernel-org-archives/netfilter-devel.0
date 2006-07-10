From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] iptables: handle cidr notation more sanely
Date: Mon, 10 Jul 2006 08:52:44 +0200
Message-ID: <20060710065244.GB832@oknodo.bof.de>
References: <20060709222818.GA23200@linuxace.com> <44B1D6FE.6080208@trash.net>
	<20060710055902.GA832@oknodo.bof.de> <44B1F726.1070001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@lists.netfilter.org,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44B1F726.1070001@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> > Better hope the past lazy typers' boot time iptables scripts will not break
> > in any critical way by such a radical interpretation change.
> > 
> > Of course, it's all their own fault when that happens, lazy bastards.
> 
> Please don't put words in my mouth.

Those were my words, not yours. I did in no way intend to put them
into your mouth. And I stand by them. I'm a cynic. That's one of the
reasons I forbid myself becoming maintainer... (lazyness being the
most important reason, of course :)

> If they rely on undocumented, clearly illogical (10.10/16 == 10/16)
> behaviour, then yes, they are at fault, but its not because of beeing
> lazy typers.

On one hand, it is just that, in my opinion.

On the other hand, it is always a bit the fault of software permitting
such abbreviation with arbitrary, undocumented semantics, in the first place.

> Anyway,
> if I'd believe that this is something more than a handful of
> people were actually using and that _anyone_ would actually rely
> on the old behaviour, I wouldn't have accepted that patch.

That's fine with me. You are the maintainer. There is no better
judge for such things. I just couldn't stop myself from adding
a piece of opinion.

> > Methinks that it would be better to make non-3-dots IP addresses
> > a syntax error, period.
> 
> I can understand your position about breaking compatibility, but
> this seems unreasonable to me. You're saying we should do something
> that has even more problems (breaking compatibility for shortcuts
> without masks as well),

I did not think about the case without masks (/32) at all. Good point.

So methinks non-3-dots should be syntax errors whenever used with masks != /32.

And you do what you think is best. As always. And I thank you for that!

best regards
  Patrick
