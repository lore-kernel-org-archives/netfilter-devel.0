From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Bug#150467: user-defined chains vs. iptables module names
Date: Thu, 20 Jun 2002 17:36:11 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206201736.11210.hno@marasystems.com>
References: <20020620145619.GA1404@mail.nontoxic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Laurence J. Lane" <ljlane@nontoxic.org>,
	netfilter-devel@lists.samba.org
In-Reply-To: <20020620145619.GA1404@mail.nontoxic.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Any proposal on what do do about it?


The problems I see when making iptables rulesets are

  * There is no distinction between terminal actions, jumps and 
modifiers/nonterminal actions, all three look the same but are conceptually 
quite different. Most of you have seen this problem with the LOG target, but 
there is several other examples.

  * Only one modifier or target can be applied per rule. I.e. it is impossible 
to LOG, MARK and ACCEPT in the same rule, to do all three three rules is 
currently needed.


As a workaround to the problem of not having a distinction beteen "modifiers" 
and targets it has been proposed to recode the LOG target as a match, but 
this does not feel right to me, and there is several other "non-terminal 
targets" sharing the same problem. Having modifiers implemented as matches 
gives a ugly dependency on ordering within the rule.

My proposal on how to deal with this is for the future is to

  1. Introduce the concept of a modifier. A modifier is something that 
modifies some aspect of the packet or netfilter but does not in itself make 
any verdict on the packet. Examples of suitable modifiers are MARK, CONNMARK, 
ECN, LOG etc.. This would make a rule consist of 1. IP match data. 2. list of 
matches. 3. list of modifiers. 4. action.

  2. Introduce a virtual JUMP action or flag for jumping to a custom chain 
only. This can be done today to workaround the problem of custom chains 
colliding with modules by only extending the userspace syntax with a way to 
explicitly indicate a jump to a custom chain as this is only a limitation of 
the userspace component.

Regard
Henrik


Laurence J. Lane wrote:
> http://bugs.debian.org/150467
>
> The problem deals with user-defined chain names clashing with iptables
> module names. Basically, it's entirely possible to create a user-defined
> chain with the same name (case sensitive)  as a target module, but the
> new chain cannot be used as a jump target.
>
> It is a packaging problem of sorts because an upgrade with new modules
> can suddenly conflict with existing user-defined chains.
>
> As always, don't shoot the messenger.
