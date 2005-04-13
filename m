From: Patrick Schaaf <bof@bof.de>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 08:52:48 +0200
Message-ID: <20050413065248.GB16534@oknodo.bof.de>
References: <20050413084249.0309.LARK@linux.net.cn>
	<425C6D58.3090002@outerspace.dyndns.org>
	<20050413085911.030C.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
Content-Disposition: inline
In-Reply-To: <20050413085911.030C.LARK@linux.net.cn>
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

> My idea is --previous is pseudo match and will duplicate the previous
> match rule and mark itself a dup. When the previous rule is deleted,
> this one will de-mark the dup, but the matching rule itself still makes
> sense.

Upon deletion, the rule-to-be-deleted is still known in whatever
program is doing the deletion. So the duplication you describe
here does not make sense, even when we would _want_ the --previous
rule to automatically morph into the original rule. No dup marking
needed. Also no copying over matches, or something. Just this logic:
	is the rule following the to-be-deleted rule --previous?
	NO: proceed as always
	YES: delete the --previous rule, and leave the to-be-deleted
	rule undisturbed.

A more interesting problem is, what to do with
	iptables -A xxx -m this -m that -j DODAD
	iptables -A xxx ! --previous
i.e. a not-previous match. Upon deletion of the first of these rules,
how would you go about negating ALL those combined matches to form
a revived, ! --previous replacing rule line? Note: not all matches
even implement negation of all their parameters...

Also see my other mail: I think that all this is too complicated and
too restrictive on the admin of the machine, and should simply NOT
be done. The "more interesting" problem above, seems to confirm
this feeling :)

best regards
  Patrick
