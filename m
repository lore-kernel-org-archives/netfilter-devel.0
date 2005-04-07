From: Wang Jian <lark@linux.net.cn>
Subject: Re: About matching
Date: Thu, 07 Apr 2005 15:01:56 +0800
Message-ID: <20050407145507.02C5.LARK@linux.net.cn>
References: <20050407135853.02BA.LARK@linux.net.cn>
	<20050407063547.GD20287@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050407063547.GD20287@oknodo.bof.de>
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


On Thu, 7 Apr 2005 08:35:48 +0200, Patrick Schaaf <bof@bof.de> wrote:

> > Yes. So I think --previous is a strong indication that
> > you-know-what-you-are-doing. With this option, kernel is instructed that
> > this optimization is needed, and is ok even if there are conflicts.
> 
> I agree. Following implementation thougts and questions arise:
> 
> It would be a bit more typing work, but '-m previous' would be
> more easy to implement, I think: just write it as a new match.
> The match function will need access to a 'didmatch' boolean variable.
> The variable value would be determined by the result of the immediately
> previous match, surely available to the main table walking code.
> 
> Should this variable be set to 0 when entering each new chain? I think yes.
> 

Here, first we should decide how -m previous is implemented.

1. A real match;
2. A pseudo match, which copy previous rule's match and mark itself a
dup of previous match;

I prefer the later. The insertion and deletion logic will be very small
and clean. When you delete the previous, this match still makes sense,
and you just clear the 'dup' mark.

> Then there is the question of how the previous match code would access
> the variable. Without changing the call signature of match functions,
> it needs to be somewhat global. Hmm: can there be several ruleset
> walks active at the same time and on the same processor? If not,
> this could be a CPU-private variable.
> 
> Last question: in the main match loop, some matching is handled by
> the loop itself (input/output device, source/destination IP address).
> Now, when a rule uses -m previous, should this rule's device and
> IP address fields be checked, anyway, or should this check also
> be ommitted? I think it could also be ommitted.
> 

These two questions depends on the decision made above.

> Finally, a full common-subexpression-elimination, in user level,
> before pushing the ruleset into the kernel, would be very nice.
> Unfortunately this will be harder to do when single-rule-updates,
> instead of full-table-loading, becomes state of the art. :)
> 

tc filter seems to be doing this in kernel space.


-- 
  lark
