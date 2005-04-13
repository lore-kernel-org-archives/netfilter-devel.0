From: Patrick Schaaf <bof@bof.de>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 09:52:51 +0200
Message-ID: <20050413075251.GD16534@oknodo.bof.de>
References: <20050413084249.0309.LARK@linux.net.cn>
	<425C6D58.3090002@outerspace.dyndns.org>
	<20050413085911.030C.LARK@linux.net.cn>
	<20050413065248.GB16534@oknodo.bof.de>
	<Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>
	<20050413071427.GC16534@oknodo.bof.de>
	<Pine.LNX.4.58.0504130930060.10437@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0504130930060.10437@blackhole.kfki.hu>
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

> > Or with a code generator with proper common subexpression elimination.
> > Wasn't there a tcng project going that way? I sometimes think that
> > this must be the right approach, just because so much optimization
> > work went into gcc - and it can't be too hard, at least on current
> > server/desktop processors, when even a full kernel compile is only
> > one or two minutes...
> 
> Have you seen Compact Filter (http://www.cs.aau.dk/~mixxel/cf/)?
> Even ported to 2.6.7, but with large rulesets the compiling of the filter
> is as crawling as iptables itself.

Didn't notice before - thanks for the link, I'll look into it.
>From a first glance this does not seem to use gcc, right?

Maybe using a generate-C/compile-C approach would become more feasible
when both tcc (www.tinycc.org) and gcc are used. tcc is incredibly fast,
but probably a lot worse than gcc at optimizing - one could imagine ordinary
rule updates to usually be optimized using tcc, and only when the admin feels
they have a stable ruleset, they could press some button which then takes
the ruleset through gcc's optimizer.

(see my hands waving? :)

best regards
  Patrick
