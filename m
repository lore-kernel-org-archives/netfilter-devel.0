From: Martijn Lievaart <m@rtij.nl>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 12:09:39 +0200
Message-ID: <425CEFE3.2010200@rtij.nl>
References: <Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>	<20050413071427.GC16534@oknodo.bof.de>
	<20050413152307.0312.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050413152307.0312.LARK@linux.net.cn>
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

Wang Jian wrote:

>Hi Patrick Schaaf,
>
>Common subexpression aggregation should be the best way to go. But
>before that is done, we should consider how to improve current scheme,
>right? It is a short term vs. long term problem.
>
>Although ! --previous can be done, I am against it with current scheme.
>The current scheme is for line by line match, not for structured
>semantic such as if-else. Structured rule matching semantic needs much
>work for correctness of insertion or deletion.
>
>The --previous is a speedup, it is by no means a structured change.
>
>I will defend my idea of duplication mark. It does make sense. It keeps
>user space compatibility very well.
>
>Consider this
>
>iptables -A SOMECHAIN -m this -m that -j ACTION1
>iptables -A SOMECHAIN --previous -j ACTION2
>iptables -A SOMECHAIN --previous -j RETURN
>
>The user space doesn't do the real work. The kernel space code store the
>rules like this:
>
>iptables -A SOMECHAIN -m this -m that -j ACTION1
>iptables -A SOMECHAIN -m this -m that -j ACTION2 (dup match)
>iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)
>
>When user space do delete, it do deletion as old days. But kernel, do
>the trivial magic.
>
>If delete the first
>
>iptables -A SOMECHAIN -m this -m that -j ACTION2 <-- de-mark
>iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)
>
>If delete the second
>
>iptables -A SOMECHAIN -m this -m that -j ACTION1
>iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)
>
>Do --previous insertion 
>
>iptables -A SOMECHAIN -m this -m that -j ACTION1
>iptables -A SOMECHAIN -m this -m that -j NEWACTION1 (dup match)
>iptables -A SOMECHAIN -m this -m that -j ACTION2 (dup match)
>iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)
>
>Do non --previous insertion
>
>iptables -A SOMECHAIN -m this -m that -j ACTION1
>iptables -A SOMECHAIN -m newmatch -j NEWACTION1
>iptables -A SOMECHAIN -m this -m that -j ACTION2 <-- de-mark
>iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)
>
>  
>

This is so non-intuitive it makes my head hurt. Also:

iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN -m this -m that -j ACTION2 (dup match)
iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)

If delete the first

iptables -A SOMECHAIN -m this -m that -j ACTION2 <-- de-mark
iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)

Now reinsert the first:

iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN -m this -m that -j ACTION2 <-- NO DUP MATCH ANYMORE
iptables -A SOMECHAIN -m this -m that -j RETURN (dup match)


which is bad when any of the matches have side effects.

IMO a better course of action is to only allow deletion of the last match(es) in a "previous-chain", which could be the complete chain. So given the example above:


iptables -A SOMECHAIN -m this -m that -j ACTION1
iptables -A SOMECHAIN --previous -j ACTION2
iptables -A SOMECHAIN --previous -j RETURN

This would only allow to delete the third, the third and the second or all three rules before a commit occurs. These semantics would also allow nicely for ! --previous.

The more I think about it, the more I like it. This in effect gives multiple targets. Now someone is bound to come up with the idea that it should also be possible to write

iptables -A SOMECHAIN -m this -m that -j ACTION1 -j ACTION2 -j RETURN

as syntactic sugar. This makes a lot of sense, but is not needed. Let some front-end tool compile the rules to the --previous form, don't burden netfilter with this, unless it can be implemented very easily, which I don't think it can. The semantics are to murky.

M4
