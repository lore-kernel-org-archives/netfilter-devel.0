From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: IPtables performance (fwd)
Date: Mon, 28 Apr 2003 13:25:59 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304281155450.24242-100000@localhost>
References: <20030427130229.GG990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Robert Olsson <robban@robtex.com>,
   John McEleney <john@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030427130229.GG990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

> yup, we are aware of this problem.  However, most people tend to execute
> iptables 1000 times for inserting 1000 rules, which is obviously the
> wrong way to do it.  This way you end up doing 1000 ruleset-loads and
> 1000 loop checks.  iptables-restore takes away that burden.

We have already been using iptables-restore since last year, with a big
increase in performance, but the basic problem still remains. Without this
patch however, it still takes 15 seconds in mark_source_chains every time
we change the ruleset on a large firewall. This is a significant delay
when it needs to happen every time a VPN user connects, for example,
before they can send traffic.

> However, the last patch seems to have changed, so I need to do some
> analysis whether it would still detect all loops or not.
> 
> I will consider any optimization as soon as anybody can guarantee me
> that it still detects all cases of loops ;)

I don't claim to understand exactly how mark_source_chains works, but here
is my argument that the patch does detect all loops. 

It appears to me that loop check made by mark_source_chains is
deterministic, so once we've visited a particular rule, and determined
that there are no loops in the paths leading from it, then the rule is
_safe_, and we don't need to check it again.

On the other hand, detection of a loop leads to immediate return with a
fatal error, so that rule will never be touched again either.

However, the current algorithm in mark_source_chains is to check the rule
once for every path leading _to_ it, despite the fact that each and every
one of these checks will return precisely the same verdict.

All that Robert's patch does is to add an array of "been" flags, one per
rule, which tells us if the rule is a jump and we've checked it before.  
Since we're still running mark_source_chains and didn't return earlier,
the rule did not cuase a loop then, and if nobody's changed the rules then
it still does not cause a loop, and doesn't need to be checked again.

> I'll put your patch into patch-o-matic 'extra' and add a Status:
> Experimental line.

Thanks =)

By the way, this code looks like it could be simplified:

[net/ipv4/netfilter/ip_tables.c:mark_source_chains()]

                                        e->comefrom ^= (1<<NF_IP_NUMHOOKS);
#ifdef DEBUG_IP_FIREWALL_USER
                                        if (e->comefrom
                                            & (1 << NF_IP_NUMHOOKS)) {
                                                duprintf("Back unset "
                                                         "on hook %u "
                                                         "rule %u\n",
                                                         hook, pos);
                                        }
#endif

because the condition inside the #ifdef will always be true, so we don't 
need to check it.

Cheers, Chris.
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
