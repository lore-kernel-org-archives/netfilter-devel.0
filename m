From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: review requested - spec for proposed match module
Date: Wed, 25 Dec 2002 09:55:07 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15881.61691.835131.3554@isis.cs3-inc.com>
References: <200212250823.gBP8NYp05377@isis.cs3-inc.com>
	<20021225162018.GA440@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20021225162018.GA440@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf writes:

 > >  --comment string
 > >    This is ignored, used for commenting commands

The first issue, of course, is less important than the second.

 > This has no place in a single, new, specialized match. It is a GENERAL
 > concept to comment stuff in-line. If considered important, I would
 > propose an extra match '-m comment' for the purpose.

I should have asked explicitly how iptables arguments are parsed.
I was imagining that after -m foo you expect a set of --x y to be
understood by foo until the next non --x.
This would make it ok to repeat an option, e.g., several --comment's.
It also means that when you move to a second module you can no longer 
supply more arguments to the first module. 

Is this correct?  (If not, what IS?)

The fact that my match arguments can get somewhat complicated
motivated the --comment as a way to describe a single --match.
I wouldn't mind also having a -m comment, but it wouldn't serve
the purpose as well.

====

 > Apart from that, as there is already an 'u32' classifier in tc,
 > it would be nice if syntax and semantics of this new iptables
 > match, would be as close as possible to the tc classifier.
 > I don't know it too well, so I'll refrain from judging your
 > proposal on this.

The name u32 does indeed derive from that one.  I only wished that
it had been available in iptables.  You are also correct that this
differs from that one in some ways.  One is syntax.  If the rules
that I induced above for match module arguments are correct then
it's not possible to imitate tc u32 syntax.

Tc u32 contains some of what I propose, not all.  It does support 
a mask and offset.  It also has a nexthdr syntax but I never got
that to work.  It does not contain ranges (or even one range) or
shifts.  And it does not support anything as complicated (or capable) 
as my little programming language.  The shifts were needed in order
to make the @ work but they're also handy for comparisons.  The @ is
meant to allow us to write a program to do what nexthdr is supposed
to do.  As far as I can tell, right now iptables and tc u32 (if it
works) give you access to the ip header and the next header, but 
that's it, i.e., no pointer to the tcp payload.  In iptables this
is even supported as a special extra argument (if I understand
correctly) which is not needed with my proposal.

I don't claim to understand tc u32 very well and I'll be happy to hear
from those who understand it better what more it has to offer.

 > Don't get me wrong: I do like the idea of an 'u32' match.
