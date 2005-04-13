From: Wang Jian <lark@linux.net.cn>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 15:50:39 +0800
Message-ID: <20050413152307.0312.LARK@linux.net.cn>
References: <Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>
	<20050413071427.GC16534@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050413071427.GC16534@oknodo.bof.de>
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

Hi Patrick Schaaf,

Common subexpression aggregation should be the best way to go. But
before that is done, we should consider how to improve current scheme,
right? It is a short term vs. long term problem.

Although ! --previous can be done, I am against it with current scheme.
The current scheme is for line by line match, not for structured
semantic such as if-else. Structured rule matching semantic needs much
work for correctness of insertion or deletion.

The --previous is a speedup, it is by no means a structured change.

I will defend my idea of duplication mark. It does make sense. It keeps
user space compatibility very well.

Consider this

iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN --previous -j ACTION2
iptables -A SOMECHAIN --previous -j RETURN

The user space doesn't do the real work. The kernel space code store the
rules like this:

iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN -m this -m that -j ACTION2 (dup match)
iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)

When user space do delete, it do deletion as old days. But kernel, do
the trivial magic.

If delete the first

iptables -A SOMECHAIN -m this -m that -j ACTION2 <-- de-mark
iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)

If delete the second

iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)

Do --previous insertion 

iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN -m this -m that -j NEWACTION1 (dup match)
iptables -A SOMECHAIN -m this -m that -j ACTION2 (dup match)
iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)

Do non --previous insertion

iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN -m newmatch -j NEWACTION1
iptables -A SOMECHAIN -m this -m that -j ACTION2 <-- de-mark
iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)


On Wed, 13 Apr 2005 09:14:27 +0200, Patrick Schaaf <bof@bof.de> wrote:

> Hi Jozsef,
> 
> On Wed, Apr 13, 2005 at 09:03:14AM +0200, Jozsef Kadlecsik wrote:
> > On Wed, 13 Apr 2005, Patrick Schaaf wrote:
> > 
> > > Also see my other mail: I think that all this is too complicated and
> > > too restrictive on the admin of the machine, and should simply NOT
> > > be done. The "more interesting" problem above, seems to confirm
> > > this feeling :)
> > 
> > I absolutely agree.
> > 
> > Rule evaluation should be improved by replacing the current linear
> > algorithm with some tree-based solution like nf-hipac. Or even with a tree
> > of internal IP sets ;-)
> 
> Or with a code generator with proper common subexpression elimination.
> Wasn't there a tcng project going that way? I sometimes think that
> this must be the right approach, just because so much optimization
> work went into gcc - and it can't be too hard, at least on current
> server/desktop processors, when even a full kernel compile is only
> one or two minutes...
> 
> BTW, I do find the general idea of '--previous' / '! --previous'
> sensible and appealing, because it wouldn't cost much to implement,
> and would give a tool to the ruleset writer to at least express
> _some_ commonality.
> 
> It's just the "upon deletion, do magic when the next rule is --previous",
> that I objected to.
> 
> best regards
>   Patrick



-- 
  lark
