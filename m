From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Suggestion for RETURN target
Date: Wed, 3 Dec 2003 21:11:24 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312032055140.11739-100000@filer.marasystems.com>
References: <3FCE1CCD.C7D69EF9@info-link.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <3FCE1CCD.C7D69EF9@info-link.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 3 Dec 2003, Brad Fisher wrote:

> I'm not sure that would do exactly what I require.  If I understand you
> correctly, when you fall off the end of a chain called with a "goto"
> operation, it would return back 2 chains (or execute the default policy on a
> built-in?).

Yes, sort of.

> This is different than my suggestion, since as I envision it,
> the only time you would go back more than one chain would be if a rule
> specifically requested it.

Which I see as unneededly complex as it moves the logics to the leaves of 
your rule tree rather than at the branches making it a very interwoven set 
of rules, especially if you call these chains from multiple locations.

>  For example,
> 
>   iptables -N chain4
>   iptables -A chain4 -s 192.168.0.1 -j RETURN --return-to 3
> 
>   iptables -N chain3
>   iptables -A chain3 -j chain4
>   iptables -A chain3 -s 192.168.0.2 -j RETURN --return-to 2
>   .. other rules for chain3 here ...
> 
>   iptables -N chain2
>   iptables -A chain2 -j chain3
>   ... other rules for chain2 here ...
> 
>   iptables -N chain1
>   iptables -A chain1 -j chain2
>   ... other rules for chain1 here ...
> 
>   iptables -A INPUT -j chain1

Yes, and such ruleset becomes very complex to follow and maintain in my
opinion. Only having call/goto type chain operations is more familiar to
most, and also makes the chains neutral on from where they are called.

Try to make a ruleset which makes sense where different levels of return
are actually used. In the above by making the jumps to chain2/3/4 a goto
class jump the return would in all cases return to chain1. The difference
is as you note if you have other levels RETURN statements (including the
implicit return at the end of the chain). But I seriously question if such
ruleset design is sane from both a ruleset design perspective and 
maintainability.

> Does anyone have any ideas on whether this would be possible to do and if so
> would they have any pointers on where I should start looking?  I don't mind
> writing the code myself...

Neither of the two should be very complex to implement, but both requires 
chainging of the iptables core. It can not be done via the match/target 
interface normally used for extending iptables.

Regards
Henrik
