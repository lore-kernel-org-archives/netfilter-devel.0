From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Sat, 17 Feb 2018 13:11:45 +0100
Message-ID: <20180217121145.GI7843@nataraja>
References: <20180216134023.15536-1-daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, alexei.starovoitov@gmail.com
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180216134023.15536-1-daniel@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Daniel,

On Fri, Feb 16, 2018 at 02:40:19PM +0100, Daniel Borkmann wrote:
> This is a very rough and early proof of concept that implements bpfilter.
> The basic idea of bpfilter is that it can process iptables queries and
> translate them in user space into BPF programs which can then get attached
> at various locations. 

Interesting approach.  My first question would be what the goal of all of this
is.  For sure, one can implement many different things, but what is the use
case, and why do it this way?

I see several possible areas of contention:

1) If you aim for a non-feature-complete support of iptables rules, it
   will create confusion to the users.  When users use "iptables", they have
   assumptions on what it will do and how it will behave.  One can of course
   replace / refactor the internal implementation, if the resulting behavior
   is identical.  And that means rules are executed at the same hooks in the stack,
   with functionally identical matches and targets, provide the same
   counter semantics, etc.  But if the behavior is different, and/or the
   provided functionality is different, then why "hide" this new
   filtering technology behind iptables, rather than its own command
   line tool?  Such an alternative tool could share the same command
   line syntax as iptables, or even provide a converter/wrapper, but
   given that it would not be called "iptables" people will implicitly
   have different assumptions about it

2) Why try to provide compatibility to iptables, when at the same time
   many people have already migrated to (or are in the process of
   migrating) to nftables?  By using iptables semantics, structures,
   architecture, you risk perpetuating the design mistakes we made in
   iptables some 18 years ago for another decade or more.  From my POV,
   if one was to do eBPF optimized rule execution, it should be based on
   nftables rather than iptables.  This way you avoid the many
   architectural problems, such as
   * no incremental rule changes but only atomic swap of an entire table
     with all its chains
   * no common/shared rulesets for IPv4 + IPv6, which is very clumsy and
     often worked around with ugly shellscript wrappers in userspace
     which then call both iptables and ip6tables to add a rule to both
     rulesets.

> The user space iptables binary issuing rule addition or dumps was
> left as-is, thus at some point any binaries against iptables uapi kernel
> interface could transparently be supported in such manner in long term.

See my comments above:  In the netfilter community, we know for at least
a decade or more about the many problems of the old iptables userspace
interface.  For many years, a much better replacement has been designed
as part of nftables.

> As rule translation can potentially become very complex, this is performed
> entirely in user space. In order to ease deployment, request_module() code
> is extended to allow user mode helpers to be invoked. Idea is that user mode
> helpers are built as part of the kernel build and installed as traditional
> kernel modules with .ko file extension into distro specified location,
> such that from a distribution point of view, they are no different than
> regular kernel modules. 

That just blew my mind, sorry :)  This goes much beyond
netfilter/iptables, and adds some quiet singificant new piece of
kernel/userspace infrastructure.  To me, my apologies, it just sounds
like a quite strange hack.  But then, I may lack the vision of how this
might be useful in other contexts.

I'm trying to understand why exactly one would
* use a 18 year old iptables userspace program with its equally old
  setsockopt based interface between kernel and userspace
* insert an entire table with many chains of rules into the kernel
* re-eject that ruleset into another userspace program which then
  compiles it into an eBPF program
* inserert that back into the kernel

To me, this looks like some kind of legacy backwards compatibility
mechanism that one would find in proprietary operating systems, but not
in Linux.  iptables, libiptc etc. are all free software.  The source
code can be edited, and you could just as well have a new version of
iptables and/or libiptc which would pass the ruleset in userspace to
your compiler, which would then insert the resulting eBPF program.

You could even have a LD_PRELOAD wrapper doing the same.  That one
would even work with direct users of the iptables setsockopt inteerface.

Why add quite comprehensive kerne infrastructure?  What's the motivation
here?

> Thus, allow request_module() logic to load such
> user mode helper (umh) binaries via:
> 
>   request_module("foo") ->
>     call_umh("modprobe foo") ->
>       sys_finit_module(FD of /lib/modules/.../foo.ko) ->
>         call_umh(struct file)
> 
> Such approach enables kernel to delegate functionality traditionally done
> by kernel modules into user space processes (either root or !root) and
> reduces security attack surface of such new code, meaning in case of
> potential bugs only the umh would crash but not the kernel. Another
> advantage coming with that would be that bpfilter.ko can be debugged and
> tested out of user space as well (e.g. opening the possibility to run
> all clang sanitizers, fuzzers or test suites for checking translation).
> Also, such architecture makes the kernel/user boundary very precise,
> meaning requests can be handled and BPF translated in control plane part
> in user space with its own user memory etc, while minimal data plane
> bits are in kernel. 

I understand that it has advantages to have the compiler in userspace.
But then, why first send your rules into the kernel and back?

> In the implemented proof of concept we show that simple /32 src/dst IPs
> are translated in such manner. 

Of course this is the first that one starts with.  However, as we all
know, iptables was never very good or efficient about 5-tuple matching.
If you want a fast implementation of this, you don't use iptables which
does linear list iteration.  The reason/rationale/use-case of iptables
is its many (I believe more than 100 now?) extensions both on the area
of matches and targets.

Some of those can be implemented easily in BPF (like recomputing the
checksum or the like).   Some others I would find much more difficult -
particularly if you want to off-load it to the NIC.  They require access
to state that only the kernel has (like 'cgroup' or 'owner' matching).

> In the below example, we show that dumping, loading and offloading of
> one or multiple simple rules work, we show the bpftool XDP dump of the
> generated BPF instruction sequence as well as a simple functional ping
> test to enforce policy in such way.

Could you please clarify why the 'filter' table INPUT chain was used if
you're using XDP?  AFAICT they have completely different semantics.

There is a well-conceived and generally understood notion of where
exactly the filter/INPUT table processing happens.  And that's not as
early as in the NIC, but it's much later in the processing of the
packet.

I believe _if_ one wants to use the approach of "hiding" eBPF behind
iptables, then either

a) the eBPF programs must be executed at the exact same points in the
   stack as the existing hooks of the built-in chains of the
   filter/nat/mangle/raw tables, or

b) you must introduce new 'tables', like an 'xdp' table which then has
   the notion of processing very early in processing, way before the
   normal filter table INPUT processing happens.

> Feedback very welcome!

Thanks.  Despite being a former netfilter core team member, I'm trying
to look at this as neutral as possible.  So please don't perceive my
comments as overly defensive or the like.

My main points are:

1) What is the goal of this?

2) Why iptables and not nftables?

3) If something looks like existing iptables, it must behave *exactly*
   like existing iptables, otherwise it is prone to break users security
   in subtle and very dangerous ways.

Looking forward to the following discussion and on other points of view.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
