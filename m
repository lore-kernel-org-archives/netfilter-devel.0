From: Patrick Schaaf <bof@bof.de>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 09:14:27 +0200
Message-ID: <20050413071427.GC16534@oknodo.bof.de>
References: <20050413084249.0309.LARK@linux.net.cn>
	<425C6D58.3090002@outerspace.dyndns.org>
	<20050413085911.030C.LARK@linux.net.cn>
	<20050413065248.GB16534@oknodo.bof.de>
	<Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>
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

Hi Jozsef,

On Wed, Apr 13, 2005 at 09:03:14AM +0200, Jozsef Kadlecsik wrote:
> On Wed, 13 Apr 2005, Patrick Schaaf wrote:
> 
> > Also see my other mail: I think that all this is too complicated and
> > too restrictive on the admin of the machine, and should simply NOT
> > be done. The "more interesting" problem above, seems to confirm
> > this feeling :)
> 
> I absolutely agree.
> 
> Rule evaluation should be improved by replacing the current linear
> algorithm with some tree-based solution like nf-hipac. Or even with a tree
> of internal IP sets ;-)

Or with a code generator with proper common subexpression elimination.
Wasn't there a tcng project going that way? I sometimes think that
this must be the right approach, just because so much optimization
work went into gcc - and it can't be too hard, at least on current
server/desktop processors, when even a full kernel compile is only
one or two minutes...

BTW, I do find the general idea of '--previous' / '! --previous'
sensible and appealing, because it wouldn't cost much to implement,
and would give a tool to the ruleset writer to at least express
_some_ commonality.

It's just the "upon deletion, do magic when the next rule is --previous",
that I objected to.

best regards
  Patrick
