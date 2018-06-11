From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [RFC nf-next 0/5] netfilter: add ebpf translation infrastructure
Date: Mon, 11 Jun 2018 15:12:58 -0700
Message-ID: <20180611221257.qzip3iqh45kqqkpy@ast-mbp.dhcp.thefacebook.com>
References: <20180601153216.10901-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, ecree@solarflare.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601153216.10901-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 01, 2018 at 05:32:11PM +0200, Florian Westphal wrote:
> This patch series adds a JIT layer to translate nft expressions
> to ebpf programs.
> 
> From commit phase, spawn a userspace program (using recently added UMH
> infrastructure).
> 
> We then provide rules that came in this transaction to the helper via pipe,
> using same nf_tables netlink that nftables already uses.
> 
> The userspace helper translates the rules, and, if successful, installs the
> generated program(s) via bpf syscall.
> 
> For each rule a small response containing the corresponding epbf file
> descriptor (can be -1 on failure) and a attribute count (how many
> expressions were jitted) gets sent back to kernel via pipe.
> 
> If translation fails, the rule is will be processed by nf_tables
> interpreter (as before this patch).
> 
> If translation succeeded, nf_tables fetches the bpf program using the file
> descriptor identifier, allocates a new rule blob containing the new 'ebpf'
> expression (and possible trailing un-translated expressions).
> 
> It then replaces the original rule in the transaction log with the new
> 'ebpf-rule'.  The original rule is retained in a private area inside the epbf
> expression to be able to present the original expressions back to userspace
> on 'nft list ruleset'.
> 
> For easier review, this contains the kernel-side only.
> nf_tables_jit_work() will not do anything, yet.
> 
> Unresolved issues:
>  - maps and sets.
>    It might be possible to add a new ebpf map type that just wraps
>    the nft set infrastructure for lookups.
>    This would allow nft userspace to continue to work as-is while
>    not requiring new ebpf helper.
>    Anonymous set should be a lot easier as they're immutable
>    and could probably be handled already by existing infra.
> 
>  - BPF_PROG_RUN() is bolted into nft main loop via a middleman expression.
>    I'm also abusing skb->cb[] to pass network and transport header offsets.
>    Its not 'public' api so this can be changed later.
> 
>  - always uses BPF_PROG_TYPE_SCHED_CLS.
>    This is because it "works" for current RFC purposes.
> 
>  - we should eventually support translating multiple (adjacent) rules
>    into single program.
> 
>    If we do this kernel will need to track mapping of rules to
>    program (to re-jit when a rule is changed.  This isn't implemented
>    so far, but can be added later.  Alternatively, one could also add a
>    'readonly' table switch to just prevent further updates.
> 
>    We will also need to dump the 'next' generation of the
>    to-be-translated table.  The kernel has this information, so its only
>    a matter of serializing it back to userspace from the commit phase.
> 
> The jitter is still limited.  So far it supports:
> 
>  * payload expression for network and transport header
>  * meta mark, nfproto, l4proto
>  * 32 bit immediates
>  * 32 bit bitmask ops
>  * accept/drop verdicts
> 
> As this uses netlink, there is also no technical requirement for
> libnftnl, its simply used here for convienience.
> 
> It doesn't need any userspace changes. Patches for libnftnl and nftables
> make debug info available (e.g. to map rule to its bpf prog id).
> 
> Comments welcome.

The implementation of patch 5 looks good to me, but I'm concerned with
patch 2 that adds 'ebpf expression' to nft. I see no reason to do so.
It seems existing support for infinite number of nft expressions is
used as a way to execute infinite number of bpf programs sequentially.
I don't think it was a scalable approach before and won't scale in the future.
I think the algorithm should consider all nft rules at once and generate
a program or two that will execute fast even when number of rules is large.
We have the same scalability issue with bpfilter RFC patches. That's why
they're still in RFC stage, since we need to figure out a way to support
thousands of iptable rules in scalable way.
There are papers on scalable packet classification algorithms that
use decision trees (hicuts, hypercuts, efficuts, etc)
Imo that is the direction should we should be looking at.
If we implement one of the algorithms as a tree(trie) with a generic lookup
it will be usuable from bpf(bpfilter), from XDP, and other places
inside the kernel.
We can even have multiple algorithms implemented and pick and choose
depending on the size of ruleset and its properties, since one size
doesn't always fit all.
I'm imagining umh will be doing iptables->trie+bpf conversion and
nft->trie+bpf conversion where bpf progs will be dealing with pieces
of logic that don't fit into trie lookup and provide generic mechanism
for parsing the packet in the specific way suited for trie lookup
for the given ruleset. The trie will be sized differently depending
on tuples needed in the lookup. Like if there is no ipv6 in the ruleset
the bpf prog won't be parsing that to prepare a tuple for given trie.
Just like bpf hash map can be of different key/value size, this new
trie will be customized for specific ruleset on the fly by umh.
At the end the trie lookup is fully generic and bpf progs before
and after are generic as well.
imo this way majority of iptables/nft rules can be converted and
performance will be great even with large rulesets.
