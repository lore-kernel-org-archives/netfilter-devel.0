From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: Bug#150467: user-defined chains vs. iptables module names
Date: Thu, 20 Jun 2002 18:23:41 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020620162341.GB2331@aaricia.hemmet.chalmers.se>
References: <20020620145619.GA1404@mail.nontoxic.org> <200206201736.11210.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <200206201736.11210.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-06-20 17:36:11+0200, Henrik Nordstrom <hno@marasystems.com> ->
> Any proposal on what do do about it?
> 
> 
> The problems I see when making iptables rulesets are
> 
>   * There is no distinction between terminal actions, jumps and 
> modifiers/nonterminal actions, all three look the same but are conceptually 
> quite different. Most of you have seen this problem with the LOG target, but 
> there is several other examples.
> 
>   * Only one modifier or target can be applied per rule. I.e. it is impossible 
> to LOG, MARK and ACCEPT in the same rule, to do all three three rules is 
> currently needed.
> 
> 
> As a workaround to the problem of not having a distinction beteen "modifiers" 
> and targets it has been proposed to recode the LOG target as a match, but 
> this does not feel right to me, and there is several other "non-terminal 
> targets" sharing the same problem. Having modifiers implemented as matches 
> gives a ugly dependency on ordering within the rule.
> 
> My proposal on how to deal with this is for the future is to
> 
>   1. Introduce the concept of a modifier. A modifier is something that 
> modifies some aspect of the packet or netfilter but does not in itself make 
> any verdict on the packet. Examples of suitable modifiers are MARK, CONNMARK, 
> ECN, LOG etc.. This would make a rule consist of 1. IP match data. 2. list of 
> matches. 3. list of modifiers. 4. action.
> 
>   2. Introduce a virtual JUMP action or flag for jumping to a custom chain 
> only. This can be done today to workaround the problem of custom chains 
> colliding with modules by only extending the userspace syntax with a way to 
> explicitly indicate a jump to a custom chain as this is only a limitation of 
> the userspace component.
> 

A very good idea with the "modifiers". However i do not feel that LOG is a
modifer. Its neither a match. More like an action, action as what action
mean as a word. You want to use action as the same thing as -j is today
(correct?). The name modifier will collide with match as they both begins
with m (the -m option).

May instead propose to take the name "action". And keep the -j TARGET name.
Meaning:

1. IP match data
2. A list of matches
3. (If 1 and 2 all matches) A list of actions. (LOG, MARK, CONNMARK).
4. An optional target. Can be this virtual JUMP.

Example:

iptables -A INPUT -s 10.11.12.13 \
 -m limit --limit 5/s   -m unclean --unlean-option \
 -a Log --log-prefix    -a Mark --mark-option \
 -j JUMP --jump-chain my_own_chain

'-a' is unused today as well. Note that i did start all Actions with a
capital and the rest lowercase.

I guess however this is all due to iptables (pkttables?) for kernel 2.5.

-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
