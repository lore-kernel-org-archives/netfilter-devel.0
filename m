From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: chain_cache
Date: Thu, 20 May 2004 11:52:31 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405201116470.7143-100000@filer.marasystems.com>
References: <40AC600C.2090500@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur Akan <akan@aiqa.com>
In-Reply-To: <40AC600C.2090500@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 May 2004, Ozgur Akan wrote:

> I thought that if I will learn iptables kernel side, I have to learn 
> libiptc because libiptc is the lowest level interface to interact with 
> kernel that I can work on.

Not really interesting to most people. It is sufficient for most people to
say that this code compiles your supplied ruleset into an iptable and
inserts that table into the kernel.

> When we insert a rule with iptables command all checks are done with 
> iptables command itself. Does kernel do some checks and give error or 
> warning if one modifies iptables.c and try to insert buggy rules to 
> iptables?

See the checkentry functions of each target/match.

net/ipv4/netfilter/ip_tables.c also verifies the basic structure of the
iptable before it is accepted by the kernel. If you want to learn the gory
details see the following functions (in approximate call chain order), but
in fact most people only need to know that this code exists, not in 
detail how it works as it has no impact on how a packet is processed.

  translate_table
  check_entry_size_and_hooks
  check_entry
  ip_check_entry
  check_match
  checkentry function of each match used
  checkentry function of the target used

The purpose of all of this code until /* And one copy for every other CPU 
*/ in translate_table is to verify the sanity of the iptable sent 
from userspace.

It is worth remembering that iptables has it's name for a reason. The
ruleset in iptables is one single large table of rules (per table:  
filter, nat, mangle etc). Each modification you make to the ruleset
actually downloads the existing iptable from the kernel, compiles a new
iptable and uploads the new iptable to the kernel. Each hook then starts 
at predefined locations/chains within the compiled table when called from 
the Linux TCP/IP stack.

> Actually I have little idea about the journey of a packet in netfilter. 
> Beside reading ip_tables.c which sources or docs do you recommend me to 
> read?

In recommended order:

Packet Filtering Howto chapter 6

Netfilter Hacking Howto

The journey of a packet through the Linux 2.4.x network stack. 

skb - Linux network buffers (briefly, so you remember this later)

and most other documents linked from the Netfilter documentation page as 
you feel interesting.

Then where to go next depends on what you want to focus on. The internals
of ip_tables.c is not very sexy and not something most peple need to care
about other than understanding that it simply walks the chains of rules
when called from the different hooks. What most people is interesting in
learning more of is how the matches/targets works and how to extend
iptables with new functions. Here the best method is to study the existing
sources of an existing match/target, both in the kernel and userspace. For
example the mark match:

   ipt_mark.c    (kernel)
   ipt_mark.h    (kernel)
   libipt_mark.c (userspace)

Then there is connection tracking, NAT and many other functions more part 
of netfilter than iptables but equally interesting.

Regards
Henrik
