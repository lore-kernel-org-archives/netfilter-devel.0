From: Brad Fisher <brad@info-link.net>
Subject: Re: Suggestion for RETURN target
Date: Wed, 03 Dec 2003 14:30:10 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCE47D1.C07304F8@info-link.net>
References: <Pine.LNX.4.44.0312032055140.11739-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

> On Wed, 3 Dec 2003, Brad Fisher wrote:

> > This is different than my suggestion, since as I envision it,
> > the only time you would go back more than one chain would be if a rule
> > specifically requested it.
>
> Which I see as unneededly complex as it moves the logics to the leaves of
> your rule tree rather than at the branches making it a very interwoven set
> of rules, especially if you call these chains from multiple locations.

I agree it does make the chains hard to follow.

> Try to make a ruleset which makes sense where different levels of return
> are actually used. In the above by making the jumps to chain2/3/4 a goto
> class jump the return would in all cases return to chain1. The difference
> is as you note if you have other levels RETURN statements (including the
> implicit return at the end of the chain). But I seriously question if such
> ruleset design is sane from both a ruleset design perspective and
> maintainability.

My main reason for asking for this feature is so I can shortcut the execution of
rules which are guaranteed to never match (ie. the rules following the jump to
another chain).  For this purpose, the goto idea will work.  I guess I thought
that the ability to return an arbitrary number of levels was "cool", but I can
live without it if something like goto existed.

> > Does anyone have any ideas on whether this would be possible to do and if so
> > would they have any pointers on where I should start looking?  I don't mind
> > writing the code myself...
>
> Neither of the two should be very complex to implement, but both requires
> chainging of the iptables core. It can not be done via the match/target
> interface normally used for extending iptables.

Would there be any chance of a patch for the goto functionality being accepted
then?  I wouldn't mind doing the work as long as I don't have to maintain a custom
patch for myself.  If anyone else is interested, then I'd be open to suggestions
on how it should work.  For example:

  # Normal 'jump' (call)
  iptables -j custom_chain

  # Add '-g' (goto) argument to iptables userspace?
  iptables -g custom_chain

  # Add '--goto' (goto) flag to iptables userspace?
  iptables -j custom_chain --goto

And of course there'd have to be a flag somewhere in the rule/target struct itself
which would indicate the calling chain shouldn't be added to the call stack.

> Regards
> Henrik

Thanks for your input!

-Brad
