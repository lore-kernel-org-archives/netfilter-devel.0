From: Patrick Schaaf <bof@bof.de>
Subject: Re: About matching
Date: Thu, 7 Apr 2005 07:43:02 +0200
Message-ID: <20050407054302.GC20287@oknodo.bof.de>
References: <20050407000158.02AA.LARK@linux.net.cn>
	<42542EBA.9050606@outerspace.dyndns.org>
	<20050407113830.02B0.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
Content-Disposition: inline
In-Reply-To: <20050407113830.02B0.LARK@linux.net.cn>
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

Hello Wang Jian,

> I have an idea before, that looks like the following
> 
> 1. A match is marked as dup when insert into chain if it has the same
> match rule with previous;
> 2. When a match gets deleted followed by match marked as dup , do
> housekeeping to make sure the dup relation is correct;
> 3. When a match is hit, if non-return, the following match marked as dup
> is evaluated immediately as hit.
> 
> This can be achieved with a little code. But the problem here is when
> used in mangle table, the target action may make the matching rule false.

The other problem is that there are several kinds of matches that
have direct or indirect side effects when run. Consider -m limit:
if you have two lines directly following each other, both using
only '-m limit --limit 1/s', your dup solution would decide the
limit only once, where the current solution presents two independant
limits of 1/s each. There are several more matches that are like that.

These cases MUST be handled, i.e. dup logic deactivated, because it is
not acceptable to change semantics of established rulesets just for the
sake of efficiency (just my strong opinion).

best regards
  Patrick
