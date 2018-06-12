From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC nf-next 0/5] netfilter: add ebpf translation infrastructure
Date: Tue, 12 Jun 2018 11:28:12 +0200
Message-ID: <20180612092812.vptmhuekmpb4pn5z@breakpoint.cc>
References: <20180601153216.10901-1-fw@strlen.de>
 <20180611221257.qzip3iqh45kqqkpy@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, ecree@solarflare.com
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180611221257.qzip3iqh45kqqkpy@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> On Fri, Jun 01, 2018 at 05:32:11PM +0200, Florian Westphal wrote:
> > The userspace helper translates the rules, and, if successful, installs the
> > generated program(s) via bpf syscall.
> > 
> > For each rule a small response containing the corresponding epbf file
> > descriptor (can be -1 on failure) and a attribute count (how many
> > expressions were jitted) gets sent back to kernel via pipe.
> > 
> > If translation fails, the rule is will be processed by nf_tables
> > interpreter (as before this patch).
> > 
> > If translation succeeded, nf_tables fetches the bpf program using the file
> > descriptor identifier, allocates a new rule blob containing the new 'ebpf'
> > expression (and possible trailing un-translated expressions).
> > 
> > It then replaces the original rule in the transaction log with the new
> > 'ebpf-rule'.  The original rule is retained in a private area inside the epbf
> > expression to be able to present the original expressions back to userspace
> > on 'nft list ruleset'.
> > 
> > For easier review, this contains the kernel-side only.
> > nf_tables_jit_work() will not do anything, yet.
> > 
> > Unresolved issues:
> >  - maps and sets.
> >    It might be possible to add a new ebpf map type that just wraps
> >    the nft set infrastructure for lookups.
> >    This would allow nft userspace to continue to work as-is while
> >    not requiring new ebpf helper.
> >    Anonymous set should be a lot easier as they're immutable
> >    and could probably be handled already by existing infra.
> > 
> >  - BPF_PROG_RUN() is bolted into nft main loop via a middleman expression.
> >    I'm also abusing skb->cb[] to pass network and transport header offsets.
> >    Its not 'public' api so this can be changed later.
> > 
> >  - always uses BPF_PROG_TYPE_SCHED_CLS.
> >    This is because it "works" for current RFC purposes.
> > 
> >  - we should eventually support translating multiple (adjacent) rules
> >    into single program.
> > 
> >    If we do this kernel will need to track mapping of rules to
> >    program (to re-jit when a rule is changed.  This isn't implemented
> >    so far, but can be added later.  Alternatively, one could also add a
> >    'readonly' table switch to just prevent further updates.
> > 
> >    We will also need to dump the 'next' generation of the
> >    to-be-translated table.  The kernel has this information, so its only
> >    a matter of serializing it back to userspace from the commit phase.
> > 
> > The jitter is still limited.  So far it supports:
> > 
> >  * payload expression for network and transport header
> >  * meta mark, nfproto, l4proto
> >  * 32 bit immediates
> >  * 32 bit bitmask ops
> >  * accept/drop verdicts
> > 
> > As this uses netlink, there is also no technical requirement for
> > libnftnl, its simply used here for convienience.
> > 
> > It doesn't need any userspace changes. Patches for libnftnl and nftables
> > make debug info available (e.g. to map rule to its bpf prog id).
> > 
> > Comments welcome.
> 
> The implementation of patch 5 looks good to me, but I'm concerned with
> patch 2 that adds 'ebpf expression' to nft. I see no reason to do so.

I think its important user(space) can see which rules are jitted, and
which ebpf prog corresponds to which rule(s), using an expression as
container allows to re-use existing nft config plane code to serialze
this via netlink attributes.

> It seems existing support for infinite number of nft expressions is
> used as a way to execute infinite number of bpf programs sequentially.

In this RFC, yes.

> I don't think it was a scalable approach before and won't scale in the future.
> I think the algorithm should consider all nft rules at once and generate
> a program or two that will execute fast even when number of rules is large.

Yes, but existence of the epbf expression doesn't prevent doing this in
the future.  Doing it now complicates things and given unresolved issues
(see above cover letter) I'm reluctant to implement this already. The
UMH in this RFC can translate only a very small subset of
expressions.  To make full-table realistic I think issues outlined above
need to be addressed first.

It can be done, in such case the epbf expression would replace not just
rule but possibly all of them.

Netlink dump of such a fully-translated table would have the epbf
expression at the beginning of the first rule, exposing epbf program id/tag,
and a list of the nft rule IDs that it replaced.  In the extreme (ideal)
case, it would thus list all rule handle IDs of the chain (including
those reachable via jump-to-user-defined-chains).

Rest of dump would be as if ebpf did not exist, but these rules would
all be "dead" from packet-path point of view.  They are linked from via
the nft epbf pseudo-expression, but no different from an arbitrary
cookie/comment.

As explained above, this also needs kernel to track mapping of
n nft rules to m ebpf progs, rather than the simple 1:1 mapping done
in this RFC.

The 1:1 mapping is not being set stone here, its just the inital
step to get the needed plumbing in, also see "Unresolved issues"
in cover letter above.

So:

Step 1: 1:1 mapping, an nft rule has at most one ebpf prog.
Step 2: figure out how to handle maps, sets, and how to cope with
        not-yet-translateable expressions
Step 3: m:n mapping: kernel provides adjacent rules to the UMH for
        jitting.  Example: user appends rules a, b, c.  UMH creates
	single ebpf prog from a/b/c.
      	nft-pseudo-expression replaces a/b/c in the
	packet path, original rules a/b/c are linked from the pseudo
	expression for tracking.  If user deletes rule b, we provide
	a/c to UMH to create new epbf prog that replaces new
	sequence a/c.
Step 4: always provide entire future base chain and all reachable chains
        to the umh.  Ideally all of it is replaced by single program.

Eventually, entire eval loop could be replaced by ebpf prog.
But it will need some time to get there -- at this point existing
nft expressions would no longer provide an ->eval() function.

Does that make sense to you?

If you see this as flawed, please let me know, but as I have no idea
how to resolve these issues going from 0 to 4 makes no sense to me.

> There are papers on scalable packet classification algorithms that
> use decision trees (hicuts, hypercuts, efficuts, etc)
> Imo that is the direction should we should be looking at.

Okay, but without any idea how to consider existing expressions,
sets, maps etc. I'm not sure it makes sense to work on that at this
point.

We also have the second problem that the netfilter base hook infra
(NF_HOOK) already imposes indirect calls on us.

Is there a plan to have a away to replace those indirect calls with
direct ones?  We can't do that easily because most of the functions are
in modules, but AFAIU ebpf could rewrite that to a sequence of direct
calls.

[..]

> imo this way majority of iptables/nft rules can be converted and
> performance will be great even with large rulesets.

Oh, I do not doubt that multiple rules can be compiled into single program,
sorry if the RFC 1:1 mapping was confusing or gave that impression.
