From: "Henning Peters" <hpeters@math.uni-goettingen.de>
Subject: ip(6)_tables.h: return type difference in ip(6)t_get_target
Date: Thu, 8 Sep 2005 15:04:29 +0200 (CEST)
Message-ID: <61424.192.35.17.21.1126184669.squirrel@mail.piranho.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi netfilter-folks,

this is my first post, so I would like to say hello to all of you.
Netfilter/iptables is a nice piece of software, thank you for that.

Ok, but fortunately that's not the only reason why I post to this list.

I am working on a network protocol implementation which interacts with
middleboxes in general, NATs in particular. Harald does not believe that
this will be popular
(http://www.netfilter.org/documentation/conferences/nf-workshop-2004-summary.html#AEN128)...
and there is probably a big chance that he will be right.

This software is being written in c++. I want to avoid using the
command-line to talk to iptables for efficiency. Including iptables
headers and linking to libiptables seemed reasonable for me. But compiling
with g++ (gcc version 3.3.4 (pre 3.3.5 20040809)) and linking to the
c-libs (extern "C" stuff) gave me a compile error:

/usr/include/linux/netfilter_ipv6/ip6_tables.h:301: error: invalid
conversion from `void*' to `ip6t_entry_target*'

btw: the code for ipv4 and ipv6 is quite the same at this location:

/* Helper functions */
static __inline__ struct ip6t_entry_target *
ip6t_get_target(struct ip6t_entry *e)
{
        return (void *)e + e->target_offset;
}

My impression is that there don't have to be a void pointer in the return
statement. The gnu c++ compiler seems to be more picky than the c compiler
about the difference of declared return type and actual returned type.
Exchanging the (void *) with (struct ip6t_entry *) worked for me well. The
same goes for ipv4.

Can this be changed or is there a reason for it beeing the way how it is
currently in the code? If keeping the void pointer as in the return
statement is a concern, one could simply make the declared return type
fit.

Henning


These are my proposed changes:

netfilter_ipv6/ip6_tables.h
301c301
<       return (void *)e + e->target_offset;
---
>       return (struct ip6t_entry_target *)e + e->target_offset;

netfilter_ipv4/ip_tables.h
295c295
<       return (void *)e + e->target_offset;
---
>       return (struct ipt_entry_target *)e + e->target_offset;
